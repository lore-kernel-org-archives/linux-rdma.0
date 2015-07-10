From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Fri, 10 Jul 2015 14:48:34 -0600
Message-ID: <20150710204834.GA7345@obsidianresearch.com>
References: <20150708190842.GB11740@obsidianresearch.com>
 <20150708203205.GA21847@infradead.org>
 <20150709000337.GE16812@obsidianresearch.com>
 <559EF332.7060103@redhat.com>
 <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com>
 <20150710161108.GA19042@obsidianresearch.com>
 <55A00754.4010009@redhat.com>
 <55A01225.9000000@talpey.com>
 <20150710195420.GA31500@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150710195420.GA31500@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>
Cc: Doug Ledford <dledford@redhat.com>, 'Christoph Hellwig' <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Steve Wise <swise@opengridcomputing.com>, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 01:54:20PM -0600, Jason Gunthorpe wrote:
> On Fri, Jul 10, 2015 at 02:42:45PM -0400, Tom Talpey wrote:
> 
> > >>For the proposed iSER patch the problem is very acute, iser makes a
> > >>single PD and phys MR at boot time for each device. This means there
> > >>is a single machine wide unchanging rkey that allows remote physical
> > >>memory access. An attacker only has to repeatedly open QPs to iSER and
> > >>guess rkey values until they find it. Add in likely non-crypto
> > >>randomness for rkeys, and I bet it isn't even that hard to do.
> > 
> > The rkeys have a PD, wich cannot be forged, so it's not a matter of
> > attacking, but it is most definitely a system integrity risk, as I
> > mentioned earlier, a simple arithmetic offset mistake can overwrite
> > anything.
> 
> Can you explain this conclusion?

Okay, so I see, iser is client only, it doesn't create a listening QP,
so you have to trick it into connecting to a malicious server, and
that is just a trust issue as Doug points out. Presumably this patch
doesn't impact isert?

But what about NFS? It looks to me like all of the ib_get_dma_mr
calls in NFS have the possibility of having IB_ACCESS_REMOTE_WRITE
set, but only on older adaptors?

Jason
