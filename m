From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: "Unicast, no dst" warning from IPoIB
Date: Mon, 22 Mar 2010 14:20:40 +0200
Message-ID: <20100322122040.GA12224@mtldesk030.lab.mtl.com>
References: <Pine.LNX.4.64.1003221142430.5956@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003221142430.5956-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 22, 2010 at 11:55:18AM +0200, Or Gerlitz wrote:
> 
> Recently (e.g now with 2.6.34-rc2) I came across this warning from ipoib_start_xmit.
> I wasn't sure if it suggests that there's some real problem or not. It happens
> few times and then vanishes, for some reason the type is always 0002 (ETH_P_AX25)
> 
> 	ib0: Unicast, no dst: type 0002, QPN 200800 1404:0001:8000:0048:fe80:0000:0000:0000
> 	ib1: Unicast, no dst: type 0002, QPN 200800 1404:0001:8000:0049:fe80:0000:0000:0000
> 

The data printed is garbage - the correct data is at offset of 8
bytes. Thus we have:
protocol = 0x800 = IP
The IPoIB inteface is connected mode
The QP number is 0x48 which you're likely to find with mlx4 hardware.
Then we see the beginning of the GID which starts with fw80...

Why did we get this? It could happen since the IPoIB neighbour that
the specific instance of IPoIB CM is pointing to might have SKBs in
its queue. When REP arrives for this connection, it will re-queue all
the queued SKBs again but there may be no dst for them anymore.

The following patch could avoid these messages:


diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index f8302c2..114404f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -996,9 +996,14 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 
 	while ((skb = __skb_dequeue(&skqueue))) {
 		skb->dev = p->dev;
-		if (dev_queue_xmit(skb))
-			ipoib_warn(priv, "dev_queue_xmit failed "
-				   "to requeue packet\n");
+		if (skb_dst(skb) && skb_dst(skb)->neighbour) {
+			if (dev_queue_xmit(skb))
+				ipoib_warn(priv, "dev_queue_xmit failed "
+					   "to requeue packet\n");
+		} else {
+			++p->dev->stats.tx_dropped;
+			dev_kfree_skb_any(skb);
+		}
 	}
 
 	ret = ib_send_cm_rtu(cm_id, NULL, 0);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5e6c2de..12265b7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -490,9 +490,14 @@ static void path_rec_completion(int status,
 
 	while ((skb = __skb_dequeue(&skqueue))) {
 		skb->dev = dev;
-		if (dev_queue_xmit(skb))
-			ipoib_warn(priv, "dev_queue_xmit failed "
-				   "to requeue packet\n");
+		if (skb_dst(skb) && skb_dst(skb)->neighbour) {
+			if (dev_queue_xmit(skb))
+				ipoib_warn(priv, "dev_queue_xmit failed "
+					   "to requeue packet\n");
+		} else {
+			++dev->stats.tx_dropped;
+			dev_kfree_skb_any(skb);
+		}
 	}
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
