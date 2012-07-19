From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] IB/qib: Add support for per-device/per-port parameters
Date: Thu, 19 Jul 2012 09:04:11 -0400
Message-ID: <20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120719130356.4706.63775.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add support for per-device/per-port driver parameters
allowing users to specify different values for different
ports/devices. All converted parameters will behave as
expected if the old parameter format is used.

New per-device/per-port parameter format:
    <param>=[<d>,]<u>[:<p>]=<v>[,<u>[:<p>]=<v>]
where:
    <param> - driver parameter name
    <d> - default value applicable to all devices/ports
    <u> - unit number (zero-based)
    <p> - port number (1-based)
    <v> - numeric value

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h         |  119 ++++++++++++++++++-
 drivers/infiniband/hw/qib/qib_driver.c  |  197 ++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/qib/qib_iba6120.c |   14 +-
 drivers/infiniband/hw/qib/qib_iba7220.c |   22 ++-
 drivers/infiniband/hw/qib/qib_iba7322.c |   60 +++++----
 drivers/infiniband/hw/qib/qib_init.c    |   24 ++--
 drivers/infiniband/hw/qib/qib_mad.c     |    3 
 drivers/infiniband/hw/qib/qib_pcie.c    |   24 ++--
 drivers/infiniband/hw/qib/qib_verbs.c   |    3 
 9 files changed, 381 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 6e19ec8..f4feb71 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -51,6 +51,7 @@
 #include <linux/completion.h>
 #include <linux/kref.h>
 #include <linux/sched.h>
+#include <linux/moduleparam.h>
 
 #include "qib_common.h"
 #include "qib_verbs.h"
@@ -721,7 +722,7 @@ struct qib_devdata {
 	u64 __iomem *kregend;
 	/* physical address of chip for io_remap, etc. */
 	resource_size_t physaddr;
-	/* qib_cfgctxts pointers */
+	/* cfgctxts pointers */
 	struct qib_ctxtdata **rcd; /* Receive Context Data */
 
 	/* qib_pportdata, points to array of (physical) port-specific
@@ -1077,6 +1078,114 @@ struct qib_devdata {
 	struct tasklet_struct error_tasklet;
 };
 
+enum qib_mod_param_t {
+	qib_mod_param_drv,
+	qib_mod_param_unit,
+	qib_mod_param_port
+};
+
+typedef int (*param_set_func_t)(struct qib_devdata *, u8, u64);
+
+struct qib_mod_param {
+	const char *name;
+	enum qib_mod_param_t type;
+	param_set_func_t func;
+	ulong dflt;
+	struct list_head list;
+	struct list_head pport;
+};
+
+extern int qib_set_mod_param(const char *, struct kernel_param *);
+extern int qib_get_mod_param(char *, struct kernel_param *);
+extern u64 qib_read_mod_param(struct qib_mod_param *, u16, u8);
+extern void qib_clean_mod_param(void);
+
+#define MAX_QIB_PARAM_LEN 128
+/**
+ * QIB_MODPARAM_GLOBAL - define a global module parameter
+ * @N: name of the module parameter
+ *
+ * Define a global module parameter for use in multiple files.
+ */
+#define QIB_MODPARAM_GLOBAL(N) \
+extern struct qib_mod_param qmp_##N
+/**
+ * QIB_MODPARAM_DRV - define a driver-scope module parameter
+ * @N: name of the module parameter
+ * @D: default value
+ * @P: visibility in sysfs
+ * @S: description
+ *
+ * Define a driver-scope (global to the driver instance) module
+ * parameter.
+ */
+#define QIB_MODPARAM_DRV(N, D, P, S)				  \
+	struct qib_mod_param qmp_##N = {			  \
+		.name = __stringify(N),				  \
+		.type = qib_mod_param_drv,			  \
+		.dflt = (ulong)D,				  \
+		.pport = { NULL, NULL }				  \
+	};							  \
+	module_param_named(N, qmp_##N.dflt, ulong, P);		  \
+	MODULE_PARM_DESC(N, S " (dflt: " __stringify(D) ")")
+/**
+ * QIB_MODPARAM_UNIT - define a unit-scope module parameter
+ * @N: name of the module parameter
+ * @F: callback function for dynamic value settings
+ * @D: default value
+ * @P: visibility in sysfs
+ * @D: description
+ *
+ * Define a unit-scope module parameter. Unit-scope module
+ * parameters allows specifying individual values for each of the
+ * QIB units.
+ */
+#define QIB_MODPARAM_UNIT(N, F, D, P, S)			   \
+	struct qib_mod_param qmp_##N = {			   \
+		.name = __stringify(N),				   \
+		.func = ((P) & S_IWUGO ? F : NULL),		   \
+		.type = qib_mod_param_unit,			   \
+		.dflt = (ulong)D,				   \
+		.pport = { NULL, NULL }				   \
+	};							   \
+	module_param_call(N, qib_set_mod_param, qib_get_mod_param, \
+			  &qmp_##N, (P));			   \
+	MODULE_PARM_DESC(N, S " (dflt: " __stringify(D) ")")
+/**
+ * QIB_MODPARAM_PORT - define a port-scope module parameter
+ * @N: name of the module parameter
+ * @F: callback function for dynamic value settings
+ * @D: default value
+ * @P: visibility in sysfs
+ * @D: description
+ *
+ * Define a port-scope module parameter. Port-scope module
+ * parameters allow specifying individual values foe each of the
+ * ports on any of the QIB units.
+ */
+#define QIB_MODPARAM_PORT(N, F, D, P, S)			   \
+	struct qib_mod_param qmp_##N = {			   \
+		.name = __stringify(N),				   \
+		.func = ((P) & S_IWUGO ? F : NULL),		   \
+		.type = qib_mod_param_port,			   \
+		.dflt = (ulong)D,				   \
+		.pport = { NULL, NULL }				   \
+	};							   \
+	module_param_call(N, qib_set_mod_param, qib_get_mod_param, \
+			  &qmp_##N, (P));			   \
+	MODULE_PARM_DESC(N, S " (dflt: " __stringify(D) ")")
+/**
+ * QIB_MODPARAM_GET - retrieve a module parameter value
+ * @N: name of the module parameter
+ * @U: unit number
+ * @P: port number
+ *
+ * Get the value for the specific unit/port. The macro will return
+ * the correct value regardless of a specific value for the
+ * specified unit/port is present or the default should be used.
+ */
+#define QIB_MODPARAM_GET(N, U, P) qib_read_mod_param(&qmp_##N, U, P)
+
 /* hol_state values */
 #define QIB_HOL_UP       0
 #define QIB_HOL_INIT     1
@@ -1106,6 +1215,7 @@ struct qib_filedata {
 };
 
 extern struct list_head qib_dev_list;
+extern struct list_head qib_mod_param_list;
 extern spinlock_t qib_devs_lock;
 extern struct qib_devdata *qib_lookup(int unit);
 extern u32 qib_cpulist_count;
@@ -1437,11 +1547,10 @@ const char *qib_get_unit_name(int unit);
 #endif
 
 /* global module parameter variables */
-extern unsigned qib_ibmtu;
-extern ushort qib_cfgctxts;
-extern ushort qib_num_cfg_vls;
+QIB_MODPARAM_GLOBAL(ibmtu);
+QIB_MODPARAM_GLOBAL(cfgctxts);
+QIB_MODPARAM_GLOBAL(krcvqs);
 extern ushort qib_mini_init; /* If set, do few (ideally 0) writes to chip */
-extern unsigned qib_n_krcv_queues;
 extern unsigned qib_sdma_fetch_arb;
 extern unsigned qib_compat_ddr_negotiate;
 extern int qib_special_trigger;
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 8895cfe..1c0dfe6 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009 QLogic Corporation. All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -42,6 +43,9 @@
 
 #include "qib.h"
 
+#undef pr_fmt
+#define pr_fmt(fmt) QIB_DRV_NAME " " fmt
+
 /*
  * The size has to be longer than this string, so we can append
  * board/chip information to it in the init code.
@@ -50,11 +54,21 @@ const char ib_qib_version[] = QIB_IDSTR "\n";
 
 DEFINE_SPINLOCK(qib_devs_lock);
 LIST_HEAD(qib_dev_list);
+LIST_HEAD(qib_mod_param_list);
 DEFINE_MUTEX(qib_mutex);	/* general driver use */
 
-unsigned qib_ibmtu;
-module_param_named(ibmtu, qib_ibmtu, uint, S_IRUGO);
-MODULE_PARM_DESC(ibmtu, "Set max IB MTU (0=2KB, 1=256, 2=512, ... 5=4096");
+/* Per-unit/port module parameter value structure
+ * linked to the qib_mod_param structure - one per
+ * unit/port */
+struct qib_mod_param_pport {
+	struct list_head list;
+	u16 unit;
+	u8 port;
+	u64 value;
+};
+
+QIB_MODPARAM_PORT(ibmtu, NULL, 5, S_IRUGO,
+		  "Set max IB MTU (0=2KB, 1=256, 2=512, ... 5=4096");
 
 unsigned qib_compat_ddr_negotiate = 1;
 module_param_named(compat_ddr_negotiate, qib_compat_ddr_negotiate, uint,
@@ -88,6 +102,178 @@ const char *qib_get_unit_name(int unit)
 	return iname;
 }
 
+int qib_set_mod_param(const char *str, struct kernel_param *kp)
+{
+	char *next = (char *)str, *tmp;
+	unsigned long val = 0, dft;
+	u32 unit = 0, port = 0;
+	struct qib_mod_param *param =
+		(struct qib_mod_param *)kp->arg;
+	struct qib_mod_param_pport *pport, *p;
+	int ret = 0;
+
+	if (strlen(str) >= MAX_QIB_PARAM_LEN) {
+		pr_warn("parameter value too long\n");
+		ret = -ENOSPC;
+		goto done;
+	}
+
+	/* qib_dev_list will be empty only when the driver is initially
+	 * loading. */
+	if (list_empty(&qib_dev_list) || !param->pport.next)
+		INIT_LIST_HEAD(&param->pport);
+	tmp = next;
+	dft = simple_strtoul(tmp, &next, 0);
+	if (next == tmp) {
+		pr_warn("invalid parameter value\n");
+		ret =  -EINVAL;
+		goto done;
+	}
+	/* clear any previously added port entries */
+	list_for_each_entry_safe(pport, p, &param->pport, list) {
+		list_del(&pport->list);
+		kfree(pport);
+	}
+	if (!*next || *next == '\n' || *next == ',')
+		param->dflt = dft;
+	else if (*next && *next == ':')
+		/* no default, rewind the string */
+		next = tmp;
+	else
+		pr_warn("invalid parameter value\n");
+	while (*next && next[1]) {
+		if (*next == ',')
+			tmp = ++next;
+		unit = simple_strtoul(tmp, &next, 0);
+		if (param->type == qib_mod_param_port) {
+			if (next == tmp || !*next || *next != ':') {
+				pr_warn("Invalid unit:port argument at \"%s\".\n",
+					tmp);
+				while (*next && *next++ != ',')
+					;
+				tmp = next;
+				continue;
+			}
+			tmp = ++next;
+			port = simple_strtoul(tmp, &next, 0);
+			if (!port) {
+				/* port numbers start at 1, 0 is invalid */
+				pr_warn("Invalid argument at \"%s\". Port numbers start at 1.\n",
+					tmp);
+				while (*next && *next++ != ',')
+					;
+				tmp = next;
+				continue;
+			}
+		}
+		if (next == tmp || *next != '=') {
+			pr_warn("Invalid %s argument at \"%s\".\n",
+				(param->type == qib_mod_param_port ?
+				"port" : "unit"), tmp);
+			while (*next && *next++ != ',')
+				;
+			tmp = next;
+			continue;
+		}
+		tmp = ++next;
+		val = simple_strtoul(tmp, &next, 0);
+		if (next == tmp) {
+			pr_warn("Invalid value string at \"%s\"\n", tmp);
+			while (*next && *next++ != ',')
+				;
+			tmp = next;
+			continue;
+		}
+		pport = kzalloc(sizeof(struct qib_mod_param_pport),
+				GFP_KERNEL);
+		if (!pport) {
+			pr_err("no memory for module parameter.\n");
+			ret =  -ENOMEM;
+			goto done;
+		}
+		pport->unit = unit;
+		pport->port = port;
+		pport->value = val;
+		list_add_tail(&pport->list, &param->pport);
+		if (!*next || *next == '\n')
+			break;
+		tmp = ++next;
+	}
+	/* add parameter to list so it can be cleaned up */
+	if (!param->list.next)
+		list_add(&param->list, &qib_mod_param_list);
+
+	if (param->func && qib_count_units(NULL, NULL)) {
+		struct qib_devdata *dd;
+		list_for_each_entry(pport, &param->pport, list) {
+			param_set_func_t setfunc = param->func;
+			list_for_each_entry(dd, &qib_dev_list, list)
+				if (dd->unit == pport->unit)
+					break;
+			if (!setfunc(dd, pport->port, pport->value))
+				pr_err("Error setting module parameter %s for IB%u:%u",
+				       param->name,
+				       pport->unit,
+				       pport->port);
+		}
+	}
+done:
+	return ret;
+}
+
+int qib_get_mod_param(char *buffer, struct kernel_param *kp)
+{
+	struct qib_mod_param *param =
+		(struct qib_mod_param *)kp->arg;
+	struct qib_mod_param_pport *pport;
+	char *p = buffer;
+	int s = 0;
+
+	s = scnprintf(p, PAGE_SIZE, "%lu", param->dflt);
+	p += s;
+
+	if (param->pport.next)
+		list_for_each_entry(pport, &param->pport, list) {
+			*p++ = ',';
+			if (param->type == qib_mod_param_unit)
+				s = scnprintf(p, PAGE_SIZE, "%u=%llu",
+					      pport->unit, pport->value);
+			else if (param->type == qib_mod_param_port)
+				s = scnprintf(p, PAGE_SIZE, "%u:%u=%llu",
+					      pport->unit, pport->port,
+					      pport->value);
+			p += s;
+		}
+	return strlen(buffer);
+}
+
+u64 qib_read_mod_param(struct qib_mod_param *param, u16 unit, u8 port)
+{
+	struct qib_mod_param_pport *pport;
+	u64 ret = param->dflt;
+
+	if (param->type != qib_mod_param_drv)
+		if (param->pport.next && !list_empty(&param->pport))
+			list_for_each_entry(pport, &param->pport, list)
+				if (pport->unit == unit &&
+				    pport->port == port)
+					ret = pport->value;
+	return ret;
+}
+
+void qib_clean_mod_param(void)
+{
+	struct qib_mod_param *p;
+	struct qib_mod_param_pport *pp, *pps;
+
+	list_for_each_entry(p, &qib_mod_param_list, list) {
+		list_for_each_entry_safe(pp, pps, &p->pport, list) {
+			list_del(&pp->list);
+			kfree(pp);
+		}
+	}
+}
+
 /*
  * Return count of units with at least one port ACTIVE.
  */
@@ -618,7 +804,8 @@ int qib_set_mtu(struct qib_pportdata *ppd, u16 arg)
 		ret = -EINVAL;
 		goto bail;
 	}
-	chk = ib_mtu_enum_to_int(qib_ibmtu);
+	chk = ib_mtu_enum_to_int(
+		QIB_MODPARAM_GET(ibmtu, ppd->dd->unit, ppd->port));
 	if (chk > 0 && arg > chk) {
 		ret = -EINVAL;
 		goto bail;
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 4d352b9..8af5bd3 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
- * All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation.  All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -2062,9 +2062,10 @@ qib_6120_get_msgheader(struct qib_devdata *dd, __le32 *rhf_addr)
 
 static void qib_6120_config_ctxts(struct qib_devdata *dd)
 {
+	u32 nkrcvqs = QIB_MODPARAM_GET(krcvqs, dd->unit, 0);
 	dd->ctxtcnt = qib_read_kreg32(dd, kr_portcnt);
-	if (qib_n_krcv_queues > 1) {
-		dd->first_user_ctxt = qib_n_krcv_queues * dd->num_pports;
+	if (nkrcvqs > 1) {
+		dd->first_user_ctxt = nkrcvqs * dd->num_pports;
 		if (dd->first_user_ctxt > dd->ctxtcnt)
 			dd->first_user_ctxt = dd->ctxtcnt;
 		dd->qpn_mask = dd->first_user_ctxt <= 2 ? 2 : 6;
@@ -3124,7 +3125,7 @@ static void get_6120_chip_params(struct qib_devdata *dd)
 	dd->piosize2k = val & ~0U;
 	dd->piosize4k = val >> 32;
 
-	mtu = ib_mtu_enum_to_int(qib_ibmtu);
+	mtu = ib_mtu_enum_to_int(QIB_MODPARAM_GET(ibmtu, dd->unit, 1));
 	if (mtu == -1)
 		mtu = QIB_DEFAULT_MTU;
 	dd->pport->ibmtu = (u32)mtu;
@@ -3274,7 +3275,7 @@ static int init_6120_variables(struct qib_devdata *dd)
 	dd->rhf_offset = 0;
 
 	/* we always allocate at least 2048 bytes for eager buffers */
-	ret = ib_mtu_enum_to_int(qib_ibmtu);
+	ret = ib_mtu_enum_to_int(QIB_MODPARAM_GET(ibmtu, dd->unit, 1));
 	dd->rcvegrbufsize = ret != -1 ? max(ret, 2048) : QIB_DEFAULT_MTU;
 	BUG_ON(!is_power_of_2(dd->rcvegrbufsize));
 	dd->rcvegrbufsize_shift = ilog2(dd->rcvegrbufsize);
@@ -3314,7 +3315,6 @@ static int init_6120_variables(struct qib_devdata *dd)
 	if (qib_mini_init)
 		goto bail;
 
-	qib_num_cfg_vls = 1; /* if any 6120's, only one VL */
 
 	ret = qib_create_ctxts(dd);
 	init_6120_cntrnames(dd);
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 86a0ba7..f809281 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
- * All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -2293,19 +2293,21 @@ static void qib_7220_config_ctxts(struct qib_devdata *dd)
 {
 	unsigned long flags;
 	u32 nchipctxts;
+	u32 cfgctxts = QIB_MODPARAM_GET(cfgctxts, dd->unit, 0);
+	u32 nkrcvqs = QIB_MODPARAM_GET(krcvqs, dd->unit, 0);
 
 	nchipctxts = qib_read_kreg32(dd, kr_portcnt);
 	dd->cspec->numctxts = nchipctxts;
-	if (qib_n_krcv_queues > 1) {
+	if (nkrcvqs > 1) {
 		dd->qpn_mask = 0x3e;
-		dd->first_user_ctxt = qib_n_krcv_queues * dd->num_pports;
+		dd->first_user_ctxt = nkrcvqs * dd->num_pports;
 		if (dd->first_user_ctxt > nchipctxts)
 			dd->first_user_ctxt = nchipctxts;
 	} else
 		dd->first_user_ctxt = dd->num_pports;
 	dd->n_krcv_queues = dd->first_user_ctxt;
 
-	if (!qib_cfgctxts) {
+	if (!cfgctxts) {
 		int nctxts = dd->first_user_ctxt + num_online_cpus();
 
 		if (nctxts <= 5)
@@ -2314,8 +2316,8 @@ static void qib_7220_config_ctxts(struct qib_devdata *dd)
 			dd->ctxtcnt = 9;
 		else if (nctxts <= nchipctxts)
 			dd->ctxtcnt = nchipctxts;
-	} else if (qib_cfgctxts <= nchipctxts)
-		dd->ctxtcnt = qib_cfgctxts;
+	} else if (cfgctxts <= nchipctxts)
+		dd->ctxtcnt = cfgctxts;
 	if (!dd->ctxtcnt) /* none of the above, set to max */
 		dd->ctxtcnt = nchipctxts;
 
@@ -3839,7 +3841,7 @@ static void get_7220_chip_params(struct qib_devdata *dd)
 	dd->piosize2k = val & ~0U;
 	dd->piosize4k = val >> 32;
 
-	mtu = ib_mtu_enum_to_int(qib_ibmtu);
+	mtu = ib_mtu_enum_to_int(QIB_MODPARAM_GET(ibmtu, dd->unit, 1));
 	if (mtu == -1)
 		mtu = QIB_DEFAULT_MTU;
 	dd->pport->ibmtu = (u32)mtu;
@@ -4078,15 +4080,13 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	ppd->cpspec->chase_timer.function = reenable_7220_chase;
 	ppd->cpspec->chase_timer.data = (unsigned long)ppd;
 
-	qib_num_cfg_vls = 1; /* if any 7220's, only one VL */
-
 	dd->rcvhdrentsize = QIB_RCVHDR_ENTSIZE;
 	dd->rcvhdrsize = QIB_DFLT_RCVHDRSIZE;
 	dd->rhf_offset =
 		dd->rcvhdrentsize - sizeof(u64) / sizeof(u32);
 
 	/* we always allocate at least 2048 bytes for eager buffers */
-	ret = ib_mtu_enum_to_int(qib_ibmtu);
+	ret = ib_mtu_enum_to_int(QIB_MODPARAM_GET(ibmtu, dd->unit, 1));
 	dd->rcvegrbufsize = ret != -1 ? max(ret, 2048) : QIB_DEFAULT_MTU;
 	BUG_ON(!is_power_of_2(dd->rcvegrbufsize));
 	dd->rcvegrbufsize_shift = ilog2(dd->rcvegrbufsize);
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 78e8550..e04e0b6 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -100,9 +100,8 @@ static const unsigned sdma_idle_cnt = 64;
  * Number of VLs we are configured to use (to allow for more
  * credits per vl, etc.)
  */
-ushort qib_num_cfg_vls = 2;
-module_param_named(num_vls, qib_num_cfg_vls, ushort, S_IRUGO);
-MODULE_PARM_DESC(num_vls, "Set number of Virtual Lanes to use (1-8)");
+static QIB_MODPARAM_PORT(num_vls, NULL, 2, S_IRUGO,
+			 "Set number of Virtual Lanes to use (1-8)");
 
 static ushort qib_chase = 1;
 module_param_named(chase, qib_chase, ushort, S_IRUGO);
@@ -113,9 +112,8 @@ module_param_named(long_attenuation, qib_long_atten, ushort, S_IRUGO);
 MODULE_PARM_DESC(long_attenuation, \
 		 "attenuation cutoff (dB) for long copper cable setup");
 
-static ushort qib_singleport;
-module_param_named(singleport, qib_singleport, ushort, S_IRUGO);
-MODULE_PARM_DESC(singleport, "Use only IB port 1; more per-port buffer space");
+static QIB_MODPARAM_UNIT(singleport, NULL, 0, S_IRUGO,
+			 "Use only IB port 1; more per-port buffer space");
 
 static ushort qib_krcvq01_no_msi;
 module_param_named(krcvq01_no_msi, qib_krcvq01_no_msi, ushort, S_IRUGO);
@@ -3306,7 +3304,8 @@ static unsigned qib_7322_boardname(struct qib_devdata *dd)
 		 dd->majrev, dd->minrev,
 		 (unsigned)SYM_FIELD(dd->revision, Revision_R, SW));
 
-	if (qib_singleport && (features >> PORT_SPD_CAP_SHIFT) & PORT_SPD_CAP) {
+	if (QIB_MODPARAM_GET(singleport, dd->unit, 0) &&
+	    (features >> PORT_SPD_CAP_SHIFT) & PORT_SPD_CAP) {
 		qib_devinfo(dd->pcidev, "IB%u: Forced to single port mode"
 			    " by module parameter\n", dd->unit);
 		features &= PORT_SPD_CAP;
@@ -3595,12 +3594,14 @@ static void qib_7322_config_ctxts(struct qib_devdata *dd)
 {
 	unsigned long flags;
 	u32 nchipctxts;
+	u32 cfgctxts = QIB_MODPARAM_GET(cfgctxts, dd->unit, 0);
+	u32 nkrcvqs = QIB_MODPARAM_GET(krcvqs, dd->unit, 0);
 
 	nchipctxts = qib_read_kreg32(dd, kr_contextcnt);
 	dd->cspec->numctxts = nchipctxts;
-	if (qib_n_krcv_queues > 1 && dd->num_pports) {
+	if (nkrcvqs > 1 && dd->num_pports) {
 		dd->first_user_ctxt = NUM_IB_PORTS +
-			(qib_n_krcv_queues - 1) * dd->num_pports;
+			(nkrcvqs - 1) * dd->num_pports;
 		if (dd->first_user_ctxt > nchipctxts)
 			dd->first_user_ctxt = nchipctxts;
 		dd->n_krcv_queues = dd->first_user_ctxt / dd->num_pports;
@@ -3609,7 +3610,7 @@ static void qib_7322_config_ctxts(struct qib_devdata *dd)
 		dd->n_krcv_queues = 1;
 	}
 
-	if (!qib_cfgctxts) {
+	if (!cfgctxts) {
 		int nctxts = dd->first_user_ctxt + num_online_cpus();
 
 		if (nctxts <= 6)
@@ -3618,10 +3619,10 @@ static void qib_7322_config_ctxts(struct qib_devdata *dd)
 			dd->ctxtcnt = 10;
 		else if (nctxts <= nchipctxts)
 			dd->ctxtcnt = nchipctxts;
-	} else if (qib_cfgctxts < dd->num_pports)
+	} else if (cfgctxts < dd->num_pports)
 		dd->ctxtcnt = dd->num_pports;
-	else if (qib_cfgctxts <= nchipctxts)
-		dd->ctxtcnt = qib_cfgctxts;
+	else if (cfgctxts <= nchipctxts)
+		dd->ctxtcnt = cfgctxts;
 	if (!dd->ctxtcnt) /* none of the above, set to max */
 		dd->ctxtcnt = nchipctxts;
 
@@ -5451,7 +5452,6 @@ static void get_7322_chip_params(struct qib_devdata *dd)
 {
 	u64 val;
 	u32 piobufs;
-	int mtu;
 
 	dd->palign = qib_read_kreg32(dd, kr_pagealign);
 
@@ -5470,11 +5470,10 @@ static void get_7322_chip_params(struct qib_devdata *dd)
 	dd->piosize2k = val & ~0U;
 	dd->piosize4k = val >> 32;
 
-	mtu = ib_mtu_enum_to_int(qib_ibmtu);
-	if (mtu == -1)
-		mtu = QIB_DEFAULT_MTU;
-	dd->pport[0].ibmtu = (u32)mtu;
-	dd->pport[1].ibmtu = (u32)mtu;
+	dd->pport[0].ibmtu = ib_mtu_enum_to_int(
+		QIB_MODPARAM_GET(ibmtu, dd->unit, 1));
+	dd->pport[1].ibmtu = ib_mtu_enum_to_int(
+		QIB_MODPARAM_GET(ibmtu, dd->unit, 2));
 
 	/* these may be adjusted in init_chip_wc_pat() */
 	dd->pio2kbase = (u32 __iomem *)
@@ -6073,7 +6072,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 {
 	struct qib_pportdata *ppd;
 	unsigned features, pidx, sbufcnt;
-	int ret, mtu;
+	int ret, maxmtu = 0;
 	u32 sbufs, updthresh;
 
 	/* pport structs are contiguous, allocated after devdata */
@@ -6150,10 +6149,6 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 	 */
 	qib_7322_set_baseaddrs(dd);
 
-	mtu = ib_mtu_enum_to_int(qib_ibmtu);
-	if (mtu == -1)
-		mtu = QIB_DEFAULT_MTU;
-
 	dd->cspec->int_enable_mask = QIB_I_BITSEXTANT;
 	/* all hwerrors become interrupts, unless special purposed */
 	dd->cspec->hwerrmask = ~0ULL;
@@ -6163,9 +6158,14 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		~(SYM_MASK(HwErrMask, IBSerdesPClkNotDetectMask_0) |
 		  SYM_MASK(HwErrMask, IBSerdesPClkNotDetectMask_1) |
 		  HWE_MASK(LATriggered));
-
 	for (pidx = 0; pidx < NUM_IB_PORTS; ++pidx) {
 		struct qib_chippport_specific *cp = ppd->cpspec;
+		int mtu = ib_mtu_enum_to_int(
+			QIB_MODPARAM_GET(ibmtu, dd->unit, pidx+1));
+		u8 vls = QIB_MODPARAM_GET(num_vls, dd->unit, pidx+1);
+		if (mtu == -1)
+			mtu = QIB_DEFAULT_MTU;
+		maxmtu = max(maxmtu, mtu);
 		ppd->link_speed_supported = features & PORT_SPD_CAP;
 		features >>=  PORT_SPD_CAP_SHIFT;
 		if (!ppd->link_speed_supported) {
@@ -6219,7 +6219,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		ppd->link_width_active = IB_WIDTH_4X;
 		ppd->link_speed_active = QIB_IB_SDR;
 		ppd->delay_mult = ib_rate_to_delay[IB_RATE_10_GBPS];
-		switch (qib_num_cfg_vls) {
+		switch (vls) {
 		case 1:
 			ppd->vls_supported = IB_VL_VL0;
 			break;
@@ -6229,8 +6229,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		default:
 			qib_devinfo(dd->pcidev,
 				    "Invalid num_vls %u, using 4 VLs\n",
-				    qib_num_cfg_vls);
-			qib_num_cfg_vls = 4;
+				    vls);
 			/* fall through */
 		case 4:
 			ppd->vls_supported = IB_VL_VL0_3;
@@ -6242,9 +6241,8 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 				qib_devinfo(dd->pcidev,
 					    "Invalid num_vls %u for MTU %d "
 					    ", using 4 VLs\n",
-					    qib_num_cfg_vls, mtu);
+					    vls, mtu);
 				ppd->vls_supported = IB_VL_VL0_3;
-				qib_num_cfg_vls = 4;
 			}
 			break;
 		}
@@ -6294,7 +6292,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 	dd->rhf_offset = dd->rcvhdrentsize - sizeof(u64) / sizeof(u32);
 
 	/* we always allocate at least 2048 bytes for eager buffers */
-	dd->rcvegrbufsize = max(mtu, 2048);
+	dd->rcvegrbufsize = max(maxmtu, 2048);
 	BUG_ON(!is_power_of_2(dd->rcvegrbufsize));
 	dd->rcvegrbufsize_shift = ilog2(dd->rcvegrbufsize);
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 24ad901..ea569a7 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -56,9 +56,8 @@
  * Number of ctxts we are configured to use (to allow for more pio
  * buffers per ctxt, etc.)  Zero means use chip value.
  */
-ushort qib_cfgctxts;
-module_param_named(cfgctxts, qib_cfgctxts, ushort, S_IRUGO);
-MODULE_PARM_DESC(cfgctxts, "Set max number of contexts to use");
+QIB_MODPARAM_UNIT(cfgctxts, NULL, 0, S_IRUGO,
+		  "Set max number of contexts to use");
 
 /*
  * If set, do not write to any regs if avoidable, hack to allow
@@ -68,9 +67,8 @@ ushort qib_mini_init;
 module_param_named(mini_init, qib_mini_init, ushort, S_IRUGO);
 MODULE_PARM_DESC(mini_init, "If set, do minimal diag init");
 
-unsigned qib_n_krcv_queues;
-module_param_named(krcvqs, qib_n_krcv_queues, uint, S_IRUGO);
-MODULE_PARM_DESC(krcvqs, "number of kernel receive queues per IB port");
+QIB_MODPARAM_PORT(krcvqs, NULL, 0, S_IRUGO,
+		  "number of kernel receive queues per IB port");
 
 unsigned qib_cc_table_size;
 module_param_named(cc_table_size, qib_cc_table_size, uint, S_IRUGO);
@@ -96,14 +94,15 @@ unsigned long *qib_cpulist;
 /* set number of contexts we'll actually use */
 void qib_set_ctxtcnt(struct qib_devdata *dd)
 {
-	if (!qib_cfgctxts) {
+	u64 val = QIB_MODPARAM_GET(cfgctxts, dd->unit, 0);
+	if (!val) {
 		dd->cfgctxts = dd->first_user_ctxt + num_online_cpus();
 		if (dd->cfgctxts > dd->ctxtcnt)
 			dd->cfgctxts = dd->ctxtcnt;
-	} else if (qib_cfgctxts < dd->num_pports)
+	} else if (val < dd->num_pports)
 		dd->cfgctxts = dd->ctxtcnt;
-	else if (qib_cfgctxts <= dd->ctxtcnt)
-		dd->cfgctxts = qib_cfgctxts;
+	else if (val <= dd->ctxtcnt)
+		dd->cfgctxts = val;
 	else
 		dd->cfgctxts = dd->ctxtcnt;
 	dd->freectxts = (dd->first_user_ctxt > dd->cfgctxts) ? 0 :
@@ -676,10 +675,10 @@ int qib_init(struct qib_devdata *dd, int reinit)
 		if (lastfail)
 			ret = lastfail;
 		ppd = dd->pport + pidx;
-		mtu = ib_mtu_enum_to_int(qib_ibmtu);
+		mtu = ib_mtu_enum_to_int(
+			QIB_MODPARAM_GET(ibmtu, dd->unit, ppd->port));
 		if (mtu == -1) {
 			mtu = QIB_DEFAULT_MTU;
-			qib_ibmtu = 0; /* don't leave invalid value */
 		}
 		/* set max we can ever have for this driver load */
 		ppd->init_ibmaxlen = min(mtu > 2048 ?
@@ -1231,6 +1230,7 @@ static void __exit qlogic_ib_cleanup(void)
 
 	idr_destroy(&qib_unit_table);
 	qib_dev_cleanup();
+	qib_clean_mod_param();
 }
 
 module_exit(qlogic_ib_cleanup);
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 19f1e6c..58745f9 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -535,7 +535,8 @@ static int subn_get_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	pip->vl_arb_low_cap =
 		dd->f_get_ib_cfg(ppd, QIB_IB_CFG_VL_LOW_CAP);
 	/* InitTypeReply = 0 */
-	pip->inittypereply_mtucap = qib_ibmtu ? qib_ibmtu : IB_MTU_4096;
+	pip->inittypereply_mtucap =
+		QIB_MODPARAM_GET(ibmtu, dd->unit, ppd->port);
 	/* HCAs ignore VLStallCount and HOQLife */
 	/* pip->vlstallcnt_hoqlife; */
 	pip->operationalvl_pei_peo_fpi_fpo =
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 790646e..27fc3e8 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (c) 2008, 2009 QLogic Corporation. All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2008 - 2012 QLogic Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -500,9 +501,8 @@ static int val2fld(int wd, int mask)
 	return wd;
 }
 
-static int qib_pcie_coalesce;
-module_param_named(pcie_coalesce, qib_pcie_coalesce, int, S_IRUGO);
-MODULE_PARM_DESC(pcie_coalesce, "tune PCIe colescing on some Intel chipsets");
+static QIB_MODPARAM_UNIT(pcie_coalesce, NULL, 0, S_IRUGO,
+			 "tune PCIe colescing on some Intel chipsets");
 
 /*
  * Enable PCIe completion and data coalescing, on Intel 5x00 and 7300
@@ -518,7 +518,7 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
 	u16 devid;
 	u32 mask, bits, val;
 
-	if (!qib_pcie_coalesce)
+	if (!QIB_MODPARAM_GET(pcie_coalesce, dd->unit, 0))
 		return 0;
 
 	/* Find out supported and configured values for parent (root) */
@@ -577,9 +577,8 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
  * BIOS may not set PCIe bus-utilization parameters for best performance.
  * Check and optionally adjust them to maximize our throughput.
  */
-static int qib_pcie_caps;
-module_param_named(pcie_caps, qib_pcie_caps, int, S_IRUGO);
-MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (0..3), ReadReq (4..7)");
+static QIB_MODPARAM_UNIT(pcie_caps, NULL, 0, S_IRUGO,
+			 "Max PCIe tuning: Payload (4lsb), ReadReq (D4..7)");
 
 static int qib_tune_pcie_caps(struct qib_devdata *dd)
 {
@@ -589,6 +588,7 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	u16 pcaps, pctl, ecaps, ectl;
 	int rc_sup, ep_sup;
 	int rc_cur, ep_cur;
+	int caps = QIB_MODPARAM_GET(pcie_caps, dd->unit, 0);
 
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
@@ -620,8 +620,8 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	ep_cur = fld2val(ectl, PCI_EXP_DEVCTL_PAYLOAD);
 
 	/* If Supported greater than limit in module param, limit it */
-	if (rc_sup > (qib_pcie_caps & 7))
-		rc_sup = qib_pcie_caps & 7;
+	if (rc_sup > (caps & 7))
+		rc_sup = caps & 7;
 	/* If less than (allowed, supported), bump root payload */
 	if (rc_sup > rc_cur) {
 		rc_cur = rc_sup;
@@ -643,8 +643,8 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	 * which is code '5' (log2(4096) - 7)
 	 */
 	rc_sup = 5;
-	if (rc_sup > ((qib_pcie_caps >> 4) & 7))
-		rc_sup = (qib_pcie_caps >> 4) & 7;
+	if (rc_sup > ((caps >> 4) & 7))
+		rc_sup = (caps >> 4) & 7;
 	rc_cur = fld2val(pctl, PCI_EXP_DEVCTL_READRQ);
 	ep_cur = fld2val(ectl, PCI_EXP_DEVCTL_READRQ);
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 56b4265..001034c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1621,7 +1621,8 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	props->max_vl_num = qib_num_vls(ppd->vls_supported);
 	props->init_type_reply = 0;
 
-	props->max_mtu = qib_ibmtu ? qib_ibmtu : IB_MTU_4096;
+	props->max_mtu = QIB_MODPARAM_GET(ibmtu, dd->unit, ppd->port) ?
+		QIB_MODPARAM_GET(ibmtu, dd->unit, ppd->port) : IB_MTU_4096;
 	switch (ppd->ibmtu) {
 	case 4096:
 		mtu = IB_MTU_4096;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
