From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 02/13] IB/core: allow passing mapping an offset into the
 SG in ib_map_mr_sg
Date: Mon, 29 Feb 2016 16:22:03 -0600
Message-ID: <56D4C48B.8010602@opengridcomputing.com>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-3-git-send-email-hch@lst.de>
 <56D30AF7.1060205@dev.mellanox.co.il> <20160228162012.GA23791@lst.de>
 <56D33356.1020707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D33356.1020707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2/28/2016 11:50 AM, Sagi Grimberg wrote:
>
>> I think you're right.  Do you have any good suggestion how to trigger
>> iSER first burst data, as apparently my normal testing didn't hit
>> this?
>
> The first burst should happen by default (against LIO which support
> ImmediateData and UnsolicitedDataOut). But it won't make a difference
> for the initiator which registers the entire buffer, sends the first
> burst and let the target read the rest accordingly...
>
> Perhaps if you change the iscsi tpg FirstBurstLength to be subpage say
> 3k (default is 64k) you can get the isert (when using MRs over iwarp)
> hit this...
>
> Steve can you help?

I can try this out.  Did this discussion result in needing a code change 
though?

Also, one acid test I do that produced non-zero initial offsets for 
nfsrdma server was mounting a large ramdisk to the client and build the 
kernel with 'make -j 16 O=blah' with O= pointing to the mounted remote 
ramdisk.  nfsrdma is very different from iser/block protocols but its 
still a good (evil) test. :)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
