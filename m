Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5664E2F28
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161111; cv=pass; b=iCc7OS+Q8Laiwrx2yyoMmLBr321Dze1mpPvay0RMieWnLDF0wzBK0Dj0KDaBCG+6t61gQA6hfAbCxcpCudJtgc1akjxssKMb7mqzpD8XPeNL4D0WbPwIhM2gsXah929QbJZbT99aPfsIitQBMemCKjpOm2O82G45tSTPFiXdKxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161111; c=relaxed/simple;
	bh=OA+zuIfAlWL/aW+XVAxLjStcjqjSDtI3e37qKUAZ4cI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+Nd29z5kjHkzUimTbmDSDcMY0ota3mkk6QYZdbDtXFAv8bqXP7dopkSq7UMhT/LRzCFLk2arsltCgkJ/1zLAJgHniSvjn3XgRUe8jtXRLFqijwRHltwsc6860MonsiT5YqzGJ/sE9A9ORdY3l7BKMH7yZZbQ4J8JzgM54BuJNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HtMO5FBX; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HtMO5FBX"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8935f42e8f0so1427368b3a.2
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 07:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792161109; cv=none;
        d=google.com; s=arc-20260327;
        b=CFttKDQfqOpL3k32T/P1zjzi2tx8UaFXSLQ7CcR3+zHHFiIA/EWew4dkPZQj3k4LFp
         /jEqAf74y32XludfzDlsgxTIz63r7RCJnXBAJY/ZvT9PzP/TvtohqA4GQdNW2ZwESKwz
         fhaoO6j/+E6t2C6NIKkNt5aZZ2kf4coiMT2uGZfKggHUK6yEGp1zpMXZeSw1qg4BIMt0
         83sglbqT4O/qMiEqlB+RJ+KH86+7Fc0GaEXjs7EMfbmvsM5l9LSN23K7JecgLG9zesYZ
         I5qBcv6UOW09u20hd7W0a6Hk1Jaoyhhn6UApESGJ7fBexMu/BVGvjkrgeEymDcBozMIS
         KM1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OA+zuIfAlWL/aW+XVAxLjStcjqjSDtI3e37qKUAZ4cI=;
        fh=h0kREV1BsJf7+vYJWDrm1WtLwYtqyqAqOUAGS8cdzy8=;
        b=X+LWx+GrwRt551ha0ncB0qbkpXOx1Gz+Vm4v+0wqyB/9b1Zy1y4MpuHCPSIU+OqMqf
         tKLewizDzeMrI8Y5TIZa5OmsTP7k5apEyo4u4zyA5HSTxIqVDJf5BwISq98a4DihqDm/
         SsPlYXe8u2tM/7I7VTKLhNADf4LZdlnhvDT0b6sf49Up0j+1y1gLM7rqmNFrTAsAxvOX
         0JmR/usmROdWrpjqjivML7MsNjYcfjf61rrZz1gz7sbfDn9hEqeSQ9RnV6JZ8+VHxEND
         F7Kr/q0usGwtB/OzGrnASKnMV0gJ/fD2RuBttt9GhpAQMriOLbOxgs78n0WclADBNNC8
         t8GQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792161109; x=1792765909; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OA+zuIfAlWL/aW+XVAxLjStcjqjSDtI3e37qKUAZ4cI=;
        b=HtMO5FBXXvWNMek/LVgQzl56Ew/5N5bPhguqYToZtIcwsKaxlx6/MLAmAxyMuWBiYS
         ATPOMUe7W30sXNSzHCu0KMu8/H6FyGdiQo37ygR9sBzn6dISRZxFTRjSULKkzVrsm/Yl
         l+FuJdRP5nkx+GjvofW6wn4OuUeW94SqloVgxHY0SBLKfimw0e3YEUBPTORPTMym2IE3
         gw2TC2Pzwhf6gXZ0PyQPVrBkmkz7luW7cBMydKfn2DYq4BqABLrJbh7BXcR4cuK7poII
         v6hzl9VW0PStEkR+Qzjpdr25OxTGrUIQFcLEikQYBO+LL9Nh8qsAWOVpJcPtAQfysTX7
         njrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161109; x=1792765909;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OA+zuIfAlWL/aW+XVAxLjStcjqjSDtI3e37qKUAZ4cI=;
        b=GEVRq36VjA7rfEjIoTfPJNW56dBqTapqaKhyBgmN/I4b3Hl2M79VohiAI0POXaMj13
         YPoPTVNXhy7sFBdf0uflvwP3chheUneCLYY9d6DIGMRD2JQwvrfRcAWNOZcmLXb9NjtJ
         9I7Fe0ilPMMjNreeCd23X5/dCDHElf3gDaQG4LxrTLHwTyzF5k0VekwKhBmM/DHQk4fq
         1/5gZtpAqoo2jfQl65jV5tsaccXObNHp5zWRdv1NeKSGy3cuERkZl01YVH86G3CqVRjh
         So8+lsHY/s2Zi7xclweYpWZk+jNQ+UwmmZ81l6kqB37IGLQfDeY6eU6tEb0n63rO7anC
         eQnA==
X-Forwarded-Encrypted: i=1; AKwUvBw1AMUaNJydZX0IajONsC4IiG6i3Tyx2m4KBrImFJAwQVuLjpYLS/GtOAlqGGWO0KUEQKMP0rblpiyi@vger.kernel.org
X-Gm-Message-State: AFq9FYIjlzgHC3UAbgZpuskXWCw55GUG7SIXiSon4HMOGW3HYQzZoQdM
	uEpRIfqrr3gSGWSMPoBGANs3Hnk6yVG4Wydom5cAZRoCexSkLsVf+rq1DUG429DUalyWdyxy4QQ
	IHYd70wAscsU5FgzQFKaarcQhgAAkBw6o9mG5AXiG
X-Gm-Gg: AYBFou2nma97rqbZ0ryk/EBAue8ioSs4ZvIcvEK9XpAP/pQKOih1eU7BWABwTNMmbew
	yoKCkitXlfjqm9MR02uzrtXXpNqIRS3O9OoG8UzMG+YGuw6i+XaRBtjtZh3M4KSaMYzzkh2mTh4
	A4I1ecLZrzCRa0xaKvZxRriUbJ0vg22v3AyoFimNaZBxBBkPOm7j+mp954C4e5SfnFT+mrunA2K
	Ip6x+yHz75GxuR5QNCKTM3TztW/QYdejCOAFMchGDa+GD39ClBMHK6Y9ABUDTKM6qbG0Ize3UEQ
	mEM6FfCg+gYIKiM4RvW1r5oLTRhLdhMqADomK6AkuD7P24yZ0eXGDxABTn6DEQcf63m2BsfXAzI
	K71V8WmTScd5K5iKDN6Yn35CV
X-Received: by 2002:a05:6a21:7111:b0:3e1:d874:7c1b with SMTP id
 adf61e73a8af0-3e1d8747dabmr8376056637.49.1792161108833; Fri, 16 Oct 2026
 07:31:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261015161756.3078300-1-jmoroni@google.com> <179208986858.417468.8994738327508258200.b4-ty@kernel.org>
 <5904f535-c9d2-4326-b149-91b72938173d@samba.org>
In-Reply-To: <5904f535-c9d2-4326-b149-91b72938173d@samba.org>
From: Jacob Moroni <jmoroni@google.com>
Date: Fri, 16 Oct 2026 10:31:36 -0400
X-Gm-Features: AclHuK-P2jWLimO9uu-0GJFLHHWvOJ9aHGZTI0TAuahFrpp7cK-hWm5REiUasFI
Message-ID: <CAHYDg1TBNnXqQDCQ6xw16JE4QQ5JNt6zv1Zng9xxJ5B5bV_Rug@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
To: Stefan Metzmacher <metze@samba.org>
Cc: Leon Romanovsky <leon@kernel.org>, tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks for verifying. There's still another fix for PBLE_LEVEL_2 on
the way as well.

I should have it out shortly.

Thanks,
Jake
