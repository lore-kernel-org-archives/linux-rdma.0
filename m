From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-3.17 0/5] ib umad/mad updates
Date: Fri,  8 Aug 2014 19:00:51 -0400
Message-ID: <1407538856-13968-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland,

The following series has 3 patches to update kernel logging within ib_umad and
ib_mad and 2 patches to add User space rmpp support via a new ioctl
registration call.

I have rebased all 5 against your for-next tree in preparation for inclusion in
the 3.17 merge window.

Thank you,
Ira Weiny

[PATCH for-3.17 1/5] ib/umad: update module to [pr|dev]_* style print messages
[PATCH for-3.17 2/5] ib/mad: update module to [pr|dev]_* style print messages
[PATCH for-3.17 3/5] ib/mad: Add dev_notice messages for various umad/mad
[PATCH for-3.17 4/5] ib/mad: add new ioctl to user space to support new
[PATCH for-3.17 5/5] ib/mad: Add user space RMPP support
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
