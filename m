Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794280218;
	b=PZGW7rvidekk2DOSS9iYBNBKcwPkQvs/B9jDqgZc7blUgkhEhWdwQWHh56GilyQUus0I
	 fSmll9IK41Q9Lz/ycL3H7twmk/Z7TbJwuU7Xbb3e+hWneA0mvANSEnTyQBn2OJWrSVSzx
	 l+gy6z8mKBy+u+tsuqSOlXieeYCgRIJ5pje1qkS7JPgxoDF+gut1PMDku9gTKDvp/xjgZ
	 A6nHuvYZ2yU5Pv1AQzBrjPsVYB/DjJBLDETxn7jXXlxs87cA18UVm3U2wPeQN0kEtqBbr
	 stPKYgWFq+p/7p9XZ5TSrR+bztsnxehTli6c8NwpVQyXoF3Tbp9Y8mAuiPRoO7NrO0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794280218;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n3sfGKW7S9id4w6EJ1yBLSVpVy17lWswp5agSoZ8nvI=;
	b=fOMwhUt8nEUVhnTPAGYtR9aWtmoxKaREHDcQgS7+kIt5op02GyfAUSaHTp1Z4NV/qpCb
	 jwzRijJIwIoSHUT+Dr+35tYzhYSDDxhI4tZcBa5yv0UjZ+Pw5arWfMbX5oN48TlZxPKXm
	 qRX8u7JrI6mgyUdwBbkpCIPqv0ONRuxIA0vVBsX6M+Y+YUq2z1ivzLnXf7b9lp6oKIpRE
	 8E2p9vtxJawSfnFRdYFO7Oz39nWvkeNBofX+i0B7bfOtZu2gakYrgTdP9/ryKCVkHbop7
	 JleiErZnnfV+UYh4MmP8NKY9BMPT/g9aUROj+i/CMxet24UJLaAHaBAoDNBIOxqbj6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DYpm3Hpn;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4777760A2609
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 03:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4777760A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DYpm3Hpn
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-89d6bd67045so783146b3a.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 19:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794280217; x=1794885017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3sfGKW7S9id4w6EJ1yBLSVpVy17lWswp5agSoZ8nvI=;
        b=DYpm3HpnJ+GzIwSECRt5WR39dUsLBo3DTMselW6Zj3ZQjnSK/25qvLf+DxdTelq+Mz
         pUYKNlXEe7iDHrX6QoX8QFmxgfjV6diDh8sRgYR5gkBGeUqgI+AOcifvgqT4qFcfIpH7
         BjR1DDaD5ZUYYPJsSwINXE0JwgEUIR8Lk0R2NcWsXbrvekrll7UItUNWO9VPT3XQcOTa
         4ipLv9+uYnMcIlzfA0zTJ1Ru50EGS49Xqm1y2pKemiG7QmMd2Bp4WCBzlx3kHZJWfvEN
         yerC9JHPW4Ba8Bj2GRXkXNgPwMW5R0og4UJCHQ0u+PR7twNDzOdus4biyT+Tl1x2MbJE
         YevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280217; x=1794885017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n3sfGKW7S9id4w6EJ1yBLSVpVy17lWswp5agSoZ8nvI=;
        b=RU573hjDMJctCqiolT/84v7NrCrNqx8cUg5wlXemmY0X5kbeYeMr/bOpUo0PKrRD4t
         E/kowIHDkm150hZKPx/fqdfZ+B3JmkTUuCsXPbFZ8Y1juh//yqLyAXFc6OSJmLAOS+iZ
         /7DIp7rcFiKNkYzok30qoVZ4+ajxmAAI+9gCalWpsEeVti9dj55NF8amns5867n/HySo
         s04+qCzgkyrXMMFQBBtj835Znj2/b65qTrdTKfcIQHZZ95X71ehjrEXE4ID6+lJb80Zb
         LYwrRR+XlSH0o4XwZ/Dx2RGZf2k/S9eeE2aVfhkOHkZq4LIAPwm9L1PqJBQc0Y2tkteA
         he/w==
X-Forwarded-Encrypted: i=1; AL+hErF4/im2BkBVDAijyLiO/awZDLypeIf8oEKX7yC0zOdO6Uptt+Bj3XRxR+9MDYvVPCcCV2csY5uA7Oh0@vger.kernel.org
X-Gm-Message-State: APuU4Z8PGbUGnQ+Noy7hSWV0jCPNmSW9mL++1n02SlJfQ1AIVry4ugEi
	L4N7FytR1czRp67ZqK51z5eoWmsc5B28s1AsiR4MI9la0iK6jUD+N3X0
X-Gm-Gg: AYBFou0DjPDpCQL7dqZtsMVjaATDhaZCt5jL2Il9OHMLcHrTDyaFW1Os10HhWh0Js/X
	ZEeZLGp52YueOWZzlevSxv9wDAATgvVKsEmBKEdLT4pqNqvOjnFB9LkicSvFFcq4a5DBL2zr0In
	9vOh9HOBHcwYJVu2M7nJX7yOaXATHWbgZ3+P+yJDD/3hSLaW/uLNGnAFizvHe38Jv1XB7ApGUTI
	iihAJFjzpFYTcCVhZA/NR6WAf8KmsDkoHJZAbCT6lGPBR/X1tdtHqmrl6LNQhJFX59t9/eZ0a9L
	s+k7nRGZ7NXVZ+UeLPPsGCLPj3AyrCdZDQMzlRupWffwiZP94d7vsJSW/Tm2wrN6K3Ys/QRP+kc
	2FAjKGgBzlUSY7Q0F3YtBUkLWK+0iCuQlLgM+luU2+U3KbwSX38jXj2cChZC1kJpVvEul2u7E7d
	qbDcH7h6p9MTlT1YWQkFVInnDsiTpQ5uW+6TQBPcD89XPHILwUEwss3lyjr5vaZ1cYyAl/havpD
	BlTKTUUgVWdYhbiYgn3vyCVRuTfyJhteMTtunfKx+DR1Qca1PCFSX4HMrAT/3EWhoYnNY94pYce
	9hgBPegKH6qBwGQzHQAlxDcNP5BxaK1gmvHA3l9zYuo=
X-Received: by 2002:a05:6a00:4009:b0:8b5:b292:85e2 with SMTP id d2e1a72fcca58-8ba95e80f66mr929417b3a.26.1794280216611;
        Mon, 09 Nov 2026 19:10:16 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dffb5sm308939b3a.55.2026.11.09.19.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:10:16 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 1/1] RDMA/srpt: Limit read data transfers to the command length
Date: Tue, 10 Nov 2026 11:08:06 +0800
Message-ID: <20261110030809.913063-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110030809.913063-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
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

SRPT builds RDMA contexts from the initiator's buffer descriptors before
parsing the CDB. For a READ underflow, target core reduces
cmd->data_length, but the prebuilt RDMA WRITE requests still cover the
full descriptor length. A backend such as rd_mcp fills only the shortened
command length, allowing the uninitialized tail to reach the initiator.

A remote initiator with access to the LUN can therefore read
uninitialized target kernel memory beyond the requested SCSI data,
potentially exposing sensitive data left from previous uses of those
pages.

For a READ underflow, limit the data SGEs in the RDMA WRITE chain to
cmd->data_length before posting it. Preserve memory registration and
invalidation requests, and retain zero-length RDMA WRITEs beyond the
limit so that work-request accounting and resource cleanup remain
unchanged.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad..2f7857ef4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2913,6 +2913,26 @@ static void srpt_queue_response(struct se_cmd *cmd)
 			first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
 					ch->sport->port, NULL, first_wr);
 		}
+
+		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			struct ib_send_wr *wr;
+			u32 data_len = cmd->data_length;
+
+			/* Keep MR operations and WR accounting unchanged. */
+			for (wr = first_wr; wr != &send_wr; wr = wr->next) {
+				int j;
+
+				if (wr->opcode != IB_WR_RDMA_WRITE)
+					continue;
+				for (j = 0; j < wr->num_sge && data_len; j++) {
+					struct ib_sge *sge = &wr->sg_list[j];
+
+					sge->length = min(sge->length, data_len);
+					data_len -= sge->length;
+				}
+				wr->num_sge = j;
+			}
+		}
 	}
 
 	if (state != SRPT_STATE_MGMT)
