From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V6 9/9] isert: Support iWARP transports using FRMRs
Date: Sun, 26 Jul 2015 13:23:12 +0300
Message-ID: <55B4B510.8050106@dev.mellanox.co.il>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161904.25617.85015.stgit@build2.ogc.int>
 <20150724165721.GC25480@obsidianresearch.com>
 <00ce01d0c641$493ea300$dbbbe900$@opengridcomputing.com>
 <20150724192411.GC26225@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724192411.GC26225-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/24/2015 10:24 PM, Jason Gunthorpe wrote:
> On Fri, Jul 24, 2015 at 01:48:09PM -0500, Steve Wise wrote:
>>> The use of FRWR for RDMA READ should be iWarp specific, IB shouldn't
>>> pay that overhead. I am expecting to see a cap_rdma_read_rkey or
>>> something in here ?
>>
>> Ok.  But cap_rdma_read_rkey() doesn't really describe the
>> requirement.  The requirement is rkey + REMOTE_WRITE.  So it is more
>> like rdma_cap_read_requires_remote_write() which is ugly and too
>> long (but descriptive)...
>
> I don't care much what name you pick, just jam something like this in
> the description

I think we can just do if (signature || iwarp) use fastreg else
use local_dma_lkey.

>
>   If set then RDMA_READ must be performed by mapping the local
>   buffers through a rkey MR with ACCESS_REMOTE_WRITE enabled.
>   The rkey of this MR should be passed in as the sg_lists's lkey for
>   IB_WR_RDMA_READ_WITH_INV.

I think this would be an incremental patch and not as part of iwarp
support.

Question though, wouldn't it be better to do a single RDMA_READ to say
4 registered keys rather than RDMA_READ_WITH_INV for each?
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
