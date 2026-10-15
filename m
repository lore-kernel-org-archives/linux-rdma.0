Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9407E4A8A1C;
	Thu, 15 Oct 2026 08:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052388; cv=none; b=ZZHluJxCgorTm4gHKDP5Hv6rm04MSZWrLemZvHcRGuxb9cD/aJliwCvdmTDYBOYn+WMD8QJ82gkUQHqvuvPEeud5IwuWK2hvTTq/5mRGrIxUFfCsehscOtpnArImkdVUgefRF8tGafOoUuwP4C9Ys9Gtkmd2gXVROiGAhVAexP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052388; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kvMISoYAq0u+bron8lQvjAcYG8g0MVl12DboLsfBeSVjNMYfSgknHSfRBvR7Y0yW0s9B1Mx4j5d42Eef3e+vjgNSbJDdWKWpTEP/HUjilYpCcUaTAW5H91VcZUW0IbAtp73PXUGLr9IGv4+Z/rr8gtkZxZBQZlUokUYlcIOHHhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGmdrSkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGmdrSkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989861F000C4;
	Thu, 15 Oct 2026 08:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792052387;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGmdrSknJVV0ciR++l5V8/fzXF6rTCPBchNFqoagstmliyf4THtiMmBW7zC4v1gDv
	 YXqg3CQOAkEBzj8UsK9DFkKEgP3xnskzjXFSjWwoFCjgX0M5bI8UPzl8dep2J7Q6u+
	 oiEV/FH5MNsJB7+7M6TJ/6AD6+rzCovh5aGiQFr96M0/h/k4eArNNS0BblbFT5yYH7
	 rD2pryyCs7IurAkm2s6HPqEPOWWQYljT3JZ/JSheZWY/VtTTyCIp9m8KBZ1F6Y06Nu
	 KEqoQtaDUaAXX6J1Brdob6DWQrutFHawd3vXwkAqAGGSuEixDKcZ+0CqbgsM90r6Ec
	 lyDUgN7/UoaPw==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v11] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Thu, 15 Oct 2026 08:19:46 +0000
Message-ID: <179205238616.408196.12778446349366057336@kernel.org>
In-Reply-To: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
References: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
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
