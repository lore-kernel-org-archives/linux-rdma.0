Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B856551981;
	Tue, 13 Oct 2026 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924617; cv=none; b=MIPLgLRvSR2DNTwR71GYKwKiLc4x4ezxxxrzrnPsnIn4X+Y+JCwmAcaSc4Hh+7DaGOcaZViL9g8uXDRIIFqD4iZ5FvXTK8UXPXi5eDlYS8hGP9rrukV+/MK9RACaGQjWRTHU25nbtUWEw3feoDtDzQ9c0SBlY4cDFHP4VzjwP50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924617; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bjubJpBnqrYagKBC5BheblnXJMs2OGtvp0UKL+APtCiqZx6tvhQAgAZ1pNedLD0YvFDjVCtFRElzA9YP5ww6I8RJeDrb6klBWyzDxZluDdG4L9vfvu9RqZJ37jnKTQbEHYJLGuPCH+dI1BOnPQhlFs+f9JyUkVOyzartDZKtw20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bI6CHf3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bI6CHf3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D511F000FF;
	Tue, 13 Oct 2026 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791924615;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI6CHf3fR0QU+fRmm+u9FS6aHviHyNZbd9tKOgZNyP+TqCG1zywD2aW3q8P5WOm8H
	 qJcrz6O1nJ0EwFgf+Or/vhT98YCyBprt6hjZO/tZU2Tqy3KHOAYZbVgsvuw3GJBrP8
	 urf/Goa7AspRDoAQGEpal2orm3Wy2d3XyTxlW6X9NPMyd94CFjoPHVpo6zc/4mHurQ
	 JHoh+Qop6SE+4rFTM0ofah5ZNlNNRb6OeDUy1IiTmR8hsMQK9lRd0o1CyzfrrA2ddT
	 nxk1L/UYT8VDmT0V8GiSl9Ma+ocTMEywUjCWK/PopXUt3tXyI4H+bZQn+SiIhhxEK6
	 r/Oh52I+qEFsQ==
From: netdev-bot+sinfo@kernel.org
To: hexlabsecurity@proton.me
Cc: Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>,
 Eric Dumazet <edumazet@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>,
 Jakub Kicinski <kuba@kernel.org>, Wen Gu <guwen@linux.alibaba.com>,
 linux-rdma@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
 Hidayath Khan <hidayath@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 Ursula Braun <ubraun@linux.ibm.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net] net/smc: don't spin in smc_rx_recvmsg() while a pipe
 holds spliced data
Date: Tue, 13 Oct 2026 20:50:13 +0000
Message-ID: <179192461349.160550.6483179052339460031@kernel.org>
In-Reply-To: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
References: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
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
