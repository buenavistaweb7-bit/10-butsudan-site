#!/bin/bash
# 全ページのHTMLを、共通パーツ（parts.sh）と各ページの中身（body-*.html）から組み立てる
# 使い方: bash _parts/build.sh
# ※ 各ページの index.html を直接編集した場合は、同じ修正を body-*.html にも入れること（上書きされるため）
set -e
cd "$(dirname "$0")"
source ./parts.sh
OUT="$(cd .. && pwd)"
SITE="〇〇仏壇店"

build_sub() {
  local key=$1 dir=$2 title=$3 desc=$4
  breadcrumb "../" "${title}|${dir}/index.html" > crumb.tmp
  {
    page_head "../" "$key" "${title}｜${SITE}" "$desc" "is-sub"
    sed -e '/__CRUMB__/{r crumb.tmp' -e 'd}' "body-${key}.html"
    page_foot "../"
  } > "$OUT/$dir/index.html"
  rm crumb.tmp
}

{
  page_head "" "home" "${SITE}｜〇〇市の仏壇・仏具の販売と修繕" "〇〇市の〇〇仏壇店は創業五十余年。金仏壇・唐木仏壇・モダン仏壇の販売、お位牌・仏具、職人による仏壇の修繕（お洗濯）まで、まごころ込めてお手伝いします。" "is-home"
  cat body-home.html
  page_foot ""
} > "$OUT/index.html"

build_sub about    about    "当店について"         "〇〇仏壇店のごあいさつ、三つの約束、沿革をご紹介します。"
build_sub products products "仏壇・仏具のご案内"   "金仏壇・唐木仏壇・モダン仏壇、お位牌・念珠・仏具の種類と価格の目安をご案内します。"
build_sub repair   repair   "仏壇の修繕"           "金箔のくすみや漆のはがれなど、お仏壇の部分修理からお洗濯（全体修復）まで。流れと費用の目安をご紹介します。"
build_sub shop     shop     "店舗案内"             "〇〇仏壇店 本店の所在地・営業時間・駐車場・アクセスのご案内です。"
build_sub contact  contact  "ご相談・お問い合わせ" "お仏壇の購入・修繕・お位牌のご相談は、お電話またはメールフォームからお気軽にどうぞ。"
echo built
