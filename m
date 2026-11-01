Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542559;
	b=ha0Mh+awSgQhVSULDEDhVi5JVuyBCeTfE7TuKllO7RuA5EdHPWLzPoPRb/auY0SQpvDU
	 vxgULPhMYe0uW/PcZCbXsAcyMBPTv8e0wmIUL5xaldJfhh3fRH6e4jIfAg29g917xPUzX
	 4l+PFTUobT/51dtYqq9NKxX9v7Upp/KjZz+Co1mEgTYGC5JwXlKNr5Fb79VBKIrrExrDd
	 eummPF7RWmPuj54PIg2b019helecbveB5Ioz4dU2HG3jj6cfcLmkZ/IDt9TcLO927zOgA
	 xUq/MVsCk5jOYzxxIQVqDyeMdM08xPxkyf7eu3zyKHZYwSGRhDr6cXVfY2PlJayOh9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542559;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=sMIiBsBGGfnuS5WxfPmtADmv/TO4FUudGIPAhofipOw=;
	b=J87J5qX0RC/UzM53uEk+t1SMIroDk+Zw6r8iNg1RsqV4SK8Ur20Gy4pT4z7f7rHupZ9z
	 zxCfp1Fp2/OvE9HoANeATPA/IY1Iy+2OxkFAjl7Afjv04IfU62sad1yJug7HLX1nPPzym
	 C6Mv9l0lhBMnm6c2+8PgmwvxtsCekFZP4AYxS2Wf22444ygj89uj6a2SraWekXm9NVLJ6
	 UdssqAhpQ2JpCUiUlnhBUK/p3w6j4VEb2ILKyAxw9X+TZiBoP76X+4yEw+U8qb744e0jS
	 9hg5DAsrK0ZfEc+KUsPFb1HpvifVphqaODua94lEBf5Pi6kftZ4ACWFJklZmo98f6eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vcJpqmfU;
	arc=none smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AFC606A32D
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 14:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81AFC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vcJpqmfU
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bccecba199so2042997e87.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 06:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793542557; x=1794147357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sMIiBsBGGfnuS5WxfPmtADmv/TO4FUudGIPAhofipOw=;
        b=vcJpqmfUdbN8tkReri4l0x+jGDh7UGhpZX4DbVuZ5aO4NgyOTuHU+T6NbhzFMYImAg
         6fmdb8ooUrh4DGkUSvCTKj5ZK3k6tXOTNvyrmJcTaFDCkZ3N0qR7EGxWkrwAzXcOQMQU
         xvKdVF12c0p5iJhej1VGBebhKRztuSAjblBZGLK4TwsNeJ12C/CucXclbxvKDU3TyUHR
         LRATY/blOtNAzhAAFTvgoxRlYufIMGXOwDhHOTu1qKARAPRmaUYepZpCnzmIrIU5VSYb
         2rurZlIlN2ToB0EBySYLkROwUBAQm2/f/kgDzkhu7UcXI1URIj4PvoRLYb+26BqTHg7M
         kh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793542557; x=1794147357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sMIiBsBGGfnuS5WxfPmtADmv/TO4FUudGIPAhofipOw=;
        b=poESiYgERRjFhV3QQ6BeG2AyT1SNEiV+hlGrAC8MkhNfOVEqLvjGRsj6nlwf03VpW6
         6jR0PB4uSkX+pcSRK/zsC/BhaO2d7H3z6lBgZ6RRqVe/cV0yct0MMnviDZ7goxKo8YYf
         WXXJDDY9v+ef/dEaZOYjliDLafCmx/7FjjoBrcXdAj9JdY0DBhKpG6DyASmogNtI/FtF
         DMVNy6FNcg/cROrDGZw15FlXfb1Ul9NS8DM+HtCvbjzaJA4mpBiqGnjJe/x0acNVL6KE
         AVoKA/jjm4QYMxC6YG29sEaWG2rzXmiLsvz0tTjDPElSNT6K1Idf+tMck+GK0Su9JPf8
         uN8A==
X-Gm-Message-State: AFq9FYKaK21h7JHFBmUwIzMfi/TNU8VbP29M9ZVGQnkmwJX5W4SP0xr/
	t+KGQsHqRE0Red7o0L9odnjSoJ7+LrMiG9E6pIkJCjAF3HXk4dMfAjo28iPCVPJCig8=
X-Gm-Gg: AYBFou2Bo10e/U+OuFGwYNCQNOcQg++e7mfi4K9ss5dlElkg9xA2jSuXviJZcneHjvc
	YIT+//QZXug6RUzwUPNhAFfYVUqXhKL20nTcxw+fWgt46T/aTCYarkY0S6I8a7CgJMX6qGRCBfW
	92TloZ/hNzlQiXettQVhkUrjiTpxcqlvTf5hYF5A1GhX1/fX8UYe8DUS3m3blGIctscJXQ2pWa5
	vbd9umKdpyKL7M4PywVlhgyFmcRbS+d5JwPEMh/BKzpUEg9Pt7U2cRdXj67WV9sPwPQ7chH2mhO
	e5iEoAP6sCERDevzPRDUbf4R58TNifeLZ2cqEO54pVse9JoXDFcfXNAsO0e7PizlHXsHe1U/xU0
	z2QaghSGXnrBl0Tz1NGymyd7am6KHaYXndzPaGJdFY5AbRPwYismwx9TGC9P3m9BekXCW2iw9nP
	2SRmXkgZULtN92uqDX+Pa7j/+QRwk/5O2gRS4PUuW0htC3O0N0YlHyTfIZGq7RocKsiidfQEj2y
	ZCdarNyvGdlDrAdBQHp8FC59w/oM0pLFa948/ypJ9agOI+LeghRVnP4ocnpmGtW2kpr95hxkE6W
	sEXR9VJT43EWI0G6DhULfT/qZ4oje/XKE5NilRw2CvoWVtLj83EWWCtFhPYAnv5Tqg55LRt8LLr
	9MiveVagJ0z0G50jY1UBKjcYU7Mq1ajK2PMWjfeXGeY0mS5oWDJNQoIx/
X-Received: by 2002:a05:6512:3d17:b0:5bf:a27e:e23e with SMTP id 2adb3069b0e04-5bfd957fbe0mr2778352e87.57.1793542556592;
        Sun, 01 Nov 2026 06:15:56 -0800 (PST)
Received: from xps.taila9902.ts.net ([2001:464e:6820:0:f43c:bf8:ce8f:65e6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe1791832sm1043672e87.23.2026.11.01.06.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 06:15:56 -0800 (PST)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH 0/2] RDMA/nldev: Reply with the command of the request
Date: Sun,  1 Nov 2026 15:15:19 +0100
Message-ID: <20261101141521.2426198-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Two doit handlers reply with another command's message type:
RDMA_NLDEV_CMD_PORT_GET with RDMA_NLDEV_CMD_GET, and RDMA_NLDEV_CMD_STAT_DEL
with RDMA_NLDEV_CMD_STAT_SET. A client that decodes replies based on their
type mis-decodes them. AFAIK iproute2 igores the reply type and rdma-core
does not use these commands. I spotted these when writing an RDMA netlink
client for Go.

I used AI to prepare the patches but I reviewed and tested myself.

Nikolaos Gkarlis (2):
  RDMA/nldev: Reply to RDMA_NLDEV_CMD_PORT_GET with its own command
  RDMA/nldev: Reply to RDMA_NLDEV_CMD_STAT_DEL with its own command

 drivers/infiniband/core/nldev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.55.0

