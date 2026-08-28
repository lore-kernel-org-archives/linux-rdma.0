Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE5639B94C
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 05:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894552; cv=pass; b=VL/N1pPPSRo80G2WCN78ARBluE/3zGjjBrMCrISr0EHBNNT/c4xxpk9OkGj5PNmq5y1Tv/u9rOQP/Z14gwb4F6ekTpm5tuyvtdhGEZNNVi0PKy88P9ve8cuf9WnDpDBshIs1+GbLging/aA89mbPPX/K/F1FiGNdfhfOgsTqITc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894552; c=relaxed/simple;
	bh=sl95zODBaQusIgO7TPjUM+NpjV35Jo+DCZNIFfUI5I8=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ip1LMR+ygNSm/S0UJqTxa68kfWQIBgFllzxscW0j97ynrUc7Dw0V+3hKljP+FgDZ8CIZ2DB//P27iQHtCPcBWdSBhSyVCqSJ9Kjxt/8/gPF9h6YC8dEFlO/85zgx3GSobKnRTbWfVQ1TJb2WlZGGM2Ca+rpag1axDfono+gd3eI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=k6h8HRW9; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="k6h8HRW9"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so504898a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 22:22:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787894551; cv=none;
        d=google.com; s=arc-20260327;
        b=RnRtXQOxibOKXqDYlrneslJAr7cSKqiCobwfev81WN2NxNDXCmOdlffUdOKJYIrxLa
         U06wZneDWAolbu77upL7O8E94CcmVlOicevikG73b+EYzp39wJzs67RxGpw6aBOrWuJv
         PJUeSNqNmJVo8L87UGPqpbn3yECmlBP4gY6A+8CqU4QQV1q1sxe9eJal+EI50bOut5bp
         vQzdNekEx3KnFS2hYPgK3BkeaeWCjgj9uMvllcshQRcqFHh2W6Eq+PhmOuPXN9+dvjic
         OTJ7A4DrGnRyy/KBsjDD1ZEsrMr0TlyRmxqn5G+hAl8IKPeYMULmvA7FcIgJT4S3D1wY
         OYuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=vWQMCUDzhGyDLGQzfH414eGNJ+nqxboyUpIlYz2mzMw=;
        fh=Gk39AkBHZWCDPAQy3vM0eHbsoajk++0GK6f9lDfqkfE=;
        b=rQ/06nJMVkM78S1RxTiF4I2RrOj43wxCatmUK2fqTxHJ0NiJFlJAXgZsCS1mohpulH
         bmxH9AgJ3Q84lzdUnt0j9XgcdVQuj/912fvpRnXia8mPQIqrJvCcG+e0QYhfc97quO5P
         xgbdBQj1ryABX3U9eTJ59Xgrgn32yHFFwcRR/zrCveeCN6z5Q1fAuHejN8VZxOQHdmuH
         2MTFGTA5SFS4DsEkJ+/oe6u380U6Szs0wTnlv4Iy7Lp3yisyV2N9zNDCPXvag3KPKWbp
         Pkw+yf5Df9hffeTdhJsGx/bWWCjC3un4PbjQywSTS0NjyN6ys8hQOAJESbcEWYfsPfVl
         IavQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787894551; x=1788499351; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vWQMCUDzhGyDLGQzfH414eGNJ+nqxboyUpIlYz2mzMw=;
        b=k6h8HRW9AFQaKGQS2lE5j9u+/+UsOlRVOjjZsmvvwBIey/9/s8Ll/gb62p5TxYMfIO
         hD8fot/Pmk4o/7UMosSJ0PMYi9Yxlsbjh4nag9HnNFcE1u81EJ3eHmzxsabqLTZbzXFZ
         QBIJLReVejIrkrTJx7rRuR2OwT1wSkSWDDWQ12M0/3yLmwwlAxrHEqZXqzYgW/KhCFm9
         OXoXPF00xN6U089AffG/sTGVnLh69C7VwFk3MWS+JQYlTdC8BNVJAMhFPtOMv+jG/cof
         gHOhongw0wQJA7el/Mr/QqmkYKWUem5kPgSgHQFlvGzxzTBFbgvddaoIpvnx9Hsz38nW
         JP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894551; x=1788499351;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vWQMCUDzhGyDLGQzfH414eGNJ+nqxboyUpIlYz2mzMw=;
        b=ScxO5ppJBJvA4JNntO+9bYHuKf9TX3NR67xtlYLMDhKzhlK7rUc0QVO5U7NidFFX0D
         tdv1zp8Un3GegCHDdFhcg/x4dJKD14j4lIwWyR7ysdqbSFZ0kfqMJHGTbIFG88OYm6+x
         RGYNsihn9NfBH/Har7STckNzza8FgOyzThNrsOU3wYgrUHfkS1me0UhzWgqnTvspa0L3
         0UlBb9SDpx0V8PtlpJxgopOIlwMoNBxM9+Er+Sm9HAIli007GRlj/tG4I8ZUJ+XTRubE
         vzDpwhAxBU5JzaJjS4pDQs7FBoXuHr/W6qWF/rYXISFN7mN9KGcL5YQmKV+zko8jeZFR
         TGUQ==
X-Forwarded-Encrypted: i=1; AHgh+RrtlY85hMq/xvptafcltbPn6/xv4FImaaetgsFAIWraZ9qvzyRIUvs+qBzw8JHZ7P8TTuIDIryD1z5u@vger.kernel.org
X-Gm-Message-State: AFuF++n7HwtZAOfChy9MXFJhIn9dzYoOamcAvCyRBoEgx82jIJwdDwC0
	v5HLNWhHmVLS3n5WH6ktLAVcl/luTh7gJ3APNZSGfxly0dvEDKoxXJg6+jq2MZRx3DfwjuzXSx/
	Mh06mg4KEWP9r91j3am32vamq4T8DShraWMP8o8nv
X-Gm-Gg: AR+sD13DTorz2ZImunE1qrhZ0AYSoBRf9bA/6nBUVTIv7y8B580FrthYvIE/7gp6Cil
	bUlg9lhYtvkSJXvNAEWSWKbDcV//20SBr3g3lF+MlytU3AqB07foNW7/V88L8s1gmxkqGm3LWyq
	Qs20OsZlUjOBUsG3duXm8wVl3y0Wr9qoRtt9lP6cCMXwpuhIIZBh5WErKB0dp/DQmIaMEHlGa+i
	ef/gf1Qfl+InEak8FK74qPDslbwyGjKY4OSpDocWTMoUeQDuCBIp7gTt0+Fa6MzXAofnF22XVzI
	r0G8gDE7ldN8pMplhkx4ARCGsyvNpK2shVB095U+XV4leSau6OEihAf22zvq1UUHKfbcun2z3ZT
	O0RYe8MdBmelpA1uNJ5b6nqD/xbkqMTg0
X-Received: by 2002:a17:90b:3c8a:b0:38e:524:8797 with SMTP id
 98e67ed59e1d1-396d10076e9mr8898313a91.13.1787894549907; Thu, 27 Aug 2026
 22:22:29 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 28 Aug 2026 05:22:28 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 28 Aug 2026 05:22:28 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 28 Aug 2026 05:22:28 +0000
X-Gm-Features: AcwNN1Umw9_qaqakQNyMoWQELEHjqho4Hul3bBnDmiYLfIj_vD1zvtPjrMp8Shg
Message-ID: <CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-WratpUE6jczHw@mail.gmail.com>
Subject: [BUG] rtrs-clt: general protection fault in process_io_rsp() / rtrs_clt_rdma_done()
To: "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>
Cc: falemi@asu.edu, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/135-rtrs-warn-on-peer-supplied-completion/

  Oops: general protection fault, probably for non-canonical address
0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
  Workqueue: rxe_wq do_work
  RIP: 0010:process_io_rsp drivers/infiniband/ulp/rtrs/rtrs-clt.c:502 [inline]
  RIP: 0010:rtrs_clt_rdma_done+0x732/0x1450
drivers/infiniband/ulp/rtrs/rtrs-clt.c:637
  RBX: 0000000000000058
  Call Trace:
   <IRQ>
   rtrs_clt_rdma_done+0x732/0x1450 drivers/infiniband/ulp/rtrs/rtrs-clt.c:637
   __ib_process_cq+0x149/0x440 drivers/infiniband/core/cq.c:110
   ib_poll_handler+0x78/0x280 drivers/infiniband/core/cq.c:157
   irq_poll_softirq+0x1ea/0x500 lib/irq_poll.c:110
   handle_softirqs+0x191/0x5a0 kernel/softirq.c:622
   </IRQ>
   rxe_receiver+0x1224/0xc940 drivers/infiniband/sw/rxe/rxe_resp.c:1567
   do_task drivers/infiniband/sw/rxe/rxe_task.c:127 [inline]
   do_work+0x1aa/0x720 drivers/infiniband/sw/rxe/rxe_task.c:191
  Kernel panic - not syncing: Fatal exception in interrupt

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
