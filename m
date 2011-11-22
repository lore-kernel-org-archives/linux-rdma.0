From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] mlx4_core: enable changing HCA default max resource
 limits
Date: Tue, 22 Nov 2011 20:52:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9BE26@ORSMSX101.amr.corp.intel.com>
References: <20111108173940.GA23912@mellanox.com>
 <4ECBDE16.5040200@mellanox.com>
 <CAL1RGDXBwDoXs-cRD4b+8WrS0eRzwAaVn4g4+_14YSAsxpkNbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXBwDoXs-cRD4b+8WrS0eRzwAaVn4g4+_14YSAsxpkNbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yeah, I guess it's sort of OK.  But is there really no better way to
> handle this than making users deal with 7 more module parameters?

Is it theoretically possible for these limits to change dynamically?

Is there some easy way for nodes to discover the size of the fabric, so that drivers and applications can adjust their algorithms accordingly?  If not, would such a feature be useful enough to consider approaching the IBTA?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
