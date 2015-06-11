From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH v7 0/3] linux: address broken PAT drivers
Date: Thu, 11 Jun 2015 13:19:51 -0700
Message-ID: <1434053994-2196-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bp-l3A5Bk7waGM@public.gmane.org
Cc: mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

Boris,

the following patches make use of the newly exported pat_enabled()
which went in through your tree. All driver and respective subsystem
maintainers have Acked these patches and are OK for them to go in through
your tree. Please let me know if there any issues or questions.

This v7 series goes with the return value fixed to be negative, this
was spotted by Mauro on the ivtv driver, I also spotted this then on
the ipath driver so fixed that there too in this series. The v7 also
goes with a small change on language on the Kconfig for the ivtv as
requested by Mauro. The v7 also goes with a small change on language
on the Kconfig for the ivtv as requested by Mauro.

Luis R. Rodriguez (3):
  ivtv: use arch_phys_wc_add() and require PAT disabled
  IB/ipath: add counting for MTRR
  IB/ipath: use arch_phys_wc_add() and require PAT disabled

 drivers/infiniband/hw/ipath/Kconfig           |  3 ++
 drivers/infiniband/hw/ipath/ipath_driver.c    | 18 ++++++---
 drivers/infiniband/hw/ipath/ipath_kernel.h    |  4 +-
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 43 +++++---------------
 drivers/media/pci/ivtv/Kconfig                |  3 ++
 drivers/media/pci/ivtv/ivtvfb.c               | 58 +++++++++++----------------
 6 files changed, 52 insertions(+), 77 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
