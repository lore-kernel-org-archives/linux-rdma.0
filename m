From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to
 device fastreg max depth
Date: Tue, 7 Jul 2015 19:30:32 +0300
Message-ID: <559BFEA8.8040401@dev.mellanox.co.il>
References: <20150705174353.10042.39648.stgit@build2.ogc.int>
 <20150705174452.10042.44695.stgit@build2.ogc.int>
 <559A335A.90506@dev.mellanox.co.il>
 <001401d0b7f9$09c21b40$1d4651c0$@opengridcomputing.com>
 <559B712D.7020105@dev.mellanox.co.il>
 <000601d0b8bd$2aa599d0$7ff0cd70$@opengridcomputing.com>
 <559BE2EC.8030806@mellanox.com>
 <004001d0b8cb$57f106f0$07d314d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004001d0b8cb$57f106f0$07d314d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/7/2015 6:41 PM, Steve Wise wrote:
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
>> Sent: Tuesday, July 07, 2015 9:32 AM
>> To: Steve Wise; 'Sagi Grimberg'
>> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-
>> devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
>>
>> On 7/7/2015 4:59 PM, Steve Wise wrote:
>>>>>>>>>>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>>>>>>>>>> index 6a594aa..de8730d 100644
>>>>>>>>>>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>>>>>>>>>>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>>>>>>>>>> @@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>>>>>>>>>>>     						   SHOST_DIX_GUARD_CRC);
>>>>>>>>>>>     		}
>>>>>>>>>>>
>>>>>>>>>>> +		/*
>>>>>>>>>>> +		 * Limit the sg_tablesize and max_sectors based on the device
>>>>>>>>>>> +		 * max fastreg page list length.
>>>>>>>>>>> +		 */
>>>>>>>>>>> +		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
>>>>>>>>>>> +			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
>>>>>>>>>>> +		shost->max_sectors = min_t(unsigned int,
>>>>>>>>>>> +			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
>>>>>>>>>>> +
>>>>>>>>>
>>>>>>>>> The min statement is meaningless for max_sectors - you do a min between
>>>>>>>>> default sg_tablesize and frpl length - so the maximum sg_tablesize is
>>>>>>>>> 128 which is 1024 max_sectors.
>>>>>>>
>>>>>>> I'm not following.  What if ib_conn->device->dev_attr.max_fast_reg_page_list_len is say, 32?
>>>>>>> Then shost->sg_tablesize is set to 32, and max_sectors is set to (32*4K) >> 9 == 256 512B sectors.
>>>>>
>>>>> Correct - but it cannot exceed 1024 (as it is derived from sg_tablesize
>>>>> which is maximum 128).
>>> Actually it is initialized to 1024 in iscsi_iser_sht / iscsi_iser.c, so it isn't derived from sg_tables (although it probably should be).  I can
>> remove the min_t() though.
>>>
>>> Hey Or, thoughts?
>>
>> Originally, we've put the double restriction of 128 SG entries AND 1024
>> sectors to make sure that whatever SG is up there, it'snot spanning >
>> 512KB.
>>
>> Think on SG whose one/some of their element/s is > one page or on
>> systems with > 4KB page size or others examples... since your patch
>> touched the number of SG entries I was thinking you need to make sure no
>> regression was introduced re the max_sectors to be <= 1024
>>
>> If U2 are @ consensus that this is  the case with the original patch w.o
>> further changes, let it be.
>>
>
> I'm not sure... you guys are the iSER experts. :)  But considering a 64K PAGE_SIZE and an adjusted sg_tablesize of say, 32, w/o the min() we get (32 * 65536) >> 9 ==  4096.  So if the requirement is that max_sectors always be <= 1024, then we need the min()...
>

I guess the min is fine given that I have a patchset for 8MB support,
so we'll get it right then.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
