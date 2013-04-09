From: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC/PATCH v3] IPoIB: Leave space in skb linear buffer for IP
 headers
Date: Tue, 9 Apr 2013 13:13:16 +0000
Message-ID: <4AF12E8016D2BF46BCDFCE8FAA77A358042F382C@FMSMSX103.amr.corp.intel.com>
References: <1365457381-10184-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365457381-10184-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> +	if (wc->byte_len > IPOIB_UD_HEAD_SIZE) {
> +		page = priv->rx_ring[wr_id].page;
> +		priv->rx_ring[wr_id].page = NULL;
> +	} else {
> +		page = NULL;
> +	}
> +
>  	/*
>  	 * If we can't allocate a new RX buffer, dump
>  	 * this packet and reuse the old buffer.
>  	 */
>  	if (unlikely(!ipoib_alloc_rx_skb(dev, wr_id))) {
>  		++dev->stats.rx_dropped;
> +		priv->rx_ring[wr_id].page = page;
>  		goto repost;
>  	}


Can you go through the "else" of the first if (page is NULL), then enter the second if? If so, isn't the page lost?


Dean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
