// γのRGBそれぞれに対する初期値
float yR = 1.0;
float yG = 1.0;
float yB = 1.0;

boolean firstMousePress = false;
HScrollbar hsR, hsG, hsB;
Button button;

PImage img; // 加工前の画像
PImage src; // 加工後の画像

void setup(){
  size(384*2, 400);
  background(255);
  textFont(createFont("Tempus Sans ITC", 24));            // 文字のフォントと大きさ設定
  img = loadImage("lion.jpg");                            // 画像の読み込み
  hsR = new HScrollbar(0, height-8*13, width, 16, 16);    // 赤用のスクロールバーの設置
  hsG = new HScrollbar(0, height-8*7, width, 16, 16);     // 緑用のスクロールバーの設置
  hsB = new HScrollbar(0, height-8, width, 16, 16);       // 青用のスクロールバーの設置
  button = new Button(20, 256, 80, 32);
  frameRate(100);
}

void mousePressed() {
  if (!firstMousePress) firstMousePress = true;
  
  // Resetボタンの範囲内でクリックした場合，リセット処理
  if(20 <= mouseX && mouseX <= 100 && 256 <= mouseY && mouseY <= 288) { 
    hsR.reset();
    hsG.reset();
    hsB.reset();
  }
}

void draw(){
  background(255);
  img.updatePixels(); // 画素データの更新
  
  // スライダー位置の更新
  hsR.update();
  hsG.update();
  hsB.update();
  
  // スライダーの描写
  hsR.display();
  hsG.display();
  hsB.display();
  
  // ボタンの描写
  button.dispButton();
  
  // マウスを押す前の状態に戻す
  if (firstMousePress) {
    firstMousePress = false;
  }
  
  // γの値をスライダーの位置から計算
  yR = hsR.getPos()/width*2;
  yG = hsG.getPos()/width*2;
  yB = hsB.getPos()/width*2;
  
  // テキスト挿入
  text("RED Y = " + yR, width/2, height-8*15);
  text("GREEN Y = " + yG, width/2, height-8*9);
  text("BLUE Y = " + yB, width/2, height-8*3);
  
  // 画像処理
  src = Y(img);
  image(img, 0, 0);
  image(src, img.width, 0);
}

PImage Y(PImage f) {
  
  // 返すためのPImageの範囲作成
  PImage g = createImage(f.width, f.height, RGB);
  f.loadPixels();
  g.loadPixels();
  int h = f.height;
  int w = f.width;
  
  // gのRGB値
  float g_r, g_g, g_b;
  for(int j = 0; j < h; j++) {
    for(int i = 0; i < w; i++) {
      
      // ピクセルの値 p = j * w + i
      int p = j * w + i;
      
      // g = 255 * (f/255)^1/γ をRGBでそれぞれ計算する
      g_r = 255 * pow(red(f.pixels[p])/255, 1/yR);
      g_g = 255 * pow(green(f.pixels[p])/255, 1/yG);
      g_b = 255 * pow(blue(f.pixels[p])/255, 1/yB);
      
      g.pixels[p] = color(g_r, g_g, g_b);
    }
  }
  return g;
}

class HScrollbar {
  int swidth, sheight;    // バーの縦幅，横幅
  float xpos, ypos;       // バーの座標
  float spos, newspos;    // スライダーの座標
  float sposMin, sposMax; // スライダーの座標の最大最小値
  int loose;              // how loose/heavy
  boolean over;           // マウスがスライダーの座標範囲内かどうか
  boolean locked;         // スライダーの値変化の条件鍵
  float ratio;            // スライダーの場所を返す際に調整する値
  float XXX = 1.0;        // 誤差を減らす値（０に近づけると計算の精度は上がるが計算処理に時間がかかる）0.0～1.0の間で好きに決める
  
  // 後のクラスButtonのために空で設置
  HScrollbar() {}
  
  // バーとスライダーの初期化
  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw; sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  // スライダーの更新
  void update() {
    
    // カーソルがスクロールバーの表示範囲内ならtrue, そうでなければfalseを返す
    if (overEvent()) over = true;
    else over = false;
    
    // マウスが押されてなおかつスクロールバーの範囲内ならロック解除
    if (firstMousePress && over) locked = true;
    if (!mousePressed) locked = false;
    
    // ロックがなければバーの最大値と最小値の中に収まるようにスライダーの値を変化させる
    if (locked) newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    if (abs(newspos - spos) > XXX) spos = spos + (newspos-spos)/loose;
  }

  // newsposの値を決める際の計算
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  // カーソルがスクロールバーの表示範囲内ならtrue, そうでなければfalseを返す
  boolean overEvent() {
    if (xpos < mouseX && mouseX < xpos+swidth && ypos < mouseY && mouseY < ypos+sheight) return true;
    else return false;
  }

  // スライダーの表示
  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) fill(0, 0, 0);
    else fill(102, 102, 102);
    rect(spos, ypos, sheight, sheight);
  }

  // スライダーの場所を把握
  float getPos() {
    return spos * ratio;
  }
  
  // スライダーの値を初期化
  void reset() {
    newspos = 376;
  }
}

// HScrollbarを継承したResetボタンのためのクラス
class Button extends HScrollbar {
  // ボタンのx, y座標, 横幅, 縦幅
  float rx, ry, rw, rh;
  
  // 値を初期化
  Button (int x, int y, int w, int h){
    rx = x; ry = y; rw = w; rh = h;
  }
  
  // ボタンの表示
  void dispButton() {
    // 基本となるボタンの作成
    noStroke();
    fill(150);
    rect(rx, ry, rw, rh);
    // 黒文字でボタン上にResetの出力
    fill(0);
    text("Reset", rx, ry+20);
    // カーソルがボタンの範囲内ならそれが分かるようにボタンの色を変える
    if (rx <= mouseX && mouseX <= rx+rw && ry <= mouseY && mouseY <= ry+rh) {
      fill(102);
      rect(rx, ry, rw, rh);
    }
    // カーソルが範囲外ならそのまま
    else {
      fill(150);
      rect(rx, ry, rw, rh);
    }
    // Resetを上書き
    fill(0);
    text("Reset", rx, ry+20);
  }
}
