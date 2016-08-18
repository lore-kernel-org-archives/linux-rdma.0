From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 15/23] perftest_communication: fix overflow w/size_of_cur=4
Date: Thu, 18 Aug 2016 13:32:10 -0400
Message-ID: <1471541538-20270-16-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

First up, we have rem[2] and cur[2], and then we figure out what to set
size_of_cur to -- either 2 or 4. If it's 4 though... we then try to do a
ctx_xchg_data() on rem and cur with a size of 4, which results in buffer
overflows and memory corruption. Just make cur and rem size 4 instead.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_communication.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index d938e41..b66801c 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -1706,8 +1706,8 @@ void check_sys_data(struct perftest_comm *user_comm, struct perftest_parameters
  ******************************************************************************/
 int check_mtu(struct ibv_context *context,struct perftest_parameters *user_param, struct perftest_comm *user_comm) {
 	int curr_mtu=0, rem_mtu=0;
-	char cur[2];
-	char rem[2];
+	char cur[4];
+	char rem[4];
 	int size_of_cur;
 
 	if (user_param->connection_type == RawEth) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
