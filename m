Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793760821;
	b=nX78si1jzmNks5dMu3DA7vqYiQ2jOdKDSjgrAg4Jxm0YrvKkbTRzr17Sg9pht360wGy+
	 EYKmue33rFbdm/FI9g4IrbDchauvgLRHBv/1tgI6uZRExXhIUKjDTmL7hWdOv/Rbvgwob
	 7ZpSP9VRTYYirYIPITGwx3Rn0FIjN89RODuYmdejIZ/8BVoHKp72nQPUaHQkeMVFmoBjm
	 Kjsvp8HHIIOV0oPpWczgWXZZoMXKAUeElQM7ERIQv9APZBsmI65XhJ9QFPiiIFDzvLk8F
	 xJHp7x82Y2letCAcFcmTzWMuKo/mVe0VtcD5UCjd6ZO8cgyQ8eyJ/XFdUnlTdquIY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793760821;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=3q3/3VXGtE17A4A0Frs9ELu63c3v5OsSDUf5evXZ3vk=;
	b=IScuj+raS9zfplGp7wh9Opu90PQre29Y0RHIVLwvEKWUXFkoLcTwV5Nz1wRBG0eE8l0X
	 GShDCBJnTJEB+PaHobAvLbagiCDYI8YnF7EiynndV5r2XqF7otVUfbCNLRm8cDKnJjZEt
	 A2D4rZ/tAyFy28R+vX5MFEN7+H8h6en1UurWvw0VLZMDDxWIetjQVXNEn3ganfMF0qYv3
	 3vq1qdUawSBWjopidV2w3n5QCE0oyWcrMROgChX9wCINsxPTVnWj39wgUdkFIK9+0N/q2
	 Kty54igt7R5hFNRwNGrVztyUcur/lsqZvc1Z0kniM22cVJP8X2R4BRfUkIIXCTe7qbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC3D606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 02:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DC3D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADnEPsynupqHOU+AA--.9810S2;
	Wed, 04 Nov 2026 10:53:38 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/irdma: fix double free of close_entry in TIME_WAIT teardown
Date: Wed,  4 Nov 2026 02:53:47 +0000
Message-Id: <20261104025347.1527584-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:qwCowADnEPsynupqHOU+AA--.9810S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF15JF45GFy8XrWfGrWxWFg_yoW8XFyrpF
	WUGryYkrWkJFW7Ca1Ik34DAFyqv3Z3G3yq9Fyqk3Z3Jr13Wr1xJw1Du3s7XrZ8AFyIgr4Y
	qF15tF95Ca13ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvEb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1l42xK82IY
	c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnIWI
	evJa73UjIFyTuYvjxUHqXdDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMBA2rqY-ninQAAs9

irdma_handle_close_entry() drops the cm_node reference held by the close
timer before releasing cm_node->close_entry.  If that put is the last
one, irdma_rem_ref_cm_node() runs irdma_destroy_connection(), which
still sees a non-NULL close_entry and calls
irdma_handle_close_entry(cm_node, 0).  That nested call frees the
close_entry and clears the pointer, and the outer call then frees the
same object once more.

Free the close_entry and clear cm_node->close_entry before dropping the
reference, so that a release triggered from that put observes a clean
cm_node.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/irdma/cm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 91c0e7298283..d8b8939d6abd 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1243,13 +1243,15 @@ static void irdma_handle_close_entry(struct irdma_cm_node *cm_node,
 		} else {
 			spin_unlock_irqrestore(&iwqp->lock, flags);
 		}
-	} else if (rem_node) {
-		/* TIME_WAIT state */
-		irdma_rem_ref_cm_node(cm_node);
 	}
 
 	kfree(close_entry);
 	cm_node->close_entry = NULL;
+
+	if (!iwqp && rem_node) {
+		/* TIME_WAIT state */
+		irdma_rem_ref_cm_node(cm_node);
+	}
 }
 
 /**
-- 
2.34.1

