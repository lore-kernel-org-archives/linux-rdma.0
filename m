From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Mon, 13 Jul 2015 14:15:38 -0600
Message-ID: <20150713201538.GA11681@obsidianresearch.com>
References: <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <20150711102538.GB14741@infradead.org>
 <55A4134C.2040301@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A4134C.2040301@talpey.com>
Sender: target-devel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 13, 2015 at 03:36:44PM -0400, Tom Talpey wrote:
> On 7/11/2015 6:25 AM, 'Christoph Hellwig' wrote:
> >I think what we need to support for now is FRMR as the primary target,
> >and FMR as a secondar[y].
> 
> FMR is a *very* bad choice, for several reasons.

If an API can transparently support FMR, then I think it can also
transparently support ib_get_phys_mr as an alternative, they look
pretty similar... ?

> Personally, I'd recommend ib_get_phys_mr() over FMR. It at least
> doesn't suffer from issues 1, 2 and 4.

Your comments are right for the rkey case, but for lkey, there is no
security concern with using a FMR, or pooling them. It doesn't look
like any iwarp drivers supports FMR, so they are certainly safe to use
on IB as the lkey.

This is why I am becoming more convinced that treating lkey
and rkey the same is not helpful.

Conversely, it looks like if we could drop ehca and mthca we could
ditch FMR entirely..

Jason
