Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6953D3CE0AE
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 03:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025172; cv=none; b=hdB3VmrcwHVQS0xzEx8ZA1VCCB2P33cNc3t214wn+CaXzux9/wpWeAe27NyLLJwvKdjUMEfsBlOpC7nOt4SLP3sPe6SH5o0NkHFEr1ERGAfMd/ShUtuf/yv0/UYCMcnI38Y9SJJoXpHz2pHa3NOmodAZROBtjevSaI5dyK7SyAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025172; c=relaxed/simple;
	bh=Pp6cXGbI+zztA+jMneI7X7NUe8//2gZ37q5m42nPhF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyl6O5RoEtfmpAYpPNkftH75cTEB7uPKtTc8yRDNFqJJNl+aelRT6s884YZJM+JG+68KkYdgqpwT4Y+2QJoyblZZqP/IhGoubsfqi6tMVz4w5Dnf6URaHDqIISaQHgMc+FwrdZkF5WitFdViXtNC6do5ksPTtWRMez4IoZiGYkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Mar1dps1; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Mar1dps1"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-848643382fcso4337749b3a.1
        for <linux-rdma@vger.kernel.org>; Mon, 17 Aug 2026 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787025171; x=1787629971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4FujdklHHhC6Wo8/B2DN1Z5wq1yNgGtjdADnNC3zDrc=;
        b=Mar1dps1bChFBy/4oaNA8tb3aD9V+mYAWy0CeZQoitsWSoVkZozfSNOp1v8jzMN/kU
         o8iae7nMgDIYgug36b/e8qTCJyMQo/abgEsaOPC0+AKfq0ONFzRocGlqVPSS1UlCMOjh
         KjdQbhdFJ38VJAa1AINzjVoLa8w654Mb2L0GjGRG5rBkewZwYZAoW+f2ziy+170IWvj+
         ZoKnr4pgmA2dvdIHGqS2RikwEmZoN/PrIVzbKK1q0iVddWS89gfaraJEPQM4g35LmNJq
         m6874i/6QI/K2H6oxYfhhUnqvE+sOJLsXP/8vXz+/ZosNNpYWEHRp0uOTXSoDvjrwqux
         HNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787025171; x=1787629971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4FujdklHHhC6Wo8/B2DN1Z5wq1yNgGtjdADnNC3zDrc=;
        b=o007MFjU3LHmFR4pquSutbf62fKQvMaO+V53hsHV/8UkbdXsJGlJtfecRv3BVrouhX
         W3ktZKj4LFWWxqfWCZxh5fHaDFbgdDKwrqGv1ya5ssgp4JzObys8gq8QXyAFKKUUkEtN
         bAzJ1mCzO+9/K320XpevV5+UeiHt66DltyxKzk+POMNN8TiX3NjD4KKmNv3svx2OurhJ
         1vx9PhnsndvT2RGEaA9dnlBLkfb0U5st6zYXFlwhfofF52vafY++toXw6+o5G3M+n0Vx
         nMqHa98oZBXCdhaf0Ci6d6BJ1RB82CTJAMamcSQq0pd0zPRrLEQVyvYqiFz78stiHtJF
         SLmQ==
X-Gm-Message-State: AOJu0YyhvhPnCRwwV0vgqvss69s7PfH9njdeGtgT9tXrTkqCAtHq/0tW
	jQyPfz8NTYAXS87xeSHQ9yT9sxYmqaDBJ9vIEz6f6N4jnwPkiA5zDdyg1GxsaBEYRRJRy5rDGxK
	NkmL0j5s=
X-Gm-Gg: AR+sD10oi3IqSKsSG7mL0pnd+r0xZmmv0PIib+Gi89zNddfbgPAbiXKQ8kuYfhSGxyP
	q5ofV+xnYLUDlbEP8ES4iYO/DET/LdN49X/4tmymYaHAyFNzKrYmwgKexWUzJmH7ZVzi08n3sEW
	BBDT0HW9Y5l5nFFHFUeNJauWFv0rwtgvFKABxKbiQ3OmPut+LOvAbigBlaGiwcCnfiCbjgKtjj3
	wQHPniyYNmRLPYZyn3brgRB9gfq5u9iueWW3VB7B2mOmNQjlYj1xtkxSnQ9oZSbpF5xLn31GyzD
	OseitV5EOMO4ZAW8KvWffbNVTfzydpT45NKxHixMtgO36qoroKnmkWoRCQaqjPmA23AQuobS/rk
	eLmKb99bkrNzH224a8oE2gT0MMc175pb7mXe7JJmC2SYMO2CBq7KN6mMWLdj6JyfY1QSFVP0nAz
	h0m0jix2LQLaX1a1q7U8/U9RIypdV4SpVG+BOgr2bALqcoQEL2/AylyKt2p1w8thhRBhss/V8WW
	7BTnlQ=
X-Received: by 2002:a05:6a00:14c8:b0:848:6c9c:4074 with SMTP id d2e1a72fcca58-851b87eaab3mr6002203b3a.1.1787025170684;
        Mon, 17 Aug 2026 20:52:50 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6f8bf71sm985058b3a.32.2026.08.17.20.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:52:50 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 2/2] RDMA/srp: Fix srp_remove_target()
Date: Tue, 18 Aug 2026 12:52:29 +0900
Message-ID: <20260818035229.505098-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
References: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

Remove all logical units before disconnecting the transport because one or
more SCSI commands may be submitted while removing logical units. Remove
the SCSI host after the transport has been disconnected because the code
that disconnects the transport needs resources that are freed by the code
that removes the SCSI host (SCSI host tag set). Remove the srp_rport_get()
and srp_rport_put() calls because the purpose of these calls was to keep
the rport until tl_err_work is cancelled.

Reported-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Closes: https://lore.kernel.org/linux-rdma/20260812190418.200337-1-yhlee@isslab.korea.ac.kr/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f3f19277c2720..ee2bd209b5cde 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1042,15 +1042,20 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 
 static void srp_remove_target(struct srp_target_port *target)
 {
+	struct scsi_device *sdev;
 	struct srp_rdma_ch *ch;
 	int i;
 
 	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
 
 	srp_del_scsi_host_attr(target->scsi_host);
-	srp_rport_get(target->rport);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
+	/*
+	 * Remove all logical units. This must happen before the
+	 * srp_disconnect_target() call because scsi_remove_device() may trigger
+	 * submission of SCSI commands. See also sd_shutdown().
+	 */
+	shost_for_each_device(sdev, target->scsi_host)
+		scsi_remove_device(sdev);
 	srp_stop_rport_timers(target->rport);
 	srp_disconnect_target(target);
 	kobj_ns_drop(KOBJ_NS_TYPE_NET, to_ns_common(target->net));
@@ -1059,7 +1064,8 @@ static void srp_remove_target(struct srp_target_port *target)
 		srp_free_ch_ib(target, ch);
 	}
 	cancel_work_sync(&target->tl_err_work);
-	srp_rport_put(target->rport);
+	srp_remove_host(target->scsi_host);
+	scsi_remove_host(target->scsi_host);
 	kfree(target->ch);
 	target->ch = NULL;
 
-- 
2.43.0

