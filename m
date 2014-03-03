From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V2] dapltest: Add final send/recv "sync" for transaction tests.
Date: Mon, 03 Mar 2014 10:13:21 -0600
Message-ID: <20140303161321.8393.85018.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The transaction tests need both sides to send a sync message after running
the test.  This ensures that all remote operations are complete before
dapltest deregeisters memory and disconnects the endpoints.

Without this logic, we see intermittent async errors on iwarp devices
because a read response or write arrives after the rmr has been destroyed.
I believe this is more likely to happen with iWARP than IB because iWARP
completions only indicate the local buffer can be reused.  It doesn't
imply that the message has even arrived at the peer, let alone been
placed in the peer application's memory.

Changes from V1:

- allocate new send/recv buffers for the Final Sync message.

- post the Final Sync recv buffer at the beginning of the final iteration
of a test.

- tests ok on cxgb4 and mlx4 devices.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 test/dapltest/test/dapl_transaction_stats.c |   10 ++
 test/dapltest/test/dapl_transaction_test.c  |  169 ++++++++++++++++++++++++++-
 2 files changed, 170 insertions(+), 9 deletions(-)

diff --git a/test/dapltest/test/dapl_transaction_stats.c b/test/dapltest/test/dapl_transaction_stats.c
index f9d6377..6422ee3 100644
--- a/test/dapltest/test/dapl_transaction_stats.c
+++ b/test/dapltest/test/dapl_transaction_stats.c
@@ -59,6 +59,16 @@ DT_transaction_stats_set_ready(DT_Tdep_Print_Head * phead,
 	DT_Mdep_Unlock(&transaction_stats->lock);
 }
 
+void
+DT_transaction_stats_reset_wait_count(DT_Tdep_Print_Head * phead,
+			       Transaction_Stats_t * transaction_stats,
+			       unsigned int num)
+{
+	DT_Mdep_Lock(&transaction_stats->lock);
+	transaction_stats->wait_count = num;
+	DT_Mdep_Unlock(&transaction_stats->lock);
+}
+
 bool
 DT_transaction_stats_wait_for_all(DT_Tdep_Print_Head * phead,
 				  Transaction_Stats_t * transaction_stats)
diff --git a/test/dapltest/test/dapl_transaction_test.c b/test/dapltest/test/dapl_transaction_test.c
index 779ea86..8b49b9b 100644
--- a/test/dapltest/test/dapl_transaction_test.c
+++ b/test/dapltest/test/dapl_transaction_test.c
@@ -34,6 +34,8 @@
 #define RMI_RECV_BUFFER_ID      1
 #define SYNC_SEND_BUFFER_ID     2
 #define SYNC_RECV_BUFFER_ID     3
+#define FINAL_SYNC_SEND_BUFFER_ID     4
+#define FINAL_SYNC_RECV_BUFFER_ID     5
 
 /*
  * The sync buffers are sent to say "Go!" to the other side.
@@ -364,15 +366,15 @@ void DT_Transaction_Main(void *param)
 		 * Adjust default EP attributes to fit the requested test.
 		 * This is simplistic; in that we don't count ops of each
 		 * type and direction, checking EP limits.  We just try to
-		 * be sure the EP's WQs are large enough.  The "+2" is for
-		 * the RemoteMemInfo and Sync receive buffers.
+		 * be sure the EP's WQs are large enough.  The "+3" is for
+		 * the RemoteMemInfo and Start and Final Sync receive buffers.
 		 */
 		ep_attr = pt_ptr->ep_attr;
-		if (ep_attr.max_recv_dtos < test_ptr->cmd->num_ops + 2) {
-			ep_attr.max_recv_dtos = test_ptr->cmd->num_ops + 2;
+		if (ep_attr.max_recv_dtos < test_ptr->cmd->num_ops + 3) {
+			ep_attr.max_recv_dtos = test_ptr->cmd->num_ops + 3;
 		}
-		if (ep_attr.max_request_dtos < test_ptr->cmd->num_ops + 2) {
-			ep_attr.max_request_dtos = test_ptr->cmd->num_ops + 2;
+		if (ep_attr.max_request_dtos < test_ptr->cmd->num_ops + 3) {
+			ep_attr.max_request_dtos = test_ptr->cmd->num_ops + 3;
 		}
 
 		/* Create EP */
@@ -399,7 +401,7 @@ void DT_Transaction_Main(void *param)
 		 */
 		test_ptr->ep_context[i].bp = DT_BpoolAlloc(pt_ptr, phead, test_ptr->ia_handle, test_ptr->pz_handle, test_ptr->ep_context[i].ep_handle, DAT_HANDLE_NULL,	/* rmr */
 							   buff_size,
-							   4,
+							   6,
 							   DAT_OPTIMAL_ALIGNMENT,
 							   false, false);
 		if (!test_ptr->ep_context[i].bp) {
@@ -422,15 +424,25 @@ void DT_Transaction_Main(void *param)
 								 ep_context[i].
 								 bp, 1)));
 		DT_Tdep_PT_Debug(3,
-				 (phead, "2: SYNC_SEND %p\n",
+				 (phead, "2: INITIAL_SYNC_SEND %p\n",
 				  (DAT_PVOID) DT_Bpool_GetBuffer(test_ptr->
 								 ep_context[i].
 								 bp, 2)));
 		DT_Tdep_PT_Debug(3,
-				 (phead, "3: SYNC_RECV %p\n",
+				 (phead, "3: INITIAL_SYNC_RECV %p\n",
 				  (DAT_PVOID) DT_Bpool_GetBuffer(test_ptr->
 								 ep_context[i].
 								 bp, 3)));
+		DT_Tdep_PT_Debug(3,
+				 (phead, "4: FINAL_SYNC_SEND %p\n",
+				  (DAT_PVOID) DT_Bpool_GetBuffer(test_ptr->
+								 ep_context[i].
+								 bp, 4)));
+		DT_Tdep_PT_Debug(3,
+				 (phead, "5: FINAL_SYNC_RECV %p\n",
+				  (DAT_PVOID) DT_Bpool_GetBuffer(test_ptr->
+								 ep_context[i].
+								 bp, 5)));
 
 		/*
 		 * Post recv and sync buffers
@@ -1635,6 +1647,25 @@ DT_Transaction_Run(DT_Tdep_Print_Head * phead, Transaction_Test_t * test_ptr)
 
 		/* repost unless this is the last iteration */
 		repost_recv = (iteration + 1 != test_ptr->cmd->num_iterations);
+		
+		/* 
+		 * If this is the last iteration, then post the Final Sync recv
+		 * buffer.  This makes the buffer available before both sides
+		 * finish their last iteration.
+		 */
+		if (!repost_recv) {
+
+			/* post the Final Sync recv buf. */
+			for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+				if (!DT_post_recv_buffer(phead,
+					 test_ptr->ep_context[i].ep_handle,
+					 test_ptr->ep_context[i].bp,
+					 FINAL_SYNC_RECV_BUFFER_ID, SYNC_BUFF_SIZE)) {
+					/* error message printed by DT_post_recv_buffer */
+					goto bail;
+				}
+			}
+		}
 
 		for (op = 0; op < test_ptr->cmd->num_ops; op++) {
 			ours = (test_ptr->is_server ==
@@ -1799,6 +1830,126 @@ DT_Transaction_Run(DT_Tdep_Print_Head * phead, Transaction_Test_t * test_ptr)
 		}		/* end loop for each op */
 	}			/* end loop for iteration */
 
+	/*
+	 * Final sync up to ensure all previous remote operations have
+	 * finished.
+	 */
+	if (test_ptr->is_server) {
+		/*
+		 * Server
+		 */
+		DT_Tdep_PT_Debug(1,
+				 (phead,
+				  "Test[" F64x "]: Send Final Sync to Client\n",
+				  test_ptr->base_port));
+		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+			if (!DT_post_send_buffer(phead,
+						 test_ptr->ep_context[i].
+						 ep_handle,
+						 test_ptr->ep_context[i].bp,
+						 FINAL_SYNC_SEND_BUFFER_ID,
+						 SYNC_BUFF_SIZE)) {
+				DT_Tdep_PT_Debug(1,
+						 (phead,
+						  "Test[" F64x
+						  "]: Server final sync send error\n",
+						  test_ptr->base_port));
+				goto bail;
+			}
+		}
+		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
+
+			if (!DT_dto_event_wait(phead,
+					       test_ptr->ep_context[i].
+					       reqt_evd_hdl, &dto_stat)) {
+				DT_Tdep_PT_Debug(1,
+						 (phead,
+						  "Test[" F64x
+						  "]: Server final sync send error\n",
+						  test_ptr->base_port));
+
+				goto bail;
+			}
+		}
+
+		DT_Tdep_PT_Debug(1,
+				 (phead,
+				  "Test[" F64x "]: Wait for Final Sync Message\n",
+				  test_ptr->base_port));
+		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
+
+			if (!DT_dto_event_wait(phead,
+					       test_ptr->ep_context[i].
+					       recv_evd_hdl, &dto_stat)) {
+				DT_Tdep_PT_Debug(1,
+						 (phead,
+						  "Test[" F64x
+						  "]: Server final sync recv error\n",
+						  test_ptr->base_port));
+				goto bail;
+			}
+		}
+	} else {
+
+		/*
+		 * Client
+		 */
+		DT_Tdep_PT_Debug(1,
+				 (phead,
+				  "Test[" F64x "]: Wait for Final Sync Message\n",
+				  test_ptr->base_port));
+		DT_transaction_stats_reset_wait_count(phead,
+					       &test_ptr->pt_ptr->
+					       Client_Stats,
+					       test_ptr->cmd->eps_per_thread);
+		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
+
+			if (!DT_dto_event_wait(phead,
+					       test_ptr->ep_context[i].
+					       recv_evd_hdl, &dto_stat)) {
+				DT_Tdep_PT_Debug(1,
+						 (phead,
+						  "Test[" F64x
+						  "]: Client final sync recv error\n",
+						  test_ptr->base_port));
+				goto bail;
+			}
+			DT_transaction_stats_set_ready(phead,
+						       &test_ptr->pt_ptr->
+						       Client_Stats);
+		}
+		DT_Tdep_PT_Debug(1,
+				 (phead, "Test[" F64x "]: Send Final Sync Msg\n",
+				  test_ptr->base_port));
+		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+			if (!DT_post_send_buffer(phead,
+						 test_ptr->ep_context[i].
+						 ep_handle,
+						 test_ptr->ep_context[i].bp,
+						 FINAL_SYNC_SEND_BUFFER_ID,
+						 SYNC_BUFF_SIZE)) {
+				DT_Tdep_PT_Debug(1,
+						 (phead,
+						  "Test[" F64x
+						  "]: Client sync send error\n",
+						  test_ptr->base_port));
+				goto bail;
+			}
+		}
+		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
+			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
+
+			if (!DT_dto_event_wait(phead,
+					       test_ptr->ep_context[i].
+					       reqt_evd_hdl, &dto_stat)) {
+				goto bail;
+			}
+		}
+	}
+
 	/* end time and print stats */
 	test_ptr->stats.end_time = DT_Mdep_GetTime();
 	if (!test_ptr->pt_ptr->local_is_server) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
