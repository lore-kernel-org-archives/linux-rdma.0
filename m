From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: enable changing HCA default max resource limits
Date: Tue, 22 Nov 2011 14:29:02 -0800
Message-ID: <4ECC222E.8080209@mellanox.com>
References: <20111108173940.GA23912@mellanox.com> <4ECBDE16.5040200@mellanox.com> <CAL1RGDXBwDoXs-cRD4b+8WrS0eRzwAaVn4g4+_14YSAsxpkNbw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E9BE26@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9BE26-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
>> Yeah, I guess it's sort of OK.  But is there really no better way to
>> handle this than making users deal with 7 more module parameters?

Do you have other suggestion?

We could have larger default profile which covers *most* known cases with the cost of memory for maintaining ICM page tables; however, there will be still some corner cases with large fabric.


> 
> Is it theoretically possible for these limits to change dynamically?

It requires extra code to clean up resources + reset HCA fw command (same thing to unload/reload driver)

> 
> Is there some easy way for nodes to discover the size of the fabric, so that drivers and applications can adjust their algorithms accordingly?  If not, would such a feature be useful enough to consider approaching the IBTA?
> 

I don't know if there is an easy way.

For in-band solution, query_sa for total port info records of the fabric would do; however, the driver first need to be up & running with some default profile, then it need to clean up and reset HCA with new learn profile. 

-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
