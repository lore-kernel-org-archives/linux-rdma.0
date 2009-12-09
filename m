From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/51] updated patches for adding QIB driver
Date: Wed, 09 Dec 2009 14:47:39 -0800
Message-ID: <adahbrzpxx0.fsf@roland-alpha.cisco.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203190305.29507.58158.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 03 Dec 2009 11:03:05 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

have not had a chance to look at the new submission yet but I think you
need at least the following rolled in, to avoid calling __exit code that
might have been thrown away from the error path of your init function.

Building with CONFIG_DEBUG_SECTION_MISMATCH=y when you see that the
kernel build tells you that you introduced new section mismatches is
probably a good idea.

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 781c87f..53c314f 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2450,7 +2450,7 @@ done:
 	return ret;
 }
 
-void __exit qib_dev_cleanup(void)
+void qib_dev_cleanup(void)
 {
 	if (qib_class) {
 		class_destroy(qib_class);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
