From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 00:25:36 -0700
Message-ID: <20150714072536.GA7630@infradead.org>
References: <20150709000337.GE16812@obsidianresearch.com>
 <559EF332.7060103@redhat.com>
 <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com>
 <20150710161108.GA19042@obsidianresearch.com>
 <55A00754.4010009@redhat.com>
 <55A01225.9000000@talpey.com>
 <20150710195420.GA31500@obsidianresearch.com>
 <20150711101736.GA14741@infradead.org>
 <20150713165748.GE23832@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150713165748.GE23832@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Steve Wise <swise@opengridcomputing.com>, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 13, 2015 at 10:57:48AM -0600, Jason Gunthorpe wrote:
> > Currently various drivers are using ib_get_dma_mr with remote flags
> > unfortunately, e.g. the SRP initiator driver uses it to optimize away
> > memory registrtions for single SGL entry requests.
> 
> Unconditionally? Ugh. Maybe we do need the warn_on :(

There is a "register_always" flag to always use real MRs, but it's
off by default:

	if (count == 1 && !register_always) {
		/*
		 * The midlayer only generated a single gather/scatter
		 * entry, or DMA mapping coalesced everything to a
		 * single entry. So a direct descriptor along with
		 * the DMA MR suffices.
		 */
		struct srp_direct_buf *buf = (void *) cmd->add_data;

		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
                buf->key = cpu_to_be32(target->rkey);
		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));

		req->nmdesc = 0;
		goto map_complete;
	}
