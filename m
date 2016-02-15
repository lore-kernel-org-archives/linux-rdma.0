From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/21] staging/rdma/hfi1: Fix header
Date: Sun, 14 Feb 2016 20:22:17 -0800
Message-ID: <20160215042214.351.82606.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix the header by moving the copyright notice out of the license text
and to the top of the header. Also, update the copyright date.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/affinity.c       |    5 +----
 drivers/staging/rdma/hfi1/affinity.h       |    5 +----
 drivers/staging/rdma/hfi1/aspm.h           |    5 +----
 drivers/staging/rdma/hfi1/chip.c           |    5 +----
 drivers/staging/rdma/hfi1/chip.h           |    5 +----
 drivers/staging/rdma/hfi1/chip_registers.h |    5 +----
 drivers/staging/rdma/hfi1/common.h         |    5 +----
 drivers/staging/rdma/hfi1/debugfs.c        |    5 +----
 drivers/staging/rdma/hfi1/debugfs.h        |    5 +----
 drivers/staging/rdma/hfi1/device.c         |    5 +----
 drivers/staging/rdma/hfi1/device.h         |    5 +----
 drivers/staging/rdma/hfi1/diag.c           |    5 +----
 drivers/staging/rdma/hfi1/dma.c            |    5 +----
 drivers/staging/rdma/hfi1/driver.c         |    5 +----
 drivers/staging/rdma/hfi1/efivar.c         |    5 +----
 drivers/staging/rdma/hfi1/efivar.h         |    5 +----
 drivers/staging/rdma/hfi1/eprom.c          |    5 +----
 drivers/staging/rdma/hfi1/eprom.h          |    5 +----
 drivers/staging/rdma/hfi1/file_ops.c       |    5 +----
 drivers/staging/rdma/hfi1/firmware.c       |    5 +----
 drivers/staging/rdma/hfi1/hfi.h            |    5 +----
 drivers/staging/rdma/hfi1/init.c           |    5 +----
 drivers/staging/rdma/hfi1/intr.c           |    5 +----
 drivers/staging/rdma/hfi1/iowait.h         |    5 +----
 drivers/staging/rdma/hfi1/mad.c            |    5 +----
 drivers/staging/rdma/hfi1/mad.h            |    5 +----
 drivers/staging/rdma/hfi1/opa_compat.h     |    5 +----
 drivers/staging/rdma/hfi1/pcie.c           |    5 +----
 drivers/staging/rdma/hfi1/pio.c            |    5 +----
 drivers/staging/rdma/hfi1/pio.h            |    5 +----
 drivers/staging/rdma/hfi1/pio_copy.c       |    5 +----
 drivers/staging/rdma/hfi1/platform.c       |    5 +----
 drivers/staging/rdma/hfi1/platform.h       |    5 +----
 drivers/staging/rdma/hfi1/qp.c             |    5 +----
 drivers/staging/rdma/hfi1/qp.h             |    5 +----
 drivers/staging/rdma/hfi1/qsfp.c           |    5 +----
 drivers/staging/rdma/hfi1/qsfp.h           |    5 +----
 drivers/staging/rdma/hfi1/rc.c             |    5 +----
 drivers/staging/rdma/hfi1/ruc.c            |    5 +----
 drivers/staging/rdma/hfi1/sdma.c           |    5 +----
 drivers/staging/rdma/hfi1/sdma.h           |    5 +----
 drivers/staging/rdma/hfi1/sysfs.c          |    5 +----
 drivers/staging/rdma/hfi1/trace.c          |    5 +----
 drivers/staging/rdma/hfi1/trace.h          |    5 +----
 drivers/staging/rdma/hfi1/twsi.c           |    5 +----
 drivers/staging/rdma/hfi1/twsi.h           |    5 +----
 drivers/staging/rdma/hfi1/uc.c             |    5 +----
 drivers/staging/rdma/hfi1/ud.c             |    5 +----
 drivers/staging/rdma/hfi1/user_exp_rcv.c   |    5 +----
 drivers/staging/rdma/hfi1/user_exp_rcv.h   |    5 +----
 drivers/staging/rdma/hfi1/user_pages.c     |    5 +----
 drivers/staging/rdma/hfi1/user_sdma.c      |    5 +----
 drivers/staging/rdma/hfi1/user_sdma.h      |    5 +----
 drivers/staging/rdma/hfi1/verbs.c          |    5 +----
 drivers/staging/rdma/hfi1/verbs.h          |    5 +----
 55 files changed, 55 insertions(+), 220 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/affinity.c b/drivers/staging/rdma/hfi1/affinity.c
index 59b2972..2cb8ca7 100644
--- a/drivers/staging/rdma/hfi1/affinity.c
+++ b/drivers/staging/rdma/hfi1/affinity.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/affinity.h b/drivers/staging/rdma/hfi1/affinity.h
index 2bdac96..b287e49 100644
--- a/drivers/staging/rdma/hfi1/affinity.h
+++ b/drivers/staging/rdma/hfi1/affinity.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/aspm.h b/drivers/staging/rdma/hfi1/aspm.h
index 67fce1d..3aac802 100644
--- a/drivers/staging/rdma/hfi1/aspm.h
+++ b/drivers/staging/rdma/hfi1/aspm.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 0a77465..93bf465 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 0b7055b..8468139 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -1,14 +1,13 @@
 #ifndef _CHIP_H
 #define _CHIP_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index 23898eb..770f05c 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -2,14 +2,13 @@
 #define DEF_CHIP_REG
 
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -21,8 +20,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index dcf8edf..e9b6bb3 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index 0b0fd8a..4fd58e3 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -1,13 +1,12 @@
 #ifdef CONFIG_DEBUG_FS
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -19,8 +18,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/debugfs.h b/drivers/staging/rdma/hfi1/debugfs.h
index 92d6fe1..b6fb681 100644
--- a/drivers/staging/rdma/hfi1/debugfs.h
+++ b/drivers/staging/rdma/hfi1/debugfs.h
@@ -1,14 +1,13 @@
 #ifndef _HFI1_DEBUGFS_H
 #define _HFI1_DEBUGFS_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/device.c b/drivers/staging/rdma/hfi1/device.c
index 58472e5..c05c39d 100644
--- a/drivers/staging/rdma/hfi1/device.c
+++ b/drivers/staging/rdma/hfi1/device.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/device.h b/drivers/staging/rdma/hfi1/device.h
index 2850ff7..5bb3e83 100644
--- a/drivers/staging/rdma/hfi1/device.h
+++ b/drivers/staging/rdma/hfi1/device.h
@@ -1,14 +1,13 @@
 #ifndef _HFI1_DEVICE_H
 #define _HFI1_DEVICE_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index b8faee0..6546e91 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/dma.c b/drivers/staging/rdma/hfi1/dma.c
index afe572d..7e8dab8 100644
--- a/drivers/staging/rdma/hfi1/dma.c
+++ b/drivers/staging/rdma/hfi1/dma.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 090b701..76ed5f7 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/efivar.c b/drivers/staging/rdma/hfi1/efivar.c
index 7dc5bae..5fe3924 100644
--- a/drivers/staging/rdma/hfi1/efivar.c
+++ b/drivers/staging/rdma/hfi1/efivar.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/efivar.h b/drivers/staging/rdma/hfi1/efivar.h
index 0707062..94e9e70 100644
--- a/drivers/staging/rdma/hfi1/efivar.h
+++ b/drivers/staging/rdma/hfi1/efivar.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index f36d06b..87114af 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/eprom.h b/drivers/staging/rdma/hfi1/eprom.h
index 5a61ba3..d41f0b1 100644
--- a/drivers/staging/rdma/hfi1/eprom.h
+++ b/drivers/staging/rdma/hfi1/eprom.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 7846f31..e4490ae 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 52a3e8c..d5befd1 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 07df515..9215482 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1,14 +1,13 @@
 #ifndef _HFI1_KERNEL_H
 #define _HFI1_KERNEL_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index cb75fc7..2def538 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 46eeeca..65348d1 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/staging/rdma/hfi1/iowait.h
index 2cb3f04..2ec6ef3 100644
--- a/drivers/staging/rdma/hfi1/iowait.h
+++ b/drivers/staging/rdma/hfi1/iowait.h
@@ -1,14 +1,13 @@
 #ifndef _HFI1_IOWAIT_H
 #define _HFI1_IOWAIT_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 305b7ae..78931fc 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/mad.h b/drivers/staging/rdma/hfi1/mad.h
index 9ebaaf9..55ee086 100644
--- a/drivers/staging/rdma/hfi1/mad.h
+++ b/drivers/staging/rdma/hfi1/mad.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/opa_compat.h b/drivers/staging/rdma/hfi1/opa_compat.h
index 30f7707..6ef3c1c 100644
--- a/drivers/staging/rdma/hfi1/opa_compat.h
+++ b/drivers/staging/rdma/hfi1/opa_compat.h
@@ -1,14 +1,13 @@
 #ifndef _LINUX_H
 #define _LINUX_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 2b0281c..7855962 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index a483c0a..859cb46 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index d80909a..0026976 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -1,14 +1,13 @@
 #ifndef _PIO_H
 #define _PIO_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/pio_copy.c b/drivers/staging/rdma/hfi1/pio_copy.c
index 998e7bc..228e9fb 100644
--- a/drivers/staging/rdma/hfi1/pio_copy.c
+++ b/drivers/staging/rdma/hfi1/pio_copy.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 2f07bec..4777414 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/platform.h b/drivers/staging/rdma/hfi1/platform.h
index 1f41bdc..19620cf 100644
--- a/drivers/staging/rdma/hfi1/platform.h
+++ b/drivers/staging/rdma/hfi1/platform.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 7b4637f..beaeb4e 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 7b1c57e..e7bc8d6 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -1,14 +1,13 @@
 #ifndef _QP_H
 #define _QP_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index c5e04b0..e38a0eb 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index c391750..2ad5980 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 70a6e63..8caad18 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index e2c4f82..5d84981 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index d989dee..134b888 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 5aec18b..8f50c99 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -1,14 +1,13 @@
 #ifndef _HFI1_SDMA_H
 #define _HFI1_SDMA_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index 3e3f180..c7f1271 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index 99fd017..6821d7c 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index dfa9967..b8b4416 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/twsi.c b/drivers/staging/rdma/hfi1/twsi.c
index 1cc0748..e82e52a 100644
--- a/drivers/staging/rdma/hfi1/twsi.c
+++ b/drivers/staging/rdma/hfi1/twsi.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/twsi.h b/drivers/staging/rdma/hfi1/twsi.h
index 0722ac8..5b8a5b5 100644
--- a/drivers/staging/rdma/hfi1/twsi.h
+++ b/drivers/staging/rdma/hfi1/twsi.h
@@ -1,14 +1,13 @@
 #ifndef _TWSI_H
 #define _TWSI_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 81b2dc7..5ba29af 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 65157a4..ae8a70f 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 36b61b5..fccae50 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.h b/drivers/staging/rdma/hfi1/user_exp_rcv.h
index 28ef98a..9bc8d9f 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.h
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.h
@@ -1,14 +1,13 @@
 #ifndef _HFI1_USER_EXP_RCV_H
 #define _HFI1_USER_EXP_RCV_H
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,8 +19,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/user_pages.c b/drivers/staging/rdma/hfi1/user_pages.c
index 1854c0c..3bf8108 100644
--- a/drivers/staging/rdma/hfi1/user_pages.c
+++ b/drivers/staging/rdma/hfi1/user_pages.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 7287307..14fe079 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index 7ef31a6..e0d0fe0 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 0e650b4..220bdb0 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index dc623c6..a85e6bc 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -1,12 +1,11 @@
 /*
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -18,8 +17,6 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
- *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
