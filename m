From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH v3 0/3] infiniband: few MTRR fixes and conversions
Date: Tue, 21 Apr 2015 13:37:53 -0700
Message-ID: <1429648676-17755-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

Infiniband has a few MTRR uses which from the looks of it
was first written on the ipath driver, later copied and pasted
on the qib driver. The behaviour of not counting is matched on
both drivers but with no good reason, since we want to generalize
use of MTRR in order to actually phase it, fix the driver to use
accounting as all other kernel users and also convert the qib
driver to arch_phys_wc_add().

The ipath driver is left without conversion to arch_phys_wc_add().

Luis R. Rodriguez (3):
  IB/qib: add acounting for MTRR
  IB/qib: use arch_phys_wc_add()
  IB/ipath: add counting for MTRR

 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c |  2 +-
 drivers/infiniband/hw/qib/qib_wc_x86_64.c     | 31 ++++-----------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
