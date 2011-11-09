From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 00/11] New Caching mechanism for ib_core
Date: Wed, 9 Nov 2011 15:12:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8DE44@ORSMSX101.amr.corp.intel.com>
References: <20111107084747.GA11297@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E8DDCE@ORSMSX101.amr.corp.intel.com>
 <20111109121907.GA6763@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111109121907.GA6763-DN/iB9hNKqpUanf73oPxOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > 1. Greater degree of control by individual drivers. Drivers have a
> > >    choice to use it or not.
> >
> > I believe that some callers need to know that specific query calls will not
> sleep.  That capability should either be required or exposed through the API.
> 
> The new cache access functions do not sleep. This is the primary
> objective of the exercise. See motviation 2 :)
> Exceptions are the init functions which may sleep because of kzalloc().
> Did you want me to mention this specifically in the comments?

Yes, but the use of the cache is hidden from the user.  Currently calls like ib_query_gid() are allowed to sleep.  If drivers are given the choice whether or not to use the cache, then there's no way for a user to know whether a query call will sleep or not.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
