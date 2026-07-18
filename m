Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8D21A0728
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391984; cv=none; b=ser6yCHHE+JolNoG9cXEV1ObP9xwO0qYE5jRjaiRF0DjCyO2O5oQAjjCUHR9b6Fkt4SI9kzQJKtw8RcqMBWSrnlc/Lv+Fptw0A1+KnS1komKSG4fOLUmsf19V73To8u54ao8WOvqXilE/+8I2zHwUFTP125/e5l8XNQultjXVgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391984; c=relaxed/simple;
	bh=SmuOn8Uxw8XZnxg47IbvGapBEh1SrF66f7V9e1FGwgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed403ICaNepkQ682CaNoIMuJoxRpRMC5EjtDGOavrbK2kHa1HefvLglEnocGmh3+i6LkivwDuPRKuA+9QAoo52CEQ7vUpempdhPecvedObpUK9b5SS4XQHkNozVTqEtu8FhOCGlaSaCFJN+tw9asdF8HXZMeDdHSjz3G/pbwi74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=QAcSNHXR; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="QAcSNHXR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso606095e9.1
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 09:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391981; x=1784996781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=95R+xIP/87RyRb0dz+s7R+IaY6bqD6sOy0TrsJCA7Fk=;
        b=QAcSNHXR7WJ8lkEc1DCyHf8bkHY2j6tNo2m/A1JddgbVd55sspZVEr/ZvfDHZZHaTJ
         dvhFfMWHO8cLD/Qr++X44q4PoP5dAE0nuovSogtsp1HNJp1fgaC4xMUWgS2uu3+hcIZR
         9G1GqBdTCT1Qh/iit0Q2yoTLqBJuzinVb+Qa27A4HH9Pw5qJh4Wk8uGppINWvReA0xa3
         M6B+nQEsu7u1uHpgw2223OCsHGKHQ90lQto6gvxxEAZ1I1vFelss9cy2KEYsg10SPEgB
         uy8PbEwJ1e5SdKdqzQgS6uxgP7A1pyPnxbeQwSCMorxdVrNgB5HygORPPahjkrRw4DAQ
         PB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391981; x=1784996781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=95R+xIP/87RyRb0dz+s7R+IaY6bqD6sOy0TrsJCA7Fk=;
        b=LGTfPyUmKOXqY5hFXPJekTAnKSOvAfuMq40+K28uVwqGfqmgL7wSRuCcntgFBS730M
         RayIA5H3kR5nozOwEDm32QwdB/L/6g/39LsLNWzr2M09bKOJ59in4VdngMpx/9Fi41pM
         NDiFsJsVYoWGgB1BspN5qhojsDeOWVhXxGNieLXMksOeOAiJFL3P9DMFBRgnOHooH6Jr
         eKgDiZ+3pOza2qcvDBE2zinRQ2dc8xUJNH5KjnosUXuz1sh7hQNxrzcCQTFglWrg/Lp/
         YZC5iOu6NeSk2A6XMvVkcs7ZtgARirjFlbWyECB9+k9D/v/m8Z86F8kbphkt3r0sR0uO
         idEQ==
X-Forwarded-Encrypted: i=1; AHgh+RovKWFP5fkOONtKqpDhKTb5asS8r6RFOZCKoclLXA2eL48/1Vem18CHJDf9efO+i55KQjNaPSVGHAoR@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6jAVtS78U1vUSExNxJRVSFIlFt7dMLNSjfYh6cdgqnQlSO0fh
	8YO8V2kXw3bW3eQkoJzI2wbMvgRNSwt0oe6B227rQ7xeD5cpgn8iYXYme+736ZC/Hg==
X-Gm-Gg: AfdE7cm23LINY8apedQUnH39a13jTEj240sVi0aUfv/fIRCk4KuNjiy4A916Pp/smNE
	XB6X/3N7ViWzju/A5xIoJ+gCYf2jIE/lnFWXQqnSeEt2/xXGgpq8X0XT9EkWISytt38TMcQwoY6
	FORQKC6T3xy2nMybycwLB4gvrTsp6G6CRAGuUqp8v4Q3WWE2jBBRNPUlvCbl8dL2TQTRoAW9hI1
	dc7KPHTA9yIMTKBofMNkz9Qxkr3MV8Gu8N43Vu0RwTeOEbX90jH8pAbaNTSQWO3jNVUwc9D2eSC
	GWGsq5j/6zbImocpckgRCU562roFfHS+N2RmdGTA+PalG14YMjdp48u0T6FJiJ7D9VmRoBj+A5V
	DQWf+rU2tdsH5vQG9B0W+DzaxtUIbBfp4Jx9hNb7SqhETDTHxdGFWAXeZtXMbdw==
X-Received: by 2002:a7b:c054:0:b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-4954a40513fmr53645805e9.25.1784391980997;
        Sat, 18 Jul 2026 09:26:20 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:20 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 3/6] md/raid1: don't use write-behind for P2PDMA bios
Date: Sat, 18 Jul 2026 16:25:44 +0000
Message-ID: <20260718162547.448892-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718162547.448892-1-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
must not assume CPU load/store access to them is safe or fast on
every architecture, and bouncing peer memory through the CPU defeats
the point of a peer-to-peer transfer.

Skip write-behind for P2PDMA bios: they are written directly to all
members, including write-mostly ones.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..57f64e890102 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1575,9 +1575,12 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		/*
 		 * The write-behind io is only attempted on drives marked as
 		 * write-mostly, which means we could allocate write behind
-		 * bio later.
+		 * bio later. P2PDMA bios are excluded: write-behind copies
+		 * the data with bio_copy_data(), a CPU copy that cannot be
+		 * assumed safe or fast on P2PDMA (device BAR) pages.
 		 */
-		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
+		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags) &&
+		    !md_bio_is_p2pdma(bio))
 			write_behind = true;
 
 		r1_bio->bios[i] = NULL;
-- 
2.43.0

