From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 13:22:12 +0100
Message-ID: <20160303122212.GA21123@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-8-git-send-email-hch@lst.de> <56D81790.8090305@dev.mellanox.co.il> <20160303120209.GC20543@lst.de> <56D8293C.1050306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D8293C.1050306@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 02:08:28PM +0200, Sagi Grimberg wrote:
> Already sent out a fix for mlx5. But even then, if a driver offers huge
> amount of translation entries per MR doesn't mean we need to allocate
> gigantic MRs for imaginary transfer sizes...
>
> I'd be happier if this is controlled by the caller.

I'll throw in an arbitrary 256 entry limit for the next version, and
see if anyone screams..
