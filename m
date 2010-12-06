From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 2/4] RAW_PACKET QP capabilities check
Date: Mon, 6 Dec 2010 09:36:11 +0200
Message-ID: <4CFC926B.8060305@voltaire.com>
References: <4CFC918D.1090708@voltaire.com> <4CFC921D.3000907@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFC921D.3000907-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to prevent regular user from creating malicious packets, at the
time of QP creation, kernel will check if the process has necessary
permissions. This examination areis done in uverbs layer and is general
for all low level drivers.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b342248..df149ed 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1052,6 +1052,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+		return -EPERM;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
