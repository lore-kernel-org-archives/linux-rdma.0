From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: issues with the rdma-cm server side mapping of IP to GID
Date: Wed, 5 Mar 2014 22:04:25 +0200
Message-ID: <CAJZOPZKya43Kxx96BdLM6z-FY5tTeYkCgxz8K9=mRyOM0mxsGA@mail.gmail.com>
References: <530C51EF.2000509@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
	<5312F107.2000404@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F39F@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZ+ZC62FeZCy17ZMkzkxqrTdTrNRDs+nWQQ4Xjb9Sx5T3A@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F440@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZKT0oGfx99PhX9OP5_qaa2QyRVEJqE+hSkM7tykN23GOw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388D200B2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D200B2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 4, 2014 at 11:31 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Clients should not be made aware of how the resolution was done.  The RDMA CM needs to abstract that problem.  Alternate mechanisms may be usable, but there aren't exactly a whole lot of options available.  The client could use native IB addressing at this point if it does not want to rely on address translation.

No, native IB addressing isn't an option for this and many other
applications. they  want to use IP addressing. We have to make sure
that our IP --> RDMA address resolving which uses neighbour lookup is
robust under the real life schemes I brought which makes the RC
connection / UD session established based on this resolution to be
totally broken.

So given the fact that we have a solution for large scale through
native IB addressing that offloads the address and route resolution --
what's your thinking on my suggestion to make address resolution for
rdma-cm endpoints creates with the  non native IB port space to use
solicit neighbour lookup (e.g avoid arp cache usage?)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
