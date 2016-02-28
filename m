From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 13/13] IB/isert: RW API WIP
Date: Sun, 28 Feb 2016 15:57:15 +0200
Message-ID: <56D2FCBB.508@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-14-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456596631-19418-14-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>   drivers/infiniband/ulp/isert/ib_isert.c | 855 ++++++--------------------------
>   drivers/infiniband/ulp/isert/ib_isert.h |  70 +--
>   2 files changed, 161 insertions(+), 764 deletions(-)

Ha! 603 LOC deletion!

I plan to incorporate the signature stuff into the rdma_rw API
and then we can reduce it even further! It'll take me some time
though...
