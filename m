From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 libmlx4] Infra-structure changes to support verbs
 extensions
Date: Tue, 16 Oct 2012 18:45:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AAE11F@ORSMSX101.amr.corp.intel.com>
References: <1350232988-22388-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350232988-22388-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -226,7 +225,7 @@ static struct ibv_device *mlx4_driver_init(const char
> *uverbs_sys_path,
>  	return NULL;
> 
>  found:
> -	if (abi_version < MLX4_UVERBS_MIN_ABI_VERSION ||
> +	if (abi_version <= MLX4_UVERBS_MIN_ABI_VERSION ||
>  	    abi_version > MLX4_UVERBS_MAX_ABI_VERSION) {
>  		fprintf(stderr, PFX "Fatal: ABI version %d of %s is not supported "
>  			"(min supported %d, max supported %d)\n",

It seems odd to throw an error when the ABI version is set to the minimum version that's supposed to be supported.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
