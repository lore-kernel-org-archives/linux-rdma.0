From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 9/10] IB/qib: use safer test on the result of
 find_first_zero_bit
Date: Wed, 4 Jun 2014 20:03:58 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21BE939B@fmsmsx120.amr.corp.intel.com>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
 <1401872880-23685-10-git-send-email-Julia.Lawall@lip6.fr>
 <32E1700B9017364D9B60AED9960492BC21BE92E6@fmsmsx120.amr.corp.intel.com>
 <alpine.DEB.2.02.1406042118420.1977@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1406042118420.1977-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Cc: infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> No, it's not necessary.  It turns out that the result cannot be greater than the
> requested maximum value.
> 
> Julia

Ok. 

No stable then.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
