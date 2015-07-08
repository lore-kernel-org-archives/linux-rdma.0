From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Wed, 8 Jul 2015 01:11:19 -0700
Message-ID: <20150708081119.GA24203@infradead.org>
References: <20150705231831.12029.80307.stgit@build2.ogc.int>
 <20150705232158.12029.25472.stgit@build2.ogc.int>
 <559A340E.9000000@dev.mellanox.co.il>
 <001601d0b7f9$3e1d6d40$ba5847c0$@opengridcomputing.com>
 <559AAA22.1000608@dev.mellanox.co.il>
 <20150707090001.GB11736@infradead.org>
 <559B9891.8060907@dev.mellanox.co.il>
 <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, 'Christoph Hellwig' <hch@infradead.org>, dledford@redhat.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 07, 2015 at 09:05:15AM -0500, Steve Wise wrote:
> I took the feedback from Christoph and Jason to mean I should remove ib_get_dma_mr() entirely and pull its guts into
> rdma_get_dma_mr(), and change all the users of ib_get_dma_mr() to use rdma_get_dma_mr().  So the net result isn't a wrapper.  It
> would of course still use rdma_device_access_flags()...

That's what I'd prefer, yes.
