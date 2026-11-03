Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699197;
	b=KMfflabj7LsJebc5xJGFipssalXxU0wcVdUbgDidY+uzPmqH93rcLVuiwZlguxIkuvii
	 Q8qqhheodAevEtCL5nnxnVUcA+vK05Yq+yjcEkE5XAP6swrdt1ntO1ypuV/TDN3EmxlKy
	 aKUazCJlGEhjk2qNMgKU3/1v2HUAlF0X6LHXhXlKPkb4ZyTJr/BedtiLnbVpyfA88SpRH
	 q3vj1QX7XDaQeNd7o9xhIyFV+PnVTXi3Pbe6TyyiL6D9bqMIU+cgJbAIolkDHijZADD/0
	 o38EXRdddnCT3rJu4K+QZGbrG90SsKwyvO9jdG9vABdHJPu+y6O+24yhZDGq6nOPZZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699197;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=FDCgLLohogj15TP7M5cXtpTUp765Lir5+ELlDyW+FDQ=;
	b=ajdxb8CABW/bSUX7dkBVMLsItryr71gaxwMaPLjSrhiLYCV0PvNZJq6P3RD7LZbzDw5J
	 H0iDeQMj7FSPudPQb6tnt5ZlRI2pJseRs+ant8qqUORpmzp+0wbh7bOPnxYm3lbf2Zltb
	 oIMKEGGYd6lsLOK74cGgPWmhB8buPCP/PtFxfCl9YgC81OFS+KeAXwCrN0VPlurDhtkzo
	 J3lYDqgMvnN1SfIIBYy23c13lmxCP+OXLt5IMuaHMiC/1bVourk6LAC9F4FeUXmSIYIm3
	 IMRsRxszyrsJSU306kAXawitbkWbz8+6jtpE0NTMvozSeX+LVmg5nHbxK2E5OZv1h6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4AC606D80F;
	Tue,  3 Nov 2026 09:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA4AC606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAA3Q5R5relqBVA7AA--.4976S2;
	Tue, 03 Nov 2026 17:46:33 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH RESEND] RDMA/cxgb4: Balance the extra skb reference on rx_pkt() error paths
Date: Tue,  3 Nov 2026 09:46:42 +0000
Message-Id: <20261103094642.1289811-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowAA3Q5R5relqBVA7AA--.4976S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WrW8Kry8Zw4Utw4fXw15CFg_yoW8Zw1fpa
	15Ca4qkFZ8CF4jk3W8Jw42vrW2ywn2y3s5uFyvy3sIvwsxZry7Jrn2gFWIgF4DCFZ5ur12
	vr4Yy3ykGrZrZrJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWx
	JVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	jU-B_UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgQAA2rpnIRRqQAAsi

rx_pkt() takes an extra reference on the skb with skb_get() so that the
pointer stored in req->cookie stays valid after the handler returns.
process_work() frees the skb once when the handler returns 0, and the
firmware completion path releases the extra reference through that
cookie.

If the route, neighbour or L2 table lookup fails, rx_pkt() returns
without calling send_fw_pass_open_req(), so the extra reference is never
released and the skb is leaked.

Move skb_get() down to just before send_fw_pass_open_req(), where the
reference is actually handed to the firmware.  The early error paths now
leave only the reference owned by process_work(), which releases it when
the handler returns.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a6f520f49d59..2cdc4744a24a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4134,7 +4134,6 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	tcph = (struct tcphdr *)(iph + 1);
 	skb_set_network_header(skb, (void *)iph - (void *)rss);
 	skb_set_transport_header(skb, (void *)tcph - (void *)rss);
-	skb_get(skb);
 
 	pr_debug("lip 0x%x lport %u pip 0x%x pport %u tos %d\n",
 		 ntohl(iph->daddr), ntohs(tcph->dest), ntohl(iph->saddr),
@@ -4193,6 +4192,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	 * in cpl and pass it through the regular cpl_pass_accept_req path.
 	 */
 	build_cpl_pass_accept_req(skb, stid, iph->tos);
+	skb_get(skb);
 	send_fw_pass_open_req(dev, skb, iph->daddr, tcph->dest, iph->saddr,
 			      tcph->source, ntohl(tcph->seq), filter, window,
 			      rss_qid, pi->port_id);
-- 
2.34.1

