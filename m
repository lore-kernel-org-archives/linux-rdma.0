Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787C726AC3;
	Tue,  6 Oct 2026 07:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272367; cv=none; b=GjuiIj2bGkLrlrtC0JWlyrdC+A8sBqjhD1595cXTHAljArjSqNDnXGvkeSmlCbHgzOhOXR8JLfu6/EQYvrAOc+PDLUI0+OIuB3AbHu/9/a/CbvQVSST9GHK+kh9GiM2OM57qX5Ownwg87NWW/VwZ5rakO0iawaUWKfh55kcxZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272367; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BfKG1iz2SJVavQdXzWiJnKUqvfkvOIdRf/UVdv7OEDWaQ2WmqznU4uwXS82RITbYve+tFof+4Gj2+MEmC20pDMVJBHjh1ibuMY9U47nDKN5Wp6Vnll20OAAWWSNwhjg20J6BMLN6/4h+LZeQdgNHhEg7XVpMGpVSuvR4R50Gcec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUQu6N45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUQu6N45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3363D1F000FF;
	Tue,  6 Oct 2026 07:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791272366;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUQu6N45s+FtWGzJ9VcAiQ+YfYgfTeOSV7KJANlBPnNtV8aXk5eMHHmZRMKXXWfkS
	 jp0Rz64GJgJBnofsOp8AtGd6ZTKkmM+PXhO5dJkFfODwH5GbMlhkiJCyw63HBEua3h
	 808zn1HgwXEaNfn61fIvx+/BW8xtA+XED+DvTNJTvzDcLFVAZXheL9zReyi/CrtiMj
	 2JIeZj31Fj2fFWy56e9Z3Gn1+5ZQNCLkyaLQBqqDcN8A6jgn969WY5KyNesCfbqnOm
	 2PrvLUFiSGnvaYfyOV/SApYOjeZ4nD2ac1poLDrlToKQcF3NMcrRAoDgCc7k7npI/z
	 SMaj9W/88jaGQ==
From: netdev-bot+sinfo@kernel.org
To: Hidayath Khan <hidayath@linux.ibm.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pasic@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net v3] net/smc: fix abort_work termination in smc_conn_free()
Date: Tue, 06 Oct 2026 07:39:24 +0000
Message-ID: <179127236468.2231598.2327407862997104282@kernel.org>
In-Reply-To: <20261006073550.1595003-1-hidayath@linux.ibm.com>
References: <20261006073550.1595003-1-hidayath@linux.ibm.com>
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
