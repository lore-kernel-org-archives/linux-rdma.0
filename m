From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 7/9] IB/core: Add RoCE IP based addressing extensions
 for uverbs
Date: Wed, 11 Sep 2013 14:38:26 +0300
Message-ID: <52305632.1030604@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com> <1378824099-22150-8-git-send-email-ogerlitz@mellanox.com> <6d494aa8d403e0c50b16f09fbd2c3ab6@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6d494aa8d403e0c50b16f09fbd2c3ab6-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: meuh-zgzEX58YAwA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/09/2013 13:06, meuh-zgzEX58YAwA@public.gmane.org wrote:
>> @@ -672,6 +821,15 @@ struct ib_uverbs_create_ah {
>>      struct ib_uverbs_ah_attr attr;
>>  };
>>
>> +struct ib_uverbs_create_ah_ex {
>> +    __u32 comp_mask;
>
>
> This create a hole or introduced unaligned access depending on the 
> 64bits ABI.

Matan is OOO for couple of days, but this seems to me as good catch.

Anyway, note that the current upstream providers of RoCE (ocrdma, mlx4) 
don't support
IB_USER_VERBS_CMD_CREATE_AH. This means their user space library need 
not access
the kernel for AH creation, we will drop the extended version of the 
this command from
the patch series altogether to reduce the volume of kernel changes and
ease with the review, thanks for the feedback so far!

Or.


>
> The way this structure is used to map a struct ib_uverbs_create_ah 
> seems wrong.
>
>> +    __u64 response;
>> +    __u64 user_handle;
>> +    __u32 pd_handle;
>> +    __u32 reserved;
>> +    struct ib_uverbs_ah_attr_ex attr;
>> +};
>> +
>>  struct ib_uverbs_create_ah_resp {
>>      __u32 ah_handle;
>>  }; 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
