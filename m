From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Tue, 1 Mar 2016 11:00:11 +0200
Message-ID: <56D55A1B.6030902@dev.mellanox.co.il>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-8-git-send-email-hch@lst.de>
 <56D4C615.5010202@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56D4C615.5010202@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>> +    if (rdma_rw_use_mr(qp->device, port_num)) {
>> +        ret = rdma_rw_init_mr_wrs(ctx, qp, port_num, sg, sg_offset,
>> +                remote_addr, rkey, dir);
>
> At some point I would like the iWARP IO to do no-mr for WRITE/dma_nents
> == 1, and WRITE/dma_nents <= max_send_sge for the device. I think this
> will help smaller iSER/NVMEF READ IOPs.  I'm testing this out now on the
> NVMEF code, which is slightly different.  If it proves out to better the
> performance, I'll post a follow-on patch...

Is this possible given that pd->local_dma_lkey has only local
permissions?
