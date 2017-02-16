From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/3] libqedr: Remove redundant memset
Date: Thu, 16 Feb 2017 07:56:10 +0200
Message-ID: <1487224571-18627-3-git-send-email-Ram.Amrani@cavium.com>
References: <1487224571-18627-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487224571-18627-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The memset was invoked with a size of zero. But anyway, zeroing of the
CQ/RQ/SQ is not required since mmap is used with MAP_ANONYNMOUS that
zeros the queue anyway.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_chain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/providers/qedr/qelr_chain.c b/providers/qedr/qelr_chain.c
index d9ccc0b..26d0d0a 100644
--- a/providers/qedr/qelr_chain.c
+++ b/providers/qedr/qelr_chain.c
@@ -87,7 +87,6 @@ int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
 
 	/* init chain */
 	memset(chain, 0, sizeof(*chain));
-	memset(chain->first_addr, 0, chain->size);
 	chain->first_addr = addr;
 	chain->size = a_chain_size;
 	chain->p_cons_elem = chain->first_addr;
@@ -97,6 +96,8 @@ int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
 	chain->last_addr = (void *)
 			((uint8_t *)addr + (elem_size * (chain->n_elems -1)));
 
+	/* Note: since we are using MAP_ANONYMOUS the chain is zeroed for us */
+
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
