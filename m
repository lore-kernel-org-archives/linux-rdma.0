From: Christoph Hellwig <hch@infradead.org>
Subject: Re: srp state in current mainline
Date: Sun, 22 Nov 2015 07:31:06 -0800
Message-ID: <20151122153106.GA26919@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org>
 <20151122143215.GA14667@infradead.org>
 <5651D775.9090500@dev.mellanox.co.il>
 <20151122151034.GA29240@infradead.org>
 <5651DEA4.8040506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5651DEA4.8040506@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 05:26:28PM +0200, Sagi Grimberg wrote:
> >No. register_always=Y is already broken in 4.3, but register_always=N is
> >now also broken in 4.4.
> 
> OK, I'm confused so please let me understand slowly :)
> 
> Your patch "ib_srp: initialize dma_length in srp_map_idb" solves
> the register_always=Y dma_length = 0 WARN_ON() on 4.4-rc, does it solve
> the data integrity errors too?

No, it doesn't.

> This code path is specific to srp because all other ULPs guarantee
> no-gaps...

Yes.  Life would be simpler if we could just set the virt_boundary
on SRP, and Bart has indicated that he's willing to at least looks at
this for the next merge window.
