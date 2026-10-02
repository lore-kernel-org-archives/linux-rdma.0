Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FA04F96B8
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790959572; cv=none; b=DDj1AK8HaJAGMf85P8xAfWVwZemH4wmLC4klwHUzVzYy9sZwjAVN/s4CBI11QJJ2s9SVR5OmIsgrBn00YWy7pz1niGi9ZqMQ7+oF6oVclDPSwhjFHWuvk+ahN93a4FH+AEbVNbAc4EgSTfNFkjmTIXQxMQzWtytjNohgLovDiVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790959572; c=relaxed/simple;
	bh=BVXcxxvTQE/O7saEp1FGaqIOau9wF587cdjRV4YC3WU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N2hYqBLY15QI6wfZ8d86/HbTwazlpC7ENuvUZ9OFlddUdfEfJKAP2cHQVoCIqf1NF/NBn48rolXzu8Wu+Bs59bCNovh9/34W/zifDTJUzP1wIm+CqS6rhMcbmw4wK6OIcu1YRhLBXuMJbrBJST7G+vl7QQ/E/Bo/ZXOJs47O1NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q+AR/DCI; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q+AR/DCI"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd53691be5so51884585ad.1
        for <linux-rdma@vger.kernel.org>; Fri, 02 Oct 2026 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790959569; x=1791564369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BQRPiGMxHWEhd9dkooGOYVkjiSB+0ASRW9701Or0AGU=;
        b=q+AR/DCI0u15RTrcZ0xfp7QtLH0d36IXLOsyvHcsiU+/SX1C26JqcAQYPOgsNo8K0U
         8jDdWCGecxNZ6kDX10/ByCgC4ZUDaC3+YBwf6Hc/d9Xv72Wn3o0kkyVhW+5dl2qDf6jB
         gUECtyZsHEvEgIgyb0wutnCERVVFrafHJIFTRTPIKaOlJXiEETTc6eyqLieiOaDsVYd+
         /LMGselywyvFZdXNB4qlgCuh+Y+vCbQUFCJRCO5vJ4faA+vyRTJd1cfZ9rN7C8zsZAtV
         xWtZFcu/wmqHGQ77XzS7mr8n4X6SG7tMBcp2gPXZgJ7F9rEp3ASF6zUWhIyIadR3wcuF
         UfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790959569; x=1791564369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BQRPiGMxHWEhd9dkooGOYVkjiSB+0ASRW9701Or0AGU=;
        b=FNEYWyaeroZaROIj64FL+Md3O3VgspYSwz1fKk/rapgNCIiDvgQFgzTDmNHiRdqzVE
         BmMi+kzwX+I8u7oWufz1CoVMnXNXi0jZQSodudwW60YQzExfarDYSRYqWZ/CAEvkeSTT
         FbeI3oOouKRXExE5Zvml4b8hrmI/+XND6PE7zBZ72w3e8u2fa3bvZn467z+PHpDPty/4
         H+6n6z/qhLRefFV5XRGcUlB58ZIJJxo8bGBlhX+ifnJb2vU1rLmFvJkX6vyQVXoyLRLC
         yZ4zaz4DBdGuY8exzaJWErGRqV74VV7CkELTGP+j8X9DJ9a07Sb/BfmI2hiwj3TCYp6l
         meZw==
X-Gm-Message-State: AFq9FYKlOkgPpDExr3G/2rII3wNg1AmJmFVzukBdpBhE6RMeunT5hjFD
	1JUHV8nb/dxPQheiHWvqst8GI0a/rrUVfEMCY6xurjqCDHHoRQdXNjVH
X-Gm-Gg: AYBFou0CYPgtg6YnDsdjZPhKN3xtXDfL5M6D+wsaJJQEOl4XmfUlje3L5YVknWoXlcg
	f2cfZkcl5C8Fx7bq51dAmbJgRXt+Wd4NXr0aVdUp5bQNbwh+sebYzYIV56HiYqTKSaFt4tgduI6
	hJnLuCXWd0NgChYlC14FIbwB2/UtRU55RSjwWNf6FJWUaBHV+R+OKmbkgTqLlnrIJVRyZBaFqKd
	95hqJhyCYGQO6siGq9o5brBdUIJvK5ISAfQ6DDOFJvosRzDLmuVIt94pMktxZVQlKbKQAAPgEXx
	8WouSUJFWLDjkY30NCxWOuSSIqnV4cVCgRCt6HMnjZcng2iQrGNmt//MdGsENpPeA6v+3QwyVvt
	CokabJ8cbqcEcDkIpkIVMrdrPD1lyB+od9jUn85OSH7Dx9qTAg+ctA++Cdn4AeZC9mnkxL+uhH9
	QQorzu2CHacdT2gyubvw19SkaJygJ2mdSTiinVnR/Zwt3hqmD89C2CV3u9I7OSIS4qdprEOjVHT
	nNnpaHxnQ==
X-Received: by 2002:a17:902:cf0a:b0:2dd:ad74:ac82 with SMTP id d9443c01a7336-2e49b69a441mr32020495ad.29.1790959569185;
        Fri, 02 Oct 2026 09:46:09 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49e1f320fsm10223295ad.2.2026.10.02.09.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:46:08 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH v3] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Sat,  3 Oct 2026 01:45:52 +0900
Message-ID: <20261002164552.294749-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
a caller-supplied opcode and no bounds check. For a user QP the WQE
comes from an mmap'd SQ ring, so wqe->wr.opcode is an
attacker-controlled __u32 read back by the requester
(req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
qp->is_user branch and never runs validate_send_wr(), whose only
opcode check is itself !wr_opcode_mask() (it indexes before it
checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
so an out-of-range opcode reads out of bounds and the result is used
as a mask and dereferenced; observed as a KASAN global-out-of-bounds
"Read of size 4" and a wild-pointer oops.

Return a zero mask for an out-of-range opcode, matching how
validate_send_wr() already treats a zero mask (an invalid WR), so no
path indexes the array out of bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Assisted-by: LLM
---
Notes (not part of the commit):
v3: no code change. Sent as a standalone message rather than as a reply to
the v2 posting, and dropped the Cc: stable@vger.kernel.org trailer, both
as asked on-list.

On the question about req_retry(): req_retry() does not reject the WQE
itself, it only re-posts it. A zero mask makes every "mask & WR_*" test
there false, so an out-of-range opcode yields iova = 0, the dma cursor
reset, and neither retry_first_write_send() nor the read fix-up; the WQE
is left in wqe_state_posted. Once the requester dispatches it, wqe->mask
stays 0 so WR_LOCAL_OP_MASK is not taken, and next_opcode() matches no
case for an out-of-range wqe->wr.opcode and returns -EINVAL, so
rxe_requester() sets wqe->status = IB_WC_LOC_QP_OP_ERR and takes the err
path, which moves the QP to IB_QPS_ERR and lets the completer post the
completion.

wr_opcode_mask() is the single choke point all three callers
(validate_send_wr(), req_next_wqe(), req_retry()) funnel through, and only
validate_send_wr() rejects the WQE on a zero mask. In req_retry()
wr_opcode_mask() is called at the top of the loop body, before the
wqe_state_posted / wqe_state_done checks, so the out-of-bounds read
happens even for WQEs the loop then skips.

ARRAY_SIZE() is not usable here: rxe_opcode.h only declares "extern
struct rxe_wr_opcode_info rxe_wr_opcode_info[]". IB_WR_REG_MR (32) is the
highest index initialised in rxe_opcode.c, and on x86-64 the object is
1320 bytes with a 40-byte stride, i.e. 33 elements, so valid indices are
0..32.

The bug was reproduced on an unpatched KASAN x86-64 build of 7.3-rc4, with
the reproducer run as uid 1000 (the splat itself is attributed to the
rxe_wq kworker, since that is where the WQE is consumed): KASAN
global-out-of-bounds read of size 4 at rxe_wr_opcode_info, and an Oops or
GPF for larger opcodes. Present unchanged in mainline 551c722f4080
(2026-09-29). This patch itself is only compile-tested (KASAN +
CONFIG_RDMA_RXE). I am posting the reproducer on-list in reply to the v2
discussion of this patch.

 drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd..dcc0788db90a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -184,6 +184,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.43.0

