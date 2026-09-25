#!/bin/bash
# $1=prefix ("" or "../")  $2=current key  $3=title  $4=description  $5=body class
page_head() {
P="$1"; CUR="$2"
cat <<HTML
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$3</title>
<meta name="description" content="$4">
<script>document.documentElement.classList.add("js");</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Shippori+Mincho:wght@400;500;600&display=swap">
<link rel="stylesheet" href="${P}assets/css/style.css">
</head>
<body class="$5">
<div class="page-fade" aria-hidden="true"></div>

<!-- ロゴマーク（蓮）：各所で <use> して使い回す -->
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
  <symbol id="lotus" viewBox="0 0 48 48"><g fill="none" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"><path d="M24 8c-5 6-5 18 0 26 5-8 5-20 0-26z"/><path d="M24 34c-3-9-9-15-15-16 0 8 6 15 15 16z"/><path d="M24 34c3-9 9-15 15-16 0 8-6 15-15 16z"/><path d="M24 34C18 30 10 29 4 31c5 4 13 5 20 3z"/><path d="M24 34c6-4 14-5 20-3-5 4-13 5-20 3z"/><path d="M12 40h24"/></g></symbol>
  <symbol id="i-tel" viewBox="0 0 24 24"><path fill="currentColor" d="M6.6 10.8a15.1 15.1 0 0 0 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1A17 17 0 0 1 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1z"/></symbol>
  <symbol id="i-mail" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="1.5" d="M3 5.5h18v13H3zM3 6l9 7 9-7"/></symbol>
  <symbol id="i-up" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="1.5" d="M5 15l7-7 7 7"/></symbol>
</svg>

<!-- ========== 共通ヘッダー ここから ========== -->
<header class="header">
  <a class="header__logo" href="${P}index.html">
    <svg class="logo-mark" aria-hidden="true"><use href="#lotus"/></svg>
    <span class="logo-name">〇〇仏壇店</span>
  </a>
  <nav class="header__nav" aria-label="グローバルナビゲーション">
    <ul>
$(navlist "$P" "$CUR")
    </ul>
  </nav>
  <a class="header__tel" href="tel:0000000000"><small>お電話でのご相談</small>TEL.000-000-0000</a>
</header>

<button class="menu-btn" type="button" aria-label="メニューを開く" aria-controls="gmenu" aria-expanded="false"><span></span><span></span><span></span></button>
<nav class="gmenu" id="gmenu" aria-label="メニュー">
  <div class="gmenu__inner">
    <ul class="gmenu__list">
$(navlist "$P" "$CUR")
    </ul>
    <div class="gmenu__info">
      〇〇仏壇店<br>
      〒000-0000 〇〇県〇〇市〇〇町1丁目2-3<br>
      <a class="tel" href="tel:0000000000">TEL.000-000-0000</a>
      営業時間 9:00〜18:00（水曜定休）
    </div>
  </div>
</nav>
<!-- ========== 共通ヘッダー ここまで ========== -->
HTML
}

navlist() {
  local P="$1" CUR="$2"
  local items=("home|index.html|トップページ" "about|about/index.html|当店について" "products|products/index.html|仏壇・仏具のご案内" "repair|repair/index.html|仏壇の修繕" "shop|shop/index.html|店舗案内" "contact|contact/index.html|ご相談・お問い合わせ")
  for it in "${items[@]}"; do
    IFS='|' read -r k h t <<<"$it"
    if [ "$k" = "$CUR" ]; then
      echo "      <li><a class=\"is-current\" href=\"${P}${h}\" aria-current=\"page\">${t}</a></li>"
    else
      echo "      <li><a href=\"${P}${h}\">${t}</a></li>"
    fi
  done
}

breadcrumb() {
  # $1=prefix, 以降 "ラベル|href" … 最後は現在地（hrefなし）
  local P="$1"; shift
  echo '<nav class="breadcrumb" aria-label="パンくずリスト">'
  echo '  <ol>'
  echo "    <li><a href=\"${P}index.html\">トップページ</a></li>"
  local n=$#
  local i=0
  for it in "$@"; do
    i=$((i+1))
    IFS='|' read -r t h <<<"$it"
    if [ $i -eq $n ]; then echo "    <li aria-current=\"page\">${t}</li>"
    else echo "    <li><a href=\"${P}${h}\">${t}</a></li>"; fi
  done
  echo '  </ol>'
  echo '</nav>'
}

page_foot() {
P="$1"
cat <<HTML

<!-- ========== お問い合わせ帯（共通） ========== -->
<section class="contact-band" aria-labelledby="contact-band-title">
  <div class="wrapper">
    <h2 class="sec-title sec-title--center fade-up" id="contact-band-title">ご相談<br>お問い合わせ</h2>
    <p class="contact-band__lead fade-up">お仏壇のご購入・お引越し・修繕・ご供養のことなど、<br class="pc-only">どんな小さなことでもお気軽にご相談ください。</p>
    <div class="contact-box fade-up">
      <div>
        <p class="contact-box__label">お電話でのご相談</p>
        <a class="contact-box__tel" href="tel:0000000000"><svg aria-hidden="true"><use href="#i-tel"/></svg>000-000-0000</a>
        <p class="contact-box__note">営業時間 9:00〜18:00（水曜定休）</p>
      </div>
      <a class="contact-box__mail" href="${P}contact/index.html">
        <span class="contact-box__label">24時間受付</span>
        <span><svg aria-hidden="true"><use href="#i-mail"/></svg>メールフォーム</span>
      </a>
    </div>
  </div>
</section>

<!-- ========== 共通フッター ========== -->
<footer class="footer">
  <div class="wrapper">
    <div class="footer__inner">
      <div class="footer__brand">
        <p class="logo-name">〇〇仏壇店<small>創業 昭和四十二年</small></p>
        <address class="footer__address">
          <strong>株式会社 〇〇仏壇店</strong>
          〒000-0000<br>
          〇〇県〇〇市〇〇町1丁目2-3<br>
          TEL.000-000-0000<br>
          営業時間 9:00〜18:00（水曜定休）<br>
          駐車場 5台完備
        </address>
      </div>
      <nav class="footer__nav" aria-label="フッターナビゲーション">
        <ul>
$(navlist "$P" "")
        </ul>
      </nav>
    </div>
    <p class="footer__copy"><small>&copy; 〇〇仏壇店 All Rights Reserved.</small></p>
  </div>
</footer>

<a class="to-top" href="#top" aria-label="ページの先頭へ"><svg aria-hidden="true"><use href="#i-up"/></svg></a>

<div class="sp-cta">
  <a href="tel:0000000000">電話で相談</a>
  <a href="${P}contact/index.html">メールで相談</a>
</div>

<script src="${P}assets/js/main.js"></script>
</body>
</html>
HTML
}
