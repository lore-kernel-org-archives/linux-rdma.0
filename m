From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Tue, 1 Mar 2016 11:19:47 +0200
Message-ID: <56D55EB3.2050707@dev.mellanox.co.il>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-8-git-send-email-hch@lst.de>
 <56D4C615.5010202@opengridcomputing.com>
 <56D55A1B.6030902@dev.mellanox.co.il> <20160301091338.GA2208@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301091338.GA2208-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>>> +    if (rdma_rw_use_mr(qp->device, port_num)) {
>>>> +        ret = rdma_rw_init_mr_wrs(ctx, qp, port_num, sg, sg_offset,
>>>> +                remote_addr, rkey, dir);
>>>
>>> At some point I would like the iWARP IO to do no-mr for WRITE/dma_nents
>>> == 1, and WRITE/dma_nents <= max_send_sge for the device. I think this
>>> will help smaller iSER/NVMEF READ IOPs.  I'm testing this out now on the
>>> NVMEF code, which is slightly different.  If it proves out to better the
>>> performance, I'll post a follow-on patch...
>>
>> Is this possible given that pd->local_dma_lkey has only local
>> permissions?
>
> I think he means NVMe / SCSI READ commands, which use RDMA WRITE.
> For NVMe / SCSI WRITE commands that use RDMA READ all bets are off
> for iWarp, but at least it supports READ W/ INVALIDATE.

I interpreted "no-mr for WRITE/dma_nents == 1" as either RDMA_WRITE of
RDMA_READ with a single dma entry (and that part I didn't understand).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
