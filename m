From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 02/13] IB/core: allow passing mapping an offset into the
 SG in ib_map_mr_sg
Date: Sun, 28 Feb 2016 19:50:14 +0200
Message-ID: <56D33356.1020707@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-3-git-send-email-hch@lst.de>
 <56D30AF7.1060205@dev.mellanox.co.il> <20160228162012.GA23791@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160228162012.GA23791@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> I think you're right.  Do you have any good suggestion how to trigger
> iSER first burst data, as apparently my normal testing didn't hit
> this?

The first burst should happen by default (against LIO which support
ImmediateData and UnsolicitedDataOut). But it won't make a difference
for the initiator which registers the entire buffer, sends the first
burst and let the target read the rest accordingly...

Perhaps if you change the iscsi tpg FirstBurstLength to be subpage say
3k (default is 64k) you can get the isert (when using MRs over iwarp)
hit this...

Steve can you help?
