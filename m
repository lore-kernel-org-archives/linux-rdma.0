Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372363B993B
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 02:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787105423; cv=none; b=RuTKh4nurBkRxIGKtyYCHDM/tVKWxRhlO/HwjECK8xg6e+eg7gqy+WlPVR7NjVYbFI4wHFewAsaC2HSj1ClCVUHYrOTx8kSSAEXXvcCnExm2k6J0NWLcGU5VJ8w7+KreBgn5PLfIyyTRYTAXwVYDgCe2G3/FqGcArN9cX2kuUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787105423; c=relaxed/simple;
	bh=wo4Q65uqCkTehgvGTLKylq4RWd/z0F3+iRJ3VNvrdN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4In/hSQV17d4CzVtGbVtvnuugsbvZcUB5NOpPhfw90HOxWMdmypCWeYIX00nLGVBGvzNtHPDf4Om3xL/mgpXszP3mHboPbU5vHYUIe5QEGT+kXJtaAMpAj4a/uRch3vzW2efXJaT/MoGW/XT7Mei+DIq4vT0CPtzAJTgrZ2YtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=kNW36Qf/; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="kNW36Qf/"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e347638adso669451a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 19:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787105419; x=1787710219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wo4Q65uqCkTehgvGTLKylq4RWd/z0F3+iRJ3VNvrdN8=;
        b=kNW36Qf/dhKkB6jH3FPJrpuQkryIilPMe///0XomJnijBEPQHkzlmIY2/k5ozAtRrg
         CNupq5oLDpk+wvRhjQ+KFxT+eYv0Kn7QhdrbpHsYTCsyAhzdzrSGsjr4P1fhp8nMMtAA
         9UJ/HbdM6MJjkzhiYhacGjoVifmfHzck+wismufg3fvSH1mZ/veUvkGtjLocpZFEUeg2
         4BQIylmUZJ3fleZfUJGO2hhSkGYrPw8uLLVQU0UC5+twoq4xBgXt+GGx1+bZZmVz1+6k
         XoFdG3j+f9AI5rkgOUUJCNfOr1atZsmIc9Diotn4rN75DMk8b6FHH6rT5XGaAbOy7Bhj
         Kn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787105419; x=1787710219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wo4Q65uqCkTehgvGTLKylq4RWd/z0F3+iRJ3VNvrdN8=;
        b=BRvJEJfCF+MNAuY0UE11DFIuWoZf6ad7LbYywFEIs5MWmkVNeFbC0mPRsFdugXc9fI
         zckdIe1IRWYzQXmQxiT1DAdSSCSlTFnzcHMbyN6EBYRYMvlNNfhLdtayyK/P2V30ZyOc
         sydmf8GeWYRqm7wPIkYk0AO/YLAhUSbxlmFdLt7dNJTIujTT0H+tnd0pJsO4cpY7n4+G
         kNMxJ2Zy5KsAKALRz6d4U8Epk3CTzFMulOOuvZ4Upd2MRg0FVt90UmdpusMZKpJU8H4q
         315CM33MSz4mo080RLr+oX2Y0INI2HjIp2Z0CNDFSXtFGgc7KJkkwYKoepxwc4NqQ3aK
         1R2g==
X-Forwarded-Encrypted: i=1; AHgh+RocDrUCys2StfEKevSJzxd0lD9GTWKm2pyvhOdLyp22x6LJuxlhRFKDgV2zBKJqlYREHZa/pR96fdb/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy37ScqF2+QLoyIp7SNTxRlULjvAta6HFnlMg05IQPZq+g8qVBu
	yxp2/WHT8a/QwMfh2BtXpMfWQaSPgnKwK1V4Dv6IOsLUROsBRn0CDl3JqME9sJM1IWk=
X-Gm-Gg: AR+sD13PfyI0gZSb03StjnkSLDo4zIWZlRJ5BTHbCXFwlHOUMXNshAOic+oxhIChlKI
	6ukdqRG98Jfu0OKLN/RBIeRU/QdUVm4Zbmsl8B8DGz//W+7XhTrcJI+hrLUYXDNL88Jrl7NZd4P
	MJqfrdntlJ8kk2UxIsecA/uZbAS9DSVgnM36N6+W3Y4FHmPs9oZR41kKKOFL8XIn+6bcbWfCyXD
	Hsm2BsXbuJn2eD9HC59ULwezn66YIla1rM+q5zbzTnSpidoh3aid9xD7t3aGrDRLcoX3g1Lv9rL
	vvyc6VJspKP1eb8Rk9jAtRbTf9MxvoHxRGZ6JTiSMO4KqZPgQGzJO06ORbZpFpFcDDnj2Vdz5b6
	pPv0fSJatE+KiyBpE0ARv/AX6X7X3dK50tvx9bH4GJcPHkbfjLBwp8XqHsPBSXFkubrh4ouIZwY
	lzi0mNYaQykzavBwLrZ4qZoOXiFNbfT9pjyRv5w197Aa0wxh33yt7oMIhDXS9Y2qdCH+CV
X-Received: by 2002:a17:90b:2241:b0:380:105f:8ffd with SMTP id 98e67ed59e1d1-39581228dbdmr2141544a91.16.1787105419152;
        Tue, 18 Aug 2026 19:10:19 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f96cb76sm770351a91.1.2026.08.18.19.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 19:10:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: bvanassche@acm.org
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	linux-rdma@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Wed, 19 Aug 2026 11:10:11 +0900
Message-ID: <20260819021011.642747-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3ca5809e-96be-4073-8596-4ab53d72d6b9@acm.org>
References: <3ca5809e-96be-4073-8596-4ab53d72d6b9@acm.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My answer to this went out without In-Reply-To and started its own
thread:

https://lore.kernel.org/linux-rdma/20260819014815.642500-1-yhlee@isslab.korea.ac.kr/

Best regards,

Yehyeong Lee
