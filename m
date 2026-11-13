Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559227;
	b=Lj3G9u/uV/GI/Rl5i+kjGjsYdmyCCuDqtTplheghIxYx5Cc2JFPUjp/3EQFz5s6MY7AK
	 azq7GlXLcOlDDJWDqzTpDm7bN9LcmLtQZcb3t/wZZE3E6N8NpdUEvFIrBjmTqmdFqKGjM
	 h4u3vZCWuwsNC0Pp/KL/wBop+Z93dET/ac+ppzAovoq+tduceieS+E7ooJQ8w8ORHbPBH
	 9PuwfZRMgkgbgKRN6DF6kamCJRvMFBvMNxi+QPEMjpd0AbSF0m+lCKyFeAuwBrob1vttI
	 YsfLKK40T6Huctz1oznrrr9X7kwcDzBnk5jzUM2JZMxrypU2YAgFf3frZU4OSH8ejEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
	b=QQOXdRSRmADTGeNha5Intsc9JQO+ur/EgqfNJUuoIB1Ry55fFZriDEgE7hT/uqH6iYdC
	 25R0qrF1n0VdFHaCRWe5gVklMWt4zXthcDqUD+Podxt78VeXBSFub5ztLa5pertLq//5T
	 3CeEnwpZcnDmIa3UbupJbWbOn25Z/5LRgZ3zjvS3iBN3dPRi43T4+GjpCVTv3+mGdVCaq
	 HJ4eyZaLMJirkHDYjbw/Gjj6RFfgMbiAAQ4JyW+8I6Yb1XJJPLMYD+2y4VYYcAS17Mry4
	 kDhap/UOH1M0JP2BPvtqk7N7oBxzK5mRn1Zq4LvekcY3t+P1PbmoPEsFOWme55CL6Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMW3oCUZ;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2A5606A327
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB2A5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMW3oCUZ
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so313526a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 00:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559226; x=1795164026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
        b=WMW3oCUZ/rAbrvlxycYpeBLVSzfh2TLgjVIcTTWk0wKtre5oqsAU4oz9pcN6quLYki
         EU/bMMfcvEgcttMb9KZqWf3fu9f5+JyBdDUffJwHcSWVoQzx4x4aibqf2XX2cuWGlEVN
         jHg+RH+23I1Hwne/9x6ygIJUDwWrX8IAll0CKyXc4bjsaWYGh/v4cEvlblf11+PRq4TG
         aOQ3JKy/k+k1L3Jfm5IxA1OIUtrFHzONFmzEA8ZZs40hWUFED4kxkbdRsSNOkGpv+/aP
         ve2h2AkSK1xNt6f7GxVjbdv/44T9tB5GaQHXLjsduAhQNcgbD9fUH+finDFVkUy23xTR
         B7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559226; x=1795164026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
        b=Ne6mEJvjWkeBxDkiGrZfAsNqO+0ctdq5B+i4fgV057GRWz9MVYXOwq9r8iQLx/RgqG
         HyiKTqFQH+k+5pofEP4GnvtHSU0DhBd3FC/8VaYbkvMsLLveAruHTzSQJ5TZ9FoCejMC
         GefWOVqyuGSPF0iYTGj9RRLAIr8WR93STTeGj2KQYXyRWiEvu3EoY6Zns1ttXAwZlBIo
         kzvjzGCAVDaOR9wrZq/F0tkoIhXm0WaVXbPbE5k8AoQjmdtTqGVYhGH2EGfA5Oc7/iNI
         XKkwahCfRjUSHXCtaD6Zq2Qr97lUW2YQqf+C81IqthXdzEkCK+RdwoSiknqnhItN3Tq5
         k2Lw==
X-Forwarded-Encrypted: i=1; AL+hErHp7ynONQdCL71r4JSxp7tAqlfGi/E1vXM8Muk++iT5Wf2aV67R5PUbFvITIMjNk96xROkIsKpKp+gE@vger.kernel.org
X-Gm-Message-State: APuU4Z8M297EVhWqOo9ECf4rEiHRTLTeKb0C+CR2VMxaKu8nW40XaAPZ
	5oPQBOhlJJadf+qYsSKEXXJUsyz9N64iOiwuVbGI/tSIEqI5ebdJVLNf
X-Gm-Gg: AYBFou1/IXD/ga8zHrM1s1GoKR7YEmRUOy5bRC83hIHe6XXgoIgis0SvjZg0gjf6St1
	uszfqcmvGs2rsuvkJ0yEJhTXpvekMES1g2HjnWo4bIeovGKAoUET1PSeGBD3Mho+KeNZaHqsyWa
	lZQ28xU3Mynbh3xYOkqE7UXqFvbKPXZyWvtA3+gDXTnVIdmYJ+Tz2pQ06u/lnqfv691WUlyc4NB
	In36YTwGo+hzDuJKbLMfgzmFTd5tpMK+SgFI3ous9uwUeDL6b0/Ueb9ub1+xHRx/pIAcWzwb39P
	Vu7SEmFp8BjNvgHN4gVEISCOcAztegjId10g4r3HOUYbBERqpEv6TaOrJ7O/kH719X0CZ8qwXpN
	VvVeX9ZbPO277I4o0CuEezDFWCC4yqBRhsfO8pxSua4+c4s0yky9MhJBm8JqV/CSfyDMel6dmHJ
	FQniR49JVjHiv6YT5JV2IS6FIhUPwzlrjztpONQe8Y9Rnrzrwy9u8L6FOiHMASwt4c/s+66h6Ds
	2UGO1bgZiEso6NidcXPJJ4FamSW7PGPmPJC1XZvAuKwEYLk7sL+QgoTDwb4XQ4OcsPNsRwNA7/J
	0PuTRZjTjNUXhPyqTFKAyejgxQG56PAJUm/IAGzUUQ==
X-Received: by 2002:a17:90b:4acb:b0:3ad:6090:a189 with SMTP id 98e67ed59e1d1-3b1b0b67b18mr1705922a91.45.1794559226059;
        Fri, 13 Nov 2026 00:40:26 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:25 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 1/3] RDMA/srpt: Initialize commands before returning BUSY
Date: Fri, 13 Nov 2026 16:38:40 +0800
Message-ID: <20261113083848.1517595-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

srpt_get_send_ioctx() clears ioctx->cmd, but descriptor parsing can fail
before target_init_cmd() is called. The error path then calls
target_send_busy(), which dereferences the NULL cmd->se_tfo pointer.
A remote initiator can trigger this by submitting a command with an
invalid descriptor table.

Initialize the command before sending BUSY on descriptor parsing errors.
Do not request an acknowledgment reference since the command will not
be submitted to target core.

Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
Cc: stable@vger.kernel.org
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8..127f256c6e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1597,6 +1597,13 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
 			       srp_cmd->tag);
 		}
+		/*
+		 * Even on -ESHUTDOWN, target_init_cmd() initializes the command
+		 * so it can be completed with BUSY without core submission.
+		 */
+		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+				scsilun_to_int(&srp_cmd->lun), 0,
+				cmd->sam_task_attr, dir, 0);
 		goto busy;
 	}
 
-- 
2.43.0

