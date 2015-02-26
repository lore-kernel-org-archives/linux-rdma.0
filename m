From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/ipath: remove some left over code
Date: Thu, 26 Feb 2015 23:43:35 +0300
Message-ID: <20150226204335.GG6820@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Dave Olson <dave.olson@qlogic.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

"ret" is always zero here after commit c4bce8032ef4 ('IB/ipath: Add new
chip-specific functions to older chips, consistent init').

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I just happened to spot this dead code when I was reviewing a different
static checker warning:

	drivers/infiniband/hw/ipath/ipath_verbs.c:2266 show_hca()
	warn: bool is not less than zero.

It looks to me that this code returns 0 on success and 1 on failure so
the warning is correct.  This is very strange.  The documentation
doesn't say anything about what the return codes mean so it is all very
puzzling.

diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 7cc3054..3de90e9 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -721,10 +721,6 @@ static int ipath_ht_boardname(struct ipath_devdata *dd, char *name,
 	if (n)
 		snprintf(name, namelen, "%s", n);
 
-	if (ret) {
-		ipath_dev_err(dd, "Unsupported InfiniPath board %s!\n", name);
-		goto bail;
-	}
 	if (dd->ipath_majrev != 3 || (dd->ipath_minrev < 2 ||
 		dd->ipath_minrev > 4)) {
 		/*
