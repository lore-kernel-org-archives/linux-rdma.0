From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 15:40:23 +0000
Message-ID: <20190307154020.GN1789@mtr-leonro.mtl.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <20190307072428.GJ1789@mtr-leonro.mtl.com>
 <4d90c392-5b6a-fea0-e6cf-c49ac19fdf30@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4d90c392-5b6a-fea0-e6cf-c49ac19fdf30@acm.org>
Content-Language: en-US
Content-ID: <85B98162D3863444929A31A9450182D7@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 07, 2019 at 06:53:54AM -0800, Bart Van Assche wrote:
> On 3/6/19 11:24 PM, Leon Romanovsky wrote:
> > My simple patch passes too :).
>
> Can you repost your patch?

https://patchwork.kernel.org/patch/10841079/

As Rasmus wrote, the thing is to avoid a < 0 check. In my patch,
I converted a <=3D 0 to !(a > 0 || a =3D=3D 0) expression.

Thanks

>
> Thanks,
>
> Bart.
