From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/6] treewide: Add and use dev_fmt similar to pr_fmt
Date: Wed,  9 May 2018 08:15:44 -0700
Message-ID: <cover.1525878372.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: openipmi-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The pr_fmt mechanism exists for pr_<level> logging message prefixing,
but no similar capability exists for dev_<level> message prefixing.

Many uses of dev_<level> have an embedded prefix for logging output.

So add a similar dev_fmt macro that can automatically prefix the
dev_<level> logging output.

Rename the existing dev_<level> functions to _dev_<level> and add new
macros that call _dev_<level> with the desired prefix if defined.

The new default #define for dev_fmt is blank.

Convert ipmi and infiniband to use this mechanism.

Miscellanea:

o x86/early-quirks uses an internal macro for #define dev_err which conflicts
 with the existing dev_err macro, so rename it.

Joe Perches (6):
  x86/early-quirks: Rename duplicate define of dev_err
  device: Add #define dev_fmt similar to #define pr_fmt
  ipmi: msghandler: Add and use pr_fmt and dev_fmt, remove PFX
  ipmi: Use more common logging styles
  ipmi: Convert printk(KERN_<level> to pr_<level>(
  infiniband: qplib_fp: Use dev_fmt

 arch/x86/kernel/early-quirks.c           |   8 +-
 drivers/base/core.c                      |  12 +--
 drivers/char/ipmi/ipmi_bt_sm.c           |  64 ++++++++--------
 drivers/char/ipmi/ipmi_devintf.c         |  11 ++-
 drivers/char/ipmi/ipmi_kcs_sm.c          |   4 +-
 drivers/char/ipmi/ipmi_msghandler.c      |  53 +++++++------
 drivers/char/ipmi/ipmi_poweroff.c        |  67 ++++++++---------
 drivers/char/ipmi/ipmi_si_hardcode.c     |   9 ++-
 drivers/char/ipmi/ipmi_si_hotmod.c       |  17 +++--
 drivers/char/ipmi/ipmi_si_intf.c         |  22 +++---
 drivers/char/ipmi/ipmi_si_pci.c          |  12 +--
 drivers/char/ipmi/ipmi_si_platform.c     |  20 ++---
 drivers/char/ipmi/ipmi_smic_sm.c         |  26 +++----
 drivers/char/ipmi/ipmi_ssif.c            |  73 +++++++++---------
 drivers/char/ipmi/ipmi_watchdog.c        |  52 +++++++------
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 125 ++++++++++++++-----------------
 include/linux/device.h                   | 103 ++++++++++++++-----------
 17 files changed, 330 insertions(+), 348 deletions(-)

-- 
2.15.0
