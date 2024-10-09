#!/opt/homebrew/bin/sbcl --script

;;;; FIX THIS ABSOLUTE MESS OF CL CODE:

(load "~/quicklisp/setup.lisp")

(ql:quickload 'cl-html-parse)
(ql:quickload 'cl-who)
(ql:quickload 'str)
(ql:quickload 'local-time)

(defpackage :gen-rss
  (:use :cl :cl-html-parse :cl-who :local-time))

(in-package :gen-rss)

;; I want to get the date of each post:

(defun collect-all-where-key (nested-list k)
  (remove-if #'null
             (loop
               :for item :in nested-list
               :when (eql item k)
                 :return nested-list
               :when (listp item)
                 :collect (collect-all-where-key item k))))

;; Structure that will hold our data
(defstruct rss-entry
  (title "" :type string)
  (link "#" :type string)
  (author "" :type string)
  (date "" :type string)
  (description "Unknown" :type string)
  (content "" :type string))

;; Build up a collection of rss entry structs:

(defparameter rss-entries
  (let* ((files (directory #P"docs/**/*.html"))
         (index-file-p (lambda (path) (uiop:string-suffix-p (namestring path) "index.html")))
         (files-cleaned (remove-if index-file-p files)))

    (loop :for fp
            :in files-cleaned
          :collect (let* ((source (parse-html (uiop:read-file-string fp)))
                          (post-ample (third (remove-if #'stringp (caar (collect-all-where-key source :BODY)))))
                          (date-time-parts (str:split #\Space (str:replace-first "Updated on: " "" (second (nth 2 post-ample)))))
                          (post-timestamp (parse-timestring (format nil "~AT~A:0" (car date-time-parts) (third date-time-parts)))))

                     (make-rss-entry
                      :title (car (cdr (caaar (collect-all-where-key source :TITLE))))
                      :link (str:replace-first "/Users/vernon/ProjectsP/vernon-grant/docs/" "https://www.vernon-grant.com/"  (namestring fp))
                      :author "Vernon Grant"
                      :description (car (last (car (nth 3 (caar (collect-all-where-key source :META))))))
                      :date (format-timestring nil post-timestamp :format '((:year 4) #\- (:month 2) #\- (:day 2) #\Space :short-weekday #\Space (:hour 2) #\: (:min 2) #\: (:sec 2) #\Space :GMT-OFFSET-OR-Z))
                      :content (format nil "<![CDATA[ ~A ]]>"
                                       (eval `(cl-who:with-html-output-to-string
                                                  (*standard-output*)
                                                ,(second (caar (collect-all-where-key source :BODY)))))))))))


(with-open-file (out-file "docs/rss.xml" :direction :output :if-exists :supersede)
  (cl-who::with-html-output
      (out-file)
    ;; xmlns:atom="http://www.w3.org/2005/Atom"
    (cl-who:str "<?xml version='1.0' encoding='utf-8'?>")
    (:rss
     :xmlns\:content "http://purl.org/rss/1.0/modules/content/"
     :xmlns\:dc "http://purl.org/dc/elements/1.1/"
     :xmlns\:atom "http://www.w3.org/2005/Atom"
     :xmlns\:media "http://search.yahoo.com/mrss/"
     :xmlns\:wfw "http://wellformedweb.org/CommentAPI/"
     :xmlns\:sy "http://purl.org/rss/1.0/modules/syndication/"
     :xmlns\:slash "http://purl.org/rss/1.0/modules/slash/"
     :version "2.0"
     (:channel
      (:title "Vernon Grant")
      (:link "https://www.vernon-grant.com")
      (:description "Welcome to my personal blog where I cover a variety of programming related topics")
      (:language "en-us")
      (cl-who:str (format nil "<lastBuildDate>~A</lastBuildDate>" (format-timestring nil (now) :format '((:year 4) #\- (:month 2) #\- (:day 2) #\Space :short-weekday #\Space (:hour 2) #\: (:min 2) #\: (:sec 2) #\Space :GMT-OFFSET-OR-Z))))
      (cl-who:str (format nil "<pubDate>~A</pubDate>" (format-timestring nil (now) :format '((:year 4) #\- (:month 2) #\- (:day 2) #\Space :short-weekday #\Space (:hour 2) #\: (:min 2) #\: (:sec 2) #\Space :GMT-OFFSET-OR-Z))))
      (:atom\:link :rel "self" :type "application/rss+xml" :href "https://www.vernon-grant.com/rss.xml")
      (loop :for entry :in rss-entries :do (cl-who:htm
                                            (:item
                                             (:title (cl-who:str (rss-entry-title entry)))
                                             (:link (cl-who:str (rss-entry-link entry)))
                                             (cl-who:str (format nil "<pubDate>~A</pubDate>" (rss-entry-date entry)))
                                             (:description (cl-who:str (rss-entry-description entry)))
                                             (:content\:encoded (cl-who:str (rss-entry-content entry)))))))))
  (force-output out-file))
