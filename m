Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4CA422521
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786698675; cv=none; b=CI02kamgxlqng6riDzB8cZ9mCDjUbDxAdH2xKvYrWG4T5Ly5DRcU3hATVCiBBSyGXf7u4RPJT2SS/48q9oeqKdiyR0l2uspijVvUf/tKY0QJy4+tssUxQF2D6IagItVNBgSK8GH53OiudvDPIu8GvLIL4eNlK566rT1oUj/gMOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786698675; c=relaxed/simple;
	bh=mitSiM7Zm2Qehwr9qj883Y6+SDxH1sOjtvMEjMsC6lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl1HVZgKv2YaG+qUezhRhsUyAyJq19neI99PRDVbUsao7amIZtIqk519li8eIB4X+xT/qAp5Ot40IbjgAQ7Rvxh+2MBiSRfdWOauRHUYzIxr9INJ6WZyZyjEY3GImtUtIDxCWdd936VMYVaSKgkEpxc95sypIkoC8R5tDh6ZAzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HkwuoYgw; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HkwuoYgw"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso537436b3a.0
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786698673; x=1787303473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kN3cxg4FbIo8tTISuz5oziD0hZFYkConcwf1MZhcyQs=;
        b=SATKvwKdYNnTFjDRuxxJU19VoUO0D+4V7vjm8W9eYbC/35LhX+wP5BUkxm0H7LtgPu
         KlfKjgcX/qSSoME9h1/PKWQ5EVCsoz1OvsodUIFyIcKpZyfzHYLW1pGHtFiV2g8RQygC
         gnNwQLlD2xZP2GUbK7aAHNcuIONQQ108hGhWMZOgLAK+ADPNVwdDaD2LEjUjbMqC7s42
         tLPlo90xYfG7IF2tWl3HcQa7zlG7EKZdObqJ71wyU2JsG4HCyMWsAAFE7FFFuU4ncYsG
         LjSXNS8xZsnN9qoU8jpIJuLiwhwY5604INKoJJHlaad4hNJ46WAaT1mXKfFJ+PPfd/I8
         BQYQ==
X-Forwarded-Encrypted: i=1; AHgh+Roq/oqMsgFAYL1tQgLjTe/8bMDKzp9Et+KUVTObOGBa/j9VT475ZOfOzNJGx8KZmwRhr6fam0HByB7K@vger.kernel.org
X-Gm-Message-State: AOJu0YzdsBSIB1bVnJd0kCpAPIB7ZzqpBqiDDKrgFL/RuiQSwwhCi6Op
	LJdeXNltGip00wLcIo/F9TjiLVSWnIKcQ7ZfmfMFVwmJ5zY3R4eMYUKxokpszdg8vUq48FEvhs7
	4dcOIN46ovHxFTAEd7PQPsDYJgdIgxx7kk0hW1o8zX/DSO1kyMGQNxuqZl+KqFdi8uKAhNe8cu0
	qu5skMn3mOr9+hpU4m5OLsdOvpUbj6mXu/gJSzlqoSVgQTr1ZH/OypPMuD0AIcIa8eeOsE/g4HO
	7mHY8YfO5+A6h0=
X-Gm-Gg: AR+sD13thuNeqlac38AgMPOZQNncpdfU5fvj4FuCgbLntLVHgnhe4pIiK11x/S6nFat
	vuVw2AT4ow+OU4N22YOPTfBpXcklLBp9VQN+r5ZR/8AwplKbKuFITo/gPwI83EoKx0AorQ/snlc
	/zaTru4KwV1ZtdFA9z/7WUwEsEIHA/j8KuYubO5J7UQgAcJpeREjdnUd66evNxrqw82hbxtOOFE
	Uomwq0OTOZJkEcCxtgvxAsQujLwrYrnAw/be+wLS8ytp2X0z0izMzmikfoaQUd9jdV3/qmlIRdg
	SUnB9Dr0L7QdtHDWV7xqN92/bV2J/Se/d6E3q/AZ1Ayh8CJFR50EN9YS7ClM+Cr0mca9jM5WFga
	F/iVqE+5btuW2HmrRZIzrzv1fCuyi1BY+lHDN34U8Wwkg3gEJt6FuoiDxlZlRP3JRww3UVC6O8F
	zBWWjnES6QEBKFRJ/v2LWIXiFCfEypMG3GWQ==
X-Received: by 2002:a05:6a20:2588:b0:3c3:c3fb:2473 with SMTP id adf61e73a8af0-3cc71cca121mr4109740637.20.1786698673072;
        Fri, 14 Aug 2026 02:11:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc095a3f73asm56785a12.8.2026.08.14.02.11.12
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Aug 2026 02:11:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb5cc1e13f8so650952a12.3
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786698671; x=1787303471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kN3cxg4FbIo8tTISuz5oziD0hZFYkConcwf1MZhcyQs=;
        b=HkwuoYgwEPqKN0koso6y9OIyhl45iVu7ai605RYTf/vvftVrH37c9asen0Kuf1rAsq
         6Izbicj9FBntl+wu16710zMCSDBNJBDThskiOTscYui+N2Ys3WrJ3cpHm29Ftd4nHwAE
         JS9d/xvqrsj+PLpDw3jvjV/r+QEB0/0bp2Xfg=
X-Forwarded-Encrypted: i=1; AHgh+Rp4b/PE6qnveE3VYF9ChV0p90m7kcvggNyl8P1mpdNNmFL2SxRnHBtjaf3PEDzTfi4CNyOv/lYNS87a@vger.kernel.org
X-Received: by 2002:a05:6a21:3391:b0:3bf:a638:4376 with SMTP id adf61e73a8af0-3cc71ccc432mr4827088637.21.1786698670987;
        Fri, 14 Aug 2026 02:11:10 -0700 (PDT)
X-Received: by 2002:a05:6a21:3391:b0:3bf:a638:4376 with SMTP id adf61e73a8af0-3cc71ccc432mr4827020637.21.1786698670453;
        Fri, 14 Aug 2026 02:11:10 -0700 (PDT)
Received: from localhost.localdomain ([192.19.203.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413887e3e7sm7056408c88.9.2026.08.14.02.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 02:11:10 -0700 (PDT)
From: Vikas Gupta <vikas.gupta@broadcom.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	jgg@nvidia.com,
	bhargava.marreddy@broadcom.com,
	rahul-rg.gupta@broadcom.com,
	vsrama-krishna.nemani@broadcom.com,
	rajashekar.hudumula@broadcom.com,
	ajit.khaparde@broadcom.com,
	siva.kallam@broadcom.com,
	usman.ansari@broadcom.com,
	Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH net-next 1/2] bng_re: add support for the shutdown callback
Date: Fri, 14 Aug 2026 14:40:53 +0530
Message-ID: <20260814091054.359508-2-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260814091054.359508-1-vikas.gupta@broadcom.com>
References: <20260814091054.359508-1-vikas.gupta@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: "Usman S. Ansari" <usman.ansari@broadcom.com>

At present it calls bng_re_remove(), which adequately handles device
teardown on shutdown. Appropriate shutdown-specific handling will be
introduced in the future.

Signed-off-by: Usman S. Ansari <usman.ansari@broadcom.com>
Reviewed-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 311c8bc93160..42b473919d09 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -477,6 +477,11 @@ static void bng_re_remove(struct auxiliary_device *adev)
 	kfree(dev_info);
 }
 
+static void bng_re_shutdown(struct auxiliary_device *adev)
+{
+	bng_re_remove(adev);
+}
+
 static const struct auxiliary_device_id bng_re_id_table[] = {
 	{ .name = BNG_RE_ADEV_NAME ".rdma", },
 	{},
@@ -488,6 +493,7 @@ static struct auxiliary_driver bng_re_driver = {
 	.name = "rdma",
 	.probe = bng_re_probe,
 	.remove = bng_re_remove,
+	.shutdown = bng_re_shutdown,
 	.id_table = bng_re_id_table,
 };
 
-- 
2.47.1

