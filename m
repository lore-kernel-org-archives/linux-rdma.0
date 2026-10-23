Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792768000;
	b=4MBEUpCDomh+Ts6aa7J01xOROSAhrhw/Pp/kzrGGn/79cVCJRVgW19ybs4K6gx2rdus6
	 myDldwRblWNuCV5FaI+b2RPQ4f8Hf+RwJmUPktd/e5Ki1wfRDtO5SlRHZQamjm5Drz5Al
	 5BBmGxIu5ECuWeB1NLZvNRn0n5uUZVDKAWy/zcIS6hvMQVIB3otyVxHcBGUMbIr+7HR4E
	 hDuseFj2mMG3o8ulCg02m2fW3LcCyj6y5grlxArbzSnvcWbnLVeuzme0Hl4tihWym6tyC
	 5GpNrExl/GkRlcJEmz2aMPYG368dFoU7Wk2PWGdCOZ0DjZdMfCorv8kYhAnkgPJvPHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792768000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=I+fqG4mAsrSSg+5WnfQZyZqsOljN0Z9m0FzBmiH+VjCULxZQSGQMX6Oa1WPoizsWWQTH
	 IF9un6pDvcpkNSsQPo4Cns8C4876Zprt+6ChEL7HnzkJRUzTj6UkDyYN68atfpswS3qXb
	 357xTCFsWMQjXBuXJiBCVKtfVbEsYTHz1KMcZZ5Qsh9Bq4WOe6Q/PwfjRiYaLWiSqS72J
	 YF8Gnb82GSaDVSqxhlOklgtE69sBfh/XRvsQWk5JmMoiPSZ4zgdm+jYoqJlIEQw4Li8WH
	 8JY4/BrM+heZDEuRLoGyOoC358wiqUp/MZXoWWnraICQ42zL91tJm2G/QjfWjbNgWsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJKHN1CD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569D3606A31A;
	Fri, 23 Oct 2026 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJKHN1CD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249CF1F01825;
	Fri, 23 Oct 2026 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792768000;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJKHN1CDtPZBtm+nMPaUGIERmWxvOmBpCMRcjfNGJH8XXrcSZxSFFcbMgy4t08NVW
	 nf5PfwWNU7fXFOt9Ah4kxWesyCPy9IWWcR8o/Av0xE4ZfOAgkUeIEET03I7H9cduBb
	 3r6TiqJbeoFpXIYqeyzBSWMXyWPpZmIQW/ZbzgKADAjlYX9p9N0gYFi99x7uXQyhXL
	 9gfFIs+awS4TVmsmj6HsCqwQrgLCTCta8COkrcqFNA25wL+DQh2NJpLNCvQgW3n9Ex
	 r+VHZxUf+XBjn94STxXVC7pImGduNgjPrp3AppvjTXeubDHJ1joOoL/8z9BY0OP3K1
	 qGPbiiSe5nrdA==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v13] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Fri, 23 Oct 2026 15:06:38 +0000
Message-ID: <179276799858.3327.5559074809059802819@kernel.org>
In-Reply-To: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
References: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
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

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
