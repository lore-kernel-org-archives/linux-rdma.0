From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] librdmacm/rsockets: Support MSG_WAITALL with rsockets
 recv()
Date: Thu, 16 Aug 2012 09:20:23 -0700
Message-ID: <1345134023.22811.9.camel@oc1677441337.ibm.com>
References: <1345074916.640.19.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89654@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89654-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-16 at 14:59 +0000, Hefty, Sean wrote:
> > Support MSG_WAITALL flag with recv() when using rsockets.
> > 
> > Signed-off-by: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> I started working on a patch for MSG_WAITALL a few weeks ago, but set it aside.  The problem I hit into was trying to handle MSG_PEEK at the same time.  This complicated the patch quite a bit.

MSG_PEEK is one of the conditions when recv() with MSG_WAITALL can return with
fewer bytes than requested. So i think we don't need to wait for all the data
when MSG_PEEK is also set.
   http://pubs.opengroup.org/onlinepubs/007904975/functions/recv.html

Thanks
Sridhar



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
