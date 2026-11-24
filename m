Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795485108;
	b=aw5Dp6vClDukC0jO5so97aYmxhDQsnZhrThx48xhlUNEUgSv/S8WykzoJ12POwmJ+FQB
	 /ueYjy1X5HaHP8AtSm1FnsqbTEiEvEdaVZpe7JREr2YV4AG9YheQkyE7bhH+LYLU8a88L
	 cNmzRpY84Jpjrhc9YF1VR0+uU2te94GuFtZpFT/J+YhwfL0iUZSOcNpifvKSko1H7NyRD
	 yP+jcsMZmMhj6ownd2CwmNMUlayzvB2SNxN9fsRiNRGirLOtT4G3TCKoPgGC0NObnn5FA
	 mLK4MdLo/ri6QtuWgEGhARy6SGWyvd4c7nKelTFSOalVBa+FXmYM6I5GnZKvAyS0iug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795485108;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZokbXljId6D6u7QuANBTdgfEPKfjnXSZeiibQC9/lkA=;
	b=vyv7DlJxUeVIRgaIAjh72kUafngv7oiprYMhu8Hz8RDM0gpu8Mq3YhbeA2OOdjnkapYq
	 0rBc/h6LbghpMXC7gzQ3d6U3GXOSx/NPYgiUMcieNfidsXQ2uaFJ6xHSFpsVaGJK0ecJP
	 QgcLQxxNxFn7ccyMiPh/mPJ+q+Ml/FLAnpJVS3zy6POIZvklYE6OapFC2lBoOF3XjOnRw
	 wUjeSZcAXIBhaKsJVW9TQz9DiUfU6ZavF6JKFul0hAlU7m933S6ly4U/CIvYFfAdkxwu+
	 ilvPkP5mxEtculgLd0TN3+CkeqsMQOP7EgvibqRxxvnq3k0ADAzuMizuHC0SQ9kvFAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Y//Iw/2h";
	arc=none smtp.remote-ip=209.85.160.53
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9135C606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 01:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9135C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y//Iw/2h
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-483c607ccb4so2116656fac.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 17:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795485106; x=1796089906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZokbXljId6D6u7QuANBTdgfEPKfjnXSZeiibQC9/lkA=;
        b=Y//Iw/2hGLlL7kW9tiXPoJQIkAnMO1wPPPyCfHudPMhAFcxaDOyuMFdss/Yr7NjONz
         3WubNTPggyprI6vliE1ezEwTf/HcsAntu+OQlK58XePd0Za4zqFgDvbOI41EFOFaFE1w
         rgStdIzT/3/WEkhCMJH1aQkeFudGFQe3/giV79QE3wMxoLz3NAhVXlyDNDc9qvvZp2XM
         h2PDAqvaH735hINC3Hsk5JHVBN3zMMAE6NROgWaEEyipARzbJlAhiVtWN8ARpNwaAO6Q
         SAOzje4yljCVX46QvbPt1JNXUwx8a+gk5DVv45F8/Y6gh7CSN3CR39lEy7Hju004hoND
         6vxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795485106; x=1796089906;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZokbXljId6D6u7QuANBTdgfEPKfjnXSZeiibQC9/lkA=;
        b=E2msoFpFl/2BVmD7eEQhnZ28zmNPcqtxMp4eQwk0o7ug2evCxkCIf3FYVBnXV8g+eS
         5fT2jIkqRY3MGbHS34ihx7owZv/gPF8i6yhUM9Vy58iqjr5ZdBIA7/zZdtgDQupT30XX
         cwGQAg0pADYawIfZoEn618TYcZsVSxoldwiNJrE+yQxSwLD1980iM8FwY8BAACBh8OSZ
         zb+weZN5T8I1jhmGtIEoxZ3M3TQZX35NqopIwsPmdTcTweTkzr/IJtBGCKC0fscbVLxC
         o7B1Y3AW+qrm3lVyHd4j+BrL69jc/Gf8tcWtktXNHSIasTrf4GqKe6fl7wBmkITmnxu2
         FyJw==
X-Forwarded-Encrypted: i=1; AL+hErEkg//wMw+m7pwqyATSsQw+p/B4UckaVz/Gl9qR4blSF5ejGrYKfJ/WDEIgUaxqqVmHIN0TTTVRMebT@vger.kernel.org
X-Gm-Message-State: APuU4Z/CgtPFu6fs2eGKyLqFm5oRv06i/1ma98LYzGXinlK/Yt2QAVSg
	k3YbbhRgKxI+QPkxYBCLcbl8/ZfDIyZeVWj5hJR8GdolvKCLgte5J0keI6d2zA==
X-Gm-Gg: AZFdTZfU+xGAjeZx+h5LQZfeceoefFJg5X2EJS5sImFjdbjopPLJe3/UjZ/aMP2lDqx
	p2Gt0XN1UH+Z7xV0XhVUsR8xhRofvivTwfPsBPWJ32Wk8VkAaqw1vlIvtCA2dLukTV4LB3VJ3qd
	jsSZ1LzKGvxZLOfewMH735EQhn/ipE9WMBNiX/k8JGROwSsWR5ngfPbHL7Cv079riHn8rC+u/KJ
	dBJW+iJMtkhifth5axKocUcheoAsgU+Z0yEQCYbMUGnJTEBNvoPLIOIyHWheznxhRYS6BXl31Qo
	husC9qnppHsir4B+wkmFMrg4OADilGiA4SXWprJ0dp+XOCxq1/lKQ/EqsmHc6c1aI+MgnHG7DN1
	8P7R9IYNqnDwYtDsxl3NzBsmNBvTGSbFyiIFOBOGNSZGQIf6wRaDP8/F9cM31V7YvM/yTm62EJR
	4Nv20EcYeXwIIjnnllKPX0s6T2SaCzGztxxgr5TJNlCGqapo3jB9M715H9V5vXU+1/RVN1ARZAo
	0yzIK/UFhlNLamJ+grYlGfZF5J2xrVD8pxg6L3jQJFwEgypgKtOHKB59b9FvFVVmFkfnXVwAAqc
	Cj3MTRcarbCipehr3Y1QD7zAZMyQ3GesI09n9IWBAg1m2kS9U/Mu0jnkoH/Jv6XS2JNdXjjUFBs
	nxO3tc1UMj2vOLr+CVyFEWQYWH+Uprr9PQafKjfAQJb+AU6uVQDZNxzrwJHXUk7dyQjk=
X-Received: by 2002:a05:687c:8da:20b0:4c4:58b7:f4b2 with SMTP id 586e51a60fabf-4c458b833aemr3066573fac.21.1795485106362;
        Mon, 23 Nov 2026 17:51:46 -0800 (PST)
Received: from tempest-testimage-cc-centos9-stream-server-1191361818 (chi-dyn-129-114-108-164.tacc.chameleoncloud.org. [129.114.108.164])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4bd044fc4besm10895565fac.7.2026.11.23.17.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 17:51:44 -0800 (PST)
From: Yuho Choi <oss.patchbox@gmail.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	Yuho Choi <oss.patchbox@gmail.com>
Subject: [PATCH rdma-next] RDMA/bnxt_re: Don't republish a QP whose destroy failed
Date: Tue, 24 Nov 2026 01:51:36 +0000
Message-ID: <20261124015141.294866-2-oss.patchbox@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bnxt_qplib_destroy_qp() removes the QP from rcfw->qp_tbl before sending
DESTROY_QP and re-inserts it if bnxt_qplib_rcfw_send_message() fails.

No caller uses the QP after a failure, though:
- bnxt_re_destroy_qp() logs the error and returns 0 since
  commit d507d29bfde3 ("RDMA/bnxt_re: Don't fail destroy QP and cleanup
  debugfs earlier"), so the IB core frees the QP.
- bnxt_re_destroy_gsi_sqp() logs the error and frees gsi_sqp.
- bnxt_re_create_qp() frees the QP resources and returns the error so the
  IB core frees the QP.
- bnxt_re_create_shadow_gsi() abandons the shadow QP on failure.

Moreover, on the error paths of bnxt_qplib_create_qp() and
bnxt_qplib_create_qp1(), bnxt_qplib_destroy_qp() is called before the QP
is even inserted into rcfw->qp_tbl (and before sq_flush/rq_flush are
initialized in bnxt_qplib_create_qp()), so the rollback publishes a
half-initialized QP that is about to be freed.

Except for the abandoned shadow QP, the QP is freed right after, so
rcfw->qp_tbl is left with a dangling pointer. On a later QP error
notification, bnxt_qplib_process_qp_event() marks that QP in error and
passes it to the async event handler.

Drop the rollback so the QP stays out of rcfw->qp_tbl when DESTROY_QP
fails.

Fixes: f218d67ef004 ("RDMA/bnxt_re: Allow posting when QPs are in error")
Fixes: d507d29bfde3 ("RDMA/bnxt_re: Don't fail destroy QP and cleanup debugfs earlier")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
---
Compile-tested only (x86_64 with INFINIBAND_BNXT_RE, W=1). I have no
NetXtreme-E RoCE hardware, and DESTROY_QP only fails when the firmware
times out or returns an error status, so I could not trigger it.

 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 5301e4f21ade..a5660002d184 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1473,7 +1473,6 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	struct bnxt_qplib_cmdqmsg msg = {};
 	struct cmdq_destroy_qp req = {};
 	u32 tbl_indx;
-	int rc;
 
 	spin_lock_bh(&rcfw->tbl_lock);
 	tbl_indx = map_qp_id_to_tbl_indx(qp->id, rcfw);
@@ -1488,16 +1487,11 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	req.qp_cid = cpu_to_le32(qp->id);
 	bnxt_qplib_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
 				sizeof(resp), 0);
-	rc = bnxt_qplib_rcfw_send_message(rcfw, &msg);
-	if (rc) {
-		spin_lock_bh(&rcfw->tbl_lock);
-		rcfw->qp_tbl[tbl_indx].qp_id = qp->id;
-		rcfw->qp_tbl[tbl_indx].qp_handle = qp;
-		spin_unlock_bh(&rcfw->tbl_lock);
-		return rc;
-	}
-
-	return 0;
+	/*
+	 * Don't put the QP back into qp_tbl if the command fails: no caller
+	 * uses the QP after a failure, and most of them free it right away.
+	 */
+	return bnxt_qplib_rcfw_send_message(rcfw, &msg);
 }
 
 void bnxt_qplib_free_qp_res(struct bnxt_qplib_res *res,

base-commit: 8dac6df92a2e66e2098bbc69061964cfe7e8375b
-- 
2.56.1

