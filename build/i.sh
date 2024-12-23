set -e
URLS=("https://github.com/kingparks/cursor-vip/releases/download/latest/")
url=${URLS[0]}
lc_type=$(echo $LC_CTYPE | cut -c 1-2)
if [ -z $lc_type ] || [ "$lc_type" = "UT" ]; then
  lc_type=$(echo $LANG | cut -c 1-2)
fi

if [ "$lc_type" = "vi" ]; then
  echo "Đang cài đặt..."
else
  echo "Installing..."
fi

for url0 in ${URLS[@]}; do
  if curl -Is --connect-timeout 4 "$url0" | grep -q "HTTP/1.1 404"; then
    url=$url0
    break
  fi
done

os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ $os_name == *"mingw"* ]]; then
  os_name="windows"
fi
raw_hw_name=$(uname -m)
case "$raw_hw_name" in
"amd64")
  hw_name="amd64"
  ;;
"x86_64")
  hw_name="amd64"
  ;;
"arm64")
  hw_name="arm64"
  ;;
"aarch64")
  hw_name="arm64"
  ;;
"i686")
  hw_name="386"
  ;;
"armv7l")
  hw_name="arm"
  ;;
*)
  echo "Không hỗ trợ phần cứng: $raw_hw_name"
  exit 1
  ;;
esac

if [ "$lc_type" = "vi" ]; then
  echo "Hệ thống hiện tại là ${os_name} ${hw_name}"
else
  echo "Current system is ${os_name} ${hw_name}"
fi

if [ ! -z $1 ]; then
   echo "{\"promotion\":\"$1\"}" >~/.cursor-viprc
fi

# Nếu là hệ thống mac hoặc linux
if [[ $os_name == "darwin" || $os_name == "linux" ]]; then
  if [ "$lc_type" = "vi" ]; then
    echo "Vui lòng nhập mật khẩu khởi động"
  else
    echo "Please enter the boot password"
  fi;
  # Dừng cursor-vip đang chạy
  pkill cursor-vip || true
  # Cài đặt
  sudo mkdir -p /usr/local/bin
  sudo curl -Lko /usr/local/bin/cursor-vip ${url}/cursor-vip_${os_name}_${hw_name}
  sudo chmod +x /usr/local/bin/cursor-vip
  if [ "$lc_type" = "vi" ]; then
    echo "Cài đặt hoàn tất! Tự động chạy; lần sau có thể nhập cursor-vip và nhấn Enter để chạy chương trình"
  else
    echo "Installation completed! Automatically run; you can run the program by entering cursor-vip and pressing Enter next time"
  fi;

  echo ""
  cursor-vip
fi;
# Nếu là hệ thống windows
if [[ $os_name == "windows" ]]; then
  # Dừng cursor-vip đang chạy
  taskkill -f -im cursor-vip.exe || true
  # Cài đặt
  curl -Lko "C:\Users\minhp\OneDrive\Desktop\cursor-vip.exe" ${url}/cursor-vip_${os_name}_${hw_name}.exe
  if [ "$lc_type" = "vi" ]; then
    echo "Cài đặt hoàn tất! Tự động chạy; lần sau có thể nhập ./cursor-vip.exe và nhấn Enter để chạy chương trình"
    echo "Sau khi chạy, nếu phần mềm diệt virus như 360 báo cáo là trojan, hãy thêm tin cậy và nhập lại ./cursor-vip.exe rồi nhấn Enter để chạy chương trình"
  else
    echo "Installation completed! Automatically run; you can run the program by entering ./cursor-vip.exe and press Enter next time"
    echo "After running, if 360 antivirus software reports a Trojan horse, add trust, and then re-enter ./cursor-vip.exe and press Enter to run the program"
  fi

  echo ""
  chmod +x "C:\Users\minhp\OneDrive\Desktop\cursor-vip.exe"
  "C:\Users\minhp\OneDrive\Desktop\cursor-vip.exe"
fi
