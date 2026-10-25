Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792928535;
	b=CI1agzsD1ilbPds5Q458SiP0nc+Dxin/8wCq5q5wbCZFyv3jdMlhVVcz9NNEeZurLPod
	 21varGX3S0kGGd/wZuz943alxuW//SoRFWXghtrvCIyCNL/dIGiHEiIxW4RM9l6qxkgnG
	 OisTnL4jk8LCeaRdsoEs+IEN9io/2HWZaTDR/r65DivSE+tqxcA/YQN3NEexW/PacT6hq
	 r/EvzBifaoDTwSU7tFWHBN/AIj5AieIq9y1PlTpEpOGF3BESghfHKRw7ND5yYnR0qqJx/
	 FyFiS9UG5IpAtVcKTNJgCavb3fODJPSjCDtecRQNE2F4lyqh1wvd4EocsBgL2hWPNvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792928535;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eKGclNvWgUqyUYzP51bT4mzycc6IKVIeGzeiBZdeKY8=;
	b=wINwSnRvrtTyvFM8+PmbZVyhjSsh3ZvqZ50qjamjcknpTrrSZvcqaLlLDsvCNKW1CVol
	 9nPd0VHv/xWAdALyy02hJR7FWQxqYVXKkITu7yfaZVUE9P8Lw9bqnRlFTAyb8eDoSDlo6
	 CqKOdCwNG+maebn44yoU9rOiqGk4ZWmcuOO3NUcxrSmV6Hs/k5vI3/AV+U+YFbeLqz6jm
	 issLBKjhFZ52L4ap8MhPfOVuhahqsMt2ZwSXqFOVoLEjcU8xrD0202vNnk6v7Rw1aa0RK
	 hH1RrIZZtHhtZFZut9tb1cYYL33UgbfPk8lMMgQ+Ej6o3d9zL8q9wkJU2i68GSsUifQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=U8j+IzmY;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22025606A327
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 11:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22025606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=U8j+IzmY
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e96502e447so18399905ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 04:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792928534; x=1793533334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eKGclNvWgUqyUYzP51bT4mzycc6IKVIeGzeiBZdeKY8=;
        b=U8j+IzmYH/pXSKWVIUwus2HUH+rGH8aZ4T8suJNpGewLFnCD7J5rvzI0HfSiYCPSVZ
         UU4CkEMO9Qqy2W5QvDKlmwHH/tbrDBUXcW+av3RsVX87Yr76Pcq2W4fqtINnH9Dj0YAt
         PMT1xCU8sCW8NDrXZD7L89UuKvknbqIDeWPRU0pyXxNlktk/2pQo/MiFFoAFQc/QXQJm
         CkiPrXK0z/fSuNwg/322gb5PCMGD1njFA5/U9v7Uy42Xg5UcrgXotJ4/DNDnAPW2vh4m
         oQWEI0QnVs/dLN9i8IBZti+bNhXgdtmXhofpsOoPgmWMCSXUEn8tr/h9gmkuOJw2jxJg
         U2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792928534; x=1793533334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eKGclNvWgUqyUYzP51bT4mzycc6IKVIeGzeiBZdeKY8=;
        b=ov7dMn97SRCXIsR7KH3C0ZwUz8u5MdcuYezRcyIcIzQiVom5eIzVYZta76cA+KJL0m
         QdAJKWULU9/8cre3YmasGNVUn1E+/LFFfW2rn8tzK2XJ8dR0x5AyqOyRtYFt4GrJRhVg
         gpLDY8V+l0yNwx3x6JvBZh0eO8Hrjtba96QFu4EVVQ8AprzlzC4Pw8lDaPURPdHPylut
         v32nQCNaEfl4tBiZSjUYqUq5fY9ov8QhVzJoiMXz7npa5QQcYbY34hcd2TsJdnoMpO6w
         P4Abj1LPD5c+sQ9Z3k72Eua1oJ0pVsFlzD7kDDbU9e01XE715u/3UybKws7UnlWgsT3I
         GH8A==
X-Forwarded-Encrypted: i=1; AKwUvBzk6YamJ62UYDAtGQkWaa+DXcgYgBgIAQ417xgS/jO2DoWPzAs9fjNCsj9Efb2gXAhPKNnbFLCVKQ8E@vger.kernel.org
X-Gm-Message-State: AFq9FYKHGcH/vhp8S8KPtUGkR+VL1XBEmMx0Zsy1SxpadL6qFocnU08o
	DPtbM3/JNZoWD2bOYcoSnumBRCNM7SJAiaGGBHQha1W1Lc3bk9OPn5gP/uW1TTz/7WQ=
X-Gm-Gg: AYBFou2PgdGOb4FAP35fxMVQHHdctKCS0CU3wvf+A3ZiVKaJtqkLDI5f4ktsbh+A0eo
	JK710/F6Smwth19sz4Z1gd5GKDCeKDvAJv8KZegVW6y5XVk9HpYiTotC7PGMnRXHOlBXwSgiXsg
	zTDro/LjEnJuVp4vcl7ARdVO1uPfK5HR/e1ZzzlqBHSPQj5rXnpdU+TUdMeB39Ri7hn9FWgS6eV
	JRYLea7abOF9qVyRSw/1Kf/6/8l4lm8GV2vTmN8kUsOlsY/lXByA8iSSPPbfrPaRoz28HfNEGGY
	NBXMGVlWfaEjSeoJdGPAfWlmGFNqQ4kOzKQG1UZJDfO6Taflju8udFysml2i+6cs2G7k/nM95eh
	Y2QXBZVjro/smw2hliJiCR6xNr1e5wVxlpQF0v2FYMU0jdaMMu+1b2ZbfeCodOea3adLfpz4+Xb
	DXUe3ovHKlGhIoarmj5D269Sz9vWvRknoeFVs0bGozUU6J50E6uiCpYA/VSKmaVnUySOCyhs/aP
	HD3GuBtlzIveXoep8oX8O6XET4lUGwSUf/aCGlCtK9Fj0cHODirfvQKKNzx2yuoZsbgHkyKVpgy
	EMfMkCkMTe1/qJYudv9SKz7q0PSTCXc/I7IVlzgTcI7+JFTULkYuNsqAoczbMEC7tw==
X-Received: by 2002:a17:90b:57e5:b0:3ac:a7ee:6770 with SMTP id 98e67ed59e1d1-3ade9b2f223mr3775889a91.7.1792928534279;
        Sun, 25 Oct 2026 04:42:14 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba32e38sm5219705a91.2.2026.10.25.04.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 04:42:13 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 2/2] RDMA/srp: drop a truncated SRP_RSP
Date: Sun, 25 Oct 2026 20:41:55 +0900
Message-ID: <20261025114155.4007867-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
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

srp_process_rsp() reads the whole 36 byte SRP_RSP header, the tag, the
credit delta, the flags, the status, the residual counts and the two data
lengths, without ever checking how many bytes the target actually sent.
Its two siblings, srp_process_cred_req() and srp_process_aer_req(), both
refuse a message shorter than their header.

A short response therefore makes the initiator parse whatever the receive
IU happened to hold from an earlier response, since the IUs are reused, and
act on a stale tag, status and residual count.

Refuse it the same way the siblings do. A conforming target always sends at
least the header, because a response shorter than that carries no tag to
complete a command with.

Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a85d28b95306a..d891029087b7e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1946,6 +1946,12 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp,
 	struct scsi_cmnd *scmnd;
 	unsigned long flags;
 
+	if (byte_len < sizeof(*rsp)) {
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "dropping truncated SRP_RSP (%u bytes)\n", byte_len);
+		return;
+	}
+
 	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
 		spin_lock_irqsave(&ch->lock, flags);
 		ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
-- 
2.43.0

