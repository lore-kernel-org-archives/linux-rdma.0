Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752823E63A4
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785147200; cv=none; b=RFfic44zodpWxi9kuGY6Ph0YojMvVFj1vU5zhf+aNRG3wwbg81Dxwt2ArYxC2/Mqrc4bJVNI7yngKB0CdQ7Yjhe4d/8mXycmE+uYCUftP2ipZIFOmi8F49VL5SiyRW/aIb6rYxh1RqVMPhuvX2CFH5onmIpy3FV+KPyJ6BK2Qxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785147200; c=relaxed/simple;
	bh=TOdxnhWT+ZLO74zXS8rVU8Ea0zC1JkHe0Dz2LVslEPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS6LGHTSEwHHXP7g/1pC5TRYxNUmrDgWCcz94lpxvAQu5tVQ0jJCcNlBogJmCdtLEQyPummryES4inZS9knqZOR6Yh5w5R/xQfrlVJgCqD6iqoyd3B1Vw59NAOX05gd3jRTlpv6P9ElHVPE5YIdjU6YKO+zYczvQ+3rHRXCl6LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=slh5LoJI; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="slh5LoJI"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8484f229529so1578936b3a.2
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 03:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785147199; x=1785751999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vp/5BcyrePbYZxYkxsuSp08ldVpSPznaXrpWbqGp8q8=;
        b=slh5LoJIOkO2Mb+XR9wN4TPaDMN43SANhDdp3Cu6yNQIOUPsTDcz6TOTzJZaQzCJar
         SDvkAYEtpEoey0U7jvF3rUamvLvdA+wdtmsvM9hnuHrwADFyUrdPciDZn95n8Zloy9Lu
         rpgnCnQx1Q3NSD9DQlwqyBjvCL87aMFZI01iy/toATYny60jGmEtGtbAY5whOcRc6ny1
         YGWeNwQjRcrpMTRuRE2nd6WebQT9e81kiZgJsTQQ4/aigrK0MHFJ+HMebR9Gt/g6afiQ
         UAwZ4T3F9EsHi1SneKewxEmEA2F6+o2Kh/8+vrOJszlyFI7aMFPijqAhuVf2vQpm6rNU
         +wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785147199; x=1785751999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vp/5BcyrePbYZxYkxsuSp08ldVpSPznaXrpWbqGp8q8=;
        b=INigNZIaH/ufQJdE72H92W2cLvQPC/ktz2F995ZADcyU5fcy09Cn+BR1SDCBVff54a
         ASW6Uzdwabqb/3MLZ2O+or3gNMWxwp+H+KoUKClVXw8os0X+rWAHM4LRuFskrDBWyxHh
         lhx6yfA1QhLI25fRRp40n73xOXBeFx0HKYrIHV/5FVJ07S7BPOUIdqzXzay6W4/KA1Ik
         I3RTb2GoNKpdr3MHsmHuBiCTlH9YrLpdOpncAbs/Hu/8Pp0PU06LUqmocyHRmazBY2ie
         9FiIajpypxPUfiijp6iXx0DxqwKPnu25FrhpbBbnYG9I4NuTCbMKLcqnts7EJ2tT2P9+
         aqag==
X-Gm-Message-State: AOJu0Yx0obfA4NeZyuvnW0JmKJ5M57tTx54/YEQtBZghgSi+j7Q7dt42
	i4U7yoBKanKCPi4mG3f4nHhfE3Cc74kKnJ+Y3FrVTGEUFk7RYTGI019TyUijA+4yUiU=
X-Gm-Gg: AR+sD10um9B4QkRuNF010wXWJWFPKn43HeFAAn6WmGeCeg2/HXD895RFwfH/uiiOfyg
	JZN3vBhYrniyOR16DAdsZBWhythcWesLd7e80VvU5jNhUEx214ej3P6XNOQZ392DIv9aQQwZBhB
	D1nG3NLK/z41ZeVgyov+g2jvWXUIJLpNZmgDMvc2cjoxqkU83Xe40PjnhCz4rGwbbDkIRGEL4wv
	ChK667gpndigSGDgrUeIRxapDzhnsz1rTL9W3k8CIp4PGmIHesq35gvHzs36s7txi4nvq2pTp4L
	FrLb9xxn0T2zkJCt/CugbzCVcvU2XXcCCwbb7uo2RkQ4/03NOwzho7YaXiFvKxEt3N2nVNmCLYq
	QnC6PSShj2InGTjaZNvQ5Uq/7WIu8fF15pGpFRwFxNtS6KAgYvoBMuwQ4i9jBM88oGnaqF7SteA
	M01KMgkrsrEsr21s+fwypW81ZO
X-Received: by 2002:a05:6a00:e87:b0:848:438d:3665 with SMTP id d2e1a72fcca58-84e595644e0mr6217501b3a.41.1785147198851;
        Mon, 27 Jul 2026 03:13:18 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:fc36:f2a9:533e:766d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53253d7dsm2788211b3a.5.2026.07.27.03.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:13:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] IB/isert: reject PDUs declaring more data than was received
Date: Mon, 27 Jul 2026 19:13:07 +0900
Message-ID: <20260727101307.1079690-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727051557.GH12003@unreal>
References: <20260727051557.GH12003@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 27, 2026 at 08:15:57AM +0300, Leon Romanovsky wrote:
> I have little desire to argue with chatbot, but the second check MUST to
> be added.

It is added, with your Suggested-by:

  [PATCH v2 2/2] IB/isert: reject login PDUs declaring more data than was received
  https://lore.kernel.org/all/20260726163931.971063-3-yhlee@isslab.korea.ac.kr/

The check runs from both isert_get_login_rx() and
isert_login_recv_done().  I posted the series as a new thread instead of
in reply to this one, which is why it does not appear here.

Best regards,
Yehyeong Lee
