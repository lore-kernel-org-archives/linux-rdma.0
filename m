From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 08:35:13 -0700
Message-ID: <20150714153513.GB11026@infradead.org>
References: <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com>
 <20150710161108.GA19042@obsidianresearch.com>
 <55A00754.4010009@redhat.com>
 <55A01225.9000000@talpey.com>
 <20150710195420.GA31500@obsidianresearch.com>
 <20150711101736.GA14741@infradead.org>
 <20150713165748.GE23832@obsidianresearch.com>
 <20150714072536.GA7630@infradead.org>
 <55A4D0F1.7000909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A4D0F1.7000909@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>, Steve Wise <swise@opengridcomputing.com>, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 12:05:53PM +0300, Sagi Grimberg wrote:
> iser has it too. I have a similar patch with a flag for iser (its
> behind a bulk of patches that are still pending though).

So instead of this flag can we revisit the need for it?  Given how
inherently isecture it is maybe a "alloc_insecure" option that turns
on the global REMOTE_WRITE MRs might be a better idea, both for these
hacks in iSER and SRP and the current iSER support without FRs.
