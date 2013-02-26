From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC] IPoIB: Free ipoib neigh on path record failure so
 path rec queries are retried
Date: Tue, 26 Feb 2013 08:55:47 -0800
Message-ID: <CAG4TOxMyTEMKLUF1+YLej7Txj4P5MLZ49cVqAhQP4CW8qi0AUA@mail.gmail.com>
References: <1361814409-6704-1-git-send-email-roland@kernel.org> <512C8F4F.9000606@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512C8F4F.9000606-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 26, 2013 at 2:32 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Looking on the flow of sending ARP probes, I see that in unicast_arp_send,
> if there's no AH for the path, a path query is initiated,
>
>   if (path->ah) {
>                 ipoib_dbg(priv, "Send unicast ARP to %04x\n",
> be16_to_cpu(path->pathrec.dlid));
>
>                 spin_unlock_irqrestore(&priv->lock, flags);
>                 ipoib_send(dev, skb, path->ah, IPOIB_QPN(cb->hwaddr));
>                 return;
>         } else if ((path->query || !path_rec_start(dev, path)) &&
>                    skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
>                 __skb_queue_tail(&path->queue, skb);
>         } else {
>                 ++dev->stats.tx_dropped;
>                 dev_kfree_skb_any(skb);
>         }
>
>
> so eventually the traffic should resume once the ND state machine sends a
> probe, agree? did you only wanted to make that faster?

Well, look at ipoib_start_xmit():

    /* unicast, arrange "switch" according to probability */
    switch (header->proto) {
    case htons(ETH_P_IP):
    case htons(ETH_P_IPV6):
        neigh = ipoib_neigh_get(dev, cb->hwaddr);
        if (unlikely(!neigh)) {
            neigh_add_path(skb, cb->hwaddr, dev);
            return NETDEV_TX_OK;
        }
        break;
    case htons(ETH_P_ARP):
    case htons(ETH_P_RARP):
        /* for unicast ARP and RARP should always perform path find */
        unicast_arp_send(skb, dev, cb);
        return NETDEV_TX_OK;

etc.  So although you mention ND, we only call unicast_arp_send() for
IPv4 ARP.  And in our case we were actually using IPv6, which follows
the main flow with neighbours even for neighbour discovery packets.
So there's no way to ever recover from having the failed path record.

In fact I bet this is why the bug has been there as long as it has
been: almost no one is using IPv6 on IPoIB seriously, and IPv4 should
work OK as you point out.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
