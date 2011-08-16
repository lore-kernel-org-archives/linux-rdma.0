From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question about libibcm
Date: Tue, 16 Aug 2011 23:43:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E40311@FMSMSX151.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E402F6@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E402F6-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -	if (param->path) {
> -		abi_path = alloca(sizeof(*abi_path));
> -		if (!abi_path)
> -			return ERR(ENOMEM);
> +	abi_path = alloca(sizeof(*abi_path));
> +	if (!abi_path)
> +		return ERR(ENOMEM);

There's no reason for alloca() here, so I replaced it with a stack variable.  This same sort of check was also in ib_cm_send_req() and ib_cm_send_lap().  I updated those as well.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
