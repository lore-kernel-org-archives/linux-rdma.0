From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 06/13] IB/core: add a need_inval flag to struct ib_mr
Date: Sun, 28 Feb 2016 17:10:26 +0200
Message-ID: <56D30DE2.9080007@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456596631-19418-7-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

> This is the first step toward moving MR invalidation decisions
> to the core.  It will be needed by the upcoming RW API.

This makes sense even before the rdma rw stuff. We can
add this bit and get rid of the iser flagging (and when
nfs/srp will support remote invalidate they will use it too)
