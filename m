From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/11] The HCA should not be closed until all resources have
 been released.
Date: Fri, 16 Oct 2009 16:50:33 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CC6@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This results in a hang on windows, since closing the device frees
the event processing thread.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/device.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 90a044e..4f26e87 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -354,16 +354,17 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 		}
 	}
 
+	dapl_os_lock_destroy(&hca_ptr->ib_trans.lock);
+	dapl_os_lock_destroy(&hca_ptr->ib_trans.llock);
+	destroy_cr_pipe(hca_ptr); /* no longer need pipe */
+	ucm_service_destroy(hca_ptr);
+
 	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
 		if (ibv_close_device(hca_ptr->ib_hca_handle))
 			return (dapl_convert_errno(errno, "ib_close_device"));
 		hca_ptr->ib_hca_handle = IB_INVALID_HANDLE;
 	}
 
-	dapl_os_lock_destroy(&hca_ptr->ib_trans.lock);
-	dapl_os_lock_destroy(&hca_ptr->ib_trans.llock);
-	destroy_cr_pipe(hca_ptr); /* no longer need pipe */
-	ucm_service_destroy(hca_ptr);
 	return (DAT_SUCCESS);
 }
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
