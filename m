Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5291E3859DC;
	Thu,  8 Oct 2026 12:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464033; cv=none; b=jYpprBXd58/Mq0jStCrqCnCGJSW7B68qxpUcto1TeO2ZjWGXV3mjwbXn6siI7SHQ6g4/66Rdu+K0vD4+gEFioWB6b20SzeaRCnXKRE1rc8EzqhWOasKqPHvNp2Ro7ZP617ubf8tJkUcvCTz/iWB0nDL+cR2ErjH9rTZk2UBCQqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464033; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZTb0ZInGB5Q9ta6MahZS7BLbKWhfpXjQYQPPLF2zkFDWs7uQwvtuJKKJ9E+Dfx2UaCwTYkroYXJKMHWbE4LmeNseoCM/55N7kjG+C2scfGC4Mcv8wqKcHICGLWqROZbj3M6WCKEkYFF782HfUdADvWS9ZAWvf4OVG43S42fX6NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLuZYVtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLuZYVtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FD81F000FF;
	Thu,  8 Oct 2026 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791464031;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLuZYVtcJ9ZYcsVoqCHMLqpG4QFAqG0VL7VIYZnGIRxL6K5J2SeWCgEcZPVXXVdVL
	 6dJqC9uS396AwOmIBN6pe2DzFkO4a6+vGQNVCmVAzqstzj8YjxCWNLgxnG8BTENPOC
	 C6FOzf0aVjjs3QvjODnjh0Iwnn5saXXwkkg3jomHSbXY8jQ5RDfu9jPj5ILR6I4JTb
	 17s83T/xp6WgbNFRcdDn8gw8d+hggKYqyJopJk5eRtp+QU/kpmauRWCL7tA5thH97M
	 yEhUAM5cV3jNYQD+3ElsWdIDQsB7SKD+Why2gMl6pQ2J4jrVXWOCuUvp0GUOKYPebS
	 UUIPIHOzid3Fw==
From: netdev-bot+sinfo@kernel.org
To: Shubham Antil <shubham@octane.security>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 Allison Henderson <achender@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 Giovanni Vignone <gio@octane.security>,
 sungbyeongchan <tjdqudcks0424@naver.com>
Subject: Re: [PATCH net v3] net/rds: ib: zero the unwritten tail of a short
 receive fragment
Date: Thu, 08 Oct 2026 12:53:50 +0000
Message-ID: <179146403086.2527009.7882565376185404237@kernel.org>
In-Reply-To: <20261008124940.13371-1-shubham@octane.security>
References: <20261008124940.13371-1-shubham@octane.security>
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
