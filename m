From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/4] IB/core: Add receive Flow Steering support
Date: Fri, 28 Jun 2013 01:09:01 +0300
Message-ID: <CAJZOPZLf85TaCM9O3yahspRsuD3KcFzAY5b4nXxe46RiZwnk6Q@mail.gmail.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com>
	<1372251464-13394-2-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD36FF3@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736FD37415@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD37415-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 27, 2013 at 11:55 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> My point was that the IPv6 filter should be defined and used here.  The following basic > filters were defined:
> ethernet -      src/dst mac ...
> ip -            src/dst ip
> tcp/udp -       src/dst port
> These are at least somewhat intuitive to me.  The IB filter is
> ib -            (src/dst?) qpn, dgid
> This is equivalent to creating a filter that's:
> tcpip -         port, dst ip
> IMO, it would be better to define IB filters using the same structure that you used for
> tcp/ip/ethernet.  For example
> ibqp -  src/dst qpn (pkey?)
> ipv6 -  src/dst ipv6/gids (flowlabel?)
> iblink -        src/dst lids, (sl?)
>
> If the hardware can only support matching on the qpn and dgid, then it can simply fail
> any requests which specify a non-zero mask on the unsupported components.

Sean, I agree that the provided filter on dest qpn / dgid doesn't make
sense and will fix that out.

Still for the initial set of patches that goes in I tend to just
remove the IB filter structure and define the different IB filters
along your proposal in a follow-up patches/es, OK?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
