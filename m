From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/9] IB/core: add a simple MR pool
Date: Tue, 1 Mar 2016 07:48:16 +0100
Message-ID: <20160301064816.GA31969@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-6-git-send-email-hch@lst.de> <56D4C805.8040507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D4C805.8040507@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 29, 2016 at 02:36:53PM -0800, Bart Van Assche wrote:
> So ib_mr_pool_get() does not remove the returned element from the list and 
> ib_mr_pool_put() adds it to the list? Why this asymmetry?

It should removed it.  I already fixed this up twice after testing,
not sure why this sneaked back in..
