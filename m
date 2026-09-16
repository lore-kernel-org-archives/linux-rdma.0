Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5A450EC13;
	Wed, 16 Sep 2026 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789584122; cv=none; b=MZpKDTaZuRfLa4mnazGdTmzSFTeYXK3BZPdVFUhOEpIbnaKpxDoszvLjezYr3EWItV908XCxkPSB4AvkcHk3t4HU1Sf41QxdSlYggCH5zk3W88kc3fM+k5rbLAO+XVDqZlpLIAfQMJCUHuNbOChfFaKFilbYqsCoXUush3uxDsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789584122; c=relaxed/simple;
	bh=6Nv1oz96v+e+9AfJZ5HQQYBaNX8xC9MmKUt1Q5W1nyY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n4dzlFP0A7pierKZFdjeOVUGTRWxnnv23iNfnGqBEyUAWusAgCwKTOC48esCKHSv3T3UknM1SxBFUjOCDWNRIAJiaiOuSKvVLs4n3oPgvm2dLkirgHxcDcmt+Wls2rj9kwUElc7/KpdpFdrkN4Cum6fXERIfwWu3imYT6UueBvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADH+ELh4qpq8rtvCA--.24533S2;
	Thu, 17 Sep 2026 02:41:37 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: bernard.metzler@linux.dev
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 6/7] RDMA/siw: Fix new_cep use-after-free in siw_accept_newconn()
Date: Wed, 16 Sep 2026 18:41:09 +0000
Message-Id: <20260916184109.2092928-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADH+ELh4qpq8rtvCA--.24533S2
X-Coremail-Antispam: 1UD129KBjvJXoWrZF1UCw43Kw1rZry5GF13CFg_yoW8Jryrpr
	43Xw1jkr4DJa1Iva1rtFyDZFyYyws3K347W3sxt3WDZrn3ZrW5XwnYgrW8WF1kAFWkXa1j
	vr4jkFZYgF18Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdYxBIdaVFxhVjvjDU0xZFpf9x0J
	UJuc_UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRIMA2qqozWJrQAAsm

On the error path the listening endpoint reference of new_cep is
dropped before the accepted socket is disassociated.  When only the
socket's reference remains, siw_socket_disassoc() drops that last
reference and frees the endpoint, leaving the subsequent
'new_cep->sock = NULL' writing into freed memory.

Tear the accepted socket down first and put the endpoint last.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/sw/siw/siw_cm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index f7ac81c0f267..1b93963cb191 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1044,14 +1044,16 @@ static void siw_accept_newconn(struct siw_cep *cep)
 	return;
 
 error:
-	if (new_cep)
-		siw_cep_put(new_cep);
-
 	if (new_s) {
 		siw_socket_disassoc(new_s);
 		sock_release(new_s);
-		new_cep->sock = NULL;
+		if (new_cep)
+			new_cep->sock = NULL;
 	}
+
+	if (new_cep)
+		siw_cep_put(new_cep);
+
 	siw_dbg_cep(cep, "error %d\n", rv);
 }
 
-- 
2.34.1

