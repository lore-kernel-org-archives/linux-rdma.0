From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: issues with the rdma-cm server side mapping of IP to GID
Date: Tue, 4 Mar 2014 23:12:46 +0200
Message-ID: <CAJZOPZKT0oGfx99PhX9OP5_qaa2QyRVEJqE+hSkM7tykN23GOw@mail.gmail.com>
References: <530C51EF.2000509@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
	<5312F107.2000404@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F39F@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZ+ZC62FeZCy17ZMkzkxqrTdTrNRDs+nWQQ4Xjb9Sx5T3A@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F440@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D1F440-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 3, 2014 at 7:15 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
[...]
> If a CM REQ actually gets to the remote side, it could be rejected as an invalid GID, and the client could retry the request.

Retrying the request is practically calling

1. rdma_resolve_addr
2. rdma_resolve_route
3. rdma_connect

where step #1 would get wrong GID from the client arp cache and hence
step #3 would result in a reject and so on...
I am starting to think that the rdma address resolution must not make
use of the arp cache, or at least provide applications
the API to dictate that ARP request must be sent, how this sounds?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
