From: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Ping: [PATCH 1/1] Fix deadlock when running
 run_iter_bw_infinitely
Date: Wed, 9 Dec 2015 10:11:55 +0100
Message-ID: <5667F05B.8010200@oracle.com>
References: <1447849673-30034-1-git-send-email-hans.westgaard.ry@oracle.com>
 <5667E747.2070006@oracle.com> <20151209085245.GA8662@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151209085245.GA8662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gil Rockah <gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry but I didn't see that "something" gobbled part of the mail.
The correct lines are  (as in the original):

src/perftest_resources.c | 22 ++++++++++++++++------
  1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index cb915e0..4d8e6c0 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -25,6 +25,12 @@ static enum ibv_wr_opcode opcode_atomic_array[] = {IBV_WR_ATOMIC_CMP_AND_SWP,IBV
  
  struct perftest_parameters* duration_param;
  struct check_alive_data check_alive_data;
+/*
+ * Flag to trig call to print_report_bw
+ * The flag is set in signal_handler and tested/reset in run_iter_bw_infinitely
+ */
+static volatile int trig_print_report_bw = 0;
+
  
  /******************************************************************************
   * Beginning
@@ -3214,7 +3220,15 @@ int run_iter_bw_infinitely(struct pingpong_context *ctx,struct perftest_paramete
  
  	/* main loop for posting */
  	while (1) {
-
+		if (trig_print_report_bw) {
+			duration_param->tcompleted[0] = get_cycles();
+			print_report_bw(duration_param,NULL);
+			duration_param->iters = 0;
+			alarm(duration_param->duration);
+			duration_param->tposted[0] = get_cycles();
+			trig_print_report_bw = 0;
+		}
+		
  		/* main loop to run over all the qps and post each time n messages */
  		for (index =0 ; index < num_of_qps ; index++) {
  
@@ -4213,11 +4227,7 @@ void check_alive(int sig)
   ******************************************************************************/
  void catch_alarm_infintely(int sig)
  {
-	duration_param->tcompleted[0] = get_cycles();
-	print_report_bw(duration_param,NULL);
-	duration_param->iters = 0;
-	alarm(duration_param->duration);
-	duration_param->tposted[0] = get_cycles();
+	trig_print_report_bw = 1;
  }



On 12/09/2015 09:52 AM, Leon Romanovsky wrote:
> On Wed, Dec 09, 2015 at 09:33:11AM +0100, Hans Westgaard Ry wrote:
>> Any comments on this patch ?
>>
>>
>>
>> On 11/18/2015 01:27 PM, Hans Westgaard Ry wrote:
>>> The test uses a signal-handler to periodically print a line of report.
>>> +		if (trig_print_report_bw) {
>>> +			duration_param->tcompleted[0] =et_cycles();
>>> +			print_report_bw(duration_param,NULL);
>>> +			duration_param->iters =;
> Excuse me, what did you mean by the line above?
>
>>> +			alarm(duration_param->duration);
>>> +			duration_param->tposted[0] =et_cycles();
>>> +			trig_print_report_bw =;
> And this line too.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
