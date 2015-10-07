From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] IB/core: avoid 32-bit warning
Date: Wed, 07 Oct 2015 15:46:35 +0200
Message-ID: <6219209.mJNClmP5Ym@wuerfel>
References: <17269152.DqJfCm1LOx@wuerfel> <56151BDF.8010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56151BDF.8010504@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

On Wednesday 07 October 2015 16:19:27 Sagi Grimberg wrote:
> On 10/7/2015 3:29 PM, Arnd Bergmann wrote:
> > The INIT_UDATA() macro requires a pointer or unsigned long argument for
> > both input and output buffer, and all callers had a cast from when
> > the code was merged until a recent restructuring, so now we get
> >
> > core/uverbs_cmd.c: In function 'ib_uverbs_create_cq':
> > core/uverbs_cmd.c:1481:66: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >
> > This makes the code behave as before by adding back the cast to
> > unsigned long.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")
> >
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > index be4cb9f04be3..88b3b78340f2 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -1478,7 +1478,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
> >       if (copy_from_user(&cmd, buf, sizeof(cmd)))
> >               return -EFAULT;
> >
> > -     INIT_UDATA(&ucore, buf, cmd.response, sizeof(cmd), sizeof(resp));
> > +     INIT_UDATA(&ucore, buf, (unsigned long)cmd.response, sizeof(cmd), sizeof(resp));
> 
> Would it make sense to cast inside INIT_UDATA() and not have callers
> worry about it?

If we want to do this properly, INIT_UDATA should be converted into a function
call that has the right types.

My patch doesn't try to do that here, it just restores the code to how it
was for the past 10 years.

	Arnd
