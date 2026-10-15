Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E2C485516
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053402; cv=none; b=PoNpUTJH9T6dF4V3bR8xVQnNHoBjA/xwZk95qFOJEWpMoECYTfXGVHXpCfMmDvMeRfLWsSHvLzIcIZFTiTB49clfWsw1i+AbqAF7pSEHxQzCzUxGDKS37ZqzOyiPmxmwpun82ft+sQnJm7Aj4JgFxglleD9PTOle/boa0+YUmfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053402; c=relaxed/simple;
	bh=rQRacz5lb3GSBMv12F+Cy9fZi1P8KakT2Zgv0K0Uumo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C8ECBGcEiNzmvyoUSxuP3Fuvzq8BjsAQdWgjIfXbJRhFKKcxKhI2HawwY4KrcKipi7NL77mFLyPsv4+a+KEWMY3kH9gV3xz8AJ8+OL3RzaI9jgoQ1LQRTo8vUAdqryzS4hlTJPhN+riB4yyjEIOmXx/UML/jqp38D8BoivX6Y4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMontasP; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMontasP"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-9179bfa9e9cso82050536d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792053399; x=1792658199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=csLZTWFJZwVmJjPK2j5B/Fm6zSWB8VBpn8JFPtRRzfA=;
        b=BMontasPnj/q/KCbkTQAjA2cXNDjjA7rQa0powvrrsXZY1JWW2eN3l9VZXRuyWTqXo
         Wpdv1Q/3LWvn2Cz6QuimQBg4y6G7CQ5PFLgH0to0zNbZttyvBTIQ+wYWxWv4DM7ZfL7z
         gp43A4A6nRW7PSBEWZEq4s2yys5A3OJmI6gtAb8CnD0jQ6xx8lVgolGALi8CWVrqbIcn
         AQ12///6JpZcyrhPkph7ef1dnjT8Din3plLarXFI1iMdnU+IV2edkyLMD/xKF2897qe+
         cRL1saPxmHAvfIF3/u6EL/XsvogfpEFKmnF1dZl82ziEaKP12F3XBeNWIdb/0FQq60kO
         jgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792053399; x=1792658199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=csLZTWFJZwVmJjPK2j5B/Fm6zSWB8VBpn8JFPtRRzfA=;
        b=VRkE6BCWZsJowjH1ulqh5fJ65u1KDXA2ttTlsrhsQsXG1SAfkmgtBZ+ScUaqtzJeGC
         CBd2YLFTCfls0ySyHp0b6whGmKJyBs+iLwsxv0nHyhkqUwc8ii8UYsEExlnwUcbjdijk
         zqD0rdbDqE5IDNd+wWe80aGStjVrYlYGCE+e8vQmR6087eXN4z5sZOau8w24Ino+EV/Q
         du3+9uc+t8oMMJlaH4fBpnISuxJXzNmDxUg3fcCWRxefm/MWH97yd42xG0vhOPdK2QEL
         YD/sVF9x/SCsaJ2696Ak3kXf0UOh6aG9MXcWnu7hWxB24T9iGG1km2o00WCZGUXraB3Y
         laBg==
X-Gm-Message-State: AFq9FYIWEfgpKdzfugrdzMxsrSbfBlt1PCjciHWOXFNtk3gi02SEgWC6
	tZRUxJhH3g4FdH0NzthbVu6sCZh1AnC/HdtnkQguP8dMUei/tv1OKqwM
X-Gm-Gg: AYBFou20dVHkilQRGOWZq0PznN6lHxjAl5vY+8iBRbeWF755zIf37/3ee8aOSGsUu7m
	GsBnC1F4WKYb9WoNCxNrV7CbzmaV0GBv2jSi9gXChJGLlXtbPCC0wzH4j6t2C9nrTt3nqhjzntX
	E0QyMHPuJtNS7MXeKPbZ71Ixi8EtOJfr+3v1lS3JwLxuXMf+2FQPqz5AHbzxz6r3I+8qS7HHtg0
	io5/LGol0sdqMq0gaWCCL2dD32usB+jN1Zh5vKmopJL3hpjVcsW23TSwUk590KWVMktNI32+TT8
	kJkUQvg4ndJO1uCR1bbFWV+82mLlcbh/dI1qyi0R+POweJZcTzmLsERgS0nSMXHThz1HAqbKTo6
	jGd9pZVVEq6g8f8p0kgaO6zfs4utog92SrGEXe5RmaNoToxVcfkn+d7ZjIOgxslAxWiNL51pY3v
	5Qt5qaur2gpToiqjkMUfqHyBzs6kew5il6nqihPpzkieqQwr+rSulOUXvCFt9A4LBRuZ639VALM
	r6sj5SsnvILlRXMnssfUM2MKSz1HYVUX2jMdAMFHO8ZO0fxIQg3oaHEw00yz4nsVZt/aBeCPrtA
	mClBwFNap7sCsBPhgCpQrH6rjEt+ioaB4g==
X-Received: by 2002:a05:620a:4552:b0:93e:5821:2c57 with SMTP id af79cd13be357-93ebd2244d7mr3256091585a.22.1792053399383;
        Thu, 15 Oct 2026 01:36:39 -0700 (PDT)
Received: from ip-172-31-15-253.ec2.internal (ec2-44-200-54-59.compute-1.amazonaws.com. [44.200.54.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5090050sm711843985a.40.2026.10.15.01.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:36:38 -0700 (PDT)
From: Deep Shah <deepshah146@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Deep Shah <deepshah146@gmail.com>
Subject: [PATCH rdma-rc 0/2] RDMA/uverbs: Fix DMABUF lifetime bugs
Date: Thu, 15 Oct 2026 08:36:35 +0000
Message-ID: <20261015083637.200958-1-deepshah146@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two lifetime bugs in the uverbs DMABUF export path. Patch 1 fixes
leaked uobject and ufile references when the uverbs FD is closed first.
Patch 2 fixes a use-after-free when dma-buf release races with ufile
cleanup.

Tested on mainline 4056b3c9d3c9 in x86_64 QEMU with KASAN and lockdep,
using test-only siw export hooks. The unpatched kernel reproduces both
bugs. Patch 1 fixes the leak, confirmed by tracing ufile release. With
both patches, the same tests complete without KASAN or lockdep reports.

The tests cover core export and teardown, not real mlx5 hardware,
importer DMA mappings, device removal, or allocation abort. The abort
issue in patch 1 is based on source review. Testing on mlx5 would be
helpful.

Deep Shah (2):
  RDMA/uverbs: Fix uobject leak in DMABUF release
  RDMA/uverbs: Fix DMABUF use-after-free during ufile cleanup

 drivers/infiniband/core/ib_core_uverbs.c      | 10 +---
 drivers/infiniband/core/uverbs.h              | 37 +++++++++++++++
 .../infiniband/core/uverbs_std_types_dmabuf.c | 46 +++++++++++--------
 3 files changed, 66 insertions(+), 27 deletions(-)


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
