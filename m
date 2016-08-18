From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 13/23] perftest_communication: don't leak addrinfo
Date: Thu, 18 Aug 2016 13:32:08 -0400
Message-ID: <1471541538-20270-14-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Error: RESOURCE_LEAK (CWE-772): [#def7]
perftest-3.0/src/perftest_communication.c:873: alloc_arg: "check_add_port" allocates memory that is stored into "res".
perftest-3.0/src/perftest_resources.c:554:2: alloc_arg: "getaddrinfo" allocates memory that is stored into "*res".
perftest-3.0/src/perftest_communication.c:879: leaked_storage: Variable "res" going out of scope leaks the storage it points to.
 #  877|
 #  878|   	if (res->ai_family != PF_INET) {
 #  879|-> 		return FAILURE;
 #  880|   	}
 #  881|

Error: RESOURCE_LEAK (CWE-772): [#def8]
perftest-3.0/src/perftest_communication.c:873: alloc_arg: "check_add_port" allocates memory that is stored into "res".
perftest-3.0/src/perftest_resources.c:554:2: alloc_arg: "getaddrinfo" allocates memory that is stored into "*res".
perftest-3.0/src/perftest_communication.c:889: leaked_storage: Variable "res" going out of scope leaks the storage it points to.
 #  887|   		if (num_of_retry == 0) {
 #  888|   			fprintf(stderr, "Received %d times ADDR_ERROR\n",NUM_OF_RETRIES);
 #  889|-> 			return FAILURE;
 #  890|   		}
 #  891|

(and more!)

This var is only accessed by the above referenced conditional, and to copy
sin, just add two freeaddrinfo(res) calls and we should plug several
possible leaks on error paths.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_communication.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index d46d21e..bec973a 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -876,11 +876,13 @@ int rdma_client_connect(struct pingpong_context *ctx,struct perftest_parameters
 	}
 
 	if (res->ai_family != PF_INET) {
+		freeaddrinfo(res);
 		return FAILURE;
 	}
 
 	memcpy(&sin, res->ai_addr, sizeof(sin));
 	sin.sin_port = htons((unsigned short)user_param->port);
+	freeaddrinfo(res);
 
 	while (1) {
 
@@ -1074,10 +1076,12 @@ int rdma_server_connect(struct pingpong_context *ctx,
 	}
 
 	if (res->ai_family != PF_INET) {
+		freeaddrinfo(res);
 		return FAILURE;
 	}
 	memcpy(&sin, res->ai_addr, sizeof(sin));
 	sin.sin_port = htons((unsigned short)user_param->port);
+	freeaddrinfo(res);
 
 	if (rdma_bind_addr(ctx->cm_id_control,(struct sockaddr *)&sin)) {
 		fprintf(stderr," rdma_bind_addr failed\n");
@@ -1160,7 +1164,6 @@ int rdma_server_connect(struct pingpong_context *ctx,
 
 	rdma_ack_cm_event(event);
 	rdma_destroy_id(ctx->cm_id_control);
-	freeaddrinfo(res);
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
