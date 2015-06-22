From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH 0/2] x86/mm/pat: don't use WARN for nopat requirement
Date: Mon, 22 Jun 2015 15:31:56 -0700
Message-ID: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bp-l3A5Bk7waGM@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

Mauro, Doug,

The 0-day robot found using WARN() on built-in kernels confusing. Upon
further thought pr_warn() is better and will likely also not confuse
humans too.

Boris, provided maintainers Ack, please consider these patches.

These depend on pat_enabled() exported symbol which went in through
the x86 tree, so I suppose this also needs to go through there. This
is an example issue of cross-tree collateral evolution follow ups,
one reason why I punted the a RFD and proposal for a linux-oven [0].
In that regard I suppose follow ups like these would need to go through
that tree as well.

[0] http://lkml.kernel.org/r/20150619231255.GC7487-dAjH6bxAqesAS62YNPtMr3dQhYtBYE6JAL8bYrjMMd8@public.gmane.org

Luis R. Rodriguez (2):
  x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
  x86/mm/pat, drivers/media/ivtv: replace WARN() with pr_warn()

 drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
 drivers/media/pci/ivtv/ivtvfb.c            | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
