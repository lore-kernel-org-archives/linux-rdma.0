From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH] IB/srpt: Increase port count
Date: Mon, 14 May 2018 07:24:34 -0700
Message-ID: <20180514142434.GA3233@infradead.org>
References: <20180510223209.10277-1-bart.vanassche@wdc.com>
 <20180514120328.GA5081@infradead.org>
 <b0540168a9b5215f8e02ea3f7e496541686a8230.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b0540168a9b5215f8e02ea3f7e496541686a8230.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 14, 2018 at 02:23:16PM +0000, Bart Van Assche wrote:
> > >     WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));
> > 
> > Should we add a IB_MAX_PORTS define that ULPs can rely on in the core?
> 
> How many drivers would benefit from the introduction of such a constant?
> A third possible alternative is that I change the port array in the ib_srpt
> driver such that it is allocated dynamically. That would allow to eliminate
> the WARN_ON() statement mentioned above.

No idea how many benefit.  But either we have an upper limit, or
ULPs should be able to deal with any possible number, e.g. by using
your dynamic allocation idea.
