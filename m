Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970719;
	b=taTRMI7MG3yYValfH0dv4/5ZgyOioAqQH0EClopdqELphl8PsidR5WlTwZJgylMvN+kc
	 AZEl3h+7FiRtBKTJ5oWKM+w6L0U4QkI4EC6B0pVhLcbBxReRSgl/Lkknk5Lt+XAC3gsQe
	 L1Ate4oRsxDUuKkFmje9fi8Is0bZS6RE5ctR5ywqBNvw7mFbSQfKBGBREJuG1MZzqm91M
	 o2RxyE49aEC8IB82LzPEh8szZdWZNwLXO4qENv+EyPbQbOkJuz7agmiKSNL8qhE9Ffxwu
	 i/JlAzYsV75JiK3fzWZkbcQDSXQS3z1nRwZUsRcnv5p9qFoTh4rTN1/xJ1vVdMLprbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=HETRtqTERejFlDwRcWc6BebILnh68XfD1Hq22tImQdB/9irwzhvcyEHqgj+hXsARGROU
	 86GkYhGFeaSdPPZ5Q0oUBd5rfbZrvSIon5+YuPw38/dwlDgPjnkozSt7EFoTgG2e4L1Vj
	 YFhlMzlm5uWCibX1AdfIX1RLsy1Yc7CVcSXU7zhr7PMYLiAMgYpF/DokZfvQSTimZRZ9S
	 jNNxlqrT7qMrROcheMf2k0+JrIF6wJ0C7GDXcuqzpHoYcqh6bTVqRnqUmC4lGxvqAHg0I
	 XJHMpUOQ6L1QlxCZh3v7eNWVa3vaYZe5x4HQc9Wu0W84NIKuBhOPeKBPzlFEy9jv6/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OVwlr1g1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C20606A326;
	Fri,  6 Nov 2026 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OVwlr1g1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEDF1F0089F;
	Fri,  6 Nov 2026 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793970719;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVwlr1g182n1x45bOXoD6sJakmUWubgrgMrjfowyi+ONkh15lxkNV32o9QI+jYLSh
	 83YJ00F+GETQD1UzgiOYR4csjrX/UMmFVHV3Wi+ddhhCWOwDsHgpaMANQQ+lCEIGTt
	 p6gLLk2OKR9SBvkkso57wJ8O8ZgpUwxk7sTE+G8TjbcL0uSmJ9WFypl3apiwNIxWKh
	 FpjBV68jue16sefLFR840f22D7uMxLd4WBA0yIhuOxZRCRUeENZbgHV/TZ8VqbzLFM
	 MseNaQVE8VGunt9GjTayJ9NeLe/3Cgs9YB0CBL3mbrGFxPdd0aUdf7IwembiBR9Vo/
	 tNVBzwBQdsQUQ==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net v2] net/smc: fix link group ownership in handshake abort
Date: Fri, 06 Nov 2026 13:11:57 +0000
Message-ID: <179397071760.488859.2441300053954897931@kernel.org>
In-Reply-To: <20261106130457.1092203-1-mjambigi@linux.ibm.com>
References: <20261106130457.1092203-1-mjambigi@linux.ibm.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
