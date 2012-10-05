From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rsocket UDP support
Date: Fri, 5 Oct 2012 00:22:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A9936E@FMSMSX151.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A9928F@FMSMSX151.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A8237346A9932D@FMSMSX151.amr.corp.intel.com>
 <CAOzFzEhkpCyr9sM4FrrLneXFLa1O-fsoRJrSKpQnoRanBso_sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEhkpCyr9sM4FrrLneXFLa1O-fsoRJrSKpQnoRanBso_sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think the RDS code achieves effectively this (though it has state
> keeping structures in the kernel, a luxury rsockets does not).
> Possibly some inspiration could be gleaned from their approach?

I've thought of RDS as well.  RDS maintains an active connection to every remote node, with data transfers over a shared RC QP.  It effectively avoids the UDP port to QPN mapping problem though.

My goal is for data transfers to occur over UD QPs for scalability and performance.  Maybe RDS could be used to maintain the UDP port to QPN mappings?  It would still require active connections between any communicating nodes, plus some way would need to be defined to notify remote clients of port to QPN changes.  Or maybe the best approach is simply to time out the mappings once known...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
