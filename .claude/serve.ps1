# local preview server (http://localhost:8127/)
$root = "C:\dev\10-butsudan-site"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8127/")
$listener.Start()
Write-Host "serving $root on http://localhost:8127/"
$types = @{".html"="text/html; charset=utf-8";".jpg"="image/jpeg";".png"="image/png";".svg"="image/svg+xml";".css"="text/css";".js"="text/javascript"}
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
  $path = Join-Path $root $rel
  if (Test-Path $path -PathType Container) { $path = Join-Path $path "index.html" }
  if (Test-Path $path -PathType Leaf) {
    $ext = [System.IO.Path]::GetExtension($path).ToLower()
    if ($types.ContainsKey($ext)) { $ctx.Response.ContentType = $types[$ext] }
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else { $ctx.Response.StatusCode = 404 }
  $ctx.Response.Close()
}
