From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: Re: [PATCH 0/4] IB: decrease large contigous allocation
Date: Wed, 26 Sep 2018 18:43:42 +0300
Message-ID: <20180926184342.44deaa4f@virtuozzo.com>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
        <20180918144623.GI11367@ziepe.ca>
        <20180918212351.GB3661@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918212351.GB3661@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, 19 Sep 2018 00:23:51 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Tue, Sep 18, 2018 at 08:46:23AM -0600, Jason Gunthorpe wrote:
> > On Tue, Sep 18, 2018 at 04:03:42PM +0300, Jan Dakinevich wrote:
> > > The size of mlx4_ib_device became too large to be allocated as
> > > whole contigous block of memory. Currently it takes about 55K. On
> > > architecture with 4K page it means 3rd order.
> > >
> > > This patch series makes an attempt to split mlx4_ib_device into
> > > several parts and allocate them with less expensive kvzalloc
> >
> > Why split it up? Any reason not to just allocate the whole thing
> > with kvzalloc?
> 

This allocation could be triggered by userspace. It means that at
_arbitrary_ time kernel could be asked for high order allocation.

This case is considered unacceptable for system under significant load,
since kernel would try to satisfy this memory request wasting the
overall performance.

> And before we are rushing to dissect mlx4_ib driver, can you
> explain the rationale behind this change? The mlx4_ib driver
> represents high-performance device which needs enough memory
> resources to operate. Those devices are limited by number
> of PCIs and SRIOV VFs (upto 126) and very rare allocated/deallocated.
> 
> I would like to see real rationale behind such change.
> 
> Thanks
> 
> >
> > Jason



-- 
Best regards
Jan Dakinevich
