Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9154CDDE6;
	Mon, 19 Oct 2026 11:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408394; cv=none; b=HDcIfO0CGZn4ugPCHq3PACc3RyiIQtFXIpwx4D9NudNjW4AOD4/yuxnkEi2I2DnDoLGoLK/FNLdd/B/ZcBfQLQVbhs7YOAxRfrpGhO+A9se96qDGkcyr3wTTlhGpf0Uy/b91EHr7RnHsaO/ScpAC87NsqROf5oK1E1AbGB9M/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408394; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ppspWsER03/k3jCGK3rhPQUCrvUhVBQPvecWWQiaARY8CJUNbujXCoAAc+Cxj6wEHPy3eoOaDmjCvHfhy8BO6uMLbsHmpyfsd+8EFGka+MRb/BX5fuNpLL8UVoVcdnlxwahmSzfVzAU25rNHongbfDC+uMmz8SzODXBwwjnkXUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjXitmKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjXitmKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA9B1F000C8;
	Mon, 19 Oct 2026 11:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792408392;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjXitmKDUDeAdudsAEx6I96sE7xkYItISNoBsBQyfLp2fs9ZvDXg1nJbxtsPuGgh0
	 JiCs2U4Mut2tWTxJC9zLBUCvAfbxcoOShjpKFPGTyWQVLdZVWfXCzpmu14ckKP2wjJ
	 ltbFKMLiIRep52i+TuksBoFxQ1gyY6PQJEQWoSNc5O4F57IVQeXsNeUWLjK6jQlKnR
	 ehl0rqQuYA3+oU1UIx291paaeEYXkxfSaUxnbDzSgInZSBED8lxXPckp+PXsJB+sTW
	 JqqRfAhTfuPXGGwawcRICL/7clCM+eb/pGndgrQjbOE8KNaSS9+T047O82Pt4cycZm
	 7p65KDcOZQWyg==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon, 19 Oct 2026 11:13:10 +0000
Message-ID: <179240839082.3290.14556767471721761174@kernel.org>
In-Reply-To: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
References: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
