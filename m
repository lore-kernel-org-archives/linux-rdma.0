From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V6 1/9] RDMA/iser: Limit sg tablesize and max_sectors to
 device fastreg max depth
Date: Sun, 26 Jul 2015 12:57:46 +0300
Message-ID: <55B4AF1A.2050406@dev.mellanox.co.il>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161820.25617.63886.stgit@build2.ogc.int>
 <20150724164123.GA25480@obsidianresearch.com>
 <00ca01d0c640$2f813d70$8e83b850$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ca01d0c640$2f813d70$8e83b850$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/24/2015 9:40 PM, Steve Wise wrote:
>
>
>> -----Original Message-----
>> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
>> Sent: Friday, July 24, 2015 11:41 AM
>> To: Steve Wise
>> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-
>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
>> Subject: Re: [PATCH V6 1/9] RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
>>
>> On Fri, Jul 24, 2015 at 11:18:21AM -0500, Steve Wise wrote:
>>> Currently the sg tablesize, which dictates fast register page list
>>> depth to use, does not take into account the limits of the rdma device.
>>> So adjust it once we discover the device fastreg max depth limit.  Also
>>> adjust the max_sectors based on the resulting sg tablesize.
>>
>> Huh. How does this relate to the max_page_list_len argument:
>>
>>   struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
>>
>> Shouldn't max_fast_reg_page_list_len be checked during the above?
>>
>> Ie does this still make sense:
>>
>> drivers/infiniband/ulp/iser/iser_verbs.c:       desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE + 1);
>>
>> ?
>>
>> The only ULP that checks this is SRP, so basically, all our ULPs are
>> probably quietly broken? cxgb3 has a limit of 10 (!?!?!!)
>>
>
> Yea seems like some drivers need to enforce this in ib_alloc_fast_reg_mr() as well as ib_alloc_fast_reg_page_list(), and ULPs need
> to not exceed the device max.
>
> I will fix iser to limit the mr and page_list allocation based on the device max.

Steve, I have a patch that addresses this in the pipe.
The patch is support for up to 8MB transfer size for 4.3 (hopefully).
So no need for you to tackle this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
