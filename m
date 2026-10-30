Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334214;
	b=faePyYm229mllRjplGpM9MWJhL1hU3pTQ8wmtQQCo/bXyaFnUFZN8yRJuph6qu5L2Zfv
	 KjsiFuk9RTkmO19u90+Tircp8EMrZsQEIkA3L8Mi/pbSHUnHbrIUypLGz2X3V9dsQyIts
	 Fdcbugc771E49KTjKhYrr1aAKCYYyYvw7AACgipeWMe3o1diMB4zulMLWGXuyuIIycequ
	 p7YGOZB3UNfZESehmNkOLnOUdwBZjsECLRWzuECkRpUU/CqnGfbA2vON3Vbe93VF3lN2p
	 1PV39VI6+0uVwS0or7I5nh5f8ePpQShF6Dt3a2GJEP/PmJxCKJChjiVHoDgAn1MBozA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=Y/MxxZ4PwwmlyLsByvatj1z5UohwmGjytBQ/i/48f1mGMkuPP9rDOC15/6yXylQoG+MN
	 552s6zAZ9/ymH3tj+a4zFq29dXOOZoRzf57WHi82JM1z4EhzLtex+rfm3iFSG4T2rhA6u
	 iRsbQjwffzdwIKluW9ZcXoWP/NzV7c3W+C0kf+Rqnm8rmRPPloIAFE4Nxn7TejswNhqJ1
	 SxnJlyfdLbNASebFnd6ue6CtH/fnNSvyES1PPGSMhINvsFElUr8JeB4zRFQ0JmeBGdgQV
	 q8cgVFAAyEIhnGXxdAshYqY7YyRtaUYNsxGXgSQFPa7TUsxKngpjiNnrC5tE7iAgjEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ba4NRljl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F6C606A331;
	Fri, 30 Oct 2026 04:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ba4NRljl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D9F1F00A02;
	Fri, 30 Oct 2026 04:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793334213;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ba4NRljl+WB59DUchEviCTnPkfE2Y9hx+TyYhwvi5reC/96ySfnrtCKJlSAtrW3/I
	 3RzVW7m79An8BgjDYdtrBkJjA73rKWNXIpNxMApGjew4bevGvA6LJ7MwSoSKgE6saO
	 +DRG3+10qrVTAI3T/jEAs+HC21fkT/URFyJmzK9mqMujJdJxi+1uo1kOjEkdph+YoA
	 P4+9jHU/xAth8GPORikTRPJ7rYF1lqRgfDwG+YC5kUYGvce/UQj9qXPH4Z7iomrfGZ
	 jZ3Q29gEr6gv0FZbNozHeUKMhFtKUa7mphyw3+9lToH2qnrZSav0bHtrCwXCkwR0Ev
	 WbuGFHXZBJ2Iw==
From: netdev-bot+sinfo@kernel.org
To: Kyle Zeng <kylebot@openai.com>
Cc: rds-devel@oss.oracle.com, Allison Henderson <achender@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Subject: Re: [PATCH] net/rds: Do not unpin a page after a failed atomic pin
Date: Fri, 30 Oct 2026 04:23:32 +0000
Message-ID: <179333421262.3327.17329211120340878721@kernel.org>
In-Reply-To: <20261030042110.73571-1-kylebot@openai.com>
References: <20261030042110.73571-1-kylebot@openai.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
