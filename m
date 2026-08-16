Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F33305678
	for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786847196; cv=none; b=IUwCgn34e7szDTuzO7deI2eX8E2e55pCa+pXoTLymisyd3D7Q2b+I1vrXo29khG+Ael4R+T1xDNehNciZ8yJXldwwxomLDL8+58w7L2deT6LQv0TnK4iVy3+utX9UNtZ5yt+C1+bJTII+N+jEpd5Pd2PVxNboQLJE1joLonYk5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786847196; c=relaxed/simple;
	bh=pis0kTjcjwtXLktyJ0SMWtk1i2ffUG1YYWwDE5g8zV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZhLJQu+C+dhxNMLLlDKTwZcHomcc1ksFYQosiPVtksqSCP6R9jFwkJW3M6Si1Kvp168X6JFpjXroCjscygP/r8Dnu9uKFTa9FYp7RhU1GwgRCDDhXBIXTwDGJyBNHw7YHeD43Rz1KqsmqprsZ08koZDdmhe6RG15/doiAaLwXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6yKdvkH; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6yKdvkH"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-902fc790cd5so13612376d6.1
        for <linux-rdma@vger.kernel.org>; Sat, 15 Aug 2026 19:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786847194; x=1787451994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oXHBCMGnZB0X0bTy2l3XtoU3OG3/4+XfTiH2lDtrhfs=;
        b=S6yKdvkHAmjS56QPh2hlZBBCqr4z1B952I/To89eri4sdNUmefb9kBt8Rl6sSwFWul
         /8Af8xqBujfX5gmL6uNpSRxPLwibmpMp5i+90+37JOQyIdgb4bzdlcD5sFIMbgUMTjmY
         9m8+BBvkgXh++vIkjTl4XqcYz1OGOiEh9EmgGHSWdXysTArodw2fY+rkwDHZ1lzURAyb
         0EIGQkSHQojAbMBXf/svrK6QkaQecl+NrVAoygb3ubIo3TeUUjllH1sAk1LMNYflyXPX
         cZt6AvlxE/KZzcEZHzUn1foelOj0nCkpR8B/KOfqAjGnn3CMRah2bFAziB+Em7afW1/U
         OzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786847194; x=1787451994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oXHBCMGnZB0X0bTy2l3XtoU3OG3/4+XfTiH2lDtrhfs=;
        b=C5ufZgBnnrGLa7VLX/gmYmtfnAxCQhYqDeG7BX2gcyBCpetgpLpmj+zdpj2OmFk9+T
         aSPkJvhoQEnKKdRaX6PcrKuMxP5Cr0XtZRPVBEs4WcWBnnE2Wr1kSVRsuWp4YfHS3I/9
         OPYCAY4ShWxRLG1u5u3sxmNo1yvAOJeETJAXQ8kbEt+6vDoRdpinMKEAGKwwxK0az3Ku
         ani693fgIjPacsxoRTFwgiGdxs+N4lFadq1uriLbBr3E21O1nEu9W6kbYJ7+zC3UV/8j
         5EiiSfYA5LEQ2JqnBXoz3qBab0UdKxGSLFRjgWamZg81bBCphuskhXrjL42etDc2Lh4m
         752w==
X-Gm-Message-State: AOJu0YxK8giK5QmxjtN+AyIHmrGxpKEAHmYqfieibKpMwWgJ65oMWu2D
	j51CObHsx7NLCQ6ODRURyqCx/hFpCighlA6BmkgNGlCrQHY4cNmEH5VU
X-Gm-Gg: AR+sD11PnY9GNOHZ6SjkR8xHT56xDFi4H4cTx8VQZFI5HiNzXcCqO8OB8fQvrifxIGX
	eJ6YIHIMxwVUtQ6JMVqk1sxuenxfWqNbe5yuJ2+BO6x6Pl4ax2GeaXlHWA8X/qj38NMznjGR1PI
	MVUXmW7DTeHVwmh4GRvi0Zl7WpJHZFHyvdVc8iGqWvzZUjQMA7Ddv97Qq3uaYuK1imqI8Bxqwmj
	ZwdDwA9voUJ/ELVULKOWB2k7Y/nJUgweqycvpZo07uX29V2HUngKA4vQj6tQ3nKnOx73ZMkGHR2
	Ikk7KvqKMyElg1ulbAvGN7uP0AsdXj73qqCRRDlXBn+k8s2ycpJfI57gLKxYbjvkCEaLXTHR/Ru
	SYpS+VgWi8rToLTtskzPprmx9ggA89bX2KsbARxhIczbEgT1L7GFY8QiUqsRIptVD79Av9L8qXV
	0FGgoKYMJRscCCeQaMiRGKNm9ww9Yhdaya4huOa2MVuhn0HxZI4ORkX0XQyk2s3SmBg9xqe7SvU
	jQc11rRzHgFRqtVMA==
X-Received: by 2002:a05:6214:27ca:b0:90a:6016:deab with SMTP id 6a1803df08f44-90a91d06fafmr191287646d6.8.1786847193628;
        Sat, 15 Aug 2026 19:26:33 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a921e54e2sm54192436d6.3.2026.08.15.19.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 19:26:33 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: bernard.metzler@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] RDMA/siw: Fix CEP use-after-free in siw_connect()
Date: Sat, 15 Aug 2026 22:26:19 -0400
Message-ID: <20260816022619.3629422-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

siw_connect() publishes a newly allocated CEP through qp->cep and gives
the QP an association reference.

If connection setup fails while the QP is being destroyed, QP teardown
can clear qp->cep and drop that reference first. The error path
nevertheless drops what it assumes is the association reference. This
consumes the local allocation reference and frees the CEP before the
error path updates cep->state and releases cep->in_use, causing a
use-after-free.

Serialize CEP association and error-side detachment with qp->state_lock.
Only drop the association reference when qp->cep still points to the CEP
being cleaned up, leaving the local reference valid until cleanup is
complete.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 87c79527ac09..7b32158ea49f 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1467,11 +1467,13 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	siw_cep_set_inuse(cep);
 
 	/* Associate QP with CEP */
+	down_write(&qp->state_lock);
 	siw_cep_get(cep);
 	qp->cep = cep;
 
 	/* siw_qp_get(qp) already done by QP lookup */
 	cep->qp = qp;
+	up_write(&qp->state_lock);
 
 	id->add_ref(id);
 	cep->cm_id = id;
@@ -1564,16 +1566,19 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		siw_socket_disassoc(s);
 		sock_release(s);
 
-		cep->qp = NULL;
-
 		cep->cm_id = NULL;
 		id->rem_ref(id);
 
-		qp->cep = NULL;
-		siw_cep_put(cep);
-
 		cep->state = SIW_EPSTATE_CLOSED;
 
+		down_write(&qp->state_lock);
+		cep->qp = NULL;
+		if (qp->cep == cep) {
+			qp->cep = NULL;
+			siw_cep_put(cep);
+		}
+		up_write(&qp->state_lock);
+
 		siw_cep_set_free_and_put(cep);
 
 	} else if (s) {
-- 
2.43.0

