From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to re-use a QP for a new connection
Date: Fri, 20 Jun 2014 19:41:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm considering a change to xprtrdma that would re-use the QP and
> rdma_cm_id after a transport disconnect.
> 
> I use rdma_disconnect() and then wait for the TIMEWAIT_EXIT upcall.
> But after that, rdma_resolve_addr() always fails (-EINVAL).
> 
> What does xprtrdma need to do to get the rdma_cm_id back to the
> RDMA_CM_IDLE state so I can reset the QP?

I don't know that the kernel rdma cm code supports this.  It's likely that the id would need to have its state reset and data structures cleaned up.  That said, I doubt re-use of the rdma_cm_id would provide any real advantage.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
