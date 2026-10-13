Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D6952E050;
	Tue, 13 Oct 2026 20:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924602; cv=none; b=PwYAcxya8mjTUaWGoqKCGReYPa2Om6mV8iyMV4gwSLBLsfRXLpOLgBHThhlCdxMVtg6mGloR/PiNwOb90dKpGdrTa0/bM45GCskv5LK3tZYyKqggebOKOCepbb2lIln1YHFOJCwbo/4WskyFAm6iM5smn90a7m0VSRdebGv0fWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924602; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t6a20H4hgbX0DXEFBFrermdfBYG/DyCFQ7bddiobqYUpxv2PypZOVqDJjFdUyQdqI2HKBy4U3XdAUv3jvvFmej57SVoE9m/znxrxyiH7P9dpB+KGIlTVAsznHaJ9LqwjbDAwbT6CD/mTywRjWT7dJmG5r3grgJbHsAWWz9CX+n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjPlQVRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjPlQVRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8DB1F000FF;
	Tue, 13 Oct 2026 20:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791924600;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjPlQVRvF4eM5eFUD5EXk5BoyQ+HZgVONvSshBwP+PtxdWIEzM3bxt2ONFsWa3dWw
	 5V1cOWbhvbSKn5xy1KQeoaMgn40WukxZeibzNDq19OfiCz3KozYMCoxZuM0qu6U6g5
	 g/bxTpqUTDIw+Rl+TKBbKS+LTfjPTwITtWettYxM98syqJQ3+BFKeqxbwOJcy33dss
	 5TUtngT4/3OAtttPGovMWfTCoi9BmbMjvRm2ODo95uq7I1Tb1/ArQlnrDQyLCIi/0C
	 Y0zxZzj8WLTGdTTQ+MSXfc3eWv5rxYsbPPqxmgFlAO/Zm1mO4tyIi8rRxKajU/MLyV
	 plReM3KlIkiHw==
From: netdev-bot+sinfo@kernel.org
To: hexlabsecurity@proton.me
Cc: Jakub Kicinski <kuba@kernel.org>, Dust Li <dust.li@linux.alibaba.com>,
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Sidraya Jayagond <sidraya@linux.ibm.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>, netdev@vger.kernel.org,
 Ursula Braun <ubraun@linux.ibm.com>, linux-s390@vger.kernel.org,
 Wen Gu <guwen@linux.alibaba.com>, Simon Horman <horms@kernel.org>,
 linux-rdma@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 Wenjia Zhang <wenjia@linux.ibm.com>
Subject: 
 Re: [PATCH net] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Tue, 13 Oct 2026 20:49:59 +0000
Message-ID: <179192459915.160550.17874285682154521585@kernel.org>
In-Reply-To: <20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me>
References: <20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
