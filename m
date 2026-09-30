Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D67B2ED16D;
	Wed, 30 Sep 2026 07:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753633; cv=none; b=pcAhLBf6fXDn/PI+v6JxA0lJ/Wu9NkQnVpi2feddGkFNnvdcpXFEWr8uQzRUpVRnAHlXdfgLWD2mTWZMVg6VpQZ4RPauKhQUyj9IfYf/yHD5RjygWDp3Atdo6jWzOIkTfzoi6T5J+UmVyyoeI39Zc9dluOmn1I//sZyOp6bhU8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753633; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EA+RtbLKhboSg2yD/9HszQyVeUUzXOezyIWSE/7AVV7yloCONCPj9Vsut5BknwWSqruv47KhKbAmAz8xlizxk3E3krFbnI3cRO6WlyTILqXy8IAKp5ttkwB0VsKKfz2FCqfUXNlJtdzJwynoG8ClwYyHn64YXwZTH3Fxf0d2v5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KniRuBAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KniRuBAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042EA1F000FF;
	Wed, 30 Sep 2026 07:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790753631;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KniRuBAsP8MkgTNcFiK4tPsyMzetKaKNwLjUJdxAmGToss+vETid4zdtfz9rTXJry
	 vDxNB8jeEgD/K5wXROauf1alrGeszfpOSzStHFKTdk/VPAGkn8sePbrLPg0WSzOxRK
	 fk9BxtRWa1dwkCC8NvEo7T4DOof9WUjMbeHt3ksVPnghRvIoA/qi3uA9PM85medVR+
	 6n+p6PuCfBdsUiWC/RMAffa4s4CoX0+zOG79J7O9V4wU+tEaDRRnIJxSfis8wO0bge
	 z8WIyIvOBSNSWpAa1cCTRr3Oh0TopzRA4WHjKv7sjszkdt55yiteky229y8qpGxseV
	 I5/nWn7zLNm7g==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v7] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Wed, 30 Sep 2026 07:33:50 +0000
Message-ID: <179075363052.31693.7276499571222525560@kernel.org>
In-Reply-To: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
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
