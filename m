From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/srp: fix invalid indirect_sg_entries parameter
 value
Date: Tue, 24 Jan 2017 18:50:32 +0200
Message-ID: <9743e758-2ba9-c6f6-f0fc-72112de72a4a@mellanox.com>
References: <1483538377-19379-1-git-send-email-maxg@mellanox.com>
 <1483538377-19379-2-git-send-email-maxg@mellanox.com>
 <1483542561.3048.13.camel@sandisk.com> <1485275572.43764.27.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485275572.43764.27.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 1/24/2017 6:32 PM, Doug Ledford wrote:
> On Wed, 2017-01-04 at 15:09 +0000, Bart Van Assche wrote:
>> On Wed, 2017-01-04 at 15:59 +0200, Max Gurtovoy wrote:
>>>
>>> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> After setting indirect_sg_entries module_param to huge value (e.g
>>> 500,000),
>>> srp_alloc_req_data() fails to allocate indirect descriptors for the
>>> request
>>> ring (kmalloc fails). This commit enforces the maximum value of
>>> indirect_sg_entries
>>> to be SG_MAX_SEGMENTS as signified in module param description.
>>>
>>> Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>>> b/drivers/infiniband/ulp/srp/ib_srp.c
>>> index 0f67cf9..79bf484 100644
>>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>> @@ -3699,6 +3699,12 @@ static int __init srp_init_module(void)
>>>  		indirect_sg_entries = cmd_sg_entries;
>>>  	}
>>>
>>> +	if (indirect_sg_entries > SG_MAX_SEGMENTS) {
>>> +		pr_warn("Clamping indirect_sg_entries to %u\n",
>>> +			SG_MAX_SEGMENTS);
>>> +		indirect_sg_entries = SG_MAX_SEGMENTS;
>>> +	}
>>> +
>>>  	srp_remove_wq = create_workqueue("srp_remove");
>>>  	if (!srp_remove_wq) {
>>>  		ret = -ENOMEM;
>>
>> Thanks!
>>
>> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>
> This patch is a fix patch and should have been tagged as such.
>  However, the proper tagging is complicated by the fact that the
> SG_MAX_SEGMENTS was originally named SCSI_MAX_SG_CHAIN_SEGMENTS.  The
> fix applies all the way back to the first patch to enable SG segments
> in the srp driver, but you will need a different patch for the kernels
> prior to the rename.  For this patch, I've added the following tags and
> applied the patch:
>
> Fixes: 65e8617fba17 (scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS)
> Fixes: c07d424d6118 (IB/srp: add support for indirect tables that don't
> fit in SRP_CMD)
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.7+
>
> Someone should write a patch for the earlier kernels and submit it
> directly to stable@ with the patch flagged for application on kernels
> from 2.6.39 to 4.6.  The upstream hash for the fix to mainline is:
>
> commit 0a475ef4226e305bdcffe12b401ca1eab06c4913
> Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Wed Jan 4 15:59:37 2017 +0200
>
>     IB/srp: fix invalid indirect_sg_entries parameter value
>

Israel,
please take it for earlier kernels as well.

Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
