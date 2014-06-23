From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 17:25:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823739931EE90@ORSMSX109.amr.corp.intel.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com>
 <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com>
 <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com>
 <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com>
 <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8@oracle.com>
 <1828884A29C6694DAF28B7E6B8A823739931EDD5@ORSMSX109.amr.corp.intel.com>
 <1F02274F-B3FC-40EE-A46D-FB178EA3781B@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1F02274F-B3FC-40EE-A46D-FB178EA3781B-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> For the record, with both mlx4 and cxgb4, we see FRMRs left valid
> after a FAST_REG_MR is flushed during a connection loss. More study
> needed, obviously.

Is the bug that this type of WR completes in error, but actually exposed the memory region?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
