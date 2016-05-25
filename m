From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 10/10] IB/hfi1: Fix credit return threshold adjustment
Date: Wed, 25 May 2016 08:27:37 -0700
Message-ID: <602d7329-b8ee-0e90-3afb-726ec44fb190@sandisk.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
 <20160524195111.19706.76829.stgit@scvm10.sc.intel.com>
 <20160525133613.GN25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525133613.GN25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/25/2016 06:36 AM, Leon Romanovsky wrote:
> On Tue, May 24, 2016 at 12:51:12PM -0700, Dennis Dalessandro wrote:
>> @@ -1872,11 +1873,27 @@ int pio_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_scontexts)
>>  			if (!newmap->map[i])
>>  				goto bail;
>>  			newmap->map[i]->mask = (1 << ilog2(sz)) - 1;
>> -			/* assign send contexts */
>> +			/*
>> +			 * assign send contexts and
>> +			 * adjust credit return threshold
>> +			 */
>>  			for (j = 0; j < sz; j++) {
>> -				if (dd->kernel_send_context[scontext])
>> +				if (dd->kernel_send_context[scontext]) {
>>  					newmap->map[i]->ksc[j] =
>>  					dd->kernel_send_context[scontext];
>> +					thres = min(sc_percent_to_threshold(
>> +						    dd->kernel_send_context
>> +						    [scontext], 50),
>> +						    sc_mtu_to_threshold(
>> +						    dd->kernel_send_context
>> +						    [scontext], dd->vld[i].mtu,
>> +						    dd->rcd[0]->rcvhdrqentsize)
>> +						    );
>> +					sc_set_cr_threshold(
>> +						dd->
>> +						kernel_send_context[scontext],
>
> You took checkpatch warnings output to the extreme.

Hello Dennis and Leon,

Such formatting usually means that the indentation level is too deep. 
One way to address this is to move the body of the for loop into a new 
function. Choosing a shorter name for kernel_send_context and 
introducing temporary variables for the results of 
sc_percent_to_threshold(...) would also help.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
