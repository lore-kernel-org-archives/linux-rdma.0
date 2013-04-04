From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH/RFC] IPoIB: Leave space in skb linear buffer for IP
 headers
Date: Thu, 04 Apr 2013 21:44:25 +0200
Message-ID: <CD83A15C.56F5%markus.stockhausen@gmx.de>
References: <1365099482-30287-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365099482-30287-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
>Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> noticed that IPoIB was
>spending significant time doing memcpy() in __pskb_pull_tail().  He
>found that this is because his adapter reports a maximum MTU of 4K,
>which causes IPoIB datagram mode to receive all the actual data in a
>separate page in the fragment list.
>
>We're already allocating extra tailroom for the skb linear part, so we
>might as well use it.
>
>Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>Reported-by: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
>Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>---
> drivers/infiniband/ulp/ipoib/ipoib.h    |  3 ++-
> drivers/infiniband/ulp/ipoib/ipoib_ib.c | 12 +++---------
> 2 files changed, 5 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
>b/drivers/infiniband/ulp/ipoib/ipoib.h
>index eb71aaa..ab2cc4c 100644
>--- a/drivers/infiniband/ulp/ipoib/ipoib.h
>+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
>@@ -64,7 +64,8 @@ enum ipoib_flush_level {
> enum {
>     IPOIB_ENCAP_LEN          = 4,
> 
>-    IPOIB_UD_HEAD_SIZE      = IB_GRH_BYTES + IPOIB_ENCAP_LEN,
>+    /* add 128 bytes of tailroom for IP/TCP headers */
>+    IPOIB_UD_HEAD_SIZE      = IB_GRH_BYTES + IPOIB_ENCAP_LEN + 128,
>...

Thanks for the help but I guess the patch is not yet perfect.

My (remote) test machine stopped responding after loading the new
ipoib module. Tomorrow I can check the console. Having a look at the
source code I guess we now have some major problems when receiving
small packets:

...
ipoib_ud_skb_put_frags(..., unsigned int length)
  ...
  size = length - IPOIB_UD_HEAD_SIZE; /* may be less than zero! */
  skb_frag_size_set(frag, size);
  ...

Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
