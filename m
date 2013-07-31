From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V8 libmlx4 1/2] Infra-structure changes to support verbs
 extensions
Date: Wed, 31 Jul 2013 10:44:53 +0300
Message-ID: <51F8C075.5020602@dev.mellanox.co.il>
References: <1374741618-890-1-git-send-email-yishaih@mellanox.com> <1374741618-890-2-git-send-email-yishaih@mellanox.com> <20130725171956.GB17616@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130725171956.GB17616-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/25/2013 8:19 PM, Jason Gunthorpe wrote:
> On Thu, Jul 25, 2013 at 11:40:17AM +0300, Yishai Hadas wrote:
>>   	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
>> +	ibv_ctx->ops = mlx4_ctx_ops;
>> +	/* New verbs should be added as below
>> +	* verbs_ctx->drv_new_func1 = mlx4_new_func1;
>> +	*/
> The comment needs revising to refer to verbs_set_ctx_op
>
>>   static inline struct mlx4_device *to_mdev(struct ibv_device *ibdev)
>>   {
>> -	return to_mxxx(dev, device);
>> +	/* ibv_device is first field of verbs_device
>> +	  * see try_driver in libibverbs.
>> +	*/
>> +	return ((struct mlx4_device *)
>> +	 ((void *)ibdev - offsetof(struct mlx4_device, verbs_dev)));
>           ^^^^^^^^^^^^^^
>
> container_of please
>
> Also this can have my ack after these changes.
     Thanks, I accept both comments, will handle as part of V9.
     Once we agree on V8 comments of libibverbs will re-send both V9.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
