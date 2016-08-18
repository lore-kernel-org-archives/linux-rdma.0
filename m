From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 11/23] raw_ethernet_resources: fix possible NULL math
Date: Thu, 18 Aug 2016 13:32:06 -0400
Message-ID: <1471541538-20270-12-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While unlikely to happen in reality, there are code paths that could be
taken, where we have the case of X = NULL, then X = X + 1;. Fix 'em.

Error: FORWARD_NULL (CWE-476): [#def39]
perftest-3.0/src/raw_ethernet_resources.c:404: assign_zero: Assigning: "header_buff" = "NULL".
perftest-3.0/src/raw_ethernet_resources.c:419: alias_transfer: Assigning: "header_buff" = "header_buff + 20UL".
perftest-3.0/src/raw_ethernet_resources.c:421: var_deref_model: Passing null pointer "header_buff" to "gen_tcp_header", which dereferences it.
perftest-3.0/src/raw_ethernet_resources.c:173:2: deref_parm_in_call: Function "memcpy" dereferences "TCP_header_buffer". [Note: The source code implementation of the function has been overridden by a builtin model.]
 #  419|   		header_buff = header_buff + sizeof(struct IP_V4_header);
 #  420|   		if (user_param->tcp)
 #  421|-> 			gen_tcp_header(header_buff, my_dest_info->port + flows_offset,
 #  422|   				       rem_dest_info->port + flows_offset);
 #  423|   		else

Error: FORWARD_NULL (CWE-476): [#def40]
perftest-3.0/src/raw_ethernet_resources.c:404: assign_zero: Assigning: "header_buff" = "NULL".
perftest-3.0/src/raw_ethernet_resources.c:419: alias_transfer: Assigning: "header_buff" = "header_buff + 20UL".
perftest-3.0/src/raw_ethernet_resources.c:424: var_deref_model: Passing null pointer "header_buff" to "gen_udp_header", which dereferences it.
perftest-3.0/src/raw_ethernet_resources.c:156:2: deref_parm_in_call: Function "memcpy" dereferences "UDP_header_buffer". [Note: The source code implementation of the function has been overridden by a builtin model.]
 #  422|   				       rem_dest_info->port + flows_offset);
 #  423|   		else
 #  424|-> 			gen_udp_header(header_buff, my_dest_info->port + flows_offset,
 #  425|   				       rem_dest_info->port+ flows_offset, pkt_size);
 #  426|

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/raw_ethernet_resources.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/raw_ethernet_resources.c b/src/raw_ethernet_resources.c
index 3b1516e..d087cab 100755
--- a/src/raw_ethernet_resources.c
+++ b/src/raw_ethernet_resources.c
@@ -406,11 +406,11 @@ void build_pkt_on_buffer(struct ETH_header* eth_header,
 	int is_udp_or_tcp = user_param->is_client_port && user_param->is_server_port;
 
 	gen_eth_header(eth_header, my_dest_info->mac, rem_dest_info->mac, eth_type);
+	header_buff = (void*)eth_header + sizeof(struct ETH_header);
 
 	if(have_ip_header) {
 		int offset = is_udp_or_tcp ? 0 : flows_offset;
 
-		header_buff = (void*)eth_header + sizeof(struct ETH_header);
 		gen_ip_header(header_buff, &my_dest_info->ip, &rem_dest_info->ip,
 			      ip_next_protocol, pkt_size, user_param->tos, offset);
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
