From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 1/3] Fix ibv_cmd_query_device_ex to return valid output
Date: Thu, 28 Jul 2016 15:19:40 +0300
Message-ID: <1469708382-29408-2-git-send-email-yishaih@mellanox.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469708382-29408-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make sure to return valid output by memset the extended fields to zero.
No need to deal with specific fields any more.

Currently, extended fields will be assigned to some value or 0 depending
on response from the command. When adding a new extended field, relevant
variables must be cleared if no response got from the kernel.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cmd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/src/cmd.c b/src/cmd.c
index cb9e34c..4b3304f 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -163,6 +163,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	cmd->comp_mask = 0;
 	cmd->reserved = 0;
 	memset(attr->orig_attr.fw_ver, 0, sizeof(attr->orig_attr.fw_ver));
+	memset(&attr->comp_mask, 0, attr_size - sizeof(attr->orig_attr));
 	err = write(context->cmd_fd, cmd, cmd_size);
 	if (err != cmd_size)
 		return errno;
@@ -184,8 +185,6 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 				resp->odp_caps.per_transport_caps.uc_odp_caps;
 			attr->odp_caps.per_transport_caps.ud_odp_caps =
 				resp->odp_caps.per_transport_caps.ud_odp_caps;
-		} else {
-			memset(&attr->odp_caps, 0, sizeof(attr->odp_caps));
 		}
 	}
 
@@ -196,8 +195,6 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		    offsetof(struct ibv_query_device_resp_ex, timestamp_mask) +
 		    sizeof(resp->timestamp_mask))
 			attr->completion_timestamp_mask = resp->timestamp_mask;
-		else
-			attr->completion_timestamp_mask = 0;
 	}
 
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, hca_core_clock) +
@@ -206,8 +203,6 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		    offsetof(struct ibv_query_device_resp_ex, hca_core_clock) +
 		    sizeof(resp->hca_core_clock))
 			attr->hca_core_clock = resp->hca_core_clock;
-		else
-			attr->hca_core_clock = 0;
 	}
 
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, device_cap_flags_ex) +
@@ -216,8 +211,6 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		    offsetof(struct ibv_query_device_resp_ex, device_cap_flags_ex) +
 		    sizeof(resp->device_cap_flags_ex))
 			attr->device_cap_flags_ex = resp->device_cap_flags_ex;
-		else
-			attr->device_cap_flags_ex = 0;
 	}
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
