Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608425;
	b=1gsrm04cy3BYMHhNUsF06baF9grwGsM/5Eicaz56YvcxJSWCXLpxyWPML6VkR4GFFww0
	 cjWLrDDCyEDABkd/Mcy9gUruUPGIDiseV9jhs/dFE/6OtF2YVNVnc1TUpTzq0v8S9j5pG
	 0Nyk3BhSoTd+QQsGM0Jxn25W4L1XgacPSj6dc1koZCRHRO0+lxOF6Pt5nMblKMSe3RPO5
	 JoejIy5nHGzYOtjedMgt0IITcZR80S+K3BC/ODr7AAIMY8YALVxX+te+4mqhtvwt280io
	 jd1myXmVqaMUmNPvMFoGG+/Rx4n3f4Ok+XP8KNipSb23WupXCu0ifvXYHn4jKBlVzqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=SLzhqG8pDEvj6F+5VxWMY4T6vKOHocxnUklCm7H1nM/9ckhNEx0BF2y89hQ15uNddGAY
	 FMDiynxW6aQSGTUmovubesNcSTRe1Yw7cVrl91Ylg3VTWmI91yAkkC+RvB5VLltsPhhkp
	 7MA5DYwWZZWIJVE+yUXxNOr7QB7LVyFwRdVe6SGoHahFAHmYFg4d2MP5umvfGlmC73Rfp
	 3d0kW58Bgz4YrlTZ9kmgZt2SgWlQ4rfPYZBv9eYdzSEbyc5t0o4BqcSpbCiT0a5VdA7ai
	 xJfW6/3cbg0cDFk5Wm8B3nICIs5aOF4112FLdBiV8HJplPMJaQ6NWO+DHlEwZ9AqIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFXqdrNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4AA606A327;
	Mon,  2 Nov 2026 08:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFXqdrNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5140B1F00919;
	Mon,  2 Nov 2026 08:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793608425;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFXqdrNlRVs2GzYsHVrrcBnXHWylh+06W4tOTEpiMSa0atWU3udBa9HHrQ6I0n08V
	 rdfWH/vtT8iAicqVSNK/xAYSurxwOwMom+V1SMDCMklRsztwixQmhxUmZkh4sFiblz
	 kcnVngYyhC+f+v2w2ZGyZ7jicdk0SeACksuuyBAXVap73iOfnNuou3WmtL67tgMFtA
	 q/ucdKIk7Pu18K1KEzRbvAtOGyyQEuOfn9S4XDttZyoMgKwhPOjJIxOl/hvYgm5TaH
	 Kek7AIykzRdS/Z6DiblEE3E0BPrFjr+GgjseC5DU9KLBLQfjZOJcfh8wiNgOZ5y/yt
	 XLZ7Eh0g+XCvw==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v15] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon, 02 Nov 2026 08:33:43 +0000
Message-ID: <179360842382.3286.18382469718020495778@kernel.org>
In-Reply-To: <20261102083122.1098393-1-mjambigi@linux.ibm.com>
References: <20261102083122.1098393-1-mjambigi@linux.ibm.com>
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
