From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 21/23] perftest_communication: check for error calling setsockopt()
Date: Thu, 18 Aug 2016 13:32:16 -0400
Message-ID: <1471541538-20270-22-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_communication.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index b66801c..6b3b1d9 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -686,7 +686,11 @@ static int ethernet_server_connect(struct perftest_comm *comm)
 
 		if (sockfd >= 0) {
 			n = 1;
-			setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &n, sizeof n);
+			if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &n, sizeof n)) {
+				freeaddrinfo(res);
+				close(sockfd);
+				return 1;
+			}
 			if (!bind(sockfd, t->ai_addr, t->ai_addrlen))
 				break;
 			close(sockfd);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
