From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 03/11] IB/core: Change ah_attr.dlid from 16 to 32 bits
Date: Thu, 8 Dec 2016 14:02:06 -0800
Message-ID: <780da5d7-8567-e1c6-9253-c67c8742ef8f@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20161208151356.GE9722@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208151356.GE9722-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/8/2016 7:13 AM, Leon Romanovsky wrote:
> On Tue, Nov 22, 2016 at 02:38:44PM -0500, Dasaratharaman Chandramouli wrote:
>> dlid field in ah_attr is increased to 32 bits. This
>> enables core components to use the larger addresses if needed.
>> The user ABI is unchanged and userspace applications can use
>> 16 bit lids when creating and modifying address handles.
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>
> <...>
>
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 52216f6..294d3ed 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -814,7 +814,7 @@ struct ib_mr_status {
>>
>>  struct ib_ah_attr {
>>  	struct ib_global_route	grh;
>> -	u16			dlid;
>> +	u32			dlid;
>>  	u8			sl;
>>  	u8			src_path_bits;
>>  	u8			static_rate;
>
> It looks like this structure can be reshuffled. Can you run pahole on it, please?
Will run before posting the next revision. Thanks.
>
> Thanks
>
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
