From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: fix resolving local ipv6 address.
Date: Wed, 7 Oct 2009 15:55:44 -0700
Message-ID: <26840C730CF948B48A185F3F073FFC04@amr.corp.intel.com>
References: <1254955759.23471.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1254955759.23471.7.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Here is a patch to allow a local ipv6 address to be resolved by rdma_cm.
>I reported this in https://bugs.openfabrics.org/show_bug.cgi?id=1759
>
>To reproduce the problem:
>rping -s -v -a ::0  &
>rping -c -v -a <ipv6 address local to this system>
>rdma_resolve_addr error -1
>
>Local ipv6 address was obtained with "ip addr show ib0"
>
>
>Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Using 'addr' there is clearly wrong, since it's of type struct rdma_dev_addr.
Thanks

>
>diff -Naurp ofa_kernel-1.5.orig/drivers/infiniband/core/addr.c ofa_kernel-
>1.5/drivers/infiniband/core/addr.c
>--- ofa_kernel-1.5.orig/drivers/infiniband/core/addr.c	2009-09-25
>12:19:44.000000000 -0700
>+++ ofa_kernel-1.5/drivers/infiniband/core/addr.c	2009-09-25
>12:22:23.000000000 -0700
>@@ -393,7 +393,7 @@ static int addr_resolve_local(struct soc
>
> 		for_each_netdev(&init_net, dev)
> 			if (ipv6_chk_addr(&init_net,
>-					  &((struct sockaddr_in6 *)
addr)->sin6_addr,
>+					  &((struct sockaddr_in6 *)
dst_in)->sin6_addr,
> 					  dev, 1))
> 				break;
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
