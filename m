From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v6 0/3] linux: address broken PAT drivers
Date: Thu, 11 Jun 2015 10:49:59 -0700
Message-ID: <1434045002-31575-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bp@suse.de
Cc: mchehab@osg.samsung.com, tomi.valkeinen@ti.com, bhelgaas@google.com, luto@amacapital.net, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Mauro,

since the ivtv patch is already acked by the driver maintainer
and depends on an x86 symbol that went through Boris' tree are you
OK in it going through Boris' tree?

Boris,

provided the outcome of the above maintainer's preference for you
to merge these please consider these patches for your tree. The
maintainer path is the only thing pending for the 1 ivtv patch.
The Infiniband subsystem maintainer, Doug, already provided his
ACK for the ipath driver and for this to go through you.

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
