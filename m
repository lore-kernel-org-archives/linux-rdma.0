Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445102;
	b=efujTU/OePUTH0IULT6pXiQ2EcZ8rR6LVva5+lK7VjfvD2ChX5DekKXP8ySVkoLaUqq4
	 wTe8jRbkUwTkjVH/hUiLZj8VxyG2MDZGVliKCBTdIn31EOisseE6jH3NNCYjIM8M9vo9j
	 VeNjiF806S2nAUAM4Iuzz9WKQNwQgndHRuaPlwo0b3vTw3KqKzI0ndoKlRL/Z+p2AQstB
	 GO1VcUx8dchgT3bIKhgpU2HU1iY0pd31ejYEN3BDAi4FYOdehjbnKkrjpttVdnH9M2PcV
	 zlY021Q0Xfj70E/zNNktZjyVd8YVq1HxNfHT1r1VpzUW78WldEwL4S9gjRyggPgzdsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445102;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oroJDpKY2n8cvcz82AUhbS2tqIsCRV2vr8OBoeaBK8I=;
	b=t0aZtISXlvbF08YH6O5KrP673EVah8Q98WYN1+HdpaWscCOGcvXeUMacZ6dfD8Abs/Uc
	 X43xYQQGooO48nR/wJvNBmkA7xLvdxHPS8pD3HULX29r5Rv5BmeBjqU6RmJ0VEBGe9nue
	 0pDePIiidZ3A0oUqm0ieRzuD2htDu32sv6snj0GeYcieXRed7ejYCwXCgxH+45Iw3zfNI
	 r2tEXVfdrd+rF81FrlcPP/+NwuXxIBqMkIvhwTX9MMU76ktROtLAJUWeKOqkODGRNDpvY
	 pDFG3D99hDCNXC4LRPs+jQoTZj2GaXXhynzqmyP3YVFWcj3GU3Rs9j3cN/kpU5AsD9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nKvEr3le;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA85606A332
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEA85606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nKvEr3le
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b413f6dda6so354334a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795445101; x=1796049901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oroJDpKY2n8cvcz82AUhbS2tqIsCRV2vr8OBoeaBK8I=;
        b=nKvEr3leziv3c4sG72Z0We+liDj+aNB3C84dddoOCQ6mzbB4izvIXB3GU2dLJJZAkR
         cLLpoEs7sT4JsRBd1qEl78UlnQvpw0Gt9/ppOd4LvCvS05LU8Smldxrh3QWciGUelJbI
         7n19l+XK7G1Fammfo50hJGt11iOnmd7/9JBFe8goPWvwF3CJXi8rCfpu/aJZdBUosE8k
         S0cJawnBatIMml+VaOBvPJhTnGQ96Bq6gA/bRb6lHJTRoCkY9l7atcj+xQUxKDFTIZPS
         p464wBR3TLqiWIklYivSHlau5FSdWFaZxUcp4Li+F/JDp8HgFZqjy6X+792FnRdI9ysW
         Zrqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445101; x=1796049901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oroJDpKY2n8cvcz82AUhbS2tqIsCRV2vr8OBoeaBK8I=;
        b=Op6XtXqykaQTBRpi6gDL87CvHn8sOLG5NanwsmdXSsdpmU2cvCrL18cM7u1asvUFoc
         WWfP8ialnOfzmtEEmbHKst9Lxyo7zjHFbtG7GP81DQlvftKSEyaUysqdHqStkUgSJbL1
         /RcEXQYvQpKjuPRB9YqQNApsWqLVxmcPWEqXcxcd3HnfV11rNEHu0gY0BDXb3ULsvicm
         TFfTxJaTiqhZBPZgOZ/pVrwE/AwW0/0ByVbmz7M38q8QAYTsPW+kMRw/TQOuKRcNJZyc
         yrEWCFedwidQ1ygVTv0RWexIlNtKEP8gx8b82kYr1x2NjuJHCR26YT7LwwuISpECPpOc
         0/NA==
X-Gm-Message-State: APuU4Z/oTaPdtXFfaFfmOy8VsiL16QDVJjuXecwifkpNwQDr3l54wxXi
	QdF5o6LO4VwONyrPHmlkqi84CCL8VDicLJFVV86u0XkZPdIj85ZGy06N
X-Gm-Gg: AZFdTZdTfBKYOGkR9jZlPqfEXK7V+wbmw+lmF4IVelRQj7KiITOOkQofnJoXtERXpEs
	fDIPlyJch8T+sUF1z81SoZlWHgkFuFVuaPQ8OKiTeebx5Lb9Pyd7BdFiHXzQlOvOknD9E9O7U8X
	j1/YOIYrFy5Vs32FAIpT458Ik4D7n/ibYpoi334JDar9WOkBhj/b6Wjzv1rjDPMQ11omf5iZONe
	Kz5dwaDy2qEXpRmbA+6zh+FuJqC0gZhldpKZng+1Ebk1NWjGubaAn+DVobWhlPz6xQv11fwqJiG
	PcZRb+vngp44DPZRdSIok/PE5ze3vaxYUOLNtmCsJdmoAcQDvmvqoH3gMKNAN+ypq8bPW4apizL
	hFLN8n566/ET0OJE93I8fupi0c7wkkd/7eFp9p+4l7wsD4O2SgCo04UNDSP1AIAVN5gzhCt6eX+
	rnwSYsORdz62JTE/N7l/B5ke8+q+RyNF4BhPKdPYdLlWLLhoILha0+J1TTc2RKlfl1QJJ/MLx5M
	awwPJOU0t8gKwEvQO+wSMgBt/ajKpgD1EWtlS26QSnjVHkrpYF80i7yXllu/WDajnCzLOCQbsab
	iq+l6ykf6EkmcX0L5Syr6hedt/f5uYfYDGFtCLY5
X-Received: by 2002:a17:90b:498c:b0:3ac:73c7:9c07 with SMTP id 98e67ed59e1d1-3b41c55b914mr15888941a91.0.1795445100877;
        Mon, 23 Nov 2026 06:45:00 -0800 (PST)
Received: from gmail.com ([124.127.13.134])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b217a5bsm7810096a91.0.2026.11.23.06.44.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:45:00 -0800 (PST)
From: Ziyu Zhang <ziyuzhang201@gmail.com>
To: sagi@grimberg.me,
	mgurtovoy@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	ziyuzhang201@gmail.com
Subject: [PATCH] IB/iser: Fix deadlock during blocking connect
Date: Mon, 23 Nov 2026 22:44:40 +0800
Message-Id: <20261123144440.65441-1-ziyuzhang201@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
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

iser_connect() holds state_mutex while waiting for up_completion. The
CMA handler for the same connection needs state_mutex before it can call
iser_connected_handler() and complete up_completion. A blocking connect
can therefore prevent its own connection completion and leave the waiter
blocked until a signal arrives.

Drop state_mutex around the wait and reacquire it before checking the
connection state, preserving serialization of state and cleanup paths.

Fixes: 504130c039f9 ("IB/iser: Protect iser state machine with a mutex")
Cc: stable@vger.kernel.org
Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 55fe68e..9fe2d3f 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -778,7 +778,9 @@ int iser_connect(struct iser_conn *iser_conn, struct sockaddr *src_addr,
 	}
 
 	if (!non_blocking) {
+		mutex_unlock(&iser_conn->state_mutex);
 		wait_for_completion_interruptible(&iser_conn->up_completion);
+		mutex_lock(&iser_conn->state_mutex);
 
 		if (iser_conn->state != ISER_CONN_UP) {
 			err =  -EIO;
-- 
2.34.1

