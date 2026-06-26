Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B93372058;
	Fri, 26 Jun 2026 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782486322; cv=none; b=vB0RPJgXR0qHbWRBh+QDX7zsZRVyrQY4ALutPRip6LpUdKI5MtJXBzit+z00UyGcsNUQwjMFefkLU+X0+3cf3s+5Ow+A/Y6F1HkdsZzF7xDTbHGGDLyfFMmNyQay7PM8g9xyVvRdBVyOqLqfpsb44RfE5sDZu5hNbNcaOB7evxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782486322; c=relaxed/simple;
	bh=cfg60twu84mX2v3dZUQeQgTuXAJSzfa0guMyntcP4V0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N/zxcb7Nj4jGBlTMr9gOVy0Bta7ElREjfkkqf8c6cR/+4YBXBF+Q0vAshfV7Wtrx8NQLxBGXv3EVYfDM3Ac8FCh00+agFHwhiCGUmyAqgKjrMV1suGbXhBqPi9bcyienPG+Ai96Z+1qm4i6R84A2apg161H6MIU776+zc3CXy+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.66])
	by APP-01 (Coremail) with SMTP id qwCowAAnzNQnlT5qeGZrAw--.16679S2;
	Fri, 26 Jun 2026 23:05:12 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] fix: infiniband/rxe: check_rkey: fix refcount underflow due to unchecked   rxe_get return value
Date: Fri, 26 Jun 2026 23:05:11 +0800
Message-Id: <20260626150511.50084-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnzNQnlT5qeGZrAw--.16679S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4fJF15Xry5XFyrWry8Zrb_yoW8JF43pr
	WfK34Ykr1fXay7ZanFyr1UXFZ0ka4DtFyDKa9293srZr15Gr47WFnI9FW3Wr4kAFyrA3ya
	qF1jyan5Ga1rGFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU2Q6
	JUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMKA2o+iCglxgAAsE

rxe_get is a conditional get (kref_get_unless_zero) that returns 0 when
  the object's refcount is already zero. In check_rkey, the return value of
  rxe_get(mr) is ignored. If rxe_get fails (returns 0), the code continues
  to use mr without a valid reference, and error paths will call
  rxe_put(mr) on an unheld reference, causing a refcount underflow.

Check the return value of rxe_get and bail out with an error when it fails.

Cc: stable@vger.kernel.org
Fixes: 290c4a902b79 ("RDMA/rxe: Fix \"Replace mr by rkey in responder resources\"")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 9cb2f6fbf2dd..0c3f3930b494 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -514,7 +514,12 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 		if (mw->access & IB_ZERO_BASED)
 			qp->resp.offset = mw->addr;
 
-		rxe_get(mr);
+		if (!rxe_get(mr)) {
+			rxe_put(mw);
+			mw = NULL;
+			state = get_rkey_violation_state(pkt);
+			goto err;
+		}
 		rxe_put(mw);
 		mw = NULL;
 	} else {
-- 
2.39.5 (Apple Git-154)

