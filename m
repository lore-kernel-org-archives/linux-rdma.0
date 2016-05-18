From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest] Fix use of uninitialized wc
Date: Wed, 18 May 2016 13:44:07 -0400
Message-ID: <1463593448-30864-2-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clang noticed that we may be assigning a garbage/undefined value to wc_id, due
to a potentially uninitialized wc. Just memset wc after allocation, and we're
all set.

 1. perftest-3.0/src/raw_ethernet_resources.c:842:12: warning: Assigned value is garbage or undefined
 #                                         wc_id = (user_param->verb_type == ACCL_INTF) ?
 #                                               ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 4. perftest-3.0/src/raw_ethernet_resources.c:673:2: note: Uninitialized value stored to field 'wr_id'
 #         ALLOCATE(wc,struct ibv_wc,CTX_POLL_BATCH);
 #         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 7. perftest-3.0/src/perftest_parameters.h:212:20: note: expanded from macro 'ALLOCATE'
 # { if((var = (type*)malloc(sizeof(type)*(size))) == NULL)        \
 #                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
 10. perftest-3.0/src/raw_ethernet_resources.c:673:2: note: Taking false branch
 11. perftest-3.0/src/perftest_parameters.h:212:3: note: expanded from macro 'ALLOCATE'
 # { if((var = (type*)malloc(sizeof(type)*(size))) == NULL)        \
 #   ^
 14. perftest-3.0/src/raw_ethernet_resources.c:682:2: note: Taking false branch
 #         if (user_param->noPeak == ON)
 #         ^
 17. perftest-3.0/src/raw_ethernet_resources.c:685:39: note: Left side of '&&' is false
 #         if(user_param->test_type == DURATION && user_param->machine == CLIENT && firstRx) {
 #                                              ^
 20. perftest-3.0/src/raw_ethernet_resources.c:694:44: note: Left side of '&&' is false
 #         while ((user_param->test_type == DURATION && user_param->state != END_STATE) || totccnt < tot_iters || totrcnt < tot_iters) {
 #                                                   ^
 23. perftest-3.0/src/raw_ethernet_resources.c:694:82: note: Assuming 'totccnt' is < 'tot_iters'
 #         while ((user_param->test_type == DURATION && user_param->state != END_STATE) || totccnt < tot_iters || totrcnt < tot_iters) {
 #                                                                                         ^~~~~~~~~~~~~~~~~~~
 26. perftest-3.0/src/raw_ethernet_resources.c:694:102: note: Left side of '||' is true
 #         while ((user_param->test_type == DURATION && user_param->state != END_STATE) || totccnt < tot_iters || totrcnt < tot_iters) {
 #                                                                                                             ^
 29. perftest-3.0/src/raw_ethernet_resources.c:696:3: note: Loop condition is false. Execution continues on line 786
 #                 for (index=0; index < user_param->num_of_qps; index++) {
 #                 ^
 32. perftest-3.0/src/raw_ethernet_resources.c:786:3: note: Taking false branch
 #                 if (user_param->use_event) {
 #                 ^
 35. perftest-3.0/src/raw_ethernet_resources.c:795:44: note: Left side of '&&' is false
 #                 if ((user_param->test_type == ITERATIONS && (totrcnt < tot_iters)) || (user_param->test_type == DURATION && user_param->state != END_STATE)) {
 #                                                          ^
 38. perftest-3.0/src/raw_ethernet_resources.c:795:108: note: Left side of '&&' is false
 #                 if ((user_param->test_type == ITERATIONS && (totrcnt < tot_iters)) || (user_param->test_type == DURATION && user_param->state != END_STATE)) {
 #                                                                                                                          ^
 41. perftest-3.0/src/raw_ethernet_resources.c:832:29: note: Left side of '||' is true
 #                 if ((totccnt < tot_iters) || (user_param->test_type == DURATION && user_param->state != END_STATE)) {
 #                                           ^
 44. perftest-3.0/src/raw_ethernet_resources.c:840:8: note: Assuming 'ne' is <= 0
 #                         if (ne > 0) {
 #                             ^~~~~~
 47. perftest-3.0/src/raw_ethernet_resources.c:840:4: note: Taking false branch
 #                         if (ne > 0) {
 #                         ^
 50. perftest-3.0/src/raw_ethernet_resources.c:864:15: note: Assuming 'ne' is >= 0
 #                         } else if (ne < 0) {
 #                                    ^~~~~~
 53. perftest-3.0/src/raw_ethernet_resources.c:864:11: note: Taking false branch
 #                         } else if (ne < 0) {
 #                                ^
 56. perftest-3.0/src/raw_ethernet_resources.c:869:4: note: Loop condition is false. Execution continues on line 694
 #                         while (rwqe_sent - totccnt < user_param->rx_depth) {    /* Post more than buffer_size */
 #                         ^
 59. perftest-3.0/src/raw_ethernet_resources.c:694:44: note: Left side of '&&' is false
 #         while ((user_param->test_type == DURATION && user_param->state != END_STATE) || totccnt < tot_iters || totrcnt < tot_iters) {
 #                                                   ^
 62. perftest-3.0/src/raw_ethernet_resources.c:694:102: note: Left side of '||' is true
 #         while ((user_param->test_type == DURATION && user_param->state != END_STATE) || totccnt < tot_iters || totrcnt < tot_iters) {
 #                                                                                                             ^
 65. perftest-3.0/src/raw_ethernet_resources.c:696:3: note: Loop condition is false. Execution continues on line 786
 #                 for (index=0; index < user_param->num_of_qps; index++) {
 #                 ^
 68. perftest-3.0/src/raw_ethernet_resources.c:786:3: note: Taking false branch
 #                 if (user_param->use_event) {
 #                 ^
 71. perftest-3.0/src/raw_ethernet_resources.c:795:44: note: Left side of '&&' is false
 #                 if ((user_param->test_type == ITERATIONS && (totrcnt < tot_iters)) || (user_param->test_type == DURATION && user_param->state != END_STATE)) {
 #                                                          ^
 74. perftest-3.0/src/raw_ethernet_resources.c:795:108: note: Left side of '&&' is false
 #                 if ((user_param->test_type == ITERATIONS && (totrcnt < tot_iters)) || (user_param->test_type == DURATION && user_param->state != END_STATE)) {
 #                                                                                                                          ^
 77. perftest-3.0/src/raw_ethernet_resources.c:832:29: note: Left side of '||' is true
 #                 if ((totccnt < tot_iters) || (user_param->test_type == DURATION && user_param->state != END_STATE)) {
 #                                           ^
 80. perftest-3.0/src/raw_ethernet_resources.c:840:8: note: Assuming 'ne' is > 0
 #                         if (ne > 0) {
 #                             ^~~~~~
 83. perftest-3.0/src/raw_ethernet_resources.c:840:4: note: Taking true branch
 #                         if (ne > 0) {
 #                         ^
 86. perftest-3.0/src/raw_ethernet_resources.c:841:5: note: Loop condition is true. Entering loop body
 #                                 for (i = 0; i < ne; i++) {
 #                                 ^
 89. perftest-3.0/src/raw_ethernet_resources.c:842:14: note: '?' condition is false
 #                                         wc_id = (user_param->verb_type == ACCL_INTF) ?
 #                                                 ^
 92. perftest-3.0/src/raw_ethernet_resources.c:842:12: note: Assigned value is garbage or undefined
 #                                         wc_id = (user_param->verb_type == ACCL_INTF) ?
 #                                               ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 #   840|   			if (ne > 0) {
 #   841|   				for (i = 0; i < ne; i++) {
 #   842|-> 					wc_id = (user_param->verb_type == ACCL_INTF) ?
 #   843|   						0 : (int)wc[i].wr_id;
 #   844|

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/raw_ethernet_resources.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/raw_ethernet_resources.c b/src/raw_ethernet_resources.c
index e87654d..534943d 100755
--- a/src/raw_ethernet_resources.c
+++ b/src/raw_ethernet_resources.c
@@ -696,6 +696,7 @@ int run_iter_fw(struct pingpong_context *ctx,struct perftest_parameters *user_pa
 	ALLOCATE(wc_tx,struct ibv_wc,CTX_POLL_BATCH);
 	ALLOCATE(rcnt_for_qp,uint64_t,user_param->num_of_qps);
 
+	memset(wc,0,sizeof(struct ibv_wc));
 	memset(rcnt_for_qp,0,sizeof(uint64_t)*user_param->num_of_qps);
 
 	tot_iters = (uint64_t)user_param->iters*user_param->num_of_qps;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
