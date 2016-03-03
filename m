From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 14:54:38 +0200
Message-ID: <56D8340E.5030601@dev.mellanox.co.il>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-8-git-send-email-hch@lst.de>
 <56D81790.8090305@dev.mellanox.co.il> <20160303120209.GC20543@lst.de>
 <56D8293C.1050306@dev.mellanox.co.il> <20160303122212.GA21123@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160303122212.GA21123@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> I'll throw in an arbitrary 256 entry limit for the next version, and
> see if anyone screams..

min with device capability. But yes, I think that will suffice.
