From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] IB/ucm: fix UCM link error
Date: Wed, 22 Aug 2018 09:33:32 +0200
Message-ID: <CAK8P3a043WTUs92521a1KJ8LEn5sjyw9Bxj7CFfK-z15AgfPHg@mail.gmail.com>
References: <20180821142100.2250647-1-arnd@arndb.de> <20180822031813.GA1313@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180822031813.GA1313@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 22, 2018 at 5:18 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Aug 21, 2018 at 04:20:44PM +0200, Arnd Bergmann wrote:
> > Building UCM with CONFIG_INFINIBAND_USER_ACCESS=m results in a
> > set of link errors including:
> >
> > drivers/infiniband/core/ucm.o: In function `ib_ucm_event_handler':
> > ucm.c:(.text+0x6dc): undefined reference to `ib_copy_path_rec_to_user'
> > drivers/infiniband/core/ucma.o: In function `ucma_event_handler':
> > ucma.c:(.text+0xdc0): undefined reference to `ib_copy_ah_attr_to_user'
> >
> > To get it to build-test again, this makes the option itself a
> > tristate, which lets Kconfig figure out the dependency correctly.
> >
> > Fixes: 486edfb1039d ("IB/ucm: Fix compiling ucm.c")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/infiniband/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Applied to for-rc
>
> But that fixes line isn't right is it?
>
> Should it be
>
> commit 7a8690ed6f5346f6738971892205e91d39b6b901
> Author: Leon Romanovsky <leonro@mellanox.com>
> Date:   Wed May 23 08:22:11 2018 +0300
>
>     RDMA/ucm: Mark UCM interface as BROKEN
>
> Which added the config in the first place??

The commit I cited is the one that caused the build regression for me.

The first one (7a8690ed6f) caused the interface to disappear,
the second one (486edfb1039d) brought it back in a way that
fails in some random configurations.

       Arnd
