From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/13] IB/core: add a need_inval flag to struct ib_mr
Date: Sun, 28 Feb 2016 17:05:45 +0100
Message-ID: <20160228160545.GC23421@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de> <1456596631-19418-7-git-send-email-hch@lst.de> <56D30DE2.9080007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D30DE2.9080007@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 28, 2016 at 05:10:26PM +0200, Sagi Grimberg wrote:
>> This is the first step toward moving MR invalidation decisions
>> to the core.  It will be needed by the upcoming RW API.
>
> This makes sense even before the rdma rw stuff. We can
> add this bit and get rid of the iser flagging (and when
> nfs/srp will support remote invalidate they will use it too)

If someone else has a use for it ASAP feel free to send it along
with that.  The R/W code currently is my priority project because
the NVMe target driver will need it.  Once that and a few other
urgent items are off my plate I'll happily help out with various
cleanups on the client side MR API again.
