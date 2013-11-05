From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: AW: AW: AW: IPoIB GRO
Date: Tue, 5 Nov 2013 10:49:18 +0200
Message-ID: <5278B10E.6010903@mellanox.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>,<527759C6.3070009@dev.mellanox.co.il> <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>,<52779612.9020103@dev.mellanox.co.il> <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>,<5278A757.2070406@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/11/2013 10:25, Markus Stockhausen wrote:
> Are the TCP Ids in an TSO setup generated through firmware or in the software stack?

in HW
> And if in firmware: How does the card know how to increase them? I would expect that it only works with IB packets
> and does not know of the IP encapsulation.

All vendors networking HW which does TSO gets a hint from the driver 
this is TSO packet, in your case see
mlx4_ib_post_send and look for IB_WR_LSO

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
