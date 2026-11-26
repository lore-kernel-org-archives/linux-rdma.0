Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795652562;
	b=lk96BSowQGcBGmyHcjK360G4ZXABgQ1ylOv+Iz8lbqO0/DItFnBcRUFY4jqwhyS3HAtR
	 ia+gmglxmVUjVr04Aep+pc4O1apUR/yw2XQg/WycCrSVGXVnDDsgbz/fHr0sBPe0UIl6k
	 ujK3UfNUd/xyph50riUdSZKL3rRwPDWxbMel/4OC8W+R9YzvJ+uweIuzqBaSw09Qu53Tt
	 F2k08gX5G7+BJisHKn9XW7eApA/psshPcY84qtnCUI2zM1tSHBg9kEQoxDOwRPmq7Xp/7
	 IjfPwOJwFPbcihCxnlpIin7dzMGb9AYk3Ogi7iTeeARMzd59Hpstke/ZK3T1qnUZObA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795652562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RvV89/qcgojhFu+RPZnXe+UxBxtm+exO0xuVGHxO5L4=;
	b=FcFyKwIBz4or7tFMohxOOhbB3nsUjagfErE0rogZL/PPu9UxfPEpTe+Pp/vG2t5VBvtF
	 iw71mXv4qkaLEo3KMhnNoZ1qG0w8vgT36T2+BW459b1AHATS0p6BqIyx5m3BipeWqsa99
	 fs9PzeUKoTuAXGlGJKDaQ3qvNYTGAP2VTyCtDh70ANjAq89ySSD0tHUqgYekSMUGJyUNB
	 ygldDP7rQTS5VxGeXDGBo9Q0hnDgEBA0K4vIlBRrxfbVnK3731Vvx3ZsagDKqrvCduwUt
	 K7IGfVtux+awu1m5eZvKenIwFYqmZel4KVBJXGlBVplGLQNIUChPkRfa//PuDG4tTjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=swOLv2Po;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286E9606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 00:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 286E9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=swOLv2Po
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-38692f62b22so7812875eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 16:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795652561; x=1796257361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RvV89/qcgojhFu+RPZnXe+UxBxtm+exO0xuVGHxO5L4=;
        b=swOLv2PoVQfp7z0bWusZ1lYJb1ED6n6l6s0V0iFQrQ+SfblhZBYgl2eVq1PibYWMPq
         wmG5JQg6LaoHuWNcHgw9I2VpccmTMYHzbjAq7So23lsSk5gAHy5XDfmP5AoHW+o1Im12
         PFpv2+aPJytV2sA5DJREEuDBp4RwJ0cjqoj9N0j5LBWI2HEu0eSzXFwK5MsjpBwPDLyo
         U/wugmgwjip8CNjVuGbjfx6oGZaTG3KQnr0Rm5+3SZbVrxgXq5Pd9fqUiiDtYDO/s/rm
         5pAmaaSqcHMUTSGI9HCqBtOTFbfsFoDTqkOL+IlW92G/V3g8vreFdNqN9REiCRSkC2is
         BURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795652561; x=1796257361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RvV89/qcgojhFu+RPZnXe+UxBxtm+exO0xuVGHxO5L4=;
        b=NMgJ6h7qC22uQhpzH7gvVxOH4Ne4Q4pb0FzLMdz43u/hLagTZ6OY6vMJEwBILPC21L
         dcxY07iQOIjWudUl4Z/R0bKAcURiAI0uJ5XLP2LZ5wM+t2cIOmcBVKCsaI8JxepEPhh7
         1MAqBe8T0kUyNOAK1U55iIrfFkBnbYhoe+tNMoLiHmwg/SOv7tKIExb2uk+9nZ5CTMku
         63JKOTLVr0tsUkIhWpoH8nR7AdenKITl+K/tVtyJPoE+OyM0QJNST200ClHxeH+DL+SD
         8M6m1SWx4FCZhttcKrDf6I16vNL8nwMBvo4EW/2eo2aeKG5g7F47KqyAwEdwtJ1pP9a4
         fqfg==
X-Gm-Message-State: APuU4Z+wwojZZyLMMkGIFOGJgzwE8Fahc1PwL+PUl8yTd/YVTFPikgGQ
	tARd19SlnV0XhMbfJmDgm05uADKUckwJ5O9SwyJ1JVQFIO6FB4akGCWuuW+4dopO
X-Gm-Gg: AZFdTZeylFF6zdjaqX1xRTkAttt+hwy7l//gR3vInFGvazATgJzonrgQuhpgOMGpCEn
	5cSrsTb7OwQ54qDq8FwJKAqlX+dSYMzG+2uM2tGfmDHLWNlrmEO2zgFMd2gzGL3OtO1O+fPu76l
	sy7PvOCVA9JKQs+2jFSzq42PGFTC/gEwhfCiheqWAO5nL1mM9V+CLOM6O1mpmajLeRpMJJrDtp6
	mj3N4Bb38Hu0TlvHxs7TFxvhkTk7W0ZRrgAhUn/AIno0kQfLsjny6U/RRAQZ9xJRRRN5cR6a2fA
	nQ9NIcVhJ1axGOjtg/TtGpIrf3hybyz6gsj3llSb07wIWN07zXJZbpYx2GbasVhSTUFM3O9+9s6
	u6uvwhusBpqzko7+gI6+aUIpQ711HBA/CIIbQ/sSEo582F2JQXt9qm+S5P+VrDR1TTy+lVlN94J
	e6WMMYgawBoR1a1wJR98ZD6nYM9vymgVZ2CZE8PZuZlub3smUR8JosgZARRPVuXNumc9dJrEgZ1
	jNUUiT/FckSnFqj893/BnQOjfedYsE05vRYq66AJMSAxMzpE6cE11wjfNyse8pgsWSRVeCIPUqy
	AHb7XlTbhp9gTt0NfibL9D8uPxiqOiii/JMo/9Qe+oA6KdLb/hKRKH2h04gw/6aeOFMe
X-Received: by 2002:a05:7300:f0c2:b0:386:688:7f25 with SMTP id 5a478bee46e88-386068880f5mr19561356eec.18.1795652561111;
        Wed, 25 Nov 2026 16:22:41 -0800 (PST)
Received: from localhost.localdomain (wood.seclab.cs.ucsb.edu. [128.111.49.37])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385646633d0sm101632315eec.3.2026.11.25.16.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 16:22:40 -0800 (PST)
From: Praneeth Balasubramanian <praneethb2002@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Praneeth Balasubramanian <praneeth@ucsb.edu>,
	stable@vger.kernel.org
Subject: [PATCH v2] RDMA/srp: Reserve send queue and CQ space for ib_drain_qp()
Date: Wed, 25 Nov 2026 16:22:27 -0800
Message-Id: <20261126002227.3598226-1-praneethb2002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <70bd9162-e9f9-4580-bfb5-cc29107a4126@acm.org>
References: <70bd9162-e9f9-4580-bfb5-cc29107a4126@acm.org>
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

From: Praneeth Balasubramanian <praneeth@ucsb.edu>

srp_destroy_qp() calls ib_drain_qp(), which also drains the send queue.
ib_drain_sq() requires the caller to "ensure there is room in the CQ and
SQ for the drain work request and completion".

SRP reserves that room on the receive side, where the queue and CQ have
queue_size + 1 entries. Commit 9294000d6d89 ("IB/srp: Drain the send
queue before destroying a QP") switched from ib_drain_rq() to
ib_drain_qp() but did not grow the send side. The send queue and send
CQ hold exactly m * queue_size entries, which is the most work requests
SRP can have outstanding. If the channel is torn down while the send
queue is full, for example during error handling after a target stops
responding, posting the drain work request can fail with "failed to
drain send queue", or its completion can find the CQ full. The QP is
then destroyed without the guarantee that ib_drain_qp() is meant to
provide.

Add one entry to the send queue and the send CQ, as nvme-rdma and iser
already do.

The missing reservation was found with an LLM-based tool that checks
callers against the rules stated in kernel comments.

Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying a QP")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>
---

Notes:
    v2:
    - No code change.
    - The author now matches the Signed-off-by. v1 went out with the gmail
      address as the From: header.
    - Added Bart's Reviewed-by and Cc: stable.
    
    This was found by an LLM-based static analysis (GPT-5.6) that checks
    kernel code against the rules stated in its comments, as part of research
    at UCSB SecLab. The patch and changelog were drafted with Claude Opus 5.5.
    I reviewed the patch and take responsibility for it.
    
    Testing: builds without new warnings with W=1 (x86_64). Not
    runtime-tested. I do not have an SRP target setup, and I have not
    observed the drain failure myself. The change only follows the
    ib_drain_sq() contract and matches the receive side and nvme-rdma.
    
    The patch applies to mainline 9ba46df34488 and to next-20261116.

 drivers/infiniband/ulp/srp/ib_srp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 955f36efeebd3..2cd0b728424e2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -546,7 +546,8 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 		goto err;
 	}
 
-	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size,
+	/* m * queue_size + 1 for ib_drain_sq() */
+	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size + 1,
 				ch->comp_vector, IB_POLL_DIRECT);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
@@ -554,7 +555,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = m * target->queue_size;
+	init_attr->cap.max_send_wr     = m * target->queue_size + 1;
 	init_attr->cap.max_recv_wr     = target->queue_size + 1;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = min(attr->max_send_sge, SRP_MAX_SGE);
-- 
2.25.1

