From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH v4 0/2] qib: few changes to bury MTRR use
Date: Tue, 21 Apr 2015 14:50:33 -0700
Message-ID: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

MTRR use is being deprecated and should only be used
with the helper arch_phys_wc_add() when PAT is not
available and enabled. This v4 follows addresse the
removal of the PAT module parameter for the driver which
was always preferring PAT anyway.

Luis R. Rodriguez (2):
  IB/qib: add acounting for MTRR
  IB/qib: use arch_phys_wc_add()

 drivers/infiniband/hw/qib/qib.h           |  1 -
 drivers/infiniband/hw/qib/qib_file_ops.c  |  3 ++-
 drivers/infiniband/hw/qib/qib_iba6120.c   |  8 +++---
 drivers/infiniband/hw/qib/qib_iba7220.c   |  8 +++---
 drivers/infiniband/hw/qib/qib_iba7322.c   | 41 +++++++++++++++----------------
 drivers/infiniband/hw/qib/qib_init.c      | 26 ++++++--------------
 drivers/infiniband/hw/qib/qib_wc_x86_64.c | 31 +++--------------------
 7 files changed, 39 insertions(+), 79 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
