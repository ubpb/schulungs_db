WickedPdf.config ||= {}
WickedPdf.config.merge!({
  encoding: "utf-8",
  layout: "pdf.html.slim",
  orientation: "Portrait", # Portrait
  page_size: "A4",
  zoom: 1,
  dpi: 75,
})