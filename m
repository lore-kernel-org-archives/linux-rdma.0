From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] libqedr: Check queue mapping return value correctly
Date: Thu, 16 Feb 2017 07:56:09 +0200
Message-ID: <1487224571-18627-2-git-send-email-Ram.Amrani@cavium.com>
References: <1487224571-18627-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487224571-18627-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When mapping CQ/RQ/SQ check the mmap return value.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_chain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/qedr/qelr_chain.c b/providers/qedr/qelr_chain.c
index edc72f4..d9ccc0b 100644
--- a/providers/qedr/qelr_chain.c
+++ b/providers/qedr/qelr_chain.c
@@ -76,7 +76,7 @@ int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
 	addr = mmap(NULL, a_chain_size, PROT_READ | PROT_WRITE,
 			 MAP_PRIVATE | MAP_ANONYMOUS, QELR_ANON_FD,
 			 QELR_ANON_OFFSET);
-	if (chain->first_addr == MAP_FAILED)
+	if (addr == MAP_FAILED)
 		return errno;
 
 	ret = ibv_dontfork_range(addr, a_chain_size);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
