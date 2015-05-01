From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix unaligned accesses
Date: Fri, 01 May 2015 08:27:46 -0600
Message-ID: <55438D62.6080505@oracle.com>
References: <1430448168-38479-1-git-send-email-david.ahern@oracle.com> <1430469925.2957.14.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430469925.2957.14.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/1/15 2:45 AM, Yann Droneaud wrote:
>>   static int cm_compare_data(struct ib_cm_compare_data *src_data,
>>   			   struct ib_cm_compare_data *dst_data)
>>   {
>> -	u8 src[IB_CM_COMPARE_SIZE];
>> -	u8 dst[IB_CM_COMPARE_SIZE];
>> +	u32 src[IB_CM_COMPARE_SIZE];
>> +	u32 dst[IB_CM_COMPARE_SIZE];
>>
>
> You have to change IB_CM_COMPARE_SIZE, as it's going to allocate more
> bytes than necessary.

d'oh. yes, oversight. Thanks for pointing out.

>
> Perhaps renaming IB_CM_COMPARE_SIZE to IB_CM_COMPARE_COUNT would be
> good, then remove the division by sizeof(u32).

I feel like I stepped into a tar pit... It's a bit odd that 
IB_CM_COMPARE_SIZE is part of an enum rather than a #define.

It seems like the number of bytes being compared is what is relevant 
here; comparing by u32's or unsigned long's is the optimization. So, I'd 
prefer to leave it as SIZE.

If there are no objections I think the better thing to do is pull it out as:

/* compare's are done u32 at a time */
#define IB_CM_COMPARE_SIZE 64/sizeof(u32)



>> diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
>> index 0e3ff30647d5..0dd576f40c83 100644
>> --- a/include/rdma/ib_cm.h
>> +++ b/include/rdma/ib_cm.h
>> @@ -337,8 +337,8 @@ void ib_destroy_cm_id(struct ib_cm_id *cm_id);
>>   #define IB_SDP_SERVICE_ID_MASK	cpu_to_be64(0xFFFFFFFFFFFF0000ULL)
>>
>>   struct ib_cm_compare_data {
>> -	u8  data[IB_CM_COMPARE_SIZE];
>> -	u8  mask[IB_CM_COMPARE_SIZE];
>> +	u32  data[IB_CM_COMPARE_SIZE];
>> +	u32  mask[IB_CM_COMPARE_SIZE];
>>   };
>>
>>   /**
>
> Anyway, you might want to compile this part of the kernel with
> -Wcast-align and ignore the false positive (in particular
> every other use of container_of()).

Why?

David
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
