Received: from mail-wm2-f8.google.com (mail-wm2-f8.google.com [74.125.225.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F104854E5
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781682; cv=none; b=ex8OwUigCvgfFSmCGaVch3FKuN8JpvpUNu5YgdzQ/vxSifwM3YCaB1oIDW9/20zbpKxwNWgII5/X6dsJygJo6XqBEz5EIqQ5EbZmy6PWoJJZLvqszVGLz+ZalGLhCHiHoJRwrmTfSs0hkF3uCDuDacez+8/buFHMa1pgwDZ9G78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781682; c=relaxed/simple;
	bh=zisK6DSZbOvLPwi/dAk2097X/6CPmHmVmuul8j51ByU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTCMpftDMK4+D+5sgd4LNV2BImPFpRy36XKNyDjlqsQKrIJORFttyWPyQ/ED9wbuAzR7pakMZb6fEvEjnZE2egCadPBRhF8A1PPMzEsXScvoSmmsk/aRHQu1OJ5QRdC6EtQvCO+SwE0xyP7L4tLU6RZHEt4fSK/OLbpbMXyjt9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PzFMbc+H; arc=none smtp.client-ip=74.125.225.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PzFMbc+H"
Received: by mail-wm2-f8.google.com with SMTP id 5b1f17b1804b1-4956bc73c0eso14573085e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 07 Sep 2026 04:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788781678; x=1789386478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zisK6DSZbOvLPwi/dAk2097X/6CPmHmVmuul8j51ByU=;
        b=PzFMbc+HE71k5MHz+pMC4F2BIVMETuZRIYspiXiS/GSAaiGUNGZItVCmI23siOCgxA
         WxJyZzagmKeANJoihEvf7l1YNuO3WAX7Hhca/d0xuvj8jj56uGRoiyINDGDQC1TuqjwR
         LNsvnR/bgeaEevdjwC58Rm7QCbehCkQEgEHg/m3z3Eq+1HzYbjWEWRzHmUWgdkqVkGPv
         kHGMUKSTiyL+TuJrVDdXO22KekmWm+JZpLSYnrQhXxz7OOVffY6EQib0rpq7y/9xx49P
         Dbsu6zZIqa1JwE9x4wgf2IPAiVfaBHJg11GGFbu3zvQsfRz7J7zchnSaSgZcf48nFZCb
         jUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788781678; x=1789386478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zisK6DSZbOvLPwi/dAk2097X/6CPmHmVmuul8j51ByU=;
        b=ObpkfWENo3+ZAbwG50WNYajRSR58V+j5sc484/vykDAMtVTaq/9Vjk637jaFfRLiOq
         g4Jsf6TWpcKhHiqoiwwwu4x21Fv9u2H4wll+t7QJ0wjR4qPV0QoHMAj1nH8ZByzB0HV/
         qYwLQnp1ZW7U+AFNbJBK20QoB8ulK2+iMnqtQtSwjwwdY8VRbXpAB/IIlmSdl0stU9sy
         slqwxWfma4J/gyXN4tPCQhy8cMDPDLOUft7Auh5ehIZ3IZFU/j8lbWTbMm8UA04qfVQR
         cSxH641n1uYVdBgMCWsq/d0wYPUrIY5wIdGKalGGIURHK+G4vLp4OgNODkm58Et/rRVt
         I+PQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSncQ0HtjkHwrpTwD3NxPxlUgCR1uS3r8oGmlZB3o2fgtaU9XCE8eZvGgB5bltqvh/s5B759Lv9bxM@vger.kernel.org
X-Gm-Message-State: AFuF++njEXfnWqKsi9A3Rh4uA77vjEKD1X8UnRHFG1GW6FSIukx5eic9
	bZgbVT7Kpx2S/Z+xGLSyspd848EuYqw41tLxs/nJ3iz5nlSHC72gYPsI
X-Gm-Gg: AYBFou053pZJ5xZ0CdHM68uN2xowZTILMuSNN+Fy1MuKoxWfe81uamx6F2U/d4A+WEK
	cz9A34HozKpABWEsbSo+TNWD1jMoHMOTMAUuz5nn5yrw9/r2yNdTKqXL6Y0uYThYCZDuCMIbpPr
	bTpyHFiVO44ipfUut0dHqqQX4a95z9CsTqBoQXWFRcnUrF9j3O2nm3mb1NFF1SMooGQt3PAf/pJ
	YDVc4tfeCnYiLjAFNyqbcos+GAgWivhP0y/9FNe1e3rSTf2UiF7qxP2PXrQwK7hN9JGMANFffH2
	xg5kyQWvDiVE5rX/UADbqC1kHyXNTzwIq7LzLC16WrkSXaLjIvXkkSwgNJ0RAAuLG5IHBMZsWJj
	VboJpzHtsHTe+Cich08EZRVW/jzgjpscGR2cr10dcv9LZ0TqTXXmCzCmCKW7R+y7wtPi7PmmkJZ
	6k7/zE8FEQP0kHl14pJgxfop0l/ZBedAPk7FrkToo8jMYOhWvdKBxhumAJFTKsvRtvb58PYmR9I
	tVa+0wciOLkOHA=
X-Received: by 2002:a05:600c:154f:b0:49c:fc6e:8cb5 with SMTP id 5b1f17b1804b1-49cfc6e8ee3mr219765505e9.25.1788781677871;
        Mon, 07 Sep 2026 04:47:57 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee80eda4sm383491635e9.15.2026.09.07.04.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 04:47:56 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: leon@kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	sagi@grimberg.me,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: Re: [PATCH v3] RDMA/srpt: Clamp the CQ size request to max_cqe
Date: Mon,  7 Sep 2026 14:47:25 +0300
Message-ID: <20260907114725.28908-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907063251.GE13683@unreal>
References: <20260907063251.GE13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Sep 07, 2026 at 09:32:51AM +0300, Leon Romanovsky wrote:
> All these Sashiko reports suggest that sq_size is being changed in the wrong
> place. Can you check for the correct value in srpt_tpg_attrib_srp_sq_size_store()?

I think sashiko could be triggered again here due to theoretical max < sq+rq
probability because in the default (4096) state of sq, store() is not called.
max_cqe <= 127 and max_cqe < 4224 points to the same issue and it is not
resolved at this layer either.
