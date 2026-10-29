Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248060;
	b=w0uZbH9SMt4a+EECAZfQThb1viuc8k62MOH9DSpjK/OwirEu/kiLIw30tQvam+yat0v+
	 8U8R+TCyFKTeAATOGyDWlSLQpq1EhBuR0QRxkL2rwFT4V+ZmgeCYwsFPGheJK8sJRgbii
	 HNoH8i0/bzDX71BWnrkyszCqdVIc/wkcaq0ZA7LpsqPWq82e8N8qp35JojzmN1eSixpl4
	 spetc2Dr1CIBHcubEfK6aekUOUPpVCYvPJFpNAKQBP3T+6XDgthu0q3ezUyhI6LNpVbXi
	 nAb/ki4xXRdeCEXPNXCZOzKHecDAksHOBNH8HnW0VO30U0w0mwrmha1FS05ZJpOvmKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248060;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=92Ry8Npagaq/z8a8VQiLsTt0Bsh/v/B89EOMNxNHR6w=;
	b=GWEt1IP1mz748Wv1kMOPcOyULtT+2cBNOnXnCDCNCiVcLm/19jqutWte5aWd52wrQS+h
	 M7lpMj07uF1agxx2zpt9iGmUek7yb64N7XzG1JYwQGjw0oCvNAqahMdHId7NiYJ+ne6L0
	 ynLjbspKE4aQVR99NKUNqhdErGyDfjLc7hUP1Y3BgaF665UFHRloUmQYHX//eg9NQWR+Y
	 B741umM0laworpyumhBuK5DuJjh3N3FrzG+fe7FVfrVRzEi0a8XTHHjtV27PqceETquYn
	 ydXbu1zfwi8amImQAjZul2/EV5zCOnPI39oXTLPvAlYGx6qxS+jXwusF/KBJfL4IiCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PmrIkzsF;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02E460A2601
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 04:27:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D02E460A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PmrIkzsF
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso199970a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 21:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793248059; x=1793852859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=92Ry8Npagaq/z8a8VQiLsTt0Bsh/v/B89EOMNxNHR6w=;
        b=PmrIkzsF3KWnP0i6mMndM6dmhR3o55JdfGB0tKABw5xOAMyEwvboHP936D2DTSd7yi
         HsM3FXRiVwQr/fKIEPvhektnia9sU2G4HOSXZlnRsDBW/zTlfaKjVO9omxl649aBln3Q
         Gf5CYIqV+U+q+aVU2MsQTjNkBgrUutudp8NJsImyalHlZujeME9ABU1C+PiDotVLpLrZ
         FySJryJUdt3JLLZAmdCX8VzgS1G09ewoclj+1OQkznyFJY7832qOBBCEPFSaavjYbuLo
         mqfDNEEQGBHNnhBDG4BIApB8j6ug75eez0IFzQ/GzKQrcepcY19gu91AKaSo3n6IxaQU
         0W0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793248059; x=1793852859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=92Ry8Npagaq/z8a8VQiLsTt0Bsh/v/B89EOMNxNHR6w=;
        b=fmR4db2dRi4lT5DzPCOyGPoZL9jsS6q+ngCZ2pyxqnpMKzSKX2N86YkIyHnGpa3eIh
         nwCZPwq1ohEh+jAoWMI0udc9dT0MHLCTGasN6BhLlbr00EcaV1tcDR+jsI8G4vmZ459t
         SvsGghzHvDjlioqBwu52r8RC8eiATDwK+mXH0+qyr+iHecpt0AlAjCz+w5/OGboFprZe
         RGcXf5+DMe+XgdwU0lf3ok0A1Hd3bKpZmwW+/09BVcwxuxpn0tl6Apghk5qIlHZ6wQ4s
         +TDcorsMYX7QsnKc7gMg11oS6x8iTR7SLO8SwX0zmoKvhxz6fejC9PRQcowxNedNEOHL
         1Mww==
X-Forwarded-Encrypted: i=1; AKwUvBxtbpzIcdvs1LcTzsWzxGMfdtU0OiY0f/KILY4usKCzfbsqidN4NILaRJAJ2q1cY8a4NbQZwLyP1fbi@vger.kernel.org
X-Gm-Message-State: AFq9FYKtRBv4ijt99dvHKfFkYblJ1eY7aYaEaBr0rtsb5ZDLDtnp5r2F
	+Zk46QTh1y8/HZhcd3fs+o9togWfIfEO9eVRymCt9cGxlaiX7wtonxDW
X-Gm-Gg: AYBFou3TiJ+l8AsxvUcWWGDFhfdreGC8lGrrCLKN7Aau9Re6KekGUFz4xnjFTqvtTmQ
	XMjwKfCS4JdhmhGpQhhNvh6faXl3PAXIeoska1JdrW8Ml2sV5MDmEdpefVu1Nwc49gjvBdsvF24
	pH3SihGjTZHehwlNgn3Hhu2CM8uePHvB84JceqFaQg0WL7wIgL/vDvhI6oqZ6oz4kDW98Rgdd7f
	2dL5XZnE+ZnspIr96oaB26DLmnnnazcFZeCg7RANqChPCpYKfuorYTJfMfUVuoY2qEjkos2jMGi
	R5IFVb5MlXFaeAVJekJVRwabv6GID1xG5mXY+L6vyXHrDv4wCSyzj8b7t9NUG5KmW7MT5mKyyK9
	vCHyoicXNFJjNJhg6GZnei3lmE2YwVjhXQqHqymmf+8U6uHn9XG1YNlF2OjfFq25YqrQaq1Lh/u
	QoSC4xhbFFkoEF1bvCTfquFIe/LonudMwXoLpN+78RFBM/5Nir0+J2567iUniQt85aRLHG1ESPx
	PkRYaetK5tG9+cdify4TgsYjq7kLhCq9ejrXJfS+zYM2IryZnJaU5oBcXiATcJzBWYH/MesgJWO
	lJvta1TwEc2l4jw8pXegEXwK+4t9Fb6sxnW1QfWDyXXkpDgssquxHC8=
X-Received: by 2002:a17:90b:57e6:b0:3a8:786a:cfed with SMTP id 98e67ed59e1d1-3ae6ed88ed6mr887736a91.37.1793248059222;
        Wed, 28 Oct 2026 21:27:39 -0700 (PDT)
Received: from localhost.localdomain ([155.69.168.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e898317sm2010846a91.16.2026.10.28.21.27.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 21:27:38 -0700 (PDT)
From: Yuqiang Sun <izaiahsun@gmail.com>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	guoqing.jiang@linux.dev,
	gi-oh.kim@ionos.com,
	aleksei.marov@ionos.com,
	lgs201920130244@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 3/3] RDMA/rtrs-srv: Reject an empty pathname
Date: Thu, 29 Oct 2026 12:27:19 +0800
Message-ID: <20261029042719.75868-4-izaiahsun@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029042719.75868-1-izaiahsun@gmail.com>
References: <20261029042719.75868-1-izaiahsun@gmail.com>
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

process_info_req() uses the pathname sent by the client as the name of
the session device and rejects names containing '/' or '.', but it
accepts an empty one.  dev_set_name() succeeds for it, and device_add()
then fails in kobject_add_internal(), which warns about the empty name.

Reject an empty pathname together with the other invalid ones.

Build-tested with x86_64 and arm64 allmodconfig (W=1, sparse): no new
warnings.  Run-tested under KVM with KASAN, lockdep and kmemleak, using
a small user-space rtrs client that sends an empty pathname: the server
now rejects it at the check above, nothing is reported, and an ordinary
rnbd map, I/O and unmap afterwards still work.  Not tested on RDMA
hardware.

Fixes: dea7bb3ad3e0 ("RDMA/rtrs: Do not allow sessname to contain special symbols / and .")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5 kbound
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 56f0ab5a7619..d34a177f7ba2 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -823,6 +823,10 @@ static int process_info_req(struct rtrs_srv_con *con,
 		return err;
 	}
 
+	if (!msg->pathname[0]) {
+		rtrs_err(s, "pathname cannot be empty\n");
+		return -EINVAL;
+	}
 	if (strchr(msg->pathname, '/') || strchr(msg->pathname, '.')) {
 		rtrs_err(s, "pathname cannot contain / and .\n");
 		return -EINVAL;
-- 
2.53.0

