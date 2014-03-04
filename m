From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: issues with the rdma-cm server side mapping of IP to GID
Date: Tue, 4 Mar 2014 21:39:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D200D8@ORSMSX109.amr.corp.intel.com>
References: <530C51EF.2000509@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
	<5312F107.2000404@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F39F@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZ+ZC62FeZCy17ZMkzkxqrTdTrNRDs+nWQQ4Xjb9Sx5T3A@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F440@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZKT0oGfx99PhX9OP5_qaa2QyRVEJqE+hSkM7tykN23GOw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237388D200B2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D200B2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > If a CM REQ actually gets to the remote side, it could be rejected as
> an
> > invalid GID, and the client could retry the request.
> >
> > Retrying the request is practically calling
> >
> > 1. rdma_resolve_addr
> > 2. rdma_resolve_route
> > 3. rdma_connect
> 
> Yep - the entire setup is broken.  If the wrong remote GID was resolved,
> then the wrong local GID _may_ have been selected.  There's no easy
> guaranteed recovery here.

On second thought, I don't think this is true.  The SGID is selected based on the IP address, not the DGID.  If the remote CM rejects the connection, the RDMA CM may be able to recover by restarting at step 2.  Query for a new PR, then re-issue the connect request.  It may be possible to do this without the application's involvement.  I'm not sure how the librdmacm would handle this, since the initial resolve_route would be redone.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
