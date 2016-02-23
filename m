From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 4/5] IB/isert: Kill struct isert_rdma_wr
Date: Tue, 23 Feb 2016 13:17:14 +0200
Message-ID: <56CC3FBA.1020704@dev.mellanox.co.il>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456148958-27973-5-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> There is exactly one instance per struct isert_cmd, so merge the two to
> simplify everyones life.

Agreed,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
