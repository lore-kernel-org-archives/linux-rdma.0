From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] mlx5: Report if kernel allows using MPW in
 SQ
Date: Tue, 12 Sep 2017 18:13:40 +0300
Message-ID: <1bb5967f-45fd-fb22-7772-10bf6b35e2e1@dev.mellanox.co.il>
References: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
 <1505130185-32658-2-git-send-email-yishaih@mellanox.com>
 <20170911164257.GA2403@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911164257.GA2403-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/11/2017 7:42 PM, Jason Gunthorpe wrote:
> On Mon, Sep 11, 2017 at 02:43:04PM +0300, Yishai Hadas wrote:
>>  	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
>> -	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
>> +	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1), /* Obsoleted */
>> +	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
>>  };
>>
>>  enum mlx5dv_cq_init_attr_mask {
>> diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
>> index fc63ae9..0e8a9a3 100644
>> +++ b/providers/mlx5/verbs.c
>> @@ -1965,8 +1965,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
>>  	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
>>  	attr->packet_pacing_caps = resp.packet_pacing_caps.caps;
>>
>> -	if (resp.support_multi_pkt_send_wqe)
>> -		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW;
>> +	if (resp.support_multi_pkt_send_wqe & MLX5_ALLOW_MPW)
>> +		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED;
>
> Er, you can't just drop setting MLX5DV_CONTEXT_FLAGS_MPW? That would
> break compat.
>

There was a kernel bug in 4.13 that MPW couldn't work properly despite 
the fact that the driver reported to user on its capability.

The bug was fixed in kernel 4.14 and now the feature is supported, the 
legacy value 1 on resp.support_multi_pkt_send_wqe is not reported from 
kernel any more as we can't rely on, and a new bit MLX5_ALLOW_MPW (1 << 
1) was introduced to indicate that feature is supported.

By the above change we want to report feature availability only when the 
new bit was set, legacy applications that use the old bit will see it 
off in both legacy and new kernels with this RDMA CORE as expected.

New applications should move to use the new bit 
MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED as pointed in mlx5dv.h and in the 
updated man page as part of this patch.

Does it clarify the above code change ?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
