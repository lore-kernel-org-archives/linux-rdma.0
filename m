From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/core: Fix unaligned accesses
Date: Sun, 03 May 2015 07:46:10 -0600
Message-ID: <554626A2.20302@oracle.com>
References: <1430515349-183903-1-git-send-email-david.ahern@oracle.com> <AM3PR05MB093528DFDBBA39DD7977CC85DCD30@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM3PR05MB093528DFDBBA39DD7977CC85DCD30-LOZWmgKjnYgQouBfZGh8ttqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/3/15 4:20 AM, Shachar Raindel wrote:
> Hi,
>
> The patch is broken - you did not update

--verbose. I did not update what?
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of David Ahern
>> Sent: Saturday, May 02, 2015 12:22 AM

That is filled in by git and the time on the server is proper. So what 
do you disagree with?

>
> <snipped>
>
>>
>>   static int cm_compare_data(struct ib_cm_compare_data *src_data,
>>   			   struct ib_cm_compare_data *dst_data)
>>   {
>> -	u8 src[IB_CM_COMPARE_SIZE];
>> -	u8 dst[IB_CM_COMPARE_SIZE];
>> +	u32 src[IB_CM_COMPARE_SIZE];
>> +	u32 dst[IB_CM_COMPARE_SIZE];
>>
>>   	if (!src_data || !dst_data)
>>   		return 0;
>> @@ -460,10 +459,10 @@ static int cm_compare_data(struct
>> ib_cm_compare_data *src_data,
>>   	return memcmp(src, dst, IB_CM_COMPARE_SIZE);
>
> You added a BUG here - you should use (IB_CM_COMPARE_SIZE * sizeof(u32)).

Thank you for pointing that out. Changed those to sizeof(src) and 
sizeof(compare_data->mask).


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
