From: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] Fix deadlock when running run_iter_bw_infinitely
Date: Wed, 18 Nov 2015 13:27:53 +0100
Message-ID: <1447849673-30034-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gil Rockah <gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The test uses a signal-handler to periodically print a line of report.
Snip libc info:
<quote>
24.4.6 Signal Handling and Nonreentrant Functions
Handler functions usually don't do very much.  The best practice is to
write a handler that does nothing but set an external variable that the
program checks regularly, and leave all serious work to the program.
</quote>
The current codebase violates the above and is deadlock prone.
The mutexes taken by the printf functions called from the signal handle=
r
might be held by activity conducted by the main thread.

This commit fixes this by setting a flag in the signal handler and hand=
le the
printout in the mainloop of the test.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index cb915e0..4d8e6c0 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -25,6 +25,12 @@ static enum ibv_wr_opcode opcode_atomic_array[] =3D =
{IBV_WR_ATOMIC_CMP_AND_SWP,IBV
=20
 struct perftest_parameters* duration_param;
 struct check_alive_data check_alive_data;
+/*
+ * Flag to trig call to print_report_bw
+ * The flag is set in signal_handler and tested/reset in run_iter_bw_i=
nfinitely
+ */
+static volatile int trig_print_report_bw =3D 0;
+
=20
 /*********************************************************************=
*********
  * Beginning
@@ -3214,7 +3220,15 @@ int run_iter_bw_infinitely(struct pingpong_conte=
xt *ctx,struct perftest_paramete
=20
 	/* main loop for posting */
 	while (1) {
-
+		if (trig_print_report_bw) {
+			duration_param->tcompleted[0] =3D get_cycles();
+			print_report_bw(duration_param,NULL);
+			duration_param->iters =3D 0;
+			alarm(duration_param->duration);
+			duration_param->tposted[0] =3D get_cycles();
+			trig_print_report_bw =3D 0;
+		}
+	=09
 		/* main loop to run over all the qps and post each time n messages *=
/
 		for (index =3D0 ; index < num_of_qps ; index++) {
=20
@@ -4213,11 +4227,7 @@ void check_alive(int sig)
  *********************************************************************=
*********/
 void catch_alarm_infintely(int sig)
 {
-	duration_param->tcompleted[0] =3D get_cycles();
-	print_report_bw(duration_param,NULL);
-	duration_param->iters =3D 0;
-	alarm(duration_param->duration);
-	duration_param->tposted[0] =3D get_cycles();
+	trig_print_report_bw =3D 1;
 }
=20
 /*********************************************************************=
*********
--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
