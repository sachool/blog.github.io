---
layout: post
title: "検索アルゴリズム"
date: 2016-04-26 16:34:05 +0900
comments: true
categories: work アルゴリズム
descriptions: 
keywords: 
author: Honda
---
###検索アルゴリズム
---
どうも、新人エンジニアのHondaです。  
今回は検索アルゴリズムの課題に取り組みました。  
前回の計算機アルゴリズムにつづいて、悩みました。  
以下記録です。  

#問題文
---
> 以下のような１万個の数値（乱数）の配列があります。  
>   １、３、６、１４、３４・・・・  
> 数値に規則性はなく、最大で１００万あります。  
> ただ、昇順になっています。  
>  
> 上記に対して目的の数値の検索をする処理をチャートで表してください  
> 目的の数値は１００あり、その結果を以下のように出力します。  
>  
> ５は３番目  
> ２５はありませんでした  
> ４０００は４万番目  
> ・・・・  
>  
> 要件：出来るだけ処理時間を短縮したいです。  

<!--more-->

#1万個って多くないですか？？？
---
この課題をみてまず思ったのは
  
_「一万個って多くないか？こんなんやってたら日が暮れるやろ。」_  

ということです。  

効率よくやらないと、検索範囲多すぎて、何時間経っても終わらないジャン？？  
とはいえ、そこはコンピュータなので、一万個くらいならどんなに効率悪い検索法でも一瞬で終わってしまうという。コンピュータのすごさを実感しました。  
手作業（？）だと数時間ですよね。  
  
今回は３つの方法を考えました。  
あまりたらたらと書いていたらすごく長くなりそうなので、駆け足でいきます。  

#第１案
---
まず考えたのは、検索値１００個を検索元と同じく昇順に並べることです。  

こうすることで、検索値の一つ目と検索元の一つ目（これ以降、たとえば検索値の一つ目は検索値[1]と記述していくことにします。）は順序において近い位置に来るので検索がしやすくなると思ったからです。  
  
次に考えたのは、_「どうやって検索するか」_です。  
  
普通に1つずつ比較していくことにしました。  

つまり、検索値[１]と検索元[1],[2],[3],,,と比較していくということです。  
検索値も昇順に並んでいるので、検索値が見つかればその次の検索からは、見つけた値の次の検索元から検索します。  
  
この方法によると、すべての値を検索し終えるのに最大で１００００×１００回の比較をすることになります。  
これではちょっと非効率なので他の方法を考えることにしました。  
 
#第２案
---
次に考えたのはいわゆる_「２分探索」_ってやつです。  

検索値を検索元の真ん中の値（つまり検索元[5000]）と比較し、検索値のほうが大きければ、今度は検索元[5000]と検索元[10000]の間の真ん中の値と検索値の大小を比較する。逆に検索値のほうが小さければ、検索元[５０００]と検索元[0]の間の真ん中の値と検索値の大小を比較する。この一連の流れを検索値が見つかるか、検索元が空になるまで行う。  

というやり方です。  

今回も第一案と同じく、検索元に検索値と一致するものが見つかれば、次の検索はその次に大きい検索元から開始します。  

このやり方であれば比較回数は最大でも、１４×１００＝１４００回です。  

さっきよりも効率よくなりました。ただ、検索値を昇順に並べていることのメリットを生かしきれてません。  

そしてこの時点で気がついたのですが、そもそもこの検索では、検索値が検索元の中に発見される確率はきわめて低いということです。  
１から１００万までの数値から選んだ１万個の検索元から、ある検索値を探すので、検索値[x]が発見される_確率は１００分の１_です。平均では、１００個の値を検索しても、検索値は１個しか発見できないということです。  

このため、「検索値が発見されたら次回の検索からは、その検索値より大きい検索元だけ検索する」というのは、ほとんど起こらないことなので、この手順を入れたところであまり効率は上がらないということになります。  

このままでは検索値を昇順に並べたメリットがあまりないので、もっと効率のいいやり方を考えることにしました。  

#第３案
---
とにかく検索値が昇順に並んでいることを利用する方法を考えました。  

ここは結構悩みました。  

どうすれば処理を早くできるのだろう？  

結局のところ、検索範囲を絞ることが検索を早めることにつながるわけだから、なにかいい方法はないかなー  
と考えていたところ、ひとつ方法を思いつきました。  

以下の方法です。  

１・検索元を１００個おきに並べて（つまり検索元[100],[200],[300],[400]...と並べる）、検索値[n]と検索元[100n]の大小関係を比較する。  
２・それぞれの大小関係を＜＜＞＜＞＞＞＜＜＜....といった形で記録する。  
３・この大小関係の＞＜の部分を検索範囲として２分検索を行う。  
（ここで左端は＞、右端は＜が存在するとして処理する。）  

やや複雑ではあるけれど、このやり方なら検索値を昇順にしていることを有効に活用できていると思います。  

本当は、２における大小関係の並びを何度もつくってどんどん検索範囲を狭めたほうが効率がいいのですが、あまりにも複雑な処理になりそうだったのであきらめました。  

#ベンチマークしてみる
---
いくつか方法は考えたけれど実際どれが一番早いやり方なのか分からないので、  
第２案と第３案のやり方を実装して、どちらの処理が早いかを比較してみました。  

コードは以下のとおりです。  
（かなり長くて処理もシンプルでないのですが、ご容赦ください）  

---
第２案
```
import java.util.Arrays;
import java.text.NumberFormat;
import java.io.*;
public class Kensaku12{
  public static void main(String[] args){

    //処理時間計測用
    TimeMeasure tm = new TimeMeasure();
    tm.start();

    //boxは検索元、numberは検索値、orderは検索値が何番目かを記録
    int[] box = new int[10000];
    int[] number = new int[100];
    int[] order = new int[100];
    int p = 0 ; int n = 0; int m=0;
    
    //100万までのランダムな数値を1万個box[]に代入
    int[] box2 = new int [1000000];
    for (int i = 0; i<box2.length ; i++){
      box2[i] = i+1;
    }
    for (int i = 0 ; i<10000; i++){
      int random;
      do{
        random = new java.util.Random().nextInt(1000000);
        box[i] = box2 [random];
      }while(box2[random] == 0);
      box2[random] = 0;
    }
    Arrays.sort(box);
    
    //numberの作成
    int[] number2 = new int [10000000];
    for (int i = 0; i<number2.length ; i++){
      number2[i] = i+1;
    }
    for (int i = 0; i < 100; i++){
      int random;
      do{
        random = new java.util.Random().nextInt(1000000);
        number[i] = number2 [random];
      }while(number2[random] == 0);
      number2[random] = 0;
    }
    Arrays.sort(number);
    System.out.println("検索する数値は以下のとおり");
    System.out.println(Arrays.toString(number));

    //二分探索
    p=0;
    while (p<100){
      m=9999;
      while(!(number[p]==box[(n+m)/2] || number[p]==box[n] || number[p]==box[m] || m-n<2)){
        if (number[p]<box[(n+m)/2]){
          m=(n+m)/2;
        }else{
          n=(n+m)/2;
        }
      }
      if(number[p]==box[(n+m)/2]){
        order[p]=(n+m)/2+1;
      }else if(number[p]==box[n]){
        order[p]=n+1;
      }else if(number[p]==box[m]){
        order[p]=m+1;
      }else {
        n=m;
      }
      p++;
    }
    
    //順序表示
    for(int i=0; i<100; i++){
      System.out.print(number[i]+"は");
      if(order[i]==0){
        System.out.println("ありませんでした");
      }else{
        System.out.println(order[i]+"番目");
      }
    }
    
    //処理時間計測
    System.out.println("実行にかかった時間は");
    tm.finish();
    tm.printResult(); 
    System.out.println("秒");
  }
}
```
--- 
第３案
```
import java.util.Arrays;
import java.text.NumberFormat;
import java.io.*;
public class Kensaku13{
  public static void main(String[] args){

    //処理時間計測用
    TimeMeasure tm = new TimeMeasure();
    tm.start();

    /*boxは検索元、numberは検索値、
    orderは見つかった検索値の位置を記録、
    relationは大小関係を記録
    */
    int[] box = new int[10000];
    int[] number = new int[100];
    int[] order = new int[100];
    int p = 0 ; int n = 0; int m=0;
    String[] relation = new String[102];
    relation[0]=">" ; relation[101]="<";
    
    //100万までのランダムな数値を1万個box[]に代入
    int[] box2 = new int [1000000];
    for (int i = 0; i<box2.length ; i++){
      box2[i] = i+1;
    }
    for (int i = 0 ; i<10000; i++){
      int random;
      do{
        random = new java.util.Random().nextInt(1000000);
        box[i] = box2 [random];
      }while(box2[random] == 0);
      box2[random] = 0;
    }
    Arrays.sort(box);
    
    //numberの作成
    int[] number2 = new int [10000000];
    for (int i = 0; i<number2.length ; i++){
      number2[i] = i+1;
    }
    for (int i = 0; i < 100; i++){
      int random;
      do{
        random = new java.util.Random().nextInt(1000000);
        number[i] = number2 [random];
      }while(number2[random] == 0);
      number2[random] = 0;
    }
    Arrays.sort(number);
    System.out.println("検索する数値は以下のとおり");
    System.out.println(Arrays.toString(number));

    //numberとboxの大小関係をrelationに代入していく
    for(int i = 0; i<100; i++){
      if(number[i]>box[(i+1)*100-1]){
        relation[i+1]=">";
      }else if(number[i]<box[(i+1)*100-1]){
        relation[i+1]="<";
      }else{
        relation[i+1]="=";
      }
    }

    /*二分探索
      まずn,mの値を大小関係に従って決める
      その後二分探索の処理*/
    p=0;
    while (p<100){
      int q = p+1;
      if (relation[q].equals("<")){
        m=q*100-1;
        while(relation[q-1].equals("<")){
          q--;
        }
        n=(q-1)*100-1;
        if (q == 1){
          n=0;
        }
      }else if (relation[q].equals(">")){
        n=q*100-1;
        while(relation[q+1].equals(">")){
          q++;
        }
        m=(q+1)*100-1;
        if(q == 100){
          m=10000;
        }
      }else {
        n = m = q*100-1;
      }

      //二分探索
      while(!(number[p]==box[(n+m)/2] || number[p]==box[n] || number[p]==box[m] || m-n<2)){
        if (number[p]<box[(n+m)/2]){
          m=(n+m)/2;
        }else{
          n=(n+m)/2;
        }
      }
      if(number[p]==box[(n+m)/2]){
        order[p]=(n+m)/2+1;
      }else if(number[p]==box[n]){
        order[p]=n+1;
      }else if(number[p]==box[m]){
        order[p]=m+1;
      }else {
        n=m;
      }
      p++;
    }

    //順序表示
    for(int i=0; i<100; i++){
      System.out.print(number[i]+"は");
      if(order[i]==0){
        System.out.println("ありませんでした");
      }else{
        System.out.println(order[i]+"番目");
      }
    }
    
    //処理時間を計測
    System.out.println("実行にかかった時間は");
    tm.finish();
    tm.printResult();
    System.out.println("秒");
  }
}
```
#で、どっちが早いの？？
---
この２通りのプログラムの早さを比べたのですが、_あまり違いがありませんでした_。  

乱数で値を決めているので、完全に同じ値の組で比べたわけではないのですが、平均的にどちらも同じくらいの処理時間でした。  
  
やり方としては、大小関係の比較をつくって検索範囲を狭めたほうが効率がいい気がするのですが、その大小関係の比較の段階で処理が複雑になっているので、あまり処理の時間は変わらなかったということでしょうか？  
  
#まとめ
---
前回の計算機の課題にくらべて、今回は結構複雑なコードを書きました。特にループの処理が多く、値が正確に代入されるようにするのが大変でした。それから、検索値と検索元の数値を、乱数を発生させて代入するところでも結構苦労しました。重複せずに、ばらばらな値を各配列に代入するために、boxとbox2という配列を二つ用意し、ちょっと回り道してbox[]を準備しました。  
    
プログラムは融通が利かないということを実感しました。  
  
今回のアルゴリズムで大小関係を比較してから検索範囲をしぼるというやり方は、複雑だからコードにするの大変そうだなと思っていたのですが、実際コードにしてみると、何とか書けたので（とはいえやっぱり理解しにくい感じですが）、アルゴリズムでできることはプログラムにできるんだなということを学びました。  
  
とはいえ、複雑で理解しにくいので、シンプルでありつつ効率もいいコードを書けるように意識していきたいと思います。  
  
次回は、いよいよ「オブジェクト指向」に入っていきます。  
それではまた。
