Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43125B0BB;
	Mon, 12 Oct 2026 08:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791792260; cv=none; b=Qj8wTOWkoM0OyZx0nCEIdGI+3ztL/3aXVbKESt+yuCUsi6X1k0PFleY/0O9B135+QfNz9vOkpo1wFwrVB8/sAvCVE6t3cDHYXNW8P9SxT1OxtoablTeTw5+fsgQSmyqWEtzHg+scARIgpB5OS6oqqbqB8z4T1mF1uaJFmaE0GmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791792260; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m+rvLx1wgK7FkChmMRgYNWeK+fajiTKqIpA4+h7Cr6LzlQ0zChgdzkCUt00LVNZF3BoHFproUQ6EYlziTRpMmnMyp8YyywTG8ZEehi7Vlu3buhs+Ih478vlESpOunehBuTiWZ2ucr/AjMa6VuDe5a4+S/OJcA6/MqYkj/4QFTwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHaVLlR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHaVLlR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC5B1F0089B;
	Mon, 12 Oct 2026 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791792258;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHaVLlR/q4q3Tug5ko6xs3b1nELLFX7X9hSnsH+/pauoSokuk7QVtTAH3cj4fLrOG
	 HquraWKz/ftJGNyFyOGFGp46Vkh7HGv24P+VVpGR3P2Nz1BwBXR5tmiUbo3R1Nn/t1
	 anF4GV0b0crXkMZYod0y1ovzDpv+p0pBfm0S7W8MOoqlfOoggvT6i7lFspKfqrtHDB
	 EsgJn9dj6z2Y30FgGEG5gLPbTx9DCboIAhed7a+yDhICedUhsWB4P9ngGeusZRGgi/
	 MH3JTXqsMK7cRgzPucQyQlfdNofQwWb+7Q2MgRffbLbBwXgcynLYUBVi09rFEx6+Z8
	 YmfTD3Shu5S5w==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v9] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Mon, 12 Oct 2026 08:04:17 +0000
Message-ID: <179179225758.2527009.15422843250132893660@kernel.org>
In-Reply-To: <20261012080034.38770-1-mjambigi@linux.ibm.com>
References: <20261012080034.38770-1-mjambigi@linux.ibm.com>
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
