Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B272344780F;
	Mon,  5 Oct 2026 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206374; cv=none; b=n50E5j76cu/2qg0ZYCp+ogCHXbyfAM/ab3yJmtPIapsYiF/4iMyIXVdCRPOBUATweUuX6wLGYgvYjozFPTzhDysnEumALlxc3LT30mBExORnIdUNUsPPQqd9vLB4pzDrWSR7PDOYmIqhVUWfXW94kK1X+f7Pip9v09F+J/WWl/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206374; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MDhAobq9c4NP5kMEAPPBm8rMdL+KH3aEaUH+LVsq7IxB9B55sGZF8rTsWFGXft6+L8t9zGW0gl1FSqVtPc6IXsfsaG+h2c1bz2ZpPdZ4kWJfGRX8chYv34EapxsAuclhHEJ0jFQ+AF/qe5v5p+MBpfsGYCxYR9nugsvfEDfeWcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLepsIBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLepsIBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B393A1F000FF;
	Mon,  5 Oct 2026 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791206365;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLepsIBfvIegkLKM4ZNB4+47Vn40pL79B0S6VECDq6saZtGnop2w/1eqk8BxYTY1x
	 fJPDBKqEa4H0UrqzYJkvuj6KlcnqKscO+6ryTB3mqZSaw8a18DnUDPC52B8432Jwry
	 xetj7spDcsAIZwCgEug+5+48dk17A4BmyGZLAdDO/kqtC2SrsPwS/1Pt6ePG678CXY
	 Zy6jb/giotZhZZjdkm+7vZBlQWJg8ewXYiBO9Tsv88xApwaul3cxUsaHplvGvlezB4
	 UKZ9HVfpEU2kEIE52jvvRgoWHV74J54azDyenyhSpNe72CamlLEESk2iQVOE7qHqAt
	 52usuuipzZyvQ==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v8] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon, 05 Oct 2026 13:19:24 +0000
Message-ID: <179120636424.1402591.14325781567092984615@kernel.org>
In-Reply-To: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
References: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
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
