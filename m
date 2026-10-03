Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467D20FA81;
	Sat,  3 Oct 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791052779; cv=none; b=YtymlzPrCA/g73SiyXMp3mZh4qB0GjVTY/wRm7Be+kybJz0M173oVSj57e6/4NttUHlYhu8mj5k1SySRix3lhhwSTgf7uYUcJVfTZWLIslnznKeKUpBa7GdKoBQmd5w4X4/m82xiqNlPYYpou2fVCg7wCHzTOfhWTIdHecPbk8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791052779; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VIrVljIp+CJa2BeFbqft53Q38MHUQL0cuBjoGrOQXZwupSEU/ZQMBLEbA0nLj0HoVw2FfhpSlyDocoyv8kPboZK5roHoI82uu2B38RCUua1AE/QiaINxI/g8Do0tUJWJ2xgm/MBswkdwXO+wLOIYAE4TQL315JUdRr2jhIsaBdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XE77Es7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XE77Es7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931021F0089B;
	Sat,  3 Oct 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791052777;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XE77Es7KEyGnIGn8HZqUIO+OPJLAptwDafT6vzHrtGzWjpfRlOUdNEM63DfzzaZNx
	 d0Zk1Mc6gAPtZgQePMBbTVj0+B0UPt+5oZ+CnOy5GToqjDueOIfN63zRlWQtBrEQWl
	 UPn5YPWd0ZekD8lJ4eIANZ0nK35isBvw/O0ugzELHeGmDKK05yMgSeKv0G+hiXUKt9
	 SES/77befK3hDEQz/NbjXx531tpFNih2Hi3vEGrPDCkWNZrccmdk5Dbhfwn3rE3B8B
	 85tQ9X1qewWW8SZ4+19cFWgNVPq7USVTMhlLT05gRReddCkNResuszuKH04T8gSY7O
	 h5YIvmsLG8mBg==
From: netdev-bot+sinfo@kernel.org
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/smc: fix link group teardown races
Date: Sat, 03 Oct 2026 18:39:36 +0000
Message-ID: <179105277608.1402591.16173087244761956438@kernel.org>
In-Reply-To: <20261003183237.2284245-1-nicoyip.dev@gmail.com>
References: <20261003183237.2284245-1-nicoyip.dev@gmail.com>
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
