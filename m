Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4364B390CAD
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 09:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785317541; cv=none; b=BrDGXkzYeShMWf5ZXLs6olAT/5lq4k2QMfMBRri+HjT3UX4d5SU3RAYmv4tuhe3zBwvxYrU1VUzzgbfiCuEALgetS3+luWc+plwnK/rfHAHJWDNLXyrIDOFeckut9ZDasQgdog67E0Gk5MNHX1B+yVY0zTZ+xcyQgoEyKG5Ohc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785317541; c=relaxed/simple;
	bh=IqU0YgZzKEzsx/5LCdF/TBIamIxgAPrzhj1KCD4dqFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g80iiqOKAnryoyPnMMyCLZEArHgaz3UguseGsY+Jrp97wJU8cUKMQ9AT7GbdP/xIULZZQzy9JdUyjujnLL3V75rfGUjS+913Nh43KwqtuIm+GeWgkEL5jVH95XExTYdDhhNMOxUQz8sFNuM5zFSZe26VFh8XY+LeLzI+DO1u88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=e+CAnnwr; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="e+CAnnwr"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso798919b3a.1
        for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 02:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785317537; x=1785922337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hK0F2HP9iBUyZmdmEIJCuhgNrKlY7dMHMuojnLxxUPQ=;
        b=e+CAnnwrbpFL/hHN3UZeWOQltSIdmH6zRLIQ2EvHWoGkRnYNJWA7yjY5unwaAUWms1
         Eot/aq2ia6MSVwTANNOPqw1zWJzJi71rUi1XWiC90n5nGpTP65wCrWDGbM0WgLehzkS5
         DVfjzs0JcE70QhNMI/As+9TeKJYpWk7TD/5A6r7qs0f8Bxl6fWMA+jXg/u0JfK5gHeS1
         qoyIIcWwl5p09WJDVAHB7MzfbfqJS8NftMcMN1+Qd2HUjzO9m3G5HQVGqLuHtu/nNhVq
         uj89lGHgSeWrOVjgUj+uVfFJOXE8ZPcWmjxyr3GdmORyfgJX+c5lDQcXyFrSS2IsPr2w
         FG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785317537; x=1785922337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hK0F2HP9iBUyZmdmEIJCuhgNrKlY7dMHMuojnLxxUPQ=;
        b=RRTkK8hVCKNGk13g1JKTjBUv78IVH1v+ZEfJKlYOi4KoNiagVo3vZGjJI2mr9yuP03
         iAL1HX/MXJGY/PANQhLxJgOSbxt/E/DByuLIGrV6G9i/pmZA0tF/FxBjidudD+D/SGxP
         BAGEKDmyv6pwx5Ifk9qvAxi981ZqSsv343Pn5zTeRpyzQMMTP1wSuaZanw9a6SHgWU6L
         6+YXcFyFp7AVqgzB7ay8WIChW5Q366s/fM1w0XxQkrBf0/pDOkR6xBkxWcBWkZY1hu+Q
         EPUwTJ5tE0KmNgvrJFqUK4Slj51qaPzQKuCpHGpumk5PE7yPbFPQU6CBlfG1wpHhvlli
         K9+Q==
X-Gm-Message-State: AOJu0YxWu6dnjfCWe/P9B6St4G+x/pjBGJkTUdj0jsY8U6GviTn6pAJi
	YlnC/iBPcjaPgdgxzEI9IOulEjoJquF1uelu6aRyQM98WLJdX/gM7zL0YUT30NUEki6Ohu/zPBB
	9Qlti1/zj8w==
X-Gm-Gg: AR+sD11875QD7eGcjvwcDHBQ6Rk1wlDmOZrjYDaDaPcoAoOYB/Dmh5ada7vb00NZBfK
	/iDNZS1J3DHgAabdHUyYuMldv6kiTFHQOYL1CuX8nkMcTRKWuHzv3K0CR5mFNRddQ40b7TqA0lz
	qB0r1ii6f2i+XLbFa+QQLva9fKHIknJ5BhAyBFiVZnPAEC4u864cyTKkQbz1rwRNVsP0zrauxwe
	mPUwYPpvjU+QThcoRnP+axF8q4WLFsf4cVU0AgGY9hbmqyS9X2aNb/2kwnQ+9pDnfNsHQAfGbtH
	08fS0eWEsilMntjq1jqNmt/eRF6KARG63SsEliXZt8GjMwq0J6C+F9ikouWLoJA9b9R/ieDn43d
	CErYyphWS0/RWxcavc4VucSg46MGiJlkiMMYvfhSisx+7UKVc8exPhHNTLSjG53pJxXqTesh+5k
	GWm1sf4mu7aUDz3TmR2hiyUdsSyxZidkGE0cE1kvdY8xmT4rGLt+ZpycShzVy+B6CSwZFS
X-Received: by 2002:a05:6a00:23c7:b0:848:6b43:35dc with SMTP id d2e1a72fcca58-84e932ebe4cmr6086121b3a.35.1785317537314;
        Wed, 29 Jul 2026 02:32:17 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea03869d2sm1082240b3a.49.2026.07.29.02.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:32:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ
Date: Wed, 29 Jul 2026 18:32:03 +0900
Message-ID: <20260729093203.1503201-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srp_recv_done() passes wc->byte_len to srp_process_rsp(). It passes
nothing to srp_process_cred_req() and srp_process_aer_req(), which read
fixed-size fields from the receive buffer without checking that those
fields were received.

The buffer size is max_ti_iu_len, which comes from the login response
and is not validated. A target that advertises 8 and then sends an
8-byte SRP_CRED_REQ makes the initiator read req->tag from beyond the
end of the buffer. req->tag is copied into the SRP_CRED_RSP and sent
back, so those bytes reach the target. SRP_AER_REQ behaves the same way
and also reads req->lun.

The leak is 8 bytes per response. max_ti_iu_len also decides which slab
cache the buffer comes from. With 8 the buffer is a kmalloc-8 object and
the read is entirely outside it:

  BUG: KASAN: slab-out-of-bounds in srp_recv_done+0x172b/0x1aa0
  Read of size 8 at addr ffff888104714da8 by task kworker/u8:3/50
   which belongs to the cache kmalloc-8 of size 8
  The buggy address is located 0 bytes to the right of
   allocated 8-byte region [ffff888104714da0, ffff888104714da8)

Without KASAN the returned bytes are whatever is next in the slab. One
run returned ".strtab".

rsp->data[3] in srp_process_rsp() has the same problem: only
resp_data_len is checked before it is read.

Drop a request that is shorter than the structure being parsed, and
check byte_len before the tsk_mgmt read.

Fixes: bb12588a38e6 ("IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Tested on v7.2-rc5 with a target patched to advertise max_ti_iu_len = 8
and to send an 8-byte SRP_CRED_REQ. Before the patch KASAN reports the
read above on every run; after it the request is dropped and the report
is gone. A conforming target is unaffected - the new checks never fire,
the LUN comes up and I/O round-trips.

That setup also trips an unrelated use-after-free at teardown, in
ib_process_cq_direct() called from srp_destroy_qp(). It reproduces the
same way with this patch reverted; both arms need kasan_multi_shot to
show it, since the read above otherwise consumes the single report. I
will report that one separately.

 drivers/infiniband/ulp/srp/ib_srp.c | 45 +++++++++++++++++++----------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index acbd787de265..93dcd15682d0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1945,7 +1945,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp,
 		ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
 		if (rsp->tag == ch->tsk_mgmt_tag) {
 			ch->tsk_mgmt_status = -1;
-			if (be32_to_cpu(rsp->resp_data_len) >= 4)
+			if (be32_to_cpu(rsp->resp_data_len) >= 4 &&
+			    byte_len >= sizeof(*rsp) + 4)
 				ch->tsk_mgmt_status = rsp->data[3];
 			complete(&ch->tsk_mgmt_done);
 		} else {
@@ -2045,13 +2046,20 @@ static int srp_response_common(struct srp_rdma_ch *ch, s32 req_delta,
 }
 
 static void srp_process_cred_req(struct srp_rdma_ch *ch,
-				 struct srp_cred_req *req)
+				 struct srp_cred_req *req, u32 byte_len)
 {
-	struct srp_cred_rsp rsp = {
-		.opcode = SRP_CRED_RSP,
-		.tag = req->tag,
-	};
-	s32 delta = be32_to_cpu(req->req_lim_delta);
+	struct srp_cred_rsp rsp = { .opcode = SRP_CRED_RSP };
+	s32 delta;
+
+	if (byte_len < sizeof(*req)) {
+		shost_printk(KERN_ERR, ch->target->scsi_host, PFX
+			     "dropping truncated SRP_CRED_REQ (%u bytes received, %zu expected)\n",
+			     byte_len, sizeof(*req));
+		return;
+	}
+
+	rsp.tag = req->tag;
+	delta = be32_to_cpu(req->req_lim_delta);
 
 	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
 		shost_printk(KERN_ERR, ch->target->scsi_host, PFX
@@ -2059,14 +2067,21 @@ static void srp_process_cred_req(struct srp_rdma_ch *ch,
 }
 
 static void srp_process_aer_req(struct srp_rdma_ch *ch,
-				struct srp_aer_req *req)
+				struct srp_aer_req *req, u32 byte_len)
 {
 	struct srp_target_port *target = ch->target;
-	struct srp_aer_rsp rsp = {
-		.opcode = SRP_AER_RSP,
-		.tag = req->tag,
-	};
-	s32 delta = be32_to_cpu(req->req_lim_delta);
+	struct srp_aer_rsp rsp = { .opcode = SRP_AER_RSP };
+	s32 delta;
+
+	if (byte_len < sizeof(*req)) {
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "dropping truncated SRP_AER_REQ (%u bytes received, %zu expected)\n",
+			     byte_len, sizeof(*req));
+		return;
+	}
+
+	rsp.tag = req->tag;
+	delta = be32_to_cpu(req->req_lim_delta);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX
 		     "ignoring AER for LUN %llu\n", scsilun_to_int(&req->lun));
@@ -2108,11 +2123,11 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		break;
 
 	case SRP_CRED_REQ:
-		srp_process_cred_req(ch, iu->buf);
+		srp_process_cred_req(ch, iu->buf, wc->byte_len);
 		break;
 
 	case SRP_AER_REQ:
-		srp_process_aer_req(ch, iu->buf);
+		srp_process_aer_req(ch, iu->buf, wc->byte_len);
 		break;
 
 	case SRP_T_LOGOUT:
-- 
2.43.0

