From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Mon, 13 Jul 2015 10:35:02 -0600
Message-ID: <20150713163502.GB23832@obsidianresearch.com>
References: <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <20150711102538.GB14741@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150711102538.GB14741@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Tom Talpey <tom@talpey.com>, Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 11, 2015 at 03:25:38AM -0700, 'Christoph Hellwig' wrote:

> So a FRMR-like API that allows to use FMRs underneath might be a good
> start.  If the imput to that API are S/G lists as in my suggestion we'll
> get indirect registration support almost for free.

That would be an excellent outcome in my view.

Jason
