From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: AW: AW: ACK behaviour difference LRO/GRO
Date: Wed, 30 Oct 2013 09:40:16 +0200
Message-ID: <5270B7E0.5030202@mellanox.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>,<526F725A.1040009@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A0CFD@EXCHANGE.collogia.de> <526F9F5A.7010903@mellanox.com> <526FB051.5020709@dev.mellanox.co.il>,<526FBEF7.2030807@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A1FCB@EXCHANGE.collogia.de>,<526FDA6E.3030708@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A214B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A214B-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/10/2013 23:17, Markus Stockhausen wrote:
> I would confirm that there is still room to improve GRO even in newest kernels

indeed, so there IS aggregation but the BW isn't as good as it used to 
be with LRO, maybe something
in IPoIB doesn't play well with the core kernel NAPI/GRO/Interrupt 
Coalescing APIs/Layers.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
