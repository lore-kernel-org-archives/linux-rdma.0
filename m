Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A584D5962;
	Wed, 16 Sep 2026 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789584397; cv=none; b=JLme81tE1sJqLoCP8OIxGQbvZm5gCtHAb7W4bdBJJEjGylrDEtV1P7xql9VXB90cdyEgFqHji+0eDiNhNtl+WC2G/km563efhqHDVLE0nTfBC7ZmTnyw18TF5SnR99SxrIv8nh1XEDsEyCmR8ANhO0Rj1Mx5Oe3Z2IMfjTKJja8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789584397; c=relaxed/simple;
	bh=gEriyIzE9YEWtO0fRiJPfGsXkBYJM1O/hmcnQlcfvlM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Imnnxg+2N3lc5HdqeGx47uklM1OlHEkIriuqvtt4qnAl42KiXOsSGtmRrwYufEjBj8sYOTSI9RLBLEfBpr1FT22bq9fVdrXMBe5lkm/iySCWZehIALeBJtwXoXj/CQGrpf2G6Zyn+xW9BA7pbsOC/a/3/voB8EABkuyhULGNQ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABHsTv+46pqt85vCA--.24127S2;
	Thu, 17 Sep 2026 02:46:22 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jgg@ziepe.ca
Cc: leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rolandd@cisco.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/core: Fix member use-after-free in process_group_error()
Date: Wed, 16 Sep 2026 18:45:55 +0000
Message-Id: <20260916184555.2093238-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHsTv+46pqt85vCA--.24127S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4kZw4kAr15Xr1xWw4rKrg_yoW8Jw1Dpw
	47Wa4UKF18XFs2yan7A39FvFWIq397t3s09FWDKwn5XwnxJ34jyw1Ykw1UWF98ArykAw42
	qrn8ArWUuFWUuaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWx
	JVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_GcJvcSsGvfC2KfnxnUUI43ZEXa7VU1
	1SoJUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgIMA2qqok+MnwAAs1

If the callback on the error path returns non-zero after a concurrent
ib_sa_free_multicast() already dropped the initial member reference,
dropping our temporary reference completes the waiter, which then frees
the member before ib_sa_free_multicast() dereferences it again.

Only free the multicast member when our reference decrement was not
the last one; otherwise the concurrent free is already in flight.

Fixes: faec2f7b96b5 ("IB/sa: Track multicast join/leave requests")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/multicast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index bea7df3dd8f3..aa6fdac5fcde 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -409,8 +409,9 @@ static void process_group_error(struct mcast_group *group)
 
 		ret = member->multicast.callback(-ENETRESET,
 						 &member->multicast);
-		deref_member(member);
-		if (ret)
+		if (refcount_dec_and_test(&member->refcount))
+			complete(&member->comp);
+		else if (ret)
 			ib_sa_free_multicast(&member->multicast);
 		spin_lock_irq(&group->lock);
 	}
-- 
2.34.1

