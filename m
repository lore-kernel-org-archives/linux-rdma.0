From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: set cfgctxts to number of CPUs by default
Date: Wed, 21 Jul 2010 15:46:11 -0700
Message-ID: <20100721224610.10126.76859.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Up to now, we have set the number of available user contexts based on
the number of hardware contexts which is set according to the number
of available CPUs. This was fine since most CPUs had a power of two
number of cores and the chip supported 4, 8, or 16 user contexts.
Now that some systems have 12 cores, the default isn't optimal and
should be set to 12 even though 16 hardware contexts need to be enabled.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_iba7322.c |    2 +-
 drivers/infiniband/hw/qib/qib_init.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 5eedf83..9031cd8 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5864,7 +5864,7 @@ static void write_7322_initregs(struct qib_devdata *dd)
 	 * Doesn't clear any of the error bits that might be set.
 	 */
 	val = TIDFLOW_ERRBITS; /* these are W1C */
-	for (i = 0; i < dd->ctxtcnt; i++) {
+	for (i = 0; i < dd->cfgctxts; i++) {
 		int flow;
 		for (flow = 0; flow < NUM_TIDFLOWS_CTXT; flow++)
 			qib_write_ureg(dd, ur_rcvflowtable+flow, val, i);
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index a873dd5..f1d16d3 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -93,7 +93,7 @@ unsigned long *qib_cpulist;
 void qib_set_ctxtcnt(struct qib_devdata *dd)
 {
 	if (!qib_cfgctxts)
-		dd->cfgctxts = dd->ctxtcnt;
+		dd->cfgctxts = dd->first_user_ctxt + num_online_cpus();
 	else if (qib_cfgctxts < dd->num_pports)
 		dd->cfgctxts = dd->ctxtcnt;
 	else if (qib_cfgctxts <= dd->ctxtcnt)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
