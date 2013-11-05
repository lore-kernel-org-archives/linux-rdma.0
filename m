From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: AW: IPoIB GRO
Date: Tue, 5 Nov 2013 10:14:04 +0200
Message-ID: <5278A8CC.6020600@mellanox.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>	<527759C6.3070009@dev.mellanox.co.il>	<12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>	<52779612.9020103@dev.mellanox.co.il>	<12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de> <CABgxfbEom7fjdshX5AaSXT3P_y=3xFwN9T3V+QXkB0bK-EfNjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbEom7fjdshX5AaSXT3P_y=3xFwN9T3V+QXkB0bK-EfNjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/11/2013 23:17, Wendy Cheng wrote:
> Look to me that the "segmentation offload" (TSO) and "receive offload (GSO) are mutual exclusive ?

Wendy, the problem Markus stepped on was no GRO on the  receive side b/c 
of bad ID-ing of packets on the sender side during the  TSO process.

GSO is SW TSO, has nothing to do with GRO.

The code you referred two probably protects against an skb attempting to 
go through both TSO/GSO and  GRO
(e.g on forwarding) which isn't the case here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
