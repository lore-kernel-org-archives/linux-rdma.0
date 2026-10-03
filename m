Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C464908BB;
	Sat,  3 Oct 2026 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045597; cv=none; b=H0zv0UgP0pghokavpoeE32nn2OUsuBKbzIY4sEJB107SB5mfUOqG1uu55Q/YgSsIkbROTLGBWWVDcf5cnM+17uzr6r2naN4C5Yjj++J8B7BNx9XqjswKDr/iIHoDECDvuR5u5avoSowUi+8Z5I8xidqeRPtnEx8s3z0UnfaQh6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045597; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SM6v4qSsv24IxadWGZAQVdIekNvesP/goI9t8U+C4/MZIr5PCw+wWTwKLJhhAYhLJMykHghNE2BtcZpm5juwfUkwSa1bGUE9zow50Y2utcYfBpbITiRE026UNTTJerjCGYkvGbzZ1CToDgalTpPeGyd7J36MINPRU1404FwHCk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlnoDWn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlnoDWn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D301F0089B;
	Sat,  3 Oct 2026 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045596;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlnoDWn3rqRhX46Cwfhb3ZdNv4dWu/Vavg1lv696ql3ssf1fmc16mBZ0v3mReFt3q
	 nNxgU3EzHpj/YkeVQt+8bF/qcRqQAVJPxS73Qd7t1wmUiD+K64WTJ4Bx/h3U6fNoIP
	 YCyX2nHu6NdvVfZpwNEqohfDepO8TMUJoFLzUKWyJA/DmM2gKNaJZYJ1JFVXnVtw6V
	 ZN4X+R0/pPPBikczdJlzzpNzhC7Sp1JlI33qAfyq9kasX2g56CNrZOkXC57YyREC3E
	 +ov8BzLDLnRMgDudxMatM3P1rLvpCJJ/7SoIP5ocZDqAHSUQrHMYPNcxsX2+FKFZeD
	 WEMCjIFkWX2CA==
From: netdev-bot+sinfo@kernel.org
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Subject: Re: [PATCH net v3 0/2] net/rds: scope-aware sendmsg connection cache
Date: Sat, 03 Oct 2026 16:39:55 +0000
Message-ID: <179104559512.1402591.10188498680112425928@kernel.org>
In-Reply-To: <20261003163526.250805-1-achender@kernel.org>
References: <20261003163526.250805-1-achender@kernel.org>
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
