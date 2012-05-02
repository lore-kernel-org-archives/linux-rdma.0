From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Fix qib driver mkey lease timeout handling
Date: Wed, 2 May 2012 14:39:11 -0400
Message-ID: <20120502183911.1978.26720.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

If a port has a MKey lease set, the MKey protect bits set to 1,
and a SubnSet arrives with an invalid MKey, a MKey mismatch trap is
generated, the lease timer begins as expected, and eventually the MKey
protect bits will be set back to 0 as per the spec.  However, if any
other SMP with an invalid MKey arrives, the lease timer is expired and
the MKey protect bits remain in force.

This is not according to to spec.  In particular, C14-17 says that
a lease timer that is underway is not affected by protection level
checks (ie, at protection level 1, a SubnGet with a bad MKey may be
successful, but does not stop the timer), and C14-19 says that the timer
shall stop when a valid MKey has been received.  C14-19 is the only
compliance statement that specifies a stopping condition for the timer.

This behavior is magnified if the port's Master SM LID attribute
points at itself.  In that case, the MKey mismatch trap is sufficient to
expire the timer, and the mkey lease attribute is rendered useless.

Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |   44 +++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 9292c76..ed611e8 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -396,6 +396,7 @@ static int get_linkdowndefaultstate(struct qib_pportdata *ppd)
 
 static int check_mkey(struct qib_ibport *ibp, struct ib_smp *smp, int mad_flags)
 {
+	int valid_mkey = 0;
 	int ret = 0;
 
 	/* Is the mkey in the process of expiring? */
@@ -406,23 +407,36 @@ static int check_mkey(struct qib_ibport *ibp, struct ib_smp *smp, int mad_flags)
 		ibp->mkeyprot = 0;
 	}
 
-	/* M_Key checking depends on Portinfo:M_Key_protect_bits */
-	if ((mad_flags & IB_MAD_IGNORE_MKEY) == 0 && ibp->mkey != 0 &&
-	    ibp->mkey != smp->mkey &&
-	    (smp->method == IB_MGMT_METHOD_SET ||
-	     smp->method == IB_MGMT_METHOD_TRAP_REPRESS ||
-	     (smp->method == IB_MGMT_METHOD_GET && ibp->mkeyprot >= 2))) {
-		if (ibp->mkey_violations != 0xFFFF)
-			++ibp->mkey_violations;
-		if (!ibp->mkey_lease_timeout && ibp->mkey_lease_period)
-			ibp->mkey_lease_timeout = jiffies +
-				ibp->mkey_lease_period * HZ;
-		/* Generate a trap notice. */
-		qib_bad_mkey(ibp, smp);
-		ret = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
-	} else if (ibp->mkey_lease_timeout)
+	if ((mad_flags & IB_MAD_IGNORE_MKEY) ||  ibp->mkey == 0 ||
+	    ibp->mkey == smp->mkey)
+		valid_mkey = 1;
+
+	/* Unset lease timeout on any valid Get/Set/TrapRepress */
+	if (valid_mkey && ibp->mkey_lease_timeout &&
+	    (smp->method == IB_MGMT_METHOD_GET ||
+	     smp->method == IB_MGMT_METHOD_SET ||
+	     smp->method == IB_MGMT_METHOD_TRAP_REPRESS))
 		ibp->mkey_lease_timeout = 0;
 
+	if (!valid_mkey) {
+		switch (smp->method) {
+		case IB_MGMT_METHOD_GET:
+			/* Bad mkey not a violation below level 2 */
+			if (ibp->mkeyprot < 2)
+				break;
+		case IB_MGMT_METHOD_SET:
+		case IB_MGMT_METHOD_TRAP_REPRESS:
+			if (ibp->mkey_violations != 0xFFFF)
+				++ibp->mkey_violations;
+			if (!ibp->mkey_lease_timeout && ibp->mkey_lease_period)
+				ibp->mkey_lease_timeout = jiffies +
+					ibp->mkey_lease_period * HZ;
+			/* Generate a trap notice. */
+			qib_bad_mkey(ibp, smp);
+			ret = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
+		}
+	}
+
 	return ret;
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
