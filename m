From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 06:53:54 -0800
Message-ID: <4d90c392-5b6a-fea0-e6cf-c49ac19fdf30@acm.org>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <20190307072428.GJ1789@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307072428.GJ1789@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

On 3/6/19 11:24 PM, Leon Romanovsky wrote:
> My simple patch passes too :).

Can you repost your patch?

Thanks,

Bart.
