From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: better understanding rdma-cm UNREACHABLE/ETIMEDOUT scheme
Date: Tue, 21 May 2013 18:54:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD29C09@ORSMSX109.amr.corp.intel.com>
References: <519B8DB3.3010500@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD29AE3@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZJ44fgPtBHpu5eXSVUQb0zP7rJH1UvL2RneDCrhGVLSwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJ44fgPtBHpu5eXSVUQb0zP7rJH1UvL2RneDCrhGVLSwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dina Leventol <dinal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> One thing seen in the nodes dmesg is a message from an old patch of
> >> yours which exists in ofed1.5.3 but didn't hit (or wasn't accepted?)
> >> upstream saying "ib_cm: calculated mra timeout 67584 > 8192, decreasing
> >> used timeout_ms" does this provides any insight into the problem?
> 
> > I don't remember this patch at all.
> 
> Alex sent it to you, is that something which is missing upstream or
> alternatively could create troubles on that ofed stack where its
> applied?

I saw the patch and recall it now.  It was a fix for an SRP target and shouldn't affect your tests or cause any issues.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
