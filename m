From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: Re: [PATCH 0/4] IB: decrease large contigous allocation
Date: Wed, 26 Sep 2018 18:48:09 +0300
Message-ID: <20180926184809.5d37cdb7@virtuozzo.com>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
        <20180918144623.GI11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918144623.GI11367@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 18 Sep 2018 08:46:23 -0600
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Sep 18, 2018 at 04:03:42PM +0300, Jan Dakinevich wrote:
> > The size of mlx4_ib_device became too large to be allocated as
> > whole contigous block of memory. Currently it takes about 55K. On
> > architecture with 4K page it means 3rd order.
> > 
> > This patch series makes an attempt to split mlx4_ib_device into
> > several parts and allocate them with less expensive kvzalloc
> 
> Why split it up? Any reason not to just allocate the whole thing with
> kvzalloc?
> 

To allocate whole ib_device with kvmalloc I will need replace kzalloc()
by kvzalloc() in ib_alloc_device() and then review allocation, to make
sure that no one uses this memory for DMA.

Although, I could introduce new ib_*alloc_device allocator for these
needs...

> Jason



-- 
Best regards
Jan Dakinevich
