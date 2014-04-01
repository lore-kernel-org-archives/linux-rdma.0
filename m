From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/5] IB/iser: Bump driver version to 1.3
Date: Tue, 1 Apr 2014 17:05:03 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04B37325@CRSMSX101.amr.corp.intel.com>
References: <1396358344-15191-1-git-send-email-ogerlitz@mellanox.com>
 <1396358344-15191-5-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396358344-15191-5-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h
> b/drivers/infiniband/ulp/iser/iscsi_iser.h
> index a4e4876..324129f 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
> @@ -69,7 +69,7 @@
> 
>  #define DRV_NAME	"iser"
>  #define PFX		DRV_NAME ": "
> -#define DRV_VER		"1.1"
> +#define DRV_VER		"1.3"

Not that it matters much but it seems odd to go from 1.1 to 1.3...

Ira


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
