From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 0/2] x86/mm/pat: modify nopat requirement warning
Date: Wed, 24 Jun 2015 10:23:18 -0700
Message-ID: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bp@suse.de, andy@silverblocksystems.net, mchehab@osg.samsung.com, dledford@redhat.com
Cc: mingo@kernel.org, fengguang.wu@intel.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The 0-day robot found that the notpat requirement warning was
being triggered on the ivtv driver on the module init path,
that will always trigger on built-in devices. We want that warning
to trigger only if real hardware is found so this moves the ivtv
warning out under its quasi-probe routine. The ipath driver already
had the warning issued on its probe so no shift of code is needed
there. Upon further thought though we decided WARN() messages would
confuse people so instead just change these to sensible single
pr_warn() messages for both drivers.

This goes build and load tested.

Luis R. Rodriguez (2):
  x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
  x86/mm/pat, drivers/media/ivtv: move pat warn and replace WARN() with
    pr_warn()

 drivers/infiniband/hw/ipath/ipath_driver.c |  6 ++++--
 drivers/media/pci/ivtv/ivtvfb.c            | 15 +++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty
