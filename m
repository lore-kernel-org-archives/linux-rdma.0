From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 6/8] IB/core: generic RDMA READ/WRITE API
Date: Mon, 7 Mar 2016 10:08:48 -0600
Message-ID: <008501d1788b$a1e93ea0$e5bbbbe0$@opengridcomputing.com>
References: <1457028192-24965-1-git-send-email-hch@lst.de> <1457028192-24965-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457028192-24965-7-git-send-email-hch@lst.de>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 6/8] IB/core: generic RDMA READ/WRITE API
> 
> This supports both manual mapping of lots of SGEs, as well as using MRs
> from the QP's MR pool, for iWarp or other cases where it's more optimal.
> For now, MRs are only used for iWARP transports.  The user of the RDMA-RW
> API must allocate the QP MR pool as well as size the SQ accordingly.
> 
> Thanks to Steve Wise for testing, fixing and rewriting the iWarp support,
> and to Sagi Grimberg for ideas, reviews and fixes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
