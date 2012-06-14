From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Thu, 14 Jun 2012 16:20:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A316A2@ORSMSX101.amr.corp.intel.com>
References: <4FBD6981.2070502@us.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A2FA25@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206111220550.4907@oc4747053027.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A2FE06@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206132110190.13728@oc4747053027.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1206132110190.13728-Nzfcc2Us4m+Xfo/+vza+31aTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yes, good point. If the other side does not have rsockets then it is not that
> straightforward.
> 
> Some thoughts:
> 
> 1. The best option might be if we exchanged an option during
> connection setup. This tells the peers if the other side is capable of RDMA.
> If it is then one can switch to support of RDMA.
> 
> One obvious area of capability exchange is with TCP option. This requires TCP
> extension though.
> 
> Is there any other mechanism to exchange capabilities?
> 
> 
> 2. In IPoIB, the address resolution returns RC or UD flags. This can allow
> one to determine if the remote peer is capabile of RDMA i.e. use of RC but
> does not tell us if rsockets is present on the peer.
> Can one still attmept an rsockets based connection over RC mode?
> 
> 
> 3. Use a service discovery mechanism to determine if the remote peer supports
> rsockets. This will need to determine if the remote port is enabled; not just
> that rsockets is present on the system.

Just to be clear, rsockets has limited fallback support today, mainly targeting the client side of the connection.

Another option, which I think ends up being a requirement for iWarp, is to use a port mapper function.  But I'd also be willing to live without fallback support on apps that require fork support.

Regarding the choices above, I have given thought to introducing a service for supporting rsocket UDP (to handle UDP port to QP mappings).  Maybe that would give us the most flexibility to solving this and all future problems.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
