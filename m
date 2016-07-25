From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/28] IB/hfi1: Explain state complete frame details
Date: Mon, 25 Jul 2016 13:38:56 -0700
Message-ID: <20160725203855.4800.55229.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When link up fails in LNI, the local and peer state complete
frames are reported as numbers.  Explain what the values mean
so the operator can better diagnose the problem.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |  134 +++++++++++++++++++++++++++++=
++++++--
 1 files changed, 126 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/=
hfi1/chip.c
index e5f49ef..f3782b3 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9918,6 +9918,131 @@ static int wait_phy_linkstate(struct hfi1_devda=
ta *dd, u32 state, u32 msecs)
 	return 0;
 }
=20
+static const char *state_completed_string(u32 completed)
+{
+	static const char * const state_completed[] =3D {
+		"EstablishComm",
+		"OptimizeEQ",
+		"VerifyCap"
+	};
+
+	if (completed < ARRAY_SIZE(state_completed))
+		return state_completed[completed];
+
+	return "unknown";
+}
+
+static const char all_lanes_dead_timeout_expired[] =3D
+	"All lanes were inactive =E2=80=93 was the interconnect media removed=
?";
+static const char tx_out_of_policy[] =3D
+	"Passing lanes on local port do not meet the local link width policy"=
;
+static const char no_state_complete[] =3D
+	"State timeout occurred before link partner completed the state";
+static const char * const state_complete_reasons[] =3D {
+	[0x00] =3D "Reason unknown",
+	[0x01] =3D "Link was halted by driver, refer to LinkDownReason",
+	[0x02] =3D "Link partner reported failure",
+	[0x10] =3D "Unable to achieve frame sync on any lane",
+	[0x11] =3D
+	  "Unable to find a common bit rate with the link partner",
+	[0x12] =3D
+	  "Unable to achieve frame sync on sufficient lanes to meet the local=
 link width policy",
+	[0x13] =3D
+	  "Unable to identify preset equalization on sufficient lanes to meet=
 the local link width policy",
+	[0x14] =3D no_state_complete,
+	[0x15] =3D
+	  "State timeout occurred before link partner identified equalization=
 presets",
+	[0x16] =3D
+	  "Link partner completed the EstablishComm state, but the passing la=
nes do not meet the local link width policy",
+	[0x17] =3D tx_out_of_policy,
+	[0x20] =3D all_lanes_dead_timeout_expired,
+	[0x21] =3D
+	  "Unable to achieve acceptable BER on sufficient lanes to meet the l=
ocal link width policy",
+	[0x22] =3D no_state_complete,
+	[0x23] =3D
+	  "Link partner completed the OptimizeEq state, but the passing lanes=
 do not meet the local link width policy",
+	[0x24] =3D tx_out_of_policy,
+	[0x30] =3D all_lanes_dead_timeout_expired,
+	[0x31] =3D
+	  "State timeout occurred waiting for host to process received frames=
",
+	[0x32] =3D no_state_complete,
+	[0x33] =3D
+	  "Link partner completed the VerifyCap state, but the passing lanes =
do not meet the local link width policy",
+	[0x34] =3D tx_out_of_policy,
+};
+
+static const char *state_complete_reason_code_string(struct hfi1_pport=
data *ppd,
+						     u32 code)
+{
+	const char *str =3D NULL;
+
+	if (code < ARRAY_SIZE(state_complete_reasons))
+		str =3D state_complete_reasons[code];
+
+	if (str)
+		return str;
+	return "Reserved";
+}
+
+/* describe the given last state complete frame */
+static void decode_state_complete(struct hfi1_pportdata *ppd, u32 fram=
e,
+				  const char *prefix)
+{
+	struct hfi1_devdata *dd =3D ppd->dd;
+	u32 success;
+	u32 state;
+	u32 reason;
+	u32 lanes;
+
+	/*
+	 * Decode frame:
+	 *  [ 0: 0] - success
+	 *  [ 3: 1] - state
+	 *  [ 7: 4] - next state timeout
+	 *  [15: 8] - reason code
+	 *  [31:16] - lanes
+	 */
+	success =3D frame & 0x1;
+	state =3D (frame >> 1) & 0x7;
+	reason =3D (frame >> 8) & 0xff;
+	lanes =3D (frame >> 16) & 0xffff;
+
+	dd_dev_err(dd, "Last %s LNI state complete frame 0x%08x:\n",
+		   prefix, frame);
+	dd_dev_err(dd, "    last reported state state: %s (0x%x)\n",
+		   state_completed_string(state), state);
+	dd_dev_err(dd, "    state successfully completed: %s\n",
+		   success ? "yes" : "no");
+	dd_dev_err(dd, "    fail reason 0x%x: %s\n",
+		   reason, state_complete_reason_code_string(ppd, reason));
+	dd_dev_err(dd, "    passing lane mask: 0x%x", lanes);
+}
+
+/*
+ * Read the last state complete frames and explain them.  This routine
+ * expects to be called if the link went down during link negotiation
+ * and initialization (LNI).  That is, anywhere between polling and li=
nk up.
+ */
+static void check_lni_states(struct hfi1_pportdata *ppd)
+{
+	u32 last_local_state;
+	u32 last_remote_state;
+
+	read_last_local_state(ppd->dd, &last_local_state);
+	read_last_remote_state(ppd->dd, &last_remote_state);
+
+	/*
+	 * Don't report anything if there is nothing to report.  A value of
+	 * 0 means the link was taken down while polling and there was no
+	 * training in-process.
+	 */
+	if (last_local_state =3D=3D 0 && last_remote_state =3D=3D 0)
+		return;
+
+	decode_state_complete(ppd, last_local_state, "transmitted");
+	decode_state_complete(ppd, last_remote_state, "received");
+}
+
 /*
  * Helper for set_link_state().  Do not call except from that routine.
  * Expects ppd->hls_mutex to be held.
@@ -9930,8 +10055,6 @@ static int goto_offline(struct hfi1_pportdata *p=
pd, u8 rem_reason)
 {
 	struct hfi1_devdata *dd =3D ppd->dd;
 	u32 pstate, previous_state;
-	u32 last_local_state;
-	u32 last_remote_state;
 	int ret;
 	int do_transition;
 	int do_wait;
@@ -10031,12 +10154,7 @@ static int goto_offline(struct hfi1_pportdata =
*ppd, u8 rem_reason)
 	} else if (previous_state
 			& (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) {
 		/* went down while attempting link up */
-		/* byte 1 of last_*_state is the failure reason */
-		read_last_local_state(dd, &last_local_state);
-		read_last_remote_state(dd, &last_remote_state);
-		dd_dev_err(dd,
-			   "LNI failure last states: local 0x%08x, remote 0x%08x\n",
-			   last_local_state, last_remote_state);
+		check_lni_states(ppd);
 	}
=20
 	/* the active link width (downgrade) is 0 on link down */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
