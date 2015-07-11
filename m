From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Sat, 11 Jul 2015 03:25:38 -0700
Message-ID: <20150711102538.GB14741@infradead.org>
References: <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
 <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150709170142.GA21921@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Tom Talpey <tom@talpey.com>, Steve Wise <swise@opengridcomputing.com>, 'Christoph Hellwig' <hch@infradead.org>, dledford@redhat.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 09, 2015 at 11:01:42AM -0600, Jason Gunthorpe wrote:
> To your point in another message, I'd say, as long as the new API
> supports FRMR at full speed with no performance penalty we are
> good. If the other variants out there take a performance hit, then I
> think that is OK. As you say, they are on the way out, we just need to
> make sure that ULPs continue to work with FMR with the new API so
> legacy cards don't completely break.

I think what we need to support for now is FRMR as the primary target,
and FMR as a secondard.  A few in-kernel drivers support physical
registrations, but it's always been clear that they've been a bad idea,
and the current discussion reconfirms that again.

So a FRMR-like API that allows to use FMRs underneath might be a good
start.  If the imput to that API are S/G lists as in my suggestion we'll
get indirect registration support almost for free.
