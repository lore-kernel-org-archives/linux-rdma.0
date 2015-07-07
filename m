From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 7 Jul 2015 02:00:01 -0700
Message-ID: <20150707090001.GB11736@infradead.org>
References: <20150705231831.12029.80307.stgit@build2.ogc.int>
 <20150705232158.12029.25472.stgit@build2.ogc.int>
 <559A340E.9000000@dev.mellanox.co.il>
 <001601d0b7f9$3e1d6d40$ba5847c0$@opengridcomputing.com>
 <559AAA22.1000608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559AAA22.1000608@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 06, 2015 at 07:17:38PM +0300, Sagi Grimberg wrote:
> >Ok. I'll remove all uses of ib_get_dma_mr()...
> >
> >
> 
> I meant that rdma_get_dma_mr can go away. I'd prefer to get the
> needed access_flags and just call existing verb.

I strongly disagree.  As this series has shown the existing API is not
epressive enough for all transports.  It thus needs to go away and be
fully replaced by the new API introduced here.
