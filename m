Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E630C37C
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785620260; cv=none; b=MT/m14JN1TpUMW2ptxTOOGMrf50x0UCCazQYzZSQe6Jirx3dE9JqCZKc0SpE3I496YH2ImJpFKUgNuClaH6wCK+RmcfKKfuZBVgFY74S++VB9fE0+fQIxa0lNsVM6RsjEZgd7pIuVqPyy8cr8N0VFmiTG1SUpClXMEDEWtUcmZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785620260; c=relaxed/simple;
	bh=PdcrG7GkMxlOZ4eaudUMpHVF5woUKkG1xAqvC1xgXnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L9OlsoQjX+eLe0gzUnH3XJW8BjSX8Y4H/cYRngmtbL51/AxvfId/Vj4I4ZWWkjdazN/tPCEhNDfGMbY2Uwyof674fpKl+csHp2sLeJSyxi21veTzztuVt9Tbehw2g/eO2UqHO+266if32kHpGWP3zGoiCWMyYswMWm56P1xGlFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BigswsHj; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BigswsHj"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-930f4e5eed1so123838385a.2
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785620258; x=1786225058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G6Et0NhWmlhqF6H6Esm0lrRD3CSb6Cqp9D32iHCNdQ4=;
        b=BigswsHjpvhURs2nEr5x3PDY7BtwS+iHViS80ZctZEbwla7nmXh7wK0yfcC60pJ8EP
         Vw8/UQOsncG5We2H4lF0l1mEY2lDV5svCTCj7aJGHYmWdwQ/AFbE0MIBq7HkpWXijzYV
         Kj5k1ttu4EoAwp1nuRsxYhis+ewC3uaXSwNVAw3b+/VKPSnxEI+4VYtQ+9nRQUIQa26u
         dIKmV+BilrVMbnHpK+LKqMF1Babz0D8zz+XMdZyh5JJZh/hNcDE4RFZgwIF8IIF1nJN/
         +LxbsuiDfPHI5JqwAshctdtkJkMOhCGPu/r9ex+7u8U1UdGWZY5UARFSAGsfWNxoba5c
         O5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785620258; x=1786225058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G6Et0NhWmlhqF6H6Esm0lrRD3CSb6Cqp9D32iHCNdQ4=;
        b=QD0FmqTi0iBIhf7jAwIRlDE6X0oxhi30PhTx51EZLYi6Gfn7SMCG4tzWYGuNUtuop2
         KTcwUT+rLpQ7/zixTLbes14Lt+4PEdiQpgx5wgW2fnaF9QmIKAmNPe6vVM58UMyzoWLy
         +V0ZVPZkUYuCND8JQhqBXEQwPhzLtTKvdRc8HgcezKy4SGczqPzXg7uoyh/Y5gJ481+j
         Js0fwhjA2dZzxzF/OjAvZ9wU4kYM3AVRy1ttrlEHa8XIPnFUehul/ID8bsLQAsOIumni
         tsPJKioHumGvcy/0ll6dfLsvaO/Kk3i5tB/8xfTT3aSSFr4hQA6krnmEVtOmxQwIDfqz
         CGWQ==
X-Gm-Message-State: AOJu0Ywqntfh+Yf6SLKqs5H/AnFKOmhkOV2ljKGstLTVvKiOAjmmVKSU
	flX+h+ufdneEisdNhuOA7Nw++djKmDlyqOx78kvn5g5kgSR6jrR6zpC1
X-Gm-Gg: AR+sD11IWLuqTWDoa52lTalgMC1O3nQ1uFk4Lwc/jpix89Qja0p6asZgzFL0h9at1N+
	7uqJXz6B0smzKv0sBo4NU+SHuRzoo6krT+YGqgcNvVUyq+UOe9rIQV/s976+zYHA18E4snvIdB6
	O/KARG5/YBS2WRNvZ+96xNr9bnQ4gEkOncF1XwwQX4wwu1Fka3Irw2ZH1L1eE/QVTvvmQ1vBazX
	CIoPsKY6oae0WLg43t708l18dj9zJ85IyvcBCvl+XESShGJYD9zRgdSdugBnjLUP5FQ0NPNUwbs
	jCEHwU0UJcoSC7OLKavKjjrImVPrqTAYHi7HPTOglYdGJPjUdiNb6CSliRIxYak0pmTcw6gtAKS
	6jZpNnzRXJbrpilOGTU77PWuCsge9ekEl3QAYyUmTEe+3cU5Tl7Ug49lpLAY8v+7ZlLDbUkLfd8
	GFrOrcThWxvO6GjvEdMlNBTtYjEvR9pYh0d+5ujl4CMQa4/pHF1/J6VK3M0cAvfu7djLqu4+4cC
	N8CKwDnwbuj+4tGyA==
X-Received: by 2002:a05:622a:22a2:b0:519:e020:6087 with SMTP id d75a77b69052e-52b5679fb54mr98575971cf.11.1785620258384;
        Sat, 01 Aug 2026 14:37:38 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435b6adesm40376256d6.24.2026.08.01.14.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 14:37:38 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: bernard.metzler@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/siw: Fix use-after-free in siw_accept()
Date: Sat,  1 Aug 2026 17:36:32 -0400
Message-ID: <20260801213632.1086548-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

siw_accept() looks up the QP supplied by userspace. If that QP is
already in RTS, the function jumps to error cleanup before associating
the incoming CEP with it.

The cleanup tests whether qp->cep is non-NULL and assumes the current
call installed the association. However, qp->cep can point to the CEP
of an existing connection. The cleanup then drops a reference from the
incoming cep, not qp->cep. Once the incoming endpoint loses its
remaining references, this can free it before the subsequent cep->qp
store, causing a use-after-free. It also clears the existing QP
association.

Only release the association reference when qp->cep is the incoming
CEP. This preserves an existing association and avoids accessing the
freed endpoint.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 87c79527ac09..0245b25e7271 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1751,7 +1751,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->state = SIW_EPSTATE_CLOSED;
 
 	siw_free_cm_id(cep);
-	if (qp->cep) {
+	if (qp->cep == cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
 	}
-- 
2.43.0

