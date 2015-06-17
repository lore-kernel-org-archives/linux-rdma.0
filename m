From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 28/49] IB/hfi1: add misc OPA defines
Date: Wed, 17 Jun 2015 08:31:06 -0400
Message-ID: <20150617123106.8744.25841.stgit@phlsvslse11.ph.intel.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122755.8744.44665.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Friedley <andrew.friedley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Gregor <john.a.gregor-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kevin Pine <kevin.pine-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kyle Liddell <kyle.liddell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ravi Krishnaswamy <ravi.krishnaswamy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sanath Kumar <sanath.s.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vlad Danushevsky <vladimir.danusevsky-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/opa_compat.h |  132 +++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)
 create mode 100644 drivers/infiniband/hw/hfi1/opa_compat.h

diff --git a/drivers/infiniband/hw/hfi1/opa_compat.h b/drivers/infiniband/hw/hfi1/opa_compat.h
new file mode 100644
index 0000000..c60ab08
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/opa_compat.h
@@ -0,0 +1,132 @@
+#ifndef _LINUX_H
+#define _LINUX_H
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+/*
+ * This header file is for OPA-specific definitions which are
+ * required by the HFI driver, and which aren't yet in the Linux
+ * IB core. We'll collect these all here, then merge them into
+ * the kernel when that's convenient.
+ */
+
+/* OPA SMA attribute IDs */
+#define OPA_ATTRIB_ID_CONGESTION_INFO		cpu_to_be16(0x008b)
+#define OPA_ATTRIB_ID_HFI_CONGESTION_LOG	cpu_to_be16(0x008f)
+#define OPA_ATTRIB_ID_HFI_CONGESTION_SETTING	cpu_to_be16(0x0090)
+#define OPA_ATTRIB_ID_CONGESTION_CONTROL_TABLE	cpu_to_be16(0x0091)
+
+/* OPA PMA attribute IDs */
+#define OPA_PM_ATTRIB_ID_PORT_STATUS		cpu_to_be16(0x0040)
+#define OPA_PM_ATTRIB_ID_CLEAR_PORT_STATUS	cpu_to_be16(0x0041)
+#define OPA_PM_ATTRIB_ID_DATA_PORT_COUNTERS	cpu_to_be16(0x0042)
+#define OPA_PM_ATTRIB_ID_ERROR_PORT_COUNTERS	cpu_to_be16(0x0043)
+#define OPA_PM_ATTRIB_ID_ERROR_INFO		cpu_to_be16(0x0044)
+
+/* OPA status codes */
+#define OPA_PM_STATUS_REQUEST_TOO_LARGE		cpu_to_be16(0x100)
+
+static inline u8 port_states_to_logical_state(struct opa_port_states *ps)
+{
+	return ps->portphysstate_portstate & OPA_PI_MASK_PORT_STATE;
+}
+
+static inline u8 port_states_to_phys_state(struct opa_port_states *ps)
+{
+	return ((ps->portphysstate_portstate &
+		  OPA_PI_MASK_PORT_PHYSICAL_STATE) >> 4) & 0xf;
+}
+
+/*
+ * OPA port physical states
+ * IB Volume 1, Table 146 PortInfo/IB Volume 2 Section 5.4.2(1) PortPhysState
+ * values.
+ *
+ * When writing, only values 0-3 are valid, other values are ignored.
+ * When reading, 0 is reserved.
+ *
+ * Returned by the ibphys_portstate() routine.
+ */
+enum opa_port_phys_state {
+	IB_PORTPHYSSTATE_NOP = 0,
+	/* 1 is reserved */
+	IB_PORTPHYSSTATE_POLLING = 2,
+	IB_PORTPHYSSTATE_DISABLED = 3,
+	IB_PORTPHYSSTATE_TRAINING = 4,
+	IB_PORTPHYSSTATE_LINKUP = 5,
+	IB_PORTPHYSSTATE_LINK_ERROR_RECOVERY = 6,
+	IB_PORTPHYSSTATE_PHY_TEST = 7,
+	/* 8 is reserved */
+	OPA_PORTPHYSSTATE_OFFLINE = 9,
+	OPA_PORTPHYSSTATE_GANGED = 10,
+	OPA_PORTPHYSSTATE_TEST = 11,
+	OPA_PORTPHYSSTATE_MAX = 11,
+	/* values 12-15 are reserved/ignored */
+};
+
+/* where best to put this opcode? */
+#define CNP_OPCODE 0x80
+
+/* OPA_PORT_TYPE_* definitions - these belong in opa_port_info.h */
+#define OPA_PORT_TYPE_UNKNOWN          0
+#define OPA_PORT_TYPE_DISCONNECTED     1
+/* port is not currently usable, CableInfo not available */
+#define OPA_PORT_TYPE_FIXED            2
+/* A fixed backplane port in a director class switch. All OPA ASICS */
+#define OPA_PORT_TYPE_VARIABLE         3
+/* A backplane port in a blade system, possibly mixed configuration */
+#define OPA_PORT_TYPE_STANDARD         4
+/* implies a SFF-8636 defined format for CableInfo (QSFP) */
+#define OPA_PORT_TYPE_SI_PHOTONICS      5
+/* A silicon photonics module implies TBD defined format for CableInfo
+ * as defined by Intel SFO group */
+/* 6 - 15 are reserved */
+
+#endif /* _LINUX_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
