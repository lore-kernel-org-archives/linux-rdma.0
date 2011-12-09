From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: multicast questions
Date: Fri, 9 Dec 2011 17:26:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373256551B6@ORSMSX102.amr.corp.intel.com>
References: <20111115100505.41345ixd637umx8h@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9ACEB@ORSMSX101.amr.corp.intel.com>
 <20111209100650.66404u6y1zbz3lt6@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111209100650.66404u6y1zbz3lt6-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is there a function that will map an IP to MGID? I have code that
> specifies the mgid, but I want to be able to specify it via an IP.

The rdma_cm will map the IP address to a corresponding MGID when calling rdma_join_multicast.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
