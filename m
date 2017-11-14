From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Warning fix and cleanup in qib_set_part_key()
Date: Tue, 14 Nov 2017 16:29:30 -0500
Message-ID: <20171114212905.17403.77778.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This two patch patch series is a fix in qib_set_part_key()
for a clang warning and to clean up the same routine to
take advantage of direct return statements to simplify the code.

---

Colin Ian King (1):
      IB/qib: remove redundant setting of any in for-loop

Joe Perches (1):
      IB/qib: Cleanup qib_set_part_key() with direct returns


 drivers/infiniband/hw/qib/qib_file_ops.c |   68 +++++++++++-------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
