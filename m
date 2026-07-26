Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CDE2D7BF
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079903; cv=none; b=qOjmyr4XGsPonjp439pnUI7YDdoWgSrVH9ZiNaAjCqklHaUX0D28FNUW6V+c+XvVdw1bTfxqUYH71wazYkTEP4wvsAnkAJ6nw9jGkcNsC0SS7e4mmiJLKmN2nyLRx8V0nvNI0Z1RQ3YIFJ9M5nwE4n/9VBQA1W4tx1vOel+pJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079903; c=relaxed/simple;
	bh=c7Pma2i2/+N0DV+POQ+i7P+HjseyUAHIKJYjDdV80zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYOXmH8NX2J8zh07APfch3ftf42LtFVIx0u2SIS8HzGCqcTrn9sxIj4Cyo1o93YY8C5frh/zc632Wh8nx9nhtQ/i8P7LhD6ktPidvvij3y22EXKFqFZRlxekB8IVyIj7z9u8a9NLHiVrveMzZIZQ3QbpmNFSfKNnmmKWbwyh78Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=rKiEsjWh; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="rKiEsjWh"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9e0b89e228so1304546a12.1
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 08:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785079901; x=1785684701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WCyiXiL6v90bExJpgxX0aqjtKCXo1CaNitEii2ppwEM=;
        b=rKiEsjWhnzzAqJLL7OCDGduoudqQ/5GIclJJXbPVLYgTbSGFI2l56Cd2Cv4F0gqGgU
         HZbJ/0UtFmm73THsKxsmzU3cIqaORXSHxg4LlzjFRKJkRjb0qQ0UJxZBybiIe+UXIWBO
         QUSH9DzMvj+V94w3+ZX3T1epS9QlOhPf+35GQGdtG6Fj40Ow2ENXslrmHbDvzy6jlkqF
         39wBku8EqpNBr+aJC1IMMAhxLucvKKBhSO422a3/8KmH0iVwnvOyYEGTiQGn67ExbgX6
         hErEpKJSfSCL2vIXAwsks9nvoC0dPztAukBXZZgHwix3Y7uZPruj5xXxSQML6q+t74zA
         lVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785079901; x=1785684701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WCyiXiL6v90bExJpgxX0aqjtKCXo1CaNitEii2ppwEM=;
        b=AQMg1sGhu936AMmaMBc0gu9Mj88MMjdIMBAEfVBkrGuqN0H+cEtIkfWWtVEzEmDBLj
         wXzeOQUpMa/OqhZTNj6LTeV7D5fYXEnew4q85AdaCK0+md4FubG1Sw1h4yVgHFfsUeAE
         ZmogbT1Cbm5rOlp4cABAXRKzy90cCseynHXpWyzWOaw6RXGQYVzQarAY8nFEE+UmXpYy
         YZQ67olQqJ6jR9Q1y4gH4/AbrU81Gt1YtsIyt1E5FomxkGyXRuGpU8W+8s80nXGt87Uu
         B6laZtvhoSytT0+WtjoqCuY4RydSxgj/E9KmZnbjrJqF7Q5ou5LXT4i7OWYn+ZwUMFLo
         iHjg==
X-Forwarded-Encrypted: i=1; AHgh+RqXNm/xH4b5LwdlSnwIZC5+DX6+xdzZFXQQQ0i6j3iv05s9FrWq426LJHtK29mt5rg5NRR/d+BXWrhM@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh7QZsM+VS2ylrXZwRGVVaINDQO976qVgdD3buxJZoIykrkvS4
	Vh54iqQtjXSComIusn4ET1fRC6+iKcaRB8pwzzZ5/qBjB6cMFe6zPwEMd5+K3jAS9mXs+8l9AvH
	CHWbyV2oiAQ==
X-Gm-Gg: AR+sD12Vr4jm7XSTLCd8QmW6xQCYNWK/k8GVqAu7byzChNNmQRnkBeTyGlVFyZh/UDh
	6iItT2EnBYzYhYW60NeRKWEiepBJlSxrucLaLVlNoMKn6rNdD9ohqadjC2Jc+qmAV30tbSVtrv7
	WDIfILhnrCuy0/cgZFpEy/7rC2p1+lRtU1Sh1ryL6UtqqqjOMztL8ue2E8xlThXgKN0TyANA7ll
	E1rB28ahxoYJKnoJo/O1LUjGejm/7rW/ZU+y3oRY6h7LviHr3LwqKVilSDC3mDBI7bGkxEhu1UO
	pXDhSa3b1lsU2w5JOb0S0JCMs5Y6DQWJb6xDQ5P1pwcB1vIOaoxWnGsmyPUMo/FPGatVUTmWlO6
	NFprNRGG4yN1qCPsDs8MMKGK5mjqHOFh4ib9Wrez+1EaYX0fB+PwP/TiZ1V7Ppa6G8o8JgueLXr
	b63if2zn6byYpzIROwJZCN18IW
X-Received: by 2002:a05:6a21:6004:b0:3c3:daa2:2b7 with SMTP id adf61e73a8af0-3c67df28fb2mr5230165637.44.1785079901080;
        Sun, 26 Jul 2026 08:31:41 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:be9c:ea6b:29a7:6c78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb6622461sm2088301a12.8.2026.07.26.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 08:31:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: leon@kernel.org
Cc: sagi@grimberg.me,
	jgg@ziepe.ca,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] IB/isert: reject PDUs declaring more data than was received
Date: Mon, 27 Jul 2026 00:31:30 +0900
Message-ID: <20260726153130.934622-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260726064628.GA12003@unreal>
References: <20260726064628.GA12003@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jul 26, 2026 at 09:46:28AM +0300, Leon Romanovsky wrote:
> 1. You should review patches generated by AI.
> 2. There is a need to add similar check to isert_get_login_rx() too.

You are right on both counts.  My changelog said the login handler
"already rejects PDUs shorter than ISER_HEADERS_LEN"; I confirmed that a
length check existed there and did not confirm that it was the same
check.  It is not - 29e7b925ae6d bounds login_req_len from below, and
nothing bounds the length the BHS declares.

I reproduced it before replying.  An initiator that sends a 105-byte
first login PDU while declaring 8193 in the BHS DataSegmentLength, on
7.2.0-rc4 with KASAN over soft-RoCE:

  BUG: KASAN: slab-out-of-bounds in kmemdup_nul+0x43/0x80
  Read of size 8193 at addr ffff8881056a8000 by task iscsi_np/167
   __asan_memcpy+0x23/0x60
   kmemdup_nul+0x43/0x80
   iscsi_target_locate_portal+0x48d/0x1180
   iscsi_target_login_thread+0x19a9/0x3350
  Allocated by task 167:
   __kmalloc_cache_noprof+0x158/0x370
   iscsi_target_login_thread+0x971/0x3350
  The buggy address belongs to the object at ffff8881056a8000
   which belongs to the cache kmalloc-8k of size 8192
  allocated 8192-byte region

faddr2line puts the allocation at iscsi_login_init_conn(),
iscsi_target_login.c:50 - login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS) -
and the read at iscsi_target_nego.c:1136, the kmemdup_nul() in
iscsi_target_locate_portal().  The read size tracks the declared value
exactly; 16384 gives "Read of size 16384", and a control run with a
correct DataSegmentLength produces no report.  It is reached before
authentication and the length is attacker-chosen.

On why isert is the one exposed: iscsi_target_check_login_request()
already rejects payload_length > MAX_KEY_VALUE_PAIRS, but it is only
called from iscsit_get_login_rx() and from cxgbit.  isert does not call
it.  iscsit over TCP is safe by construction in any case - it reads
exactly payload_length + padding from the socket, so the declared length
governs how much arrives rather than how much is copied out of an
already-filled buffer.

Your check is sufficient and not merely necessary: the posted login SGE
is ISER_RX_PAYLOAD_SIZE, so login_req_len cannot exceed
MAX_KEY_VALUE_PAIRS and size = min(login_req_len, MAX_KEY_VALUE_PAIRS)
is login_req_len; once dlength <= login_req_len the copy out stays
inside what was copied in.

I will send a v2 two-patch series - the isert_recv_done() check as 1/2
and this one as 2/2 with Suggested-by: Leon Romanovsky
<leonro@nvidia.com> - once the before/after on the login case is run.

Best regards,
