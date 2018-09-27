From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Thu, 27 Sep 2018 16:08:59 -0700
Message-ID: <1538089739.226558.10.camel@acm.org>
References: <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
         <20180925023722.GA32600@ziepe.ca> <20180927010803.GA7640@flashbox>
         <20180927044826.GC24889@ziepe.ca>
         <CAKwvOdnmg2XY6K-8jTna3EKR1Nx04gOm6ZoywUwQO_CSANR_jg@mail.gmail.com>
         <20180927202849.GA11120@flashbox>
         <CAKwvOdnMOcdKPNHwKbcsg8rJX3_hDTgY752Nb4hgMC2D4p5aRg@mail.gmail.com>
         <20180927222821.GC28301@ziepe.ca> <1538087622.226558.8.camel@acm.org>
         <CAKwvOd=qNZsfSFJUFZqBbSYt4T_T7TudohzhTqpigvDAHek78A@mail.gmail.com>
         <20180927225823.GD28301@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927225823.GD28301@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-09-27 at 16:58 -0600, Jason Gunthorpe wrote:
+AD4 Anyhow, the standard is hard to read in this area, but reality is
+AD4 this:
+AD4 
+AD4 +ACM-include +ADw-stdio.h+AD4
+AD4 
+AD4 enum a
+AD4 +AHs
+AD4 	A1 +AD0 1,
+AD4 	A2 +AD0 1ULL+ADwAPA-40,
+AD4 +AH0AOw
+AD4 
+AD4 int main(int argc, const char +ACo-argv+AFsAXQ)
+AD4 +AHs
+AD4 	printf(+ACIAJQ-zu+AFw-n+ACI, sizeof(enum a))+ADs
+AD4 	return 0+ADs
+AD4 +AH0
+AD4 
+AD4 +ACQ gcc -Wall -std+AD0-c11 test.c +ACYAJg ./a.out
+AD4 8
+AD4 
+AD4 I forget if this a common compiler extension, unclear standard, or was
+AD4 formally revised in C11 or what, but it is the real world the Linux
+AD4 kernel lives in.
+AD4 
+AD4 It is even more confusing if you wonder what types A1 and A2 are+ACE

What's unfortunate is that gcc and sparse have different opinions about how
to compile the above code. Even if gcc supports enumeration constants that
exceed what fits in an int, sparse does not AFAIK.

Bart.
