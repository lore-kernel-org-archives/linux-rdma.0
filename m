From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: AW: IPoIB GRO
Date: Mon, 4 Nov 2013 13:17:25 -0800
Message-ID: <CABgxfbEom7fjdshX5AaSXT3P_y=3xFwN9T3V+QXkB0bK-EfNjA@mail.gmail.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>
	<527759C6.3070009@dev.mellanox.co.il>
	<12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>
	<52779612.9020103@dev.mellanox.co.il>
	<12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I looked at TSO code earlier this year. IIRC, if TSO is on, the upper
layer (e.g. IP) would just send the super-packet down (to IPOIB) w/out
segmentation (for send); if off, it then does the segmentation (to
match the MTU size) before calling device's send. For GSO, I would
imagine it needs some sorts of segmentation sequence to know how to
pull them together on the receive end. Look to me that the
"segmentation offload" (TSO) and "receive offload (GSO) are mutual
exclusive ? Check out dev_gro_receive() (line number based on 2.6.32
RHEL kernel):

   2980
   2981         if (skb_is_gso(skb) || skb_has_frags(skb))
   2982                 goto normal;


See how it bails out when TSO (skb_is_gso()) is on ? So it looks like
an IPOIB bug that ipoib_ib_handle_rx_wc() does a unconditional
napi_gro_receive() regardless adapter capability (and TSO setting).

Just a guess !

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
