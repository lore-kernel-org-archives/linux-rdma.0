From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/RFC] IPoIB: Free ipoib neigh on path record failure so
 path rec queries are retried
Date: Tue, 26 Feb 2013 12:32:47 +0200
Message-ID: <512C8F4F.9000606@mellanox.com>
References: <1361814409-6704-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361814409-6704-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 25/02/2013 19:46, Roland Dreier wrote:
> If IPoIB fails to look up a path record (eg if it tries during an SM
> failover when one SM is dead but the new one hasn't taken over yet), the
> driver ends up with a neighbour structure but no address handle (AH).
> There's no mechanism to recover from this: any further packets sent to
> this destination will be silently dumped in ipoib_start_xmit().

Looking on the flow of sending ARP probes, I see that in 
unicast_arp_send, if there's no AH for the path, a path query is initiated,

   if (path->ah) {
                 ipoib_dbg(priv, "Send unicast ARP to %04x\n",
be16_to_cpu(path->pathrec.dlid));

                 spin_unlock_irqrestore(&priv->lock, flags);
                 ipoib_send(dev, skb, path->ah, IPOIB_QPN(cb->hwaddr));
                 return;
         } else if ((path->query || !path_rec_start(dev, path)) &&
                    skb_queue_len(&path->queue) < 
IPOIB_MAX_PATH_REC_QUEUE) {
                 __skb_queue_tail(&path->queue, skb);
         } else {
                 ++dev->stats.tx_dropped;
                 dev_kfree_skb_any(skb);
         }


so eventually the traffic should resume once the ND state machine sends 
a probe, agree? did you only wanted to make that faster?

Or.

> Fix this by freeing the neighbour structures when a path rec query fails, so that the next packet queued to be sent will trigger a new path record query.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
