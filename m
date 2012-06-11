From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Mon, 11 Jun 2012 21:21:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A2FE06@ORSMSX101.amr.corp.intel.com>
References: <4FBD6981.2070502@us.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A2FA25@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206111220550.4907@oc4747053027.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1206111220550.4907-Nzfcc2Us4m+Xfo/+vza+31aTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Though one can consider the fall-back in reverse order i.e. if the
> rdma connection fails  continue with the already established connection (over
> the normal inet socket).

When I consider fallback, one of the issues is handling the case where one of the two sides is not using rsockets.  This prevents us from injecting new traffic into the TCP stream.

Still, if there's a way for rsockets to support fork for a significant number of apps, I'd be willing to live with these trade-offs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
