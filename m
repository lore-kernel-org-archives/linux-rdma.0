From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use
 roce_gid_cache
Date: Thu, 19 Feb 2015 17:18:53 +0200
Message-ID: <54E5FEDD.2080001@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <f91c8ed3-f6a4-4b63-85f9-870d9687a14f@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f91c8ed3-f6a4-4b63-85f9-870d9687a14f-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/02/2015 00:02, Somnath Kotur wrote:
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -458,7 +458,7 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
>  }
>  
>  int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
> -			       u16 *vlan_id)
> +			       u16 *vlan_id, int if_index)
>  {
>  	int ret = 0;
>  	struct rdma_dev_addr dev_addr;
> @@ -481,6 +481,7 @@ int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
>  		return ret;
>  
>  	memset(&dev_addr, 0, sizeof(dev_addr));
> +	dev_addr.bound_dev_if = if_index;

There's a call to rdma_resolve_ip later in this function. I think it
overrides the if_index you store here.

I would expect this function to somehow limit the address resolution
done by rdma_resolve_ip so that the result has to use if_index as a
source interface.

>  
>  	ctx.addr = &dev_addr;
>  	init_completion(&ctx.comp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
