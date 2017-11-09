From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 rdma-core 2/2] bnxt_re/lib: increment psn in case of 0 length packets
Date: Thu,  9 Nov 2017 06:10:40 -0500
Message-ID: <1510225840-20034-3-git-send-email-devesh.sharma@broadcom.com>
References: <1510225840-20034-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510225840-20034-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If application posts a 0 length packet, post send routine
is skipping to increment the psn number. This will cause
PSN number to go out of sync and eventually connection would
terminate due to sequence error.

post_send routine must increment the psn number by 1 even
for zero length packets.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 4d9b044..9d4e02b 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -1048,6 +1048,8 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
 		pkt_cnt = (len / qp->mtu);
 		if (len % qp->mtu)
 			pkt_cnt++;
+		if (len == 0)
+			pkt_cnt = 1;
 		nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
 		psns->flg_npsn = htole32(nxt_psn);
 		qp->sq_psn = nxt_psn;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
