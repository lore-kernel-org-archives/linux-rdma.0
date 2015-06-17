From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH acm] acme.c: Fix IPv6 address handling in inet_any_pton
Date: Wed, 17 Jun 2015 05:50:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF64BF@ORSMSX109.amr.corp.intel.com>
References: <558026A4.3090907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558026A4.3090907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks - applied manually

>  acm/src/acme.c |    2 +-

Path?

> diff --git a/acm/src/acme.c b/acm/src/acme.c
> index 9bf7557..d54c8b9 100644
> --- a/acm/src/acme.c
> +++ b/acm/src/acme.c
> @@ -787,7 +787,7 @@ static int inet_any_pton(char *addr, struct sockaddr

This was off by a couple hundred lines.  Can you check your branch?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
