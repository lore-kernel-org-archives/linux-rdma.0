From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 07 Mar 2019 16:08:23 -0800
Message-ID: <1552003703.45180.17.camel@acm.org>
References: <20190307010153.81157-1-bvanassche@acm.org>
         <20190307012417.GU1758@mellanox.com>
         <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
         <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2019-03-07 at 08:18 +-0100, Rasmus Villemoes wrote:
+AD4 On 07/03/2019 03.14, Bart Van Assche wrote:
+AD4 +AD4 On 3/6/19 5:24 PM, Jason Gunthorpe wrote:
+AD4 +AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 +AD4 diff --git a/include/linux/overflow.h b/include/linux/overflow.h
+AD4 +AD4 +AD4 +AD4 index 40b48e2133cb..8afe0c0ada6f 100644
+AD4 +AD4 +AD4 +AD4 +-+-+- b/include/linux/overflow.h
+AD4 +AD4 +AD4 +AD4 +AEAAQA -202,6 +-202,24 +AEAAQA
+AD4 +AD4 +AD4 +AD4     +ACM-endif /+ACo COMPILER+AF8-HAS+AF8-GENERIC+AF8-BUILTIN+AF8-OVERFLOW +ACo-/
+AD4 +AD4 +AD4 +AD4   +-/+ACo
+AD4 +AD4 +AD4 +AD4 +- +ACo Evaluate a +AD4APQ 0 without triggering a compiler warning if the type
+AD4 +AD4 +AD4 +AD4 of a
+AD4 +AD4 +AD4 +AD4 +- +ACo is an unsigned type.
+AD4 +AD4 +AD4 +AD4 +- +ACo-/
+AD4 +AD4 +AD4 +AD4 +-+ACM-define is+AF8-positive(a) (+AHs                    +AFw
+AD4 
+AD4 is+AF8-non+AF8-negative, please+ACE positive means +AD4 0. And perhaps it's better to
+AD4 move these utility macros closer to the top of the file, together with
+AD4 the other type/range helpers.

Hi Rasmus,

Thank you for the feedback. But according to what I found online opinions
about whether or not zero is a positive number seem to vary. From
https://en.wikipedia.org/wiki/Sign+AF8(mathematics):

Terminology for signs

When 0 is said to be neither positive nor negative, the following phrases
may be used to refer to the sign of a number:
+ACo A number is positive if it is greater than zero.
+ACo A number is negative if it is less than zero.
+ACo A number is non-negative if it is greater than or equal to zero.
+ACo A number is non-positive if it is less than or equal to zero.

When 0 is said to be both positive and negative, modified phrases are used
to refer to the sign of a number:
+ACo A number is strictly positive if it is greater than zero.
+ACo A number is strictly negative if it is less than zero.
+ACo A number is positive if it is greater than or equal to zero.
+ACo A number is negative if it is less than or equal to zero.

Bart.
