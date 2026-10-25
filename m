Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892287;
	b=YYTu1GTnOXmcJWbyzrQSPKUAkJ3Bk+GD43EuD2kwfTi7lCLvoHIzocN7BjUe4JikfWjm
	 eTDdw+b1opCkNplS97uWPIdedzc37TbPj4CnBKvXOWCPj82DPT90D5LMiuOFhtSil+3L1
	 D+tRj/6yOpm3LnOydmUc7WhiRa9/ROdYfQLcTSD2Buday7HRC+AinqGWLLrFDnqL78OI1
	 UlVqZwG/RbTN9dW92bTK+cZ19bIFVtSf8MRTyZD+6U+0NzdCXkJv3P2/sBkFFdcs2EtDu
	 QwJGvqjQMUpXPSgoLOGIwhk4o5XyCBVkudwEccFkFnSGrQXuO2xf+pnoxJqYo6nPK0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=u8h1InsNpeC2AlWGNl5I9ntcUmNs0bzik5YkhmDqhCQ=;
	b=TxmhqC7Kq7TpIOBC5P9TIYjsizCyAtmfAOkFI61eIRiq/Ub85PUIYKiu9Op+CBWQeXL8
	 0zTFhD9pcq2rQIeFc7xatLNYaFNSuxaMOI9NAofHf7gSonsXAJopkb2zVs3eGvfst+igM
	 DntX/O2Qzh22AQmh5x+N3kN8U9jw0OGHT20ipUqYM8GfLy/ds+97AodDmLRuxb+u41seS
	 x7TW/6tYej+jziakABCoRFEYUOal1Z2YdT/mg6BFzf83Jr3q7t/EugXRDaZvMFKZWmPs+
	 4XlF56SRBYFPr24OTaRdxEY+WE5fvTSuITE67r8N72f+Lq9Xelw2igdxHsS76EyVeLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sEGEkAsT;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F67606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9F67606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sEGEkAsT
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-35b2c599f43so1154051eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 18:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892284; x=1793497084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u8h1InsNpeC2AlWGNl5I9ntcUmNs0bzik5YkhmDqhCQ=;
        b=sEGEkAsTpgfmX82g11PV76q1y7ztdsbuImZnA2R0xNogWSBJjygohuxHaAvHrR5h4t
         MIjSvtpCEnNm7+2UUXIBZ+gmfNImcsjx1SEKy6y3PK18adPKmvvRmeJ9zllhdHjO+1/q
         njtdixJEtnfxjw1SdO+rSCevSSHExE0Q/TCKvrXXbBgsjYcAJGmDjrmU/totlJei9AV2
         NJydQzHgb16+Sman8eEjuNjMtMkqer46DIgBoMmbiRPBrVWiJ8flj7Q+EKdjAOAqOB73
         c9YDNartU+E6io5F3XtQR6ODJmWLZ0Nhe//6KM5ot91kyRbukwdAxh0u4okw7spJD2H1
         blfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892284; x=1793497084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u8h1InsNpeC2AlWGNl5I9ntcUmNs0bzik5YkhmDqhCQ=;
        b=MQD2Xqa50JQcvA7KmrYklfae9p1CXuXJ+RmK4vJEi3Q0yFxkyR4LXprWgpr3+jobWH
         JUejEANrlT/TPTfM+g9dyHbYROK+H5K840ULe15DlhiMvL8GZwj89ipsbuhdoIC725aS
         11Xm2vwPEhlo8Bm+1oI0xu3nG7JJcAp0b8Z2OAUMWOWUqLwB0S2tWQ43Tg+DBO9hYfzS
         +ZBYf7PJRFL/Aeq1nD8Gm4o41B6h/AuWvLs5JVh0YXa9Y+BeNfM+lH8cNWiccQkeqTY9
         u8litjQS50kivjzBs8+wdnhFruHhov11gNd4ayQRAmXQR2faPBergjWX6habA2/Xbsmc
         gfpw==
X-Forwarded-Encrypted: i=1; AKwUvByw+pS85cPghH7XAFvM+zNCbYW9uqgXIZFzza/Wya+YyjoXOecAZZE8R1Z2MQ1guyqABGPbiGHsPPZE@vger.kernel.org
X-Gm-Message-State: AFq9FYKSgBShxH19n+uvRfXMFlHFus2qlxhpkRo4KcE5TApQaP7dwaeq
	9YfmBHThRhFA4GUb98Q7lsVfl3v/i/ElmIC2SV47FcEvC5XpwQ7OBgfD2gKf+lQ80/I=
X-Gm-Gg: AYBFou0F02SSd8SuAEaiGj6CgaGBThyFWrfWLXQ5jEalEeOGY3HZVjgtwCma2mfk3ap
	565Dfl/sE1ZWhJ8aZOmJ4FXlMQpkgQNirN/yBNxUndKIjiL6fxA1TPWpkDsi9Q96NYlpeWhQF6D
	J+YDe2MW5BL8GapfoAd+5HiJY7ovnhQ2GGWtBD9JvgH8BKdrPmTWO2bAGhV4hONV9d9ntaaSCXf
	BtDhL3LdgaS8cBrAkK6Feiwiul+Mraz+kQVAoONXhqdINhCpu1Z+9YxHPRJCDZJZv2+ZdyXCm4D
	wlJU6YTC/TFIVs8fJS46pgBlx1mLyENQ1M8rsbbW3b2CfvRN/iu7s07NqIOmBZsV+E3b1s3713k
	WWFy18TcQdg8khiHWc+Uzbo6bdRdEWIadt7ubrHj/wLe9qtNiCPHIs9IpMnIBqc8wG4tkQmwru9
	lJNy3jVDEuuXNk/421W2h7OaSSEYRCrKKWt8KI9+is+unXXY7r8ZhtI36Al8aZX4EloOXv2vJid
	sE3h6HqV1Uk5JXTRyUS1l8ndyrkRwCFblj0adfEpIiIDfnvebeGke2NZLQbd9ilV/LBn0bFgKtc
	tbCMsKX/Um3mPAj7EvSpHgWV5A7jzdKD9S00yjDSboWTGxmvq9AiOqWjZGK/xNX7GQ==
X-Received: by 2002:a05:693c:820d:b0:366:bcf9:1807 with SMTP id 5a478bee46e88-369e84dd76amr5254349eec.36.1792892283556;
        Sat, 24 Oct 2026 18:38:03 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8dbaa42sm13724329eec.21.2026.10.24.18.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 0/3] RDMA/srpt: fix the descriptor table checks and the context counters
Date: Sun, 25 Oct 2026 10:37:45 +0900
Message-ID: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

The first two patches bound initiator supplied descriptor data, and the
third widens the counters that hold what the first one admits.

A 510 entry table fits in the default 8276 byte IU when the additional CDB
is empty, so the bound accepts it and the counters then have to hold it.
With only the bound, a conforming command carrying 256 or more descriptors
still wraps n_rw_ctx and leaks every context it allocated. With only the
wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
still walks a descriptor table that runs past the receive buffer.

The first fix dates from the driver's merge and the other two from the
conversion to the generic RDMA READ/WRITE API, which is why they are split.

Changes since v4, all in 1/3 and all from Bart's review.

The span check now uses struct_size(idb, desc_list, nbufs) rather than an
open-coded sizeof and multiplication, and the size_t casts are gone. nbufs
is at most 510 by the time the span is computed, because the existing count
check runs first, so struct_size() cannot saturate.

nbufs == 0 is refused explicitly. Bart and Sashiko both pointed out that a
table_desc.len below one descriptor still got through while the v4 commit
message claimed otherwise, so the check is there now and the message
describes what the code does.

2/3 is new, and it has not been reviewed yet. While working out why
nbufs == 0 reaches ib_post_send() I read the rest of srpt_alloc_rw_ctxs()
and found that a descriptor length of zero is not checked either. It
reaches target_alloc_sgl(), which has no length check of its own, and ends
in sg_init_marker() indexing a zero entry table at nents - 1, which is
unsigned, so the write lands far outside any allocation. DIRECT requests
are affected as well as INDIRECT tables, so the check sits in the shared
loop, and the patch carries its own Fixes tag.

3/3 is unchanged and carries Bart's Reviewed-by.

Link: https://lore.kernel.org/linux-rdma/20261024162852.3528224-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (3):
  RDMA/srpt: bound the indirect descriptor table to the IU
  RDMA/srpt: reject zero-length buffer descriptors
  RDMA/srpt: widen the indirect RDMA context counters

 drivers/infiniband/ulp/srpt/ib_srpt.c | 21 ++++++++++++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 22 insertions(+), 3 deletions(-)


base-commit: 6fba331225f5040e93d0947d1027e9712238291f
-- 
2.43.0

