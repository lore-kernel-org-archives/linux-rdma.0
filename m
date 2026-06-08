Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DED331A7E;
	Mon,  8 Jun 2026 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780931885; cv=none; b=K830kltDBGL/9k1bxNoTWLBg2LfHCcT6X0Qnd7CjBtiuevlsHlG0XHxfh0VT4qXOrGgLlyQs5qBXzpLL/gt8DMrjnUfZcxN6rGEOVsVd2N6+LdDNC7yhRGi2P/4Wpjl5wEitFBk5c05aNBR5cMWzPP2+2ZLSY97ehYvlllT1ej0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780931885; c=relaxed/simple;
	bh=K9p27pNdwqddgm00diVh8tCYJvpYfRuwYufY8MF0TRs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eEmzaLpYxQu8ipw4PElShk2tmFNsnI9eyOHOqcX//Uyuih+k6iwSdXxrsO4kY+htw36slcdguBc4NWTQnJ2WUDMdJLL2k18lkWzbr/7SUYb5lggPmAArVW2nQ2e+RfxLzRSTbY+o4UvertTdw9poYxtVw1Q3ErVaTpXCzEYgTzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAD3mtMn3SZqqUDnAA--.3777S2;
	Mon, 08 Jun 2026 23:17:59 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: fw@strlen.de,
	kees@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/iwpm: fix kref bypass in iwpm_add_mapping() error path
Date: Mon,  8 Jun 2026 15:17:51 +0000
Message-Id: <20260608151751.151532-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAD3mtMn3SZqqUDnAA--.3777S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtF4DCr1ftr47uFWkAFy8Grg_yoW8Jr4rpr
	W5Aa12kr15Wa1Sya18WF90vF1xX397Xa9rGa4UKw17ArnxXws2y3Z8Ca4UXFs7Ar1kKrsx
	WrsrCF4qgFy2qF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwsMA2om2m4IIAAAsT

iwpm_get_nlmsg_request() returns with kref_init() + kref_get()
(refcount=2). iwpm_add_mapping() calls iwpm_free_nlmsg_request()
directly on the error path instead of using kref_put(), bypassing
the kref mechanism and freeing the object with a non-zero refcount.

Replace the direct iwpm_free_nlmsg_request() call with
kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request).

Cc: stable@vger.kernel.org
Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/iwpm_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 672b0c33a6de..854c974d6586 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -207,7 +207,7 @@ int iwpm_add_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 add_mapping_error_nowarn:
 	dev_kfree_skb(skb);
 	if (nlmsg_request)
-		iwpm_free_nlmsg_request(&nlmsg_request->kref);
+		kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);
 	return ret;
 }
 
-- 
2.34.1

