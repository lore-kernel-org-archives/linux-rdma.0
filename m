Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693950;
	b=1gJoqaI9qlVsSFxVbUIRuOIysOOaZ5REa9FjBk6c5aQOvFfrKBYDXvPn1+l044jGoH2H
	 JoTmhme73pevoaOmwyr1NbRkZidQTvpA2eMYPyJq1imAAf5+4U7DawAqiCaJG6esxFrNZ
	 SWK6Wwx3A/9cIqyqFlSX0tD0CdcVXWkXQEvdtXo8V1774NYxWQRmrcUs0qUUyNyNwHobh
	 RBPBhVO1IrTXxMrzWmItS8pHJhUampSE1P09rolKcfDiluFOm7CUEsmfg/mtQ8NhydFBt
	 pEixxtB3yPBun/JgNfEqHt5bM3xjjuY4crBG1v70Q81Yg4gcVrv0WNiSgNL7B+IQhSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693950;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=0eH5aVQYUtNQwxUKjm8Xd4TfFeiPp0mMM52IQ05Kxrc=;
	b=UW3VjuSxcivsZVqkHva8cQZb8T+NbWIiboMXENg7v/JnLFCKQKnBIZtiblyWA1GHrvYI
	 VGzpvOitTHTHfl5J4TcpX6j6iA3Lm5ic12O/fxwNQ/ncEK6jcMGitSx+AHV4HY0bTYyn5
	 xY8ue9sguTz1MV/TrwDiUzvPl1LtPRIZ1Ky46GVgcMo1IFSYpNyTULX453JKXqYdeakcK
	 7Vu2YXOu/Y3JerPS+mThk6iGa76uiEwwFpRPxfbSqNjdftm65EPYOLwF7xC4xk7ayx6tW
	 Ec2ZMCCY13GBvJzgu6ztOPMztE04kKXhdIl26r9Xm75n87P9SW7b93VCJwxn1Lvp7AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E8B606A329;
	Tue,  3 Nov 2026 08:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8E8B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn8JH6mOlq8lk6AA--.1314S2;
	Tue, 03 Nov 2026 16:19:06 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/hfi1: Free the trap send buffer when no address handle is available
Date: Tue,  3 Nov 2026 08:19:15 +0000
Message-Id: <20261103081915.1147987-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowADn8JH6mOlq8lk6AA--.1314S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFW5Jw1kKFyDtF1rGF4rKrg_yoW8GrWkpF
	Wqga4YkryDXF4aqa1UJw1DAFWFk3Z3t3yUurWvk34Du3Z8Zry7tr1Ska40qrW8Jrn7ur4a
	vrs8XF48ur1kCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUMGQ
	DUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRIAA2rpWfXuFAAAsN

send_trap() allocates a MAD send buffer before checking the subnet
manager address handle. If creating that handle fails, or if the subnet
manager LID is permissive, it unlocks and returns without submitting or
freeing the buffer. No send completion can release an unsubmitted MAD.

Free the send buffer after releasing the lock on both early returns,
matching the other failures after ib_create_send_mad().

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/hfi1/mad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 585f1d99b91b..dbc2dd55689e 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -335,12 +335,14 @@ static void send_trap(struct hfi1_ibport *ibp, struct trap_node *trap)
 			ah = hfi1_create_qp0_ah(ibp, ibp->rvp.sm_lid);
 			if (IS_ERR(ah)) {
 				spin_unlock_irqrestore(&ibp->rvp.lock, flags);
+				ib_free_send_mad(send_buf);
 				return;
 			}
 			send_buf->ah = ah;
 			ibp->rvp.sm_ah = ibah_to_rvtah(ah);
 		} else {
 			spin_unlock_irqrestore(&ibp->rvp.lock, flags);
+			ib_free_send_mad(send_buf);
 			return;
 		}
 	} else {
-- 
2.34.1

