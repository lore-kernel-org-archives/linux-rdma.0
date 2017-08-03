From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/4] Shim sd_notify when libsystemd is not present
Date: Thu,  3 Aug 2017 16:04:03 -0600
Message-ID: <1501797846-8228-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501797846-8228-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501797846-8228-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/fixup-include/systemd-sd-daemon.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/buildlib/fixup-include/systemd-sd-daemon.h b/buildlib/fixup-include/systemd-sd-daemon.h
index bd111bc6d21cd9..29cb70c51d404d 100644
--- a/buildlib/fixup-include/systemd-sd-daemon.h
+++ b/buildlib/fixup-include/systemd-sd-daemon.h
@@ -9,3 +9,8 @@ static inline int sd_is_socket(int fd, int family, int type, int listening)
 {
 	return 0;
 }
+
+static inline int sd_notify(int unset_environment, const char *state)
+{
+	return 0;
+}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
