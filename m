From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Wed, 17 Aug 2016 17:35:42 +0300
Message-ID: <4cf7c492-ed42-d9cc-38e8-15d8c50d585f@grimberg.me>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469708382-29408-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index ccf1d51..87e4332 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -209,6 +209,13 @@ enum ibv_odp_general_caps {
>  	IBV_ODP_SUPPORT = 1 << 0,
>  };
>
> +#define ibv_is_qpt_supported(caps, qpt) ((caps) & (1 << (qpt)))

This looks useful, but not directly related to this patch. Would
be better to add it in a stand-alone patch (even if its a one-liner).

Otherwise looks good,

Reviewed-by: Sagi Grimberg <sag-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
