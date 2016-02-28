From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/13] IB/isert: RW API WIP
Date: Sun, 28 Feb 2016 17:04:34 +0100
Message-ID: <20160228160434.GB23421@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de> <1456596631-19418-14-git-send-email-hch@lst.de> <56D2FCBB.508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D2FCBB.508@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 28, 2016 at 03:57:15PM +0200, Sagi Grimberg wrote:
>
>>   drivers/infiniband/ulp/isert/ib_isert.c | 855 ++++++--------------------------
>>   drivers/infiniband/ulp/isert/ib_isert.h |  70 +--
>>   2 files changed, 161 insertions(+), 764 deletions(-)
>
> Ha! 603 LOC deletion!
>
> I plan to incorporate the signature stuff into the rdma_rw API
> and then we can reduce it even further! It'll take me some time
> though...

The whole series including the CQ API actually removes more code
than it adds even with a single consumer.
