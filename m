From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/{mlx4,ipoib}: bug fixes for vendor mads and ipoib/gro
Date: Tue, 31 Jan 2012 18:14:11 -0800
Message-ID: <CAL1RGDW-uSrgpBhOr5gm4gWVrP3bqv2jihKqjpoPmbPoga_DJg@mail.gmail.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
 <4F24F51F.20309@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237333498CF8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237333498CF8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2012 at 11:12 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> What sort of impact does this bug to ipoib have?
>
> I ask because my bandwidth numbers on 3.2 for large, unidirectional transfers over ipoib are abysmal.

I don't think this particular issue is a regression... the
compare_ether_header()
has been in __napi_gro_receive() since at least 2.6.37 from mid-2010.

Did you try 3.1?  ie do you know that the 3.2 bad results are a recent
regression?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
