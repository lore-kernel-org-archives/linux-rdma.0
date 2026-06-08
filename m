Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FCC3CE4AC;
	Mon,  8 Jun 2026 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780933340; cv=none; b=F2paAZX0UkEp3xVLWLNZ60t2piV+DfjlnIFoWWFcKbx2RYNJrCobzsEQ/oaMrm1d4GdmRiZuee2jJ68TQjV5PFrPag14hJboQlj1zA919CHGgogmYsLSGG+jB4oIOCPHsJy1/Vddw7W2vDZfxHFa8ZkXNd119iX3c9r4UGLb7iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780933340; c=relaxed/simple;
	bh=62Njt5KzYm3OVzRtskaHyGKueMl1GRrNXaps6gJzcqs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IXQzvlgKyOm8WSKaY3gvMbW6NjOaSxNm0HOtP68f+XuQpb5SOnJOBM5/Xp3XGH4TUgIBFbwVzo6hCcWeO9xJHQySEuyny8eFFwjt5jpd2g59w0mnq/ahSP55wDVjbNS5oIl/1EaiOBBNRNbvcRL9BjrztkscVAYVtbQXvklawPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABnCtPX4iZqYLXnAA--.15591S2;
	Mon, 08 Jun 2026 23:42:16 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: fw@strlen.de,
	kees@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/iwpm: fix kref bypass in iwpm_add_and_query_mapping() error path
Date: Mon,  8 Jun 2026 15:42:08 +0000
Message-Id: <20260608154208.158175-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABnCtPX4iZqYLXnAA--.15591S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF48KF4rAw47AFW7ZrW7XFb_yoW8Jw15pr
	45Aay2kr15Wa1fAa18uF9YvF18X397A3srGa4UKw17JrnIqws2y3WDCa4jvFsxAr1kGFsx
	Xrs7CF4qgF9ruF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUowIDDU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgoMA2om2bMXSgABs5

iwpm_get_nlmsg_request() returns with kref_init() + kref_get()
(refcount=2). iwpm_add_and_query_mapping() calls
iwpm_free_nlmsg_request() directly on the error path instead of
using kref_put(), freeing the object while the refcount is still
non-zero. The success path correctly uses kref_put() via
iwpm_wait_complete_req().

Replace the direct iwpm_free_nlmsg_request() call with
kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request).

Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/iwpm_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 854c974d6586..bac3d1f321ab 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -296,7 +296,7 @@ int iwpm_add_and_query_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 query_mapping_error_nowarn:
 	dev_kfree_skb(skb);
 	if (nlmsg_request)
-		iwpm_free_nlmsg_request(&nlmsg_request->kref);
+		kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	return ret;
 }
 
-- 
2.34.1

