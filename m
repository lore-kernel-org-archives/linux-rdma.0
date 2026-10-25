Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892293;
	b=t1tXyspWuvPHUAnPLKPAern9jczFb73dul7//Pgkd2wtYZQtnBsw64zhrXWFrfzQGRLg
	 AqQJ5VK2fqVkw52YtjZ0fdI3I+bSArpKGB1l/en6wQKVPz1adaoGBj9GKs6OjBdhiiSss
	 i38E8dn+tqm0xA8+Mx8XKkslPQfvz20/sMxzAnhnpA7yU/opdoCaPwpvTJjR7rr4G/4fS
	 Xl2LPjtcVIOUpQHA/+ZvaTHxGJr/xV/+GCEerMDDSNiWYhtKRS1aZ727yys7KapOOO4bm
	 7SWqrkCw3bg6WwebAeUzZeHrkv1iJy21mmbpwybS4AGPn7hJHwf8E3W2Tcws38lR6HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dyBv9Dc6Qhx1XOQaA7oqdIJfObyTsj1C7Q26W9Ag+os=;
	b=M9UaDp7FWKbMs7MX8mae/SHhELbfoYA72RQdYX+zY3iagMlJM1ah4MYfG7YJaAirOpBd
	 Uc+Ejrpkmzc9U3Xhk8ElpljPc3gcf9Yp5RdqI3iXRdeFo6uWxDfytpqdVUm9faSxuu3NO
	 EdE9jWdoOpnCUMHHFEBHJrmv4InkmpzJOS9UQs5i2Tg4YDv53GRoBF9Ukn2/1M6Y66baw
	 AUVUD5jNkozaGRMvjW2DYFeTLj3wDHhLW9GUzEF4tYUCjTZ/TmlEILsK1oHrGQnBFu4Wy
	 tRoTmwytsdmcWVMN3xOFZk+DVmBojJBDim4ZBtJKDrkEkSdE5bxIFDfwKoFT0IwhLmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=iQHI7mA7;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DC606A326
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 533DC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=iQHI7mA7
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33fb4680717so3193262eec.1
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892292; x=1793497092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dyBv9Dc6Qhx1XOQaA7oqdIJfObyTsj1C7Q26W9Ag+os=;
        b=iQHI7mA7+ZzOl9CK0wtM3zFhG196uutFD8us38y2LTGi8QugKaq2lzH6OukKW9FGTM
         misApk5qzZFKUhZo8t5MWvifMvUMyOfT10FQBGQ/OFe4rBpJdEk+OCqn3aLovyWiszmn
         2FTg5YCDH5ndZazMmzgTwtOylV1NFVyRCeJ8edC5fqTZ904MTHeUmYctHSXGtu+xTblw
         z5c8CULHZYO8Sbwu/mZ68/jwBq91jem/Fl2DBqpR6s4VVYqwSGxpfDnSKTupdXSu0D37
         mmaw3E14HbQneLYcjm7uJppGomjpEXWLXbdaK7uUKQNcMqYlEL0nzX40P2oIK3Xsj9Eg
         BdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892292; x=1793497092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dyBv9Dc6Qhx1XOQaA7oqdIJfObyTsj1C7Q26W9Ag+os=;
        b=EFsrxYhCMFutGLeQdrvdYMKdNwfpBC+OH3titsnRzEZA11t4giIWxkHWQy93CJGxcH
         iZl9mEU5KBznx1+YTBfx6Tohw4pI2G7mAoFTqRUakAwYhNs2O+eqEGADXQeqJe9zwu65
         L/RNmazHKbhiV4OlYdksiHDnaY8FJx7xfHOl7nIe3dY2JGIKe92p3D8z/BchmL6MANxz
         ftpsk6AWolcr+APlGXJKDU5O+FQRpkBVhd2Y1i5c5Ksk+mlmelrZi4mEukq5zsrE32yg
         MFV/OEM3A4G1mYCJ35Qd4ZttSySxbXuunTUASoyescT4bQs5vm8MAOzzi3UU1qEwwVWt
         KGBA==
X-Forwarded-Encrypted: i=1; AKwUvBxHqfLE2+QrM64RANp8qLp8jae/eTFKpzRfGIu6dpiDtVswrI/6LVmo8ykc+ZYaccMvXKwCQb0mmkGX@vger.kernel.org
X-Gm-Message-State: AFq9FYIn0fwbzY0TMZtgXXE6DV5yNj2OiUH8xtsGDcEkxjcy7MX33+94
	3al5bISjSWeocc1XuXU5QWm2uP9gmGZHKSS4kUduCnO0u5U1C33GmNWmaCOEKUvtkR0=
X-Gm-Gg: AYBFou1VS6VKqZex+X4OYiD3f8OitfJlXITY4/dAYssEqhpwG6xqVGJtYH1zl6uFpvb
	petfhZXtJL3FLn66gpvaeXJcsP3ksHMDiMwF8nuoEz+DNoZpQdCH8owIW9HWYMam7e/vpte+Jq9
	n8WfqhSUwaVEtVkbr0wNfUDi32gEZkJLKUh+Z1uWVe5LJRrwiuxn3i/QCbdrZt9KY/sIB16NMBn
	+TtnqNwByoao1hNwHTxHaHu8GOY+/zV3hcpJjDL34UlTCQuGfXoH9eq2QCcN8DcoBBoMMPBdKNt
	EOPPpUgcoybdxLcAow9hngR34ecQPzF0I7PPtH35FqSchV+uJ7Kyi1h4mMLp2SQkL4I/bMpVn6i
	FZmiIvoBO2VnKPWFMQJfyxXti47pyAUFygcuoR6clxGYg6+IOSMuKU8Xm8EzayS2jeEPjKjPX5S
	lmBNCSI6bzOS2Ef3VRoRO0GOSAZvS4Hb2/2J7nRgolvJ0zH7q6nunlzs5Y3px/6dDjxAIFkwl/X
	Z0EwLOihmToZamQkaYYNATBMpaJ8c8evsZFca7qYdSeL7VwCuDDtXoAUov6vFelCORtkUSYWV5K
	qTzFbPFUBtWYRbcOCrjb3BKIHcRX72jiHz2tdIqzVqGRNPxksBPB4vGiVQdBRMG0DQ==
X-Received: by 2002:a05:7301:4711:b0:369:4c3f:8a5 with SMTP id 5a478bee46e88-369e84b7d3dmr5194521eec.14.1792892292449;
        Sat, 24 Oct 2026 18:38:12 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8dbaa42sm13724329eec.21.2026.10.24.18.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:12 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 3/3] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 10:37:48 +0900
Message-ID: <20261025013748.3755639-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
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

srpt_send_ioctx::n_rdma and ::n_rw_ctx are u8, and neither of the values
stored in them is bounded by 255.

n_rw_ctx counts the INDIRECT descriptors a command carries, and the count
guard in srpt_get_desc_tbl() admits data_out_desc_cnt plus
data_in_desc_cnt, so up to 510. At 256 descriptors n_rw_ctx wraps to
zero, and srpt_release_cmd() frees the contexts only when it is non-zero,
so every scatterlist and RDMA context the command allocated leaks.

n_rdma is not a descriptor count at all. It is the sum of the
rdma_rw_ctx_init() return values, which is the number of work requests
each context needs, accumulated by ioctx->n_rdma += ret. A handful of
descriptors for large transfers can pass 255 on their own, with no
unusual descriptor count involved. A wrapped n_rdma is then handed to
atomic_sub_return(ioctx->n_rdma, &ch->sq_wr_avail) and tested by
WARN_ON(ioctx->n_rdma <= 0), so the send queue work request accounting
drifts too.

Make both counters int, the type the values they accumulate already have.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index dfcecbe3a47c7..a2af0882eff5a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -959,7 +959,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct scatterlist *prev = NULL;
 	unsigned prev_nents;
-	u8 n_rdma, n_rw_ctx;
+	int n_rdma, n_rw_ctx;
 	int ret, i;
 
 	if (nbufs == 1) {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 506c11b843593..d9061aa65c1a8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -223,8 +223,8 @@ struct srpt_send_ioctx {
 	struct ib_cqe		rdma_cqe;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-	u8			n_rdma;
-	u8			n_rw_ctx;
+	int			n_rdma;
+	int			n_rw_ctx;
 	bool			queue_status_only;
 	u8			sense_data[TRANSPORT_SENSE_BUFFER];
 };
-- 
2.43.0

