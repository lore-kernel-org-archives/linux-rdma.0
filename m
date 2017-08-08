From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 12/27] IB/core: Change port_attr.sm_lid from 16
 to 32 bits
Date: Tue, 8 Aug 2017 09:49:17 -0700
Message-ID: <018c6e70-78d5-51ec-993f-35be575a6da1@intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
 <20170804205320.17853.77236.stgit@scvm10.sc.intel.com>
 <20170806081857.GC3636@mtr-leonro.local>
 <20170806082217.GE3636@mtr-leonro.local>
 <20170808144146.GF28851@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67CFAF96@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67CFAF96-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/8/2017 9:35 AM, Weiny, Ira wrote:
>> On Sun, Aug 06, 2017 at 11:22:17AM +0300, Leon Romanovsky wrote:
>>> On Sun, Aug 06, 2017 at 11:18:57AM +0300, Leon Romanovsky wrote:
>>>> On Fri, Aug 04, 2017 at 01:53:21PM -0700, Dennis Dalessandro wrote:
>>>>> From: Dasaratharaman Chandramouli
>>>>> <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>
>>>>> sm_lid field in struct ib_port_attr is increased to 32 bits. This
>>>>> enables core components to use larger LIDs if needed.
>>>>> The user ABI is unchanged and return 16 bit values when queried.
>>>>>
>>>>> Signed-off-by: Dasaratharaman Chandramouli
>>>>> <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>> ---
>>>>>   drivers/infiniband/core/uverbs_cmd.c |    8 +++++---
>>>>>   include/rdma/ib_verbs.h              |    2 +-
>>>>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/infiniband/core/uverbs_cmd.c
>>>>> b/drivers/infiniband/core/uverbs_cmd.c
>>>>> index 7ef74b0..38dce45 100644
>>>>> --- a/drivers/infiniband/core/uverbs_cmd.c
>>>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>>>>> @@ -275,11 +275,13 @@ ssize_t ib_uverbs_query_port(struct
>> ib_uverbs_file *file,
>>>>>   	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
>>>>>   	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
>>>>>   	resp.pkey_tbl_len    = attr.pkey_tbl_len;
>>>>> -	resp.sm_lid 	     = attr.sm_lid;
>>>>> -	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
>>>>> +	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
>>>>>   		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
>>>>> -	else
>>>>> +		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
>>>>> +	} else {
>>>>>   		resp.lid     = (u16)attr.lid;
>>>>> +		resp.sm_lid  = (u16)attr.sm_lid;
>>>> I see that lid is already has casting from u32 to u16 and now it is sm_lid.
>>>> Do we have more elegant way to achieve that? And comment for future
>>>> developers can be good too.
>>> I see now, you changed lid in patch 11. The same comment there.
>> To be clear on that point: NAK on *current* implementation.
>>
>> At least, it should be done in separate function, with comment explains why
>> are you doing and why it is safe to cast from higher value to lower value and
>> proper checks that you are not loosing information when you are casting.
>>
> A comment is reasonable.  However, I'm not sure a separate function is needed.  With the current interface there is no way to pass all the information through.
>
> Software which requires the use of these values will need to know to get them from other sources (OPA MAD queries for the SM LID for example.)
>
> Ira
>
Hi Leon,

I had already created a function to do the cast in the 'IB/core: Change 
wc.slid from 16 to 32 bits' patch
but I did not apply it here. Sorry about that.  My plan is to rename the 
functions to ib_lid_{spu16,be16}
and introduce them in this patch with a comment in the git log that 
these functions exist. I will also add
a comment stating why we aren't losing any information.

Thank you.

don

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
