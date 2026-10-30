Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381790;
	b=DVftO/BvEVEKq/PimEN0goiX6t4whwoHBiHLUtSHIHRjoqmx6L5Nrh15hOr+/yrAS8W9
	 d1WjZjdRu5o/mMaabOLNc/vHiRue6nDzdR13Han8YKlU0UogkDZrOnXPaEBo5azD0iXTB
	 2ldJpEDRt2eqjrZ6L0A06F/TsCWhenqVNfhEQF/FtKoyRBU7smDsh/jncEEPXFhoMu72Z
	 tJxLrqof8ed2lZlvcOyEr5Y0mFn51OOqRb8ZU/OowY9HnKxksWlumQzzbpSYz90Tc81Ca
	 hyhSAZggBm6zEVZkEdoUYV5G5sjcys80fkP3lu8evxfhRSwtfHEhkGXzoOON1WEH80w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381790;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=945dpUI8tB2gJpRVSolSGYelQFbEaHJ3XJYtxTvsE3E=;
	b=3C2wS6nGYHCYQzt5CMuZbdR9EKGc1HlpbiZRRkHLogYZ2aNhuN6QBJdiGnN4ezCae0j6
	 MxHpfV580DQRs69o5BCSnvVR3xeQI2fYilFylhYS59zo6ROGVS96XdyiFDbh+aIgCIbtD
	 VJbI6WeKzMOdLg+xsVIQdvLydQYgZqL7X5tLanY9ksC/WMwkqGVqZaIj3DEVrb6GQQyhU
	 XrXpFctmhWT6MARcEC7oGo5hCZ9ncqC0gFuc8GppPzJHdK9qvtK4mWgoAXYHiTUEbYNAE
	 8uKmKPavsNy6rgOftG/z9e73WBfTrhYwiqvNn3iYSLWzp/lSzLVRVVs6nJN2UNoWpYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C7MnBKwA;
	arc=none smtp.remote-ip=209.85.222.200
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA5606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 17:36:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFBA5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C7MnBKwA
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb71b1443so189889485a.2
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 10:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793381788; x=1793986588; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=945dpUI8tB2gJpRVSolSGYelQFbEaHJ3XJYtxTvsE3E=;
        b=C7MnBKwAUPTYYlkAOmorJ4HwoWd1VoQ53EoN7Nh9Q4Vp9naIL6MiIGS1HEwS6w5oDN
         v39kJ7pDAs7SllQpwafI1S8lysxr5PoclNXr2FZY/3q7VlQPV3kHJqadTWlbItOIjRIY
         c05yihJm5qjjZeMmLmDFe6wF9v47Dtz4pl5XRcLmqZyODViL3nzwxvxi52PUey10DAd+
         Bz0leMYH9OGf+VqRWP3HL/t0YTpn3rKaxOcZtVGM0EzG0FL++1DX8ZPbGGgMMDUI2kFD
         6291cQxubb5lXUjv+RrlY2GmBZJgYcYNJ5Kajd0qa77wgQbQii5OzuIK62dkmWChXfQk
         PB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381788; x=1793986588;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=945dpUI8tB2gJpRVSolSGYelQFbEaHJ3XJYtxTvsE3E=;
        b=Z90sNpMx39qbbTpQ4mAb8w39l4pWfjSGAotUfTBSk0RGNrhpyEpVoxyKCQ7wjOinRz
         n/TcjIn6m2oI3SfCwSOKjec5gYnAdbiu8pFc+GX+ibeZgPjcafI3cCY6rMep5mn7akKE
         4uD+rwSeQALHWzViKu52eTzlT3mS7ljivMuNVt7c8ymfKoyTP+Ob/dY9gnEx1y2K3740
         3MlfelpYOtuUXoaGFCINQ6Rv3jYQjPVe+j+P+q7Ss4QAH59wN8Nnb5dd5E8Gs9VyRJC4
         DH76HKSCofQQmBCx9bwToyje/xkTJ2AujnF4bcF3K2MSJDeItyNRhnFL1SUc75D2U8uD
         dxFA==
X-Gm-Message-State: AFq9FYL6/cvW6faJ/INxYi/9SY54tI9A/Sg/GCksbrsy4q04rTqziMRl
	cVlK0og9gXnf3paOyhF9Z+owkAn2HmVr5vPlcDYYtkfAiUcQXfnPbbzJvW6DU+1fUmUvnL37Tgn
	yRnYaRIgMtg==
X-Received: from qkau1.prod.google.com ([2002:a05:620a:a1c1:b0:93e:d0fb:f14a])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:2b43:b0:93d:92a9:1a5e
 with SMTP id af79cd13be357-94421799683mr520623985a.37.1793381788178; Fri, 30
 Oct 2026 10:36:28 -0700 (PDT)
Date: Fri, 30 Oct 2026 17:35:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261030173556.1873811-1-jmoroni@google.com>
Subject: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma co-maintainer
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, jay.bhat@intel.com, john.s.lacombe@intel.com, 
	Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Tatyana Nikolova is currently the only listed maintainer of the irdma
driver. Add myself as a co-maintainer to help with patch review and
ongoing maintenance.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a6e6ec629e0..52952b1c8319 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13118,6 +13118,7 @@ F:	include/linux/net/intel/
 
 INTEL ETHERNET PROTOCOL DRIVER FOR RDMA
 M:	Tatyana Nikolova <tatyana.e.nikolova@intel.com>
+M:	Jacob Moroni <jmoroni@google.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/irdma/
-- 
2.56.0.317.g454f8302e1-goog

