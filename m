From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 10:31:22 +0200
Message-ID: <526F725A.1040009@mellanox.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/10/2013 21:34, Markus Stockhausen wrote:
> After some quite hard test iterations the problem seems to come from the
> IPoIB switch from LRO to GRO between kernels 2.6.37 and 2.6.38.
>
> I built a test setup with a 2.6.38 kernel and additionaly compiled a 2.6.37
> ib_ipoib module against it. This way I can run a direct comparison
> between the old and new module. The major difference between the
> two version is inside the ipoib_ib_handle_rx_wc() function:
>
> 2.6.37: lro_receive_skb(&priv->lro.lro_mgr, skb, NULL);
> 2.6.38: napi_gro_receive(&priv->napi, skb);

These two commits that went in 3.3

936d7de IPoIB: Stop lying about hard_header_len and use skb->cb to stash 
LL addresses
a0417fa net: Make qdisc_skb_cb upper size bound explicit

were supposed to make IPoIB/GRO to work properly, specifically with 
them, you should see aggregation coming into play

I think Yishai Hadas from Mellanox was looking on that too, do we have 
any insights on the matter?

Or.


Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
