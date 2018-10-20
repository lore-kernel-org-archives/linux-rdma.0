From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] iw_cxgb4: fix a missing-check bug
Date: Sat, 20 Oct 2018 18:14:12 -0500
Message-ID: <038301d468ca$9d30ca90$d7925fb0$@opengridcomputing.com>
References: <1540072741-18856-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540072741-18856-1-git-send-email-wang6495@umn.edu>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Wenwen Wang' <wang6495@umn.edu>
Cc: 'Kangjie Lu' <kjlu@umn.edu>, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@ziepe.ca>, "'open list:CXGB4 IWARP RNIC DRIVER (IW_CXGB4)'" <linux-rdma@vger.kernel.org>, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hey Wenwen,

> Subject: [PATCH] iw_cxgb4: fix a missing-check bug
> 
> In c4iw_flush_hw_cq, the next CQE is acquired through t4_next_hw_cqe(). In
> t4_next_hw_cqe(), the CQE, i.e., 'cq->queue[cq->cidx]', is checked to see
> whether it is valid through t4_valid_cqe(). If it is valid, the address of
> the CQE is then saved to 'hw_cqe'. Later on, the CQE is copied to the
local
> memory in create_read_req_cqe(). The problem here is that the CQE is
> actually in a DMA region allocated by dma_alloc_coherent() in create_cq().
> Given that the device also has the permission to access the DMA region, a
> malicious device controlled by an attacker can modify the CQE in the DMA
> region after the check in t4_next_hw_cqe() but before the copy in
> create_read_req_cqe(). By doing so, the attacker can supply invalid CQE,
> which can cause undefined behavior of the kernel and introduce potential
> security risks.
> 

If the dma device is malicious, couldn't it just dma some incorrect CQE but
still valid in the first place?  I don't think this patch actually solves
the issue, and it forces a copy of a 64B CQE in a critical data io path.  

So I must NACK this. 

Thanks,

Steve.
