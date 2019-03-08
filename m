From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Fri, 8 Mar 2019 09:09:46 +0100
Message-ID: <ca0d8714-3258-3155-247c-af2d63c28273@rasmusvillemoes.dk>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
 <1552003703.45180.17.camel@acm.org>
 <20190308070107.GE32625@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190308070107.GE32625@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 08/03/2019 08.01, Leon Romanovsky wrote:
> 
> Mathematical therm for discrete numbers greater or equal to zero is
> "normal numbers".

Sorry, WHAT? "Normal" is used and abused for a lot of things in
mathematics, but I have never heard it used that way. When attached to
the word "number", it means a real number with certain properties
related to its digit expansion(s). And then of course there's the
isnormal() thing for floating point values in C/computing.

Strong NAK to using is_normal/is_negative.

Rasmus
