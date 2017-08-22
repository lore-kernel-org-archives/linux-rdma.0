From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 03/16] IB/qib: Remove unnecessary memory allocation
 for boardname
Date: Mon, 21 Aug 2017 18:26:26 -0700
Message-ID: <20170822012625.32701.35321.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove all the memory allocation implemented for boardname and
directly assign the defined string literal.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba6120.c |   20 +++++-----------
 drivers/infiniband/hw/qib/qib_iba7220.c |   22 ++++++-----------
 drivers/infiniband/hw/qib/qib_iba7322.c |   40 +++++++++++++------------------
 drivers/infiniband/hw/qib/qib_init.c    |    1 -
 4 files changed, 32 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 46045fc..3259a60 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1742,38 +1742,32 @@ static void qib_setup_6120_interrupt(struct qib_devdata *dd)
  */
 static void pe_boardname(struct qib_devdata *dd)
 {
-	char *n;
-	u32 boardid, namelen;
+	u32 boardid;
 
 	boardid = SYM_FIELD(dd->revision, Revision,
 			    BoardID);
 
 	switch (boardid) {
 	case 2:
-		n = "InfiniPath_QLE7140";
+		dd->boardname = "InfiniPath_QLE7140";
 		break;
 	default:
 		qib_dev_err(dd, "Unknown 6120 board with ID %u\n", boardid);
-		n = "Unknown_InfiniPath_6120";
+		dd->boardname = "Unknown_InfiniPath_6120";
 		break;
 	}
-	namelen = strlen(n) + 1;
-	dd->boardname = kmalloc(namelen, GFP_KERNEL);
-	if (dd->boardname)
-		snprintf(dd->boardname, namelen, "%s", n);
 
 	if (dd->majrev != 4 || !dd->minrev || dd->minrev > 2)
 		qib_dev_err(dd,
-			"Unsupported InfiniPath hardware revision %u.%u!\n",
-			dd->majrev, dd->minrev);
+			    "Unsupported InfiniPath hardware revision %u.%u!\n",
+			    dd->majrev, dd->minrev);
 
 	snprintf(dd->boardversion, sizeof(dd->boardversion),
 		 "ChipABI %u.%u, %s, InfiniPath%u %u.%u, SW Compat %u\n",
 		 QIB_CHIP_VERS_MAJ, QIB_CHIP_VERS_MIN, dd->boardname,
-		 (unsigned)SYM_FIELD(dd->revision, Revision_R, Arch),
+		 (unsigned int)SYM_FIELD(dd->revision, Revision_R, Arch),
 		 dd->majrev, dd->minrev,
-		 (unsigned)SYM_FIELD(dd->revision, Revision_R, SW));
-
+		 (unsigned int)SYM_FIELD(dd->revision, Revision_R, SW));
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 49cd6e3..04bdd3d 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2050,41 +2050,35 @@ static void qib_setup_7220_interrupt(struct qib_devdata *dd)
  */
 static void qib_7220_boardname(struct qib_devdata *dd)
 {
-	char *n;
-	u32 boardid, namelen;
+	u32 boardid;
 
 	boardid = SYM_FIELD(dd->revision, Revision,
 			    BoardID);
 
 	switch (boardid) {
 	case 1:
-		n = "InfiniPath_QLE7240";
+		dd->boardname = "InfiniPath_QLE7240";
 		break;
 	case 2:
-		n = "InfiniPath_QLE7280";
+		dd->boardname = "InfiniPath_QLE7280";
 		break;
 	default:
 		qib_dev_err(dd, "Unknown 7220 board with ID %u\n", boardid);
-		n = "Unknown_InfiniPath_7220";
+		dd->boardname = "Unknown_InfiniPath_7220";
 		break;
 	}
 
-	namelen = strlen(n) + 1;
-	dd->boardname = kmalloc(namelen, GFP_KERNEL);
-	if (dd->boardname)
-		snprintf(dd->boardname, namelen, "%s", n);
-
 	if (dd->majrev != 5 || !dd->minrev || dd->minrev > 2)
 		qib_dev_err(dd,
-			"Unsupported InfiniPath hardware revision %u.%u!\n",
-			dd->majrev, dd->minrev);
+			    "Unsupported InfiniPath hardware revision %u.%u!\n",
+			    dd->majrev, dd->minrev);
 
 	snprintf(dd->boardversion, sizeof(dd->boardversion),
 		 "ChipABI %u.%u, %s, InfiniPath%u %u.%u, SW Compat %u\n",
 		 QIB_CHIP_VERS_MAJ, QIB_CHIP_VERS_MIN, dd->boardname,
-		 (unsigned)SYM_FIELD(dd->revision, Revision_R, Arch),
+		 (unsigned int)SYM_FIELD(dd->revision, Revision_R, Arch),
 		 dd->majrev, dd->minrev,
-		 (unsigned)SYM_FIELD(dd->revision, Revision_R, SW));
+		 (unsigned int)SYM_FIELD(dd->revision, Revision_R, SW));
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 2653064..92ae68c 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3582,75 +3582,69 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 static unsigned qib_7322_boardname(struct qib_devdata *dd)
 {
 	/* Will need enumeration of board-types here */
-	char *n;
-	u32 boardid, namelen;
-	unsigned features = DUAL_PORT_CAP;
+	u32 boardid;
+	unsigned int features = DUAL_PORT_CAP;
 
 	boardid = SYM_FIELD(dd->revision, Revision, BoardID);
 
 	switch (boardid) {
 	case 0:
-		n = "InfiniPath_QLE7342_Emulation";
+		dd->boardname = "InfiniPath_QLE7342_Emulation";
 		break;
 	case 1:
-		n = "InfiniPath_QLE7340";
+		dd->boardname = "InfiniPath_QLE7340";
 		dd->flags |= QIB_HAS_QSFP;
 		features = PORT_SPD_CAP;
 		break;
 	case 2:
-		n = "InfiniPath_QLE7342";
+		dd->boardname = "InfiniPath_QLE7342";
 		dd->flags |= QIB_HAS_QSFP;
 		break;
 	case 3:
-		n = "InfiniPath_QMI7342";
+		dd->boardname = "InfiniPath_QMI7342";
 		break;
 	case 4:
-		n = "InfiniPath_Unsupported7342";
+		dd->boardname = "InfiniPath_Unsupported7342";
 		qib_dev_err(dd, "Unsupported version of QMH7342\n");
 		features = 0;
 		break;
 	case BOARD_QMH7342:
-		n = "InfiniPath_QMH7342";
+		dd->boardname = "InfiniPath_QMH7342";
 		features = 0x24;
 		break;
 	case BOARD_QME7342:
-		n = "InfiniPath_QME7342";
+		dd->boardname = "InfiniPath_QME7342";
 		break;
 	case 8:
-		n = "InfiniPath_QME7362";
+		dd->boardname = "InfiniPath_QME7362";
 		dd->flags |= QIB_HAS_QSFP;
 		break;
 	case BOARD_QMH7360:
-		n = "Intel IB QDR 1P FLR-QSFP Adptr";
+		dd->boardname = "Intel IB QDR 1P FLR-QSFP Adptr";
 		dd->flags |= QIB_HAS_QSFP;
 		break;
 	case 15:
-		n = "InfiniPath_QLE7342_TEST";
+		dd->boardname = "InfiniPath_QLE7342_TEST";
 		dd->flags |= QIB_HAS_QSFP;
 		break;
 	default:
-		n = "InfiniPath_QLE73xy_UNKNOWN";
+		dd->boardname = "InfiniPath_QLE73xy_UNKNOWN";
 		qib_dev_err(dd, "Unknown 7322 board type %u\n", boardid);
 		break;
 	}
 	dd->board_atten = 1; /* index into txdds_Xdr */
 
-	namelen = strlen(n) + 1;
-	dd->boardname = kmalloc(namelen, GFP_KERNEL);
-	if (dd->boardname)
-		snprintf(dd->boardname, namelen, "%s", n);
-
 	snprintf(dd->boardversion, sizeof(dd->boardversion),
 		 "ChipABI %u.%u, %s, InfiniPath%u %u.%u, SW Compat %u\n",
 		 QIB_CHIP_VERS_MAJ, QIB_CHIP_VERS_MIN, dd->boardname,
-		 (unsigned)SYM_FIELD(dd->revision, Revision_R, Arch),
+		 (unsigned int)SYM_FIELD(dd->revision, Revision_R, Arch),
 		 dd->majrev, dd->minrev,
-		 (unsigned)SYM_FIELD(dd->revision, Revision_R, SW));
+		 (unsigned int)SYM_FIELD(dd->revision, Revision_R, SW));
 
 	if (qib_singleport && (features >> PORT_SPD_CAP_SHIFT) & PORT_SPD_CAP) {
 		qib_devinfo(dd->pcidev,
-			"IB%u: Forced to single port mode by module parameter\n",
-			dd->unit);
+			    "IB%u: Forced to single port mode by module parameter\n",
+			    dd->unit);
 		features &= PORT_SPD_CAP;
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 6c16ba1..4a2252a 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1398,7 +1398,6 @@ static void cleanup_device_data(struct qib_devdata *dd)
 		qib_free_ctxtdata(dd, rcd);
 	}
 	kfree(tmp);
-	kfree(dd->boardname);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
