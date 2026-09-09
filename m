Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41283471271
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942702; cv=none; b=DXD8FmZu9o5q8ZjoFvf6BmnwQ+veI24gZcGn9JDD4v0ziCiP/3auhlOZlVJl34deDT/QMvBSyF4PU63z41kglIOXlWxeR+dW+TDYfvpXHx5C//oC1oUf3FYFtFWjsUGH0YU+Cp8hLK84o4Zr7iwGfOv1RC7wfiKjYOwdbqCwcLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942702; c=relaxed/simple;
	bh=uDLNxhbJgkz0/NSwy7S9jmNTyJ0BMSFl8QEG5JPhLbM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WvmMIPTQA3Rie7K1Cj/CoJNKYkJA1S5FbIMo7WrEOgwcBPVh/Dc6gs3/Y4p/D1pG7lvd7dHrQnHg82Bg7W3kZhTWaNWsvUngVIOhX2Gdk+XO0bdEAb05daqMer0Lg41h4RyJZkQcowzfvFRboIuO+WU4rBYOB2lM21v5dyRD9sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=DnLdVRsS; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DnLdVRsS"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-868b3248b2cso445150b3a.1
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942700; x=1789547500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aF2YYLviQC7k0gOePiuYzdYi8in7fV8VgUF3QZqs4ww=;
        b=nwUp/Pv+d0gCzwHgWiO71FWsAwnHDAhaZHw4+ZwwqgMIWam3/Uw2PWhpBCJIPRfmzO
         QeJF9QSaiL4dAEfEDzP5hfaJ3HLjndEyosHRUiiicPkijAgQmaDGVKK6i2RvCXISi9ST
         nzmYS5yxa8beAqMD4DDBAk4kwmvbRIhyXKLEpTLc2LHbDdYKcMRWhuJRWCUW18znjD0j
         SL6553uka+I/6ppYxxDUO69jrRDCPhxv8nFQ3MfSM2rtshpkDbUhC9MO8kxtwZoZNo2n
         XXlzUTfJ7nQplDVN3K94U7XQPfHFED+s7v8npIUcKOA9GDIeOwD82m2b+JLU4HtCTD6k
         npsA==
X-Gm-Message-State: AFuF++lpOoUCr0vUuO6LZymybIUgITtUNCCrS3+xiQvTc/JOiXgrJDKO
	Ee3kd2fJ7GtKSekhpfetvRtf+eaEjtV1FB1hGflbhrMh2/VQ2retX5IvF7nC8PH00b2RXJBjzlw
	jupJzGIb5hikLhUipsxsSkacw2veGssTNhBi7HN1mBOIUCHaW/jwTciX0pwL05fl3/YToPUqsL4
	7Cgpl53vbELFhUOySUdUHfeFgunhr3MF6L30PvA+S7L0YTJMEA2ECZ+PiaMIsFnPdIe5Tsnyl7E
	ns2HebWg+BIGWq66w==
X-Gm-Gg: AYBFou0t5ARgJYU/ihymA0AOwkEi+/0ZsjQMMIE1jufZdfaFNe1sM6i3YK4lkMHY34G
	F0d7lVFGUx5+rbo37Xz4pfW+eNZGGmSdFpjyTapmawaizoZq+fCfRk75h6SjJ4eokNQiBH3qfV+
	7jS574KO5RAT3kogwG2YEzBRz8GQA2+jbJMVRZBsQp+KpeUXW98ES70RTILrd42XWXKz9y1+9zH
	GKPgyDAahUTL9uc1pIhpomn4KlVaSdt0YRXvBWAn4ZfVepSS7o2JUidtevUgE7Rqqf3v5O7+ghr
	zRSYY/GcbbC5gOSVyVSNomO1GR7rkwltbS3bHKI5/gSRBi4ml3yUAyZ1nHKoJWP26mMlPvsQNou
	nULuVmo3Pdq81Xt8g5q78qG9rbl464QiBQjADgKxG+UtW9phMlMquONoNxryO72/8OZRfejmbsN
	Lry3f9BwkIkx3ZSgKi0RgJCWE+PCurhmpLsenLpv0=
X-Received: by 2002:a05:6a00:4298:b0:848:4754:28e4 with SMTP id d2e1a72fcca58-86169e6ecfbmr45785055b3a.15.1788942700576;
        Wed, 09 Sep 2026 01:31:40 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8652a30058bsm2488550b3a.8.2026.09.09.01.31.40
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:40 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398fe469aa0so9022539a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942698; x=1789547498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aF2YYLviQC7k0gOePiuYzdYi8in7fV8VgUF3QZqs4ww=;
        b=DnLdVRsSN+bgUpgl75iX25GTmTBsz5o4O32I8I2n8YmUw6tDufq2M/+KZ4tU/+gXHM
         zfnMsaRchsNd6ipC1dp3yyvN0reIpAYkIHntjis8jFcNkVM7Fnubv0pV5eGVAGxYP4Xa
         jiGfhYElvbp5wucOYLANGx9aUZ8QpRynaxx04=
X-Received: by 2002:a17:90b:1d45:b0:398:9bd4:d1a with SMTP id 98e67ed59e1d1-39b262995b8mr49409055a91.25.1788942698468;
        Wed, 09 Sep 2026 01:31:38 -0700 (PDT)
X-Received: by 2002:a17:90b:1d45:b0:398:9bd4:d1a with SMTP id 98e67ed59e1d1-39b262995b8mr49408997a91.25.1788942697899;
        Wed, 09 Sep 2026 01:31:37 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:37 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 8/8] RDMA/bnxt_re: Check is_in_used before trusting RCFW completion
Date: Wed,  9 Sep 2026 06:52:44 -0700
Message-Id: <20260909135244.122747-8-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260909135244.122747-1-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Gate the crsqe->resp memcpy in bnxt_qplib_process_qp_event() on
is_in_used in addition to is_waiter_alive, since a late/duplicate
completion for an already-retired cookie could still write through a
stale resp pointer.

Also disarm the waiter and clear resp when a wait call bails out early
on ERR_DEVICE_DETACHED, and require is_in_used before re-triggering
__destroy_timedout_ah(), closing the same stale-cookie exposure
elsewhere in the completion path.

Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driver detect a timedout")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 9ee0d500436c..0339e55bea88 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -511,14 +511,16 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 	else
 		rc = __poll_for_resp(rcfw, cookie);
 
-	if (rc) {
+	if (rc || test_bit(ERR_DEVICE_DETACHED, &rcfw->cmdq.flags)) {
 		spin_lock_bh(&rcfw->cmdq.hwq.lock);
 		crsqe = &rcfw->crsqe_tbl[cookie];
 		crsqe->is_waiter_alive = false;
+		crsqe->resp = NULL;
 		if (rc == -ENODEV)
 			set_bit(FIRMWARE_STALL_DETECTED, &rcfw->cmdq.flags);
 		spin_unlock_bh(&rcfw->cmdq.hwq.lock);
-		return -ETIMEDOUT;
+		if (rc)
+			return -ETIMEDOUT;
 	}
 
 	if (evnt->status) {
@@ -627,6 +629,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 	struct bnxt_qplib_qp *qp;
 	u16 cookie, blocked = 0;
 	bool is_waiter_alive;
+	bool is_in_used;
 	struct pci_dev *pdev;
 	u32 wait_cmds = 0;
 	int rc = 0;
@@ -682,7 +685,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		if (crsqe->is_internal_cmd && !qp_event->status)
 			atomic_dec(&rcfw->timeout_send);
 
-		if (crsqe->is_waiter_alive) {
+		if (crsqe->is_waiter_alive && crsqe->is_in_used) {
 			if (crsqe->resp) {
 				memcpy(crsqe->resp, qp_event, sizeof(*qp_event));
 				/* Insert write memory barrier to ensure that
@@ -697,6 +700,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 
 		req_size = crsqe->req_size;
 		is_waiter_alive = crsqe->is_waiter_alive;
+		is_in_used = crsqe->is_in_used;
 
 		crsqe->req_size = 0;
 		if (!is_waiter_alive)
@@ -718,7 +722,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		 * resource leak and relatively not critical +  unlikely
 		 * scenario. Current design is not to handle such case.
 		 */
-		if (!is_waiter_alive && !qp_event->status &&
+		if (is_in_used && !is_waiter_alive && !qp_event->status &&
 		    qp_event->event == CREQ_QP_EVENT_EVENT_CREATE_AH)
 			__destroy_timedout_ah(rcfw,
 					      (struct creq_create_ah_resp *)
-- 
2.39.3

