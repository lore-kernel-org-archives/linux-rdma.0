Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59346369D4F
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 09:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786698669; cv=none; b=ely6rPCu58TjNWlVjV875bDOgFwdkYiaDdQmbmSRWK5j5pyA/HL2J6oOCs863R0YlgBGyHqlF0PJHGIQNg/VcXkid1gdNhqp6+drNU2N1G10RXrWxyu6cModRkeERb2aFcmjv1e622eaPW3B/beMIGgvvDu1oax3X0MYSfSDR7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786698669; c=relaxed/simple;
	bh=D+zrBT0ZGSNOMO2IwawwUlukirkCq+drXjkafF6pPAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uHdPGDSmSALMN6ZZBOKUu11vmu5BFoHOsDiIJYm9REicC1tVy0VByALkVRH4SNaa8PvZxIkyF8EQmcRVZkrCSnTlaQyKlLjlOwe9NSKKMyieLEoL6hdLMpTm0gXWukv+0xFuJCykwqxV+ehZ/79lstid0EHJvx3pSCuS3VNirR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dUUOJmGY; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dUUOJmGY"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38deea72eebso813699a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786698668; x=1787303468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3rqj6MNuRHMhzwluCEZg0MCNuMGlG0chZi1NOjoeikI=;
        b=Udo8Dzg7UiYA+kG8LXunH0rTRGJJbWx04IFqXZzycOrWs7sb8/Cu5nr5/r3uWOO4qZ
         YMWEDnJ/w7l3FHC5rmEH29w6M+A6dwlftQ4KcIEwmJn4fBCsyMnv5W8StRxQliFJ3fJT
         WTwQzDzPviTb3ZCeOe0DcOrHnWdAzcMfWmHfIvweuLB+hqNg8M9M/So++/2PzDiQNMRj
         72OScgC+2LUkBbdef1zxsOI1ju16oijtLffu0OiuoRuGFmeTd3pfuCu7Vooc2nkChVHh
         A7oTAuWuMhWVzU+mjvFEybVuuyzFbr0C2A29vXze11fc+POON4BpFnaG6yACpZUH5Wpd
         JY/Q==
X-Forwarded-Encrypted: i=1; AHgh+RoI+C78yI4/DwxLfOmaUQjWIOeTBDwKOEcf1a09bHTZkJ3ip8l4WFsfZKmSuZuNpXA5815e9pPGXEyu@vger.kernel.org
X-Gm-Message-State: AOJu0YybY7660/vu1IbFLJ93WZ1ayrbon9KahE8x7ZKhbI/QkBce92T9
	KcxdAjjny2OmzkTYI2GoxRtsWaUtp5+a+GXPbFo4yQgO86174XjKg9jaWFJ4dWXFYAxnTq4obSd
	Fy/ETddwuNPRVcR6J/N4WBLJbmYYeCyyaQhpf+qdC6Kti7us2y27muCqU6C6H0KKJnFdzLlXVTS
	Iqkw1ijHR24vmX/bZjv3lpBKMCCAr/Om7betleU9dum7FiNUvEM6MZwgZXd4fQjojjEqOclXmU3
	dRh2Kg68tdjNzI=
X-Gm-Gg: AR+sD12Oly+sSZh14YbEwpu+7JZW2k6vqbAnZo3oD8XHRQMPkHOjV2DRISTJBaceslU
	JJ7Zqin/KJuY+aSi4QCCTf+sxwKqBC/K+OLplu/uLm74jaAirbloLbU9lFXQbsQSRe4T1BsjyTZ
	olHTH+4cIN+Fi3O5sKpZgUdqe29RtzEjmLY52yk6UmQqz2fdwurp/ITXy8cVbVS8qT4V/Lu5usg
	NqZEhaHySqWIKOVtcjc1YwBqP1Ns1mvOYHl/NSKVPgzQIOKLyK8cmfJ+4XvGI/cPzBW8uHYxYWW
	2foPiRVyHjA7oeyxvbS/QS5ya+kHBgfH6Vmb0KmQuQu0kjXAWBy0FkJD8CCdObNV1WLqiA+7MU9
	qV6V0WfkZXL/jH5eS4t52fSeSYEvh3pDb2HIxmfsq//VvO7wUdxmFN7KtePY85qVCC4C33ENNhy
	6PSDlGkZJAj7u5o9Eu/Lb9byCMZkDbP2EKAw==
X-Received: by 2002:a17:90b:2587:b0:38e:9045:bac0 with SMTP id 98e67ed59e1d1-3933b741419mr4790273a91.5.1786698667595;
        Fri, 14 Aug 2026 02:11:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-394ea8637dbsm659258a91.2.2026.08.14.02.11.07
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Aug 2026 02:11:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dd87656d3so906294a91.2
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786698666; x=1787303466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3rqj6MNuRHMhzwluCEZg0MCNuMGlG0chZi1NOjoeikI=;
        b=dUUOJmGY6K5T+8sA0zrfBlV44rO6wc0Xobq4SWDowQRl2CkZyjUOdrX1YEhnLxTltf
         WFEGqoI46j87wrtEgx/n8pbq+RId9EBzyzZfGXbC467L+/NH/Puy+K7+hHN11Xftog1h
         Tg1VpbsXHTnVLxsYAv8go/r2E1RS1xqeqhHyQ=
X-Forwarded-Encrypted: i=1; AHgh+RofTooepCQAIsi2EdI+heHH2X+NW6cKCoBlbXuzfW1CMTPT0FZrp4igB35FVpj0yjTSM0XN/fXO5FKt@vger.kernel.org
X-Received: by 2002:a17:90b:582c:b0:381:c500:b0d1 with SMTP id 98e67ed59e1d1-3933bad0d4cmr5296266a91.20.1786698665766;
        Fri, 14 Aug 2026 02:11:05 -0700 (PDT)
X-Received: by 2002:a17:90b:582c:b0:381:c500:b0d1 with SMTP id 98e67ed59e1d1-3933bad0d4cmr5296104a91.20.1786698664564;
        Fri, 14 Aug 2026 02:11:04 -0700 (PDT)
Received: from localhost.localdomain ([192.19.203.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413887e3e7sm7056408c88.9.2026.08.14.02.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 02:11:04 -0700 (PDT)
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
Subject: [PATCH net-next 0/2] add callback
Date: Fri, 14 Aug 2026 14:40:52 +0530
Message-ID: <20260814091054.359508-1-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Hi,
This series introduces support for the PCI shutdown callback. Patch 1
implements it in the bng_re (RoCE) driver and patch 2 in the bnge
driver.

Thanks,
Vikas

Usman S. Ansari (1):
  bng_re: add support for the shutdown callback

Vikas Gupta (1):
  bnge: add steps in bnge_shutdown()

 drivers/infiniband/hw/bng_re/bng_dev.c        |  6 +++++
 .../net/ethernet/broadcom/bnge/bnge_core.c    | 24 +++++++++++++++++++
 2 files changed, 30 insertions(+)

-- 
2.47.1

