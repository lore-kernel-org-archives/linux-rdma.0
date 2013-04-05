From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP
 headers
Date: Fri, 05 Apr 2013 20:42:19 +0200
Message-ID: <CD84E1B9.5721%markus.stockhausen@gmx.de>
References: <1365109940-22916-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365109940-22916-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


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
>v2: Try to handle the case where we get all the data in the linear part
>of the skb and don't need the frag part at all.
>
> drivers/infiniband/ulp/ipoib/ipoib.h    |  3 ++-
> drivers/infiniband/ulp/ipoib/ipoib_ib.c | 17 ++++++-----------
> 2 files changed, 8 insertions(+), 12 deletions(-)
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
>     IPOIB_UD_RX_SG          = 2, /* max buffer needed for 4K mtu */
> 
>     IPOIB_CM_MTU          = 0x10000 - 0x10, /* padding to align header
>to 16 */
>diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>index 2cfa76f..ecf4faf 100644
>--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>@@ -109,11 +109,12 @@ static void ipoib_ud_skb_put_frags(struct
>ipoib_dev_priv *priv,
>                    struct sk_buff *skb,
>                    unsigned int length)
> {
>-    if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
>+    if (ipoib_ud_need_sg(priv->max_ib_mtu) &&
>+        length > IPOIB_UD_HEAD_SIZE) {
>         skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
>         unsigned int size;
>         /*
>-         * There is only two buffers needed for max_payload = 4K,
>+         * There are only two buffers needed for max_payload = 4K,
>          * first buf size is IPOIB_UD_HEAD_SIZE
>          */
>         skb->tail += IPOIB_UD_HEAD_SIZE;
>@@ -156,18 +157,12 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct
>net_device *dev, int id)
>     struct ipoib_dev_priv *priv = netdev_priv(dev);
>     struct sk_buff *skb;
>     int buf_size;
>-    int tailroom;
>     u64 *mapping;
> 
>-    if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
>-        buf_size = IPOIB_UD_HEAD_SIZE;
>-        tailroom = 128; /* reserve some tailroom for IP/TCP headers */
>-    } else {
>-        buf_size = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
>-        tailroom = 0;
>-    }
>+    buf_size = ipoib_ud_need_sg(priv->max_ib_mtu) ?
>+        IPOIB_UD_HEAD_SIZE : IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
> 
>-    skb = dev_alloc_skb(buf_size + tailroom + 4);
>+    skb = dev_alloc_skb(buf_size + 4);
>     if (unlikely(!skb))
>         return NULL;
> 
>-- 
>1.8.1.2
>

Hello,

this patch is better than the first one. No more lockups of the server.
Nevertheless I'm sorry to tell you that we are not finished yet. After
running some promising netperf/netserver tests I switched over to NFS.
The machine behaves like working with an active handbrake. Throughput
varies and sometimes communication is totally stopped. dmesg shows some
very ugly output.

[39604.701231] RPC: multiple fragments per record not supported
[39604.706444] RPC: multiple fragments per record not supported
[39604.720131] RPC: multiple fragments per record not supported
[39604.720172] rpc-srv/tcp: nfsd: got error -32 when sending 140
               bytes - shutting down socket
[39604.750376] RPC: multiple fragments per record not supported
[39604.767136] RPC: multiple fragments per record not supported
[39604.803122] RPC: multiple fragments per record not supported
[39604.836599] RPC: multiple fragments per record not supported
[39604.846579] RPC: multiple fragments per record not supported
[39604.854730] RPC: multiple fragments per record not supported
[39604.862385] RPC: multiple fragments per record not supported
[39604.911370] rpc-srv/tcp: nfsd: got error -32 when sending 140
               bytes - shutting down socket
[39607.278661] rpc-srv/tcp: nfsd: got error -32 when sending 140
               bytes - shutting down socket
[39629.669290] receive_cb_reply: Got unrecognized reply: calldir
               0x1 xpt_bc_xprt           (null) xid 50916007
[39629.669303] net_ratelimit: 98 callbacks suppressed
[39629.669306] RPC: multiple fragments per record not supported


Maybe you you know what problem is left.

Thank you very much.

Markus.

P.S. I did some more comprehensive tests on my Intel L5420 NFS
DDR Infiniband Server with my initial netperf/netserver scenario
and the dirty trick forcing the device max MTU to 3K. With a
powerful client throughput towards the server raised from 5Gbit/s
to 10Gbit/s. NFS large writes (receive operations) raised from
350MByte/s to 510MByte/s.

So if you have any chance to build a patch that uses fragments
depending on current set MTU people with older 2K switches
will be real winners.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
