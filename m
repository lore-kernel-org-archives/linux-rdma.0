Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693458;
	b=SyH7WShOiG+aeW9gSWtmJOcv/aFNzeauyfpevkV+2Ru3kZpf083jXijQCUw8ot6+6MA0
	 vQyftokaE7ileUrIRu26MdjvVEQbe6LVJ0832sMkLyKpZ3YJTxubTAMJKddMzd7/T2ERs
	 wMl+f8C7wt7htm11P3MmI3lQBrinTglVwJ/ZFK6TvYXzcM3rIdoOxXMuT2BcryJQT+JiI
	 Y0h9ApcJ208Xycu6znnReRT548Jj09VP2CJjITgctZZh15bAT20kL0rUsIJm+7D99Ex89
	 SAGIwXNQExPDUi8K0TfV3sHVglRPB7rvHSwhoyVMIPTkwTBG7fu261jokSmQDl68Saw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693458;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=HUZpK24o84wPwNtUK+OHNr/ldBfN/PVneAO/2TSEglk=;
	b=IJk5T7UGeF/Df9XWqnYPJDexpjKsGIQMH8gAiA3o7nJJ1LClzcA9TqHZIo6b9pfjkd2D
	 vDBCDGRxoQxIBsx3guduMWPe1xAWG246gaqqiNn+OUREmoTQyt68HhFCsy48EqTgJLWCQ
	 /jkYTF35+4JgGPhWmoSQeSQCPqByLXPvwd4Nisz6FW8l2S9NXnHIGxM4uAGWYwvrwoGY8
	 edVscJZIzBS6qDG/Ie8ub/ADy2FUdm6jZUPvqk8QVCe7D5sj4oTsxuS/ONsHWgic8zm/E
	 TZBriZiy9KggJpViegLupG/rm6rU9366x37ZAxJLX2rtxyh7X7zkhVwUfof6of/pNTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4666606A33A;
	Tue,  3 Nov 2026 08:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4666606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHE5QOl+lqDUQ6AA--.1272S2;
	Tue, 03 Nov 2026 16:10:54 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/cm: Release the GID attribute even if its port has no CM support
Date: Tue,  3 Nov 2026 08:11:03 +0000
Message-Id: <20261103081103.1134475-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowAAHE5QOl+lqDUQ6AA--.1272S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyrZr4fZFy8KrW8Wr4fuFg_yoW8Grykpa
	yDJ34YkFy5XF47Kw48Ja1UZa45G3s7Ja42gFykW3s29rn8X3W2vFyFk3WI9F98Xr97X3y7
	Xr12yF1kWrykXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUXID
	7UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRUAA2rpWfXlIgAAs3

When no source GID attribute is supplied, get_cm_port_from_path() looks
one up with rdma_find_gid(). A successful lookup takes a reference even
if the matching port has no CM port object. cm_add_one() skips ports
without IB CM support, so cm_dev->port[] can contain NULL entries.

The current cleanup tests port instead of the lookup result, leaking the
GID attribute reference when a matching non-CM port is found. Test whether
the attribute is valid before releasing it. Keep the put outside the
CM device lock and skip it for a failed lookup or an empty device list.

Fixes: 398391071f25 ("IB/cm: Replace members of sa_path_rec with 'struct sgid_attr *'")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1a2c2775b14d..0d95cb27ad17 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -517,7 +517,7 @@ get_cm_port_from_path(struct sa_path_rec *path, const struct ib_gid_attr *attr)
 			}
 		}
 		read_unlock_irqrestore(&cm.device_lock, flags);
-		if (port)
+		if (!IS_ERR_OR_NULL(attr))
 			rdma_put_gid_attr(attr);
 	}
 	return port;
-- 
2.34.1

