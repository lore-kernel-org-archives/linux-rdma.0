Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633EF3A380F
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065566; cv=none; b=cD2J/WtPKn4AiX7adsdNv9Uu6vyxmdPxO54vfR9xEq/nKk8GxAfBN13X5mvvOttztaNEJcm7DqoH2rUDDkiK5MFq11czIIRBUD85/I0sAOpGTsxmFh+KZAskm2QvBNHiGIw2agzHaEhD/4dQnuKnJ87wGt+KKTST3bE3yEMcD6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065566; c=relaxed/simple;
	bh=rD6vL7WJH3OCucOsC8HBYYohWiKi/wQIj/76rbm0B/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsZa9g5yuo2PBiEBBoGqKb8pCCHXuwZxnAgKOIcRtC5cWaSy0pIeYeI1Ii31NpmRz1ZaOITgbCj6oB+Ff0yepPJRe5ER2SkGUp9WFvkrC4KhFbct/4zktBySeSe0sfsDYOl52t3RAeAroUTA5/J1p4LGFG47Obz6WOkWWbr5Z2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=XDvrQmMT; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="XDvrQmMT"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47db714766aso1443011f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065561; x=1785670361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kpThYo2099okC/dCttBWDQwlmrc8IkfHjxPNABRRgtI=;
        b=XDvrQmMTuqMgXpbqtyPWuAonMNfByOeVS6B9HEKtMQec0haS4XWIcgRsezOL9oLX4M
         D6BMl1IUieQ2YVRrnpkaWZHR+vf34spl/aLs+b37/AXtelF0c5/lCveCo1vKovBHh6T5
         KXqrPfvVe9FFg3a0ySBWsjJgEEd3hWtOvNbMl+CdqFxIfEcaXIBCXlx+Mh+YxkCoIfCa
         z8V+QCx6vsGsXzRh2t+3sjnnsVJcqfWlB014RPYRnDgoG2fA3UyRBh0Vz6sG7Nu/+BYv
         H7be2wvUfHXR7DKpL/bgO6qtbkgaYHRQTbF8fBDD4GuGPt4ap8Xg+H/86n5cnUvvEK81
         qCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065561; x=1785670361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kpThYo2099okC/dCttBWDQwlmrc8IkfHjxPNABRRgtI=;
        b=s4vqIdmggIRgFADanBqA+iW/DmhMX/314f/2hPNvY56o26EaPSXIxjo0q/tOfi2Qaw
         1YvQiWTfuBtmibkS9wcr5R1svH+bBg+9FajKMXk8NyfepAgaYIa2uDLnpKJHV8xqfQM9
         Pj+Z+3YHoQMdrQWcs0gc2OBatFfsp6vGDYFQ/ZIpO+wrO2g2TsS61MuCcT1qn430Nc07
         8rRbJW8vvA6oPHJOvi/IG8Yy/F1t/9STQoDIaNXwdtmiTR9onkAateTrfPidpr3KL/xH
         01UlOJJtbpRNameP0QckILMiTRc5CFsWvHS2T5h8Epq2+hhOruKS1WJKoIYy4h9qo6xm
         g3DA==
X-Forwarded-Encrypted: i=1; AHgh+RptJmnSLzns6iIK1wTnBS4r8oQ0CYoucBwuxaV8uGJ7LFxnX/TVOJLvssny7gYHqAWeLFNiSrDa8zmS@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+tAeE1cMfeaky1AU66qj7HN2nCMp9lmbfrA7faQHVoawQWdXW
	ZnFRj9U8wSH9E2pIQz72WY0BX9QiW6gFcIVW9zazINCJazUC5iaqsKuXf/7IZNW9CQ==
X-Gm-Gg: AR+sD13dg1nKAJ/jnWznT6pVKCG+hVbrNkreJAytiiVP/1OK/2f521OFGwUW5ACg5hx
	3qlMR+iVkMdKPgudOP8/TNBKpKUyERR2aZ5HhXQDphJS1wniE1/oKPXMNr4Mci/2yojk2aPXc6A
	EHhfPh7BaOEnNfUPV3rm2j1J4BDntVSSAMtoixSijRk8JR92ZwKCoHnZVlsHdfAVGCNGyNiDXFD
	ByxSNpQU58lAAo+Zl9DKCUaMxYgRl+ggZ0rz0nPTqPF6cz+5mT8Vr1amsWq1jLSab2GlB2uvX7E
	BYwnAwGX0Wu1d1Pa/SQoVjmYiCb0R3rzW6aZ39D5Cemcn5x/SyC5CbNvv5xByIV1YcwGSu4bIOy
	vOepoWlmz4OLwUkpYXHnG1KV0c62OXUaSSJ2tpHasYFGQxjD8mpFKd71Nx3W1EUOFZJYjQZxpgZ
	pPUBxp6ERbhsx9BUWdiqS6BIa/T+t5ChoC70/I2YKR+JfY6IOOKN84A08rrMz8Ad4zkb7qLU9LE
	Ga51yLvW1QyKNwpybrx4iDCjiIo5fy+nlu2RUbDQQ==
X-Received: by 2002:a05:6000:2088:b0:47f:91e6:3729 with SMTP id ffacd0b85a97d-47f9cf160b0mr9458165f8f.24.1785065561564;
        Sun, 26 Jul 2026 04:32:41 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:41 -0700 (PDT)
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
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 03/12] md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
Date: Sun, 26 Jul 2026 13:32:20 +0200
Message-ID: <20260726113229.2154269-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726113229.2154269-1-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A write that skips write-behind (full behind queue, a waiting
reader, failed behind-bio allocation) races the in-flight behind
write it overlaps: nothing orders the two on the write-mostly
member, and if the older behind data lands last the member keeps
stale data for sectors already acknowledged as rewritten.

Serialize on CollisionCheck, which marks exactly the rdevs owning a
serial tree: serialize_policy rdevs plus write-mostly members when
write-behind arms serialization -- the case the MD_SERIALIZE_POLICY
test misses.  remove_serial() under the same condition.

An rdev hot-added under serialize_policy gets no serial tree at all,
because mddev_create_serial_pool() skips one that is not write-behind
eligible: the old gate dereferences NULL there, this one skips
serialization instead.  Martin Wilck's fix repairs that case at the
source, after which CollisionCheck is a strict superset of
MD_SERIALIZE_POLICY.

Link: https://lore.kernel.org/linux-raid/20260723112741.1206836-1-mwilck@suse.com/
Fixes: 69df9cfc7042 ("raid1: serialize the overlap write")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..997f79c05db7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -564,7 +564,7 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
+	} else if (test_bit(CollisionCheck, &rdev->flags))
 		remove_serial(rdev, lo, hi);
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
@@ -1677,7 +1677,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
+			/*
+			 * CollisionCheck marks every rdev with a serial
+			 * tree; order against in-flight write-behind I/O.
+			 */
+			if (test_bit(CollisionCheck, &rdev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
-- 
2.52.0

