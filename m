From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [linux-next PATCH] IB/core: change rdma_gid2ip into void
 function as it always return zero
Date: Wed, 29 Apr 2015 16:57:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC8979@ORSMSX109.amr.corp.intel.com>
References: <1430300444-29534-1-git-send-email-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430300444-29534-1-git-send-email-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ork-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ork-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/addr.c | 13 +++----------
>  include/rdma/ib_addr.h         |  3 +--
>  2 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/infiniband/core/addr.c
> b/drivers/infiniband/core/addr.c
> index f80da50..38339d2 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -472,13 +472,8 @@ int rdma_addr_find_dmac_by_grh(union ib_gid *sgid,
> union ib_gid *dgid, u8 *dmac,
>  	} sgid_addr, dgid_addr;
> 
> 
> -	ret = rdma_gid2ip(&sgid_addr._sockaddr, sgid);
> -	if (ret)
> -		return ret;
> -
> -	ret = rdma_gid2ip(&dgid_addr._sockaddr, dgid);
> -	if (ret)
> -		return ret;
> +	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
> +	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
> 
>  	memset(&dev_addr, 0, sizeof(dev_addr));
> 
> @@ -512,10 +507,8 @@ int rdma_addr_find_smac_by_sgid(union ib_gid *sgid,
> u8 *smac, u16 *vlan_id)
>  		struct sockaddr_in6 _sockaddr_in6;
>  	} gid_addr;
> 
> -	ret = rdma_gid2ip(&gid_addr._sockaddr, sgid);
> +	rdma_gid2ip(&gid_addr._sockaddr, sgid);
> 
> -	if (ret)
> -		return ret;
>  	memset(&dev_addr, 0, sizeof(dev_addr));
>  	ret = rdma_translate_ip(&gid_addr._sockaddr, &dev_addr, vlan_id);
>  	if (ret)
> diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
> index ce55906..ac54c27 100644
> --- a/include/rdma/ib_addr.h
> +++ b/include/rdma/ib_addr.h
> @@ -160,7 +160,7 @@ static inline int rdma_ip2gid(struct sockaddr *addr,
> union ib_gid *gid)
>  }
> 
>  /* Important - sockaddr should be a union of sockaddr_in and sockaddr_in6
> */
> -static inline int rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
> +static inline void rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
>  {
>  	if (ipv6_addr_v4mapped((struct in6_addr *)gid)) {
>  		struct sockaddr_in *out_in = (struct sockaddr_in *)out;
> @@ -173,7 +173,6 @@ static inline int rdma_gid2ip(struct sockaddr *out,
> union ib_gid *gid)
>  		out_in->sin6_family = AF_INET6;
>  		memcpy(&out_in->sin6_addr.s6_addr, gid->raw, 16);
>  	}
> -	return 0;
>  }
> 
>  static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
> --
> 1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
