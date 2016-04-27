From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Strange dma map/unmap/memcpy dance in ipoib_cm_handle_rx_wc
Date: Wed, 27 Apr 2016 10:48:29 +0300
Message-ID: <57206ECD.8060007@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I need a bit of help in understanding the logic behind the following
code sequence in ipoib_cm_handle_rx_wc:

newskb = ipoib_cm_alloc_rx_skb(dev, rx_ring, wr_id, frags,
                                       mapping, GFP_ATOMIC);

so Here a new skb is being allocated and pages constituting its
fragments are being dma mapped.

ipoib_cm_dma_unmap_rx(priv, frags, rx_ring[wr_id].mapping);

immediately after that the very same mappings are being unmapped. And
finally the resulting dma addresses from ipoib_cm_alloc_rx_skb are being
copied via this call to memcpy:

memcpy(rx_ring[wr_id].mapping, mapping, (frags + 1) * sizeof *mapping);

Can someone explain what's the logic of doing the memcpy after the
mappings have been destroyed, doesn't that mean the dma addresses stored
in rx_ring[wr_id].mapping are invalid?

Regards,
Nikolay
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
