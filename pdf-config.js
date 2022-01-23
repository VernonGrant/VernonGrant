module.exports = {
    dest: './assets/vernon-grant.pdf',
    stylesheet_encoding: 'utf-8',
    stylesheet: ['https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/2.10.0/github-markdown.min.css'],
    css: `
      .page-break { page-break-after: always; }
      .markdown-body { font-size: 13px; }
      .markdown-body pre > code { white-space: pre-wrap; }
    `,
    body_class: 'markdown-body',
    marked_options: {
        headerIds: false,
        smartypants: true,
    },
    pdf_options: {
        format: 'A4',
        margin: '20mm 15mm',
        printBackground: true,
    },
};