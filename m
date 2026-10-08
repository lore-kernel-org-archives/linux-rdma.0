Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140003BF68D;
	Thu,  8 Oct 2026 06:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440144; cv=none; b=WOzzBKYAuGhGoyis/lDD53nsnrRnuXn3/01AG9ZDFd9kp6IvjE6qVNaeKaCh4u+jw3C07IW7cdNNpj9xmdNR19NxL3hCIlf+8MJqbScKD15P9ab+ry9m8YRGPDxnD+uPjkVeSY0dWDyMnFT0a9JRFjzYEQJ6p/SxVV4+uRCk+EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440144; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WwTEezonSz5dsjLPScuHdkIBnpvK3NjyX0G3fzTU0f43QXtHsYiyIJB2apynC8dqiKLhWbfFNQHSOWAZZsiaR/+tAPmF7doYdNujjpMVlSvR/8Qyxb0D6Dfx7HHj0NGiM79JgR3FQDzbxiJoVwhymEqqX23O/t4TVjiGm8GVSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4u3FAzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4u3FAzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979151F000FF;
	Thu,  8 Oct 2026 06:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791440143;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4u3FAzQwto4KlU3Ea825SSGHimwCMACpMKGn0jYktSxKcGMh8WkW8LIJfokO2Kbq
	 0Jxgnjoo6VTEATQljDOXIAGpinttMU4MoYUIkCe2223IEEGJOb3flU4lsLWDLI9v+D
	 LMX4UpBOLd9CzBFJYFEee2qFsFXj8mp/TeMwqpj4S/I/PZFPZx6DhqBZi5VnJYnCQW
	 osJ06vlIhfcSmcWHKvQ0kFrsVR7wdGvww2cQ4vnVNOofUezgMbi5G1rvpMMpaGkAFo
	 bT91EJjkyrb7TD8QW+LfCrO+eG/Z1LwOR+L1TcVRtbMlGGminxKoMI+cf1aZ3n4Ws7
	 qPl2ScmL4sAYg==
From: netdev-bot+sinfo@kernel.org
To: hexlabsecurity@proton.me
Cc: Sidraya Jayagond <sidraya@linux.ibm.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, Stefan Raspl <raspl@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, Hidayath Khan <hidayath@linux.ibm.com>,
 Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>
Subject: Re: [PATCH net v6 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Date: Thu, 08 Oct 2026 06:15:42 +0000
Message-ID: <179144014211.2527009.14229815515603894076@kernel.org>
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
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
