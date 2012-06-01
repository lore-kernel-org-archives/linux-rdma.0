From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ibacm/acme.c: Eliminate seg fault when source not
 supplied
Date: Fri, 1 Jun 2012 00:04:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A255F3@ORSMSX101.amr.corp.intel.com>
References: <4FC6919E.9090805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC6919E.9090805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/src/acme.c b/src/acme.c
> index d3f8174..533588c 100644
> --- a/src/acme.c
> +++ b/src/acme.c
> @@ -618,12 +618,18 @@ static void resolve(char *svc)
>  				ret = resolve_name(&path);
>  				break;
>  			case 'l':
> -				memset(&path, 0, sizeof path);
> -				ret = resolve_lid(&path);
> +				if (src_addr) {
> +					memset(&path, 0, sizeof path);
> +					ret = resolve_lid(&path);
> +				} else
> +					ret = -1;
>  				break;
>  			case 'g':
> -				memset(&path, 0, sizeof path);
> -				ret = resolve_gid(&path);
> +				if (src_addr) {
> +					memset(&path, 0, sizeof path);
> +					ret = resolve_gid(&path);
> +				} else
> +					ret = -1;
>  				break;
>  			default:
>  				break;

Thanks.

For this problem, I'd prefer to check for a NULL src_addr in resolve_lid and resolve_gid.  The ibacm service could then select a SLID/SGID based on the specified DLID/DGID.  This makes things easier for the user.

But until ibacm handles a 0 SLID/SGID, have ib_acme provide a more usable failure message.

I can make this patch if this sounds workable to you.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
