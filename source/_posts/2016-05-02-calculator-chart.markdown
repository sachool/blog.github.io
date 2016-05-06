---
layout: post
title: "電卓アルゴリズムの作成"
date: 2016-05-02 12:04:32 +0900
comments: true
categories: 電卓 アルゴリズム
descriptions: 
keywords:  アルゴリズム　フローチャート
author: k_yoshida 
---

はじめましてk_yoshidaです。
電卓を作成する課題取り組みをまとめました。

<!-- more -->

#課題
***四則演算を行えるアルゴリズムの作成***

## 四則演算アルゴリズムつくる前に

四則演算を行うのにルールをまず整理します。

-- 掛け算・割り算が優先される

-- 足し算・引き算が掛け算・引き算より優先度が低い

-- ()の中が優先的に計算される。


計算される優先度とまとめると

**() > 掛け算・引き算　>足し算・引き算**

となります。

これらの優先度を注目してチャートを作成します。

![チャート図1](/images/calulator_frow.png)

[値取得関数](/images/number_calulator.png)

[（）があったときの関数](/images/brackets.png)

---
### 考え方

入力される計算式を一度配列に入れる

配列から１づつ取り出し識別をする　（）,演算子,その他と順にチェックを行う。

優先度の高い計算から先に計算を行い、足し算引き算の式に変換をする

足し算だけの式になると順番が変わらないので簡単に計算を行える。


このフローチャートでは

>Ansは答え入れる変数  
>numは読み込んできた値を持っている変数  
>Boxは一時的に計算した結果を入れる変数  

計算が終わればAnsが答えになる

例えば 
`
10+20/5+(20-13)-7
` といった式が入力されたとする

1.  10が読み込まれnumに代入 Boxにも代入  
1.  足し算なので10はAnsに代入 新たな値(20)がnumに代入  
1.  割り算なのでnum / 5となる　20/5が計算され　(4)がBoxに代入  
1.  足し算なので10＋4が　Ansに代入  
	1. （があるので）まで計算をする　関数を呼び出し結果(7)をnumに代入
1.  引き算なので　Ans + num (14+7)となってAnsに21が代入(-7)がboxに代入
1.  Ans とBoxを足す　21-7 となって14
1.  Ans が出力される  

---

### 検証

アルゴリズムが本当に正しいかコードベースに落として実証をする
今回はC言語を用いて実行,検証を行う
完成したコードは以下になる。

```
#include <stdio.h>
#include <stdlib.h>
#define NUM 10000
void Calculation(char A[], int *i, int* x);
void numerics(char A[], int* i, int* x);

int main(void)
{
    int i = 0, num;
    double Ans = 0, Box;
    
    char A[NUM];
    
    scanf("%s", &A);
    
    numerics(A, &i, &num);
    
    Box = num;
    
    while(A[i+1] != '\0') {
        switch (A[i]) {
            case '*':
            i++;
            numerics(A, &i, &num);
            Box = Box * num;
            break;
            
            case '/': 
            i++;
            numerics(A, &i, &num);
            Box = Box / num;
            break;
            
            case '+':
            Ans = Ans + Box;
            i++;
            numerics(A, &i, &num);
            Box = num;
            break;
            
            case '-':
            Ans = Ans + Box;
            i++;
            numerics(A, &i, &num);
            Box = -1 * num;
            break;
            
            default :
            printf("演算子がおかしいです\n");
            abort();
            break;
        }
    }
    
    Ans = Ans + Box;
    
    printf("%f\n",Ans);
    
    return 0;
}

void numerics(char A[], int* i, int* x)
{
    int I, num;
    I = *i;
    
    if(A[I] <= 57 && A[I] >= 48) {
        num = (int)A[I] - (int)'0';
        if(A[I+1] != '\0') {
            for(I++ ; A[I] <= 57 && A[I] >= 48; I++) {
                num = num * 10 + (int)A[I] - (int)'0';
            }
        }
    } else if(A[I] == '-') {
        I++;
        numerics(A, &I, &num);
        num = num * (-1);
        
    } else if(A[I] == '(') {
        // 計算関数呼び出し
        I++;
        Calculation(A, &I, &num);
        
    } else {
        // エラー処理
        printf("入力が正しくありません\n");
        abort();
        
    }
    
    *x = num;
    *i = I;
    
}

void Calculation(char A[], int *i, int* x) {
    int count, num;
    double Ans = 0, Box;
    count = *i;
    numerics(A, &count, &num);
    
    Box = num;
    while(A[count] != ')') {
        switch (A[count]) {
            case '*' :
            count++;
            numerics(A, &count, &num);
            Box = Box * num;
            break;
            
            case '/' :
            count++;
            numerics(A, &count, &num);
            Box = Box / num;
            break;
            
            case '+' :
            Ans = Ans + Box;
            count++;
            numerics(A, &count, &num);
            Box = num;
            break;
            
            case '-' :
            Ans = Ans + Box;
            count++;
            numerics(A, &count, &num);
            Box = -1 * num;
            break;
            
            default :
            printf("演算子がおかしいです\n");
            abort();
            break;
        }   
    } 
    Ans = Ans + Box;
    count++;   
    *i = count;
    *x = Ans;  
}
```

numerics関数は値の読み込み,Calculation関数は（）内の計算を行う。

フローチャートと同じようにコードを作成してコンパイル実行を行いいくつかの文字列をいれて検証行った。想定された動作と同じように実行することができました。


### 考察
一度に四則演算を行えるようにアルゴリズムを考えるのは難しいと思います。
先に足し算引き算だけが出来るアルゴリズム,割り算掛け算ができるアルゴリズムを作成してマージさせるといい感じになりました。わからない所から入るより分かる所から物事を見たほうが理解がしやすいという事に気が付きました。


