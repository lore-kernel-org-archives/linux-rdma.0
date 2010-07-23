From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Fri, 23 Jul 2010 08:48:15 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D7B7@orsmsx501.amr.corp.intel.com>
References: <Pine.GSO.4.40.1007212046022.17-100000@kappa.cse.ohio-state.edu>
	<4C47EFFB.1040808@Voltaire.com>
 <AANLkTinPRAPDZi8xn5zOr5k26-=040N45vVWk1usf8H5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinPRAPDZi8xn5zOr5k26-=040N45vVWk1usf8H5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Larry <tsrjzq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > you can see the lid and qp numbers are zero, something is broken... when you use the rdma-cm,
> > the address to be provided to the utility should be on an IPoIB subnet, is that what you're doing?
>   The address may not have to be IPoIB interface, any interface which
> can find the other side will be OK.

Use of the rdma_cm requires that the address be associated with an RDMA device.  In the case of IB, the address should refer to an IP address assigned to an ipoib device.  If you remove the -c option from the perftest, any IP address should work.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
