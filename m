Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792860496;
	b=kt8/iCsRkw58hxiljQhOgvfm58xBqEzlbNWMwmjASxlTWGZybU5KvWUq15yK7EBYgqvj
	 cQGB7znapFtdrQ29vc4HHDrQij0j9x0urhKkTn2/rOS3IOoqpEIzf6k4C2wGVW8eKLHrj
	 kLmQzhe+GsJ4yqwbVtNO8VsDcyzYUHNC/c+0aa75n2/WW0vKDKi6H9ZAKBlNwtg0fv9pL
	 hK1fyc5DtwE/rWcnBAhsZT/bFrxQA/UDY30tGoWhQXR1eGnxTOrqwfMIrDwyTl6OTdnXh
	 z9cJVawGvUKNr+ltbGYiFmJRe95bzkxPfl6kx5q4NO80KmYKOtB3CcDbywALOJCQS+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792860496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isFDLv8vN/snFPyaQLe+9KSLlWtekB0w1jnYJnzpvG4=;
	b=O5Rl2bf6EGFztpfOT58rqaV4tXTNpyaMJVOD6snGmMxmfMpKU1qY6aq8o76bIFLX1D5w
	 UjNqz7QywDcIDDCDLA1yUJi7Zic72UFXoPoOy8WklRC3bpe5dNq3mjplBmwnR4JAXp6/Q
	 nAfufvdJWNPcp5xu6UYkWypG8rigH625q97lrBhM2VUg0r6y5AhhV/rhtb0NakgnLsoRW
	 RNIhlyBS9NKl9TXoCNNCXoEC9L7upFcXPP8FdhfwpwNDZ07v2v2aDGXpY3ocgOtZN6f+C
	 m1EHOHHj0mtiVohNiB7pYME7DQ1lTE4Zj0ZOw3PsAqhTMeguE+XXfWvOwc8ZhcNRINA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=uGZeaz9N;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7356C606A31D
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7356C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=uGZeaz9N
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so1534433a91.2
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792860496; x=1793465296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=isFDLv8vN/snFPyaQLe+9KSLlWtekB0w1jnYJnzpvG4=;
        b=uGZeaz9NSx8x8gU+5cVfYPY+kB08j9XyRrFWMUzY05K9ULUlFZQLvOrYR7d5zfdDSY
         OENhR8C/AekQGYvo/bT99vvkW0/rKfFydRbWCkudpEC0XmNB+0ARnxjo9WXk3bFqQ8VS
         uI3IPA3/93wuN88jA+BPyVvpnS5zfJERS+7UwiKD2f+0zromq4oVSdAN7HZ5eXwBaNwF
         fd3QeQSFGRU2sZjJwNMwF748LcB9ExXzJ4z0p/tlV8UV8KhSJ48HIq3QlNFDfquR+HKs
         Z34YDIG1yDQCcyA5B3ljIYIlxKnCq7RPrMq+WCK41KYLmQHDI5agHHnYfDXYhWpx/4ZP
         2XyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792860496; x=1793465296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=isFDLv8vN/snFPyaQLe+9KSLlWtekB0w1jnYJnzpvG4=;
        b=pvnADQHjm+FF/cMm8uT7h4Cr6f2fQKjg8EM/ER/S2q4GPGJL+Pr4sr/cH4M5WzJEbL
         +IfIj+pZ4Gd8eNL2pw47o4Fx/iam9b7rC34UcFHHkFQ/u2G4sZQypckE6FVub7QD7bxQ
         g1Rz6wccuCGURyi6k5hDBxqzoDc5CKgIZQNC726lkUXcEcq20YYkVrtvKaGmXlE42zQf
         LJ03JBrwAjyvmzUijJaF7r+t1TQuRNtzdgKLGzYhCRkojE2SdGD/oDmbLW++So5Dneeu
         CMzeeABBnSghOF8E/b2FlrRntp3hmAvCZApndEVXxdBXagmkYhMTegRj+tK6clO67oFE
         ySwg==
X-Forwarded-Encrypted: i=1; AKwUvBwwn+cXEd4f0d2IcZl02f6KidIFT30vZAqd8+Kqsz1qzzbqASx4FJRLNj9GHbfuNEBA06QCF/hpnkFe@vger.kernel.org
X-Gm-Message-State: AFq9FYLL3XXsLzPHGauB6VU3zq+9vb/vnK5NT7c/ccRD7kXQer3RC/za
	YL9lMlxEx6ZaTE3/JrCHUGJ5SodFcK5hBAREP88TKOqr8jxXqUKyKfsE3aWuTSTe4p4=
X-Gm-Gg: AYBFou0KGVwHBcOoFjLXE0M1K4SC87NG9gkLWo8onmLEt9shbnw/sUVkcryrIcT8RS7
	ssfyHMC0p2yNaEghwcxdzh6rwUlddid/G9/9U+EK2ygjGzAn7VfOIPimMGHuo38pz44ENG1tcmP
	SckM5eDe+lgsIBBQnUYHHgg+Fw0gYo3m5j+p7T5xXOdQ8plhO0ik+GYW104M2vxMBKFl1VQQt2W
	zz+GL4UO5pMvBX+lXf0V0vBGWa/y5JdnqX9FeNncIGcO+t5f5dWN0pxjhtMzCyyrvrnAsJxrklX
	Kcgr5MOpNPtH/prRyTUuWLq0EVAfV9pNkJR5UNhCVSKDtJKttkeCUfO4ru2IjjH0j5AS0zO/2hU
	ZPALMe5hJRKPu8jSXfKJxA5nB/J/2iuPtrfARfL2TxtLKz+z2gL2rLOqhdb5O64MpyPWc6TA1pu
	buk6zT8OeQm/KgJjY8M7gwN2qKU20Eig7yVj8+oLgtpCsQ5ZiyAHR1ait9YUPI/ofhPcRP5Zf85
	P0vNjxWzHA1Xd9CHfBHRtu/V06OGDgQo1MTTq/Sud1lkzqAw4fBle7rfz8qgW9VKFzUgMGZ17ZW
	cAhPzsXzIGhzbP+JuKKYefHZjg8AjSI3wGGUQYPVb+VKMbt5QDWg1ZIuv3MjzAHL
X-Received: by 2002:a17:90b:582d:b0:3ac:c024:b275 with SMTP id 98e67ed59e1d1-3ade9b2ef33mr2135648a91.9.1792860495722;
        Sat, 24 Oct 2026 09:48:15 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba31797sm2193053a91.1.2026.10.24.09.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:48:15 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 01:48:05 +0900
Message-ID: <20261024164805.3531156-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <65d23010-ca3e-402f-8384-732678b6ffb3@acm.org>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr> <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr> <65d23010-ca3e-402f-8384-732678b6ffb3@acm.org>
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

On Thu, 22 Oct 2026 08:57:04 -0700, Bart Van Assche wrote:
> Why int, which is signed, instead of an unsigned type?

v4 is posted and 2/2 is unchanged, still int. The cover letter keeps the
offer to make both unsigned int and turn the WARN_ON in
srpt_rdma_read_done() into == 0 if you prefer that.

https://lore.kernel.org/linux-rdma/20261024162852.3528224-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
