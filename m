From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 08:52:51 -0800
Message-ID: <CAGXu5jLBPpKOT-NV1P0nuFeSQYfoNY_8B0V4gcQg18xHPUVbhQ@mail.gmail.com>
References: <20190307010153.81157-1-bvanassche@acm.org> <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org> <20190307072428.GJ1789@mtr-leonro.mtl.com>
 <4d90c392-5b6a-fea0-e6cf-c49ac19fdf30@acm.org> <20190307154020.GN1789@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307154020.GN1789@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 7, 2019 at 7:40 AM Leon Romanovsky <leonro@mellanox.com> wrote:
>
> On Thu, Mar 07, 2019 at 06:53:54AM -0800, Bart Van Assche wrote:
> > On 3/6/19 11:24 PM, Leon Romanovsky wrote:
> > > My simple patch passes too :).
> >
> > Can you repost your patch?
>
> https://patchwork.kernel.org/patch/10841079/
>
> As Rasmus wrote, the thing is to avoid a < 0 check. In my patch,
> I converted a <= 0 to !(a > 0 || a == 0) expression.

I'd be happy either way. Is there a larger benefit to having a safe
"is_non_negative()" helper, or should we go with the minimal change to
the shl macro?

-Kees

-- 
Kees Cook
