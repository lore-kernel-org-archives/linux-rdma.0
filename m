From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] mlx5: Use non-cached mapping when Blueflame
 is not used
Date: Sun, 29 Oct 2017 23:26:04 +0200
Message-ID: <6531033a-9d61-bbca-ac14-46b05973610c@dev.mellanox.co.il>
References: <1509282070-1391-1-git-send-email-yishaih@mellanox.com>
 <1509282070-1391-2-git-send-email-yishaih@mellanox.com>
 <20171029173344.GA4488@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029173344.GA4488-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/29/2017 7:33 PM, Jason Gunthorpe wrote:
> On Sun, Oct 29, 2017 at 03:01:09PM +0200, Yishai Hadas wrote:
> 
>> diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
>> index ffe2c55..9e20a25 100644
>> +++ b/providers/mlx5/mlx5dv.h
>> @@ -632,6 +632,11 @@ enum mlx5dv_set_ctx_attr_type {
>>   	MLX5DV_CTX_ATTR_BUF_ALLOCATORS = 1,
>>   };
>>   
>> +enum {
>> +	MLX5_MMAP_GET_REGULAR_PAGES_CMD	= 0,
>> +	MLX5_MMAP_GET_NC_PAGES_CMD	= 3,
>> +};
>> +
> 
> These are added to a public header, but I couldn't see where they
> would get used by a DV user??

A DV user already had access to the mlx5 mmap command before this series 
by using the mlx5dv_get_qp() API:
qp_out->uar_mmap_offset = mqp->bf->uar_mmap_offset;

This offset value was used as part of the mmap() system call and reached 
the mlx5 kernel driver, it encoded the required command.

The enum that was added here, just exposed the optional commands which 
post this series may be issued including the new 
MLX5_MMAP_GET_NC_PAGES_CMD value.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
