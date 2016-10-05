From: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] i40iw: Remove macros I40IW_STAG_KEY_FROM_STAG and I40IW_STAG_INDEX_FROM_STAG
Date: Wed,  5 Oct 2016 13:55:38 +0200
Message-ID: <1475668538-12914-1-git-send-email-thuth@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The macros I40IW_STAG_KEY_FROM_STAG and I40IW_STAG_INDEX_FROM_STAG are
apparently bad - they are using the logical "&&" operation which
does not make sense here. It should have been a bitwise "&" instead.
Since the macros seem to be completely unused, let's simply remove
them so that nobody accidentially uses them in the future. And while
we're at it, also remove the unused macro I40IW_CREATE_STAG.

Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_user.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 276bcef..0d91667 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -96,12 +96,6 @@ enum i40iw_device_capabilities_const {
 #define i40iw_physical_fragment u64
 #define i40iw_address_list u64 *
 
-#define I40IW_CREATE_STAG(index, key)       (((index) << 8) + (key))
-
-#define I40IW_STAG_KEY_FROM_STAG(stag)      ((stag) && 0x000000FF)
-
-#define I40IW_STAG_INDEX_FROM_STAG(stag)    (((stag) && 0xFFFFFF00) >> 8)
-
 #define	I40IW_MAX_MR_SIZE	0x10000000000L
 
 struct i40iw_qp_uk;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
