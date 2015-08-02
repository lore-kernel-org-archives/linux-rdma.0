From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 12/22] IB/iser: Introduce iser_reg_ops
Date: Sun, 2 Aug 2015 10:59:43 +0300
Message-ID: <55BDCDEF.9070105@dev.mellanox.co.il>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-13-git-send-email-sagig@mellanox.com>
 <55BA3D51.8050003@opengridcomputing.com>
 <20150730172526.GC25282@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730172526.GC25282-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/30/2015 8:25 PM, Jason Gunthorpe wrote:
> On Thu, Jul 30, 2015 at 10:05:53AM -0500, Steve Wise wrote:
>>> +int iser_assign_reg_ops(struct iser_device *device)
>>> +{
>>> +	struct ib_device_attr *dev_attr = &device->dev_attr;
>>> +
>>> +	/* Assign function handles  - based on FMR support */
>>> +	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
>>> +	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
>>> +		iser_info("FMR supported, using FMR for registration\n");
>>> +		device->reg_ops = &fmr_ops;
>>> +	} else
>>> +	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
>>> +		iser_info("FastReg supported, using FastReg for registration\n");
>>> +		device->reg_ops = &fastreg_ops;
>>> +	} else {
>>> +		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
>>> +		return -1;
>>> +	}
>>> +
>>
>> Perhaps no device supports both FMR and FRMR, but the above code would
>> choose FMR over FRMR.  Shouldn't it be the other way around?
>
> Agree. We should always prefer FRMR. Many of the IB drivers support
> both..

I agree,

I planned to change that as part of my remote invalidate support
patches. Would it be acceptable to hold that off for the next cycle?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
