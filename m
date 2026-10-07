Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF41BD9D0;
	Wed,  7 Oct 2026 04:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791345834; cv=none; b=D5W5hwgyYIS24NJIrXVcWQxQfkjoI9KFbFCmFKPTAn+36X9RYjrpzrj8CUbTkpiECgdARfXYqik/iQb1ae3y4aoZUREf5ADXIX/cI13zCrJHVtpBuGnRfL5FKZJ8R6lsw1ofz9MSlz0GuYZE9BkginuFrEZ3yuZ5BHRaKRxNhXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791345834; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m1lyndtAH+aNr3mMLoNXrg5q4q7F4PN1H7/ojcd+zw18dhZOOEXOrBvcbPheAOxPCP6pJ25bu64JzcFD5EiLKCAWUJfT+mviWDLxicO3hxNg2v6ELixKia4UcpXAnV7fMlP1FeiibM7Ncl0uekOMmuc4DvUDWArPCi3KOaIdczU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6jcccpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6jcccpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0DF1F0089B;
	Wed,  7 Oct 2026 04:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791345833;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6jcccpFsQ9cxLN/2ksxk1npoxZ8mmUOummcirC3bu0aCLONYRyM3YaTZTLi8gnbv
	 XGi2fdgVjLNHFhXp7CDRCcfnrkZM8cr7YGF80ucSJrcmCDT+gAMFwjZbu3YXHunfPB
	 g+OHwoP6hAAsQwwSadpysahXji1xVSNp+/YwrMCgAtxQYIArgQtTQdRx6y8AbbNkiU
	 dwgYM44C1gaTdoL1nlYGtroJsjhMVWM7iYNcyPilgUnojXDOp65AUCjk6vNO3v1n0U
	 QgxO01K3s5E+TgvnE4X2zyPjDPUurRzohIu0oQe164dG+pr0o/HB6UiD05Fifl7mSF
	 hkJSZrnQeXnyA==
From: netdev-bot+sinfo@kernel.org
To: Atharva Vartak <atharva.a.vartak@gmail.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>,
 Wen Gu <guwen@linux.alibaba.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Ursula Braun <ubraun@linux.ibm.com>, Hans Wippel <hwippel@linux.ibm.com>,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v2] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
Date: Wed, 07 Oct 2026 04:03:51 +0000
Message-ID: <179134583170.2527009.15228546923733851986@kernel.org>
In-Reply-To: <20261007040009.137568-1-atharva.a.vartak@gmail.com>
References: <20261007040009.137568-1-atharva.a.vartak@gmail.com>
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
