Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B503CFF46;
	Tue, 13 Oct 2026 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901205; cv=none; b=Xn+CmEMJYfbuZtYXZYJvzKaRFNI5vLRwj8sifdQHJVHuj7Klx6Z9q421hX5BgNwQraxuhgTsz5tGyB2Kj5dmXGTE2HMCxlkbL+NmWOtiRw8e5gtbZNbOwsSbSRPHXKZVfA90oArwJZGGWajkdPk35410VUmN7hudw7oJvH6jvIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901205; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tsGQnbl5UJb76L+9aWYvv+L3mOEtYRe/fFc24wNalpI4gy0rCxU82On/PpgAs+Q0oJ0QwukZvHUsuBTpuE+SUEBv9xNMwuIyfy/N7FHvlEbm822COQPJUs/GvKXKdCWR49DVjcqyOLqpo1eZswX+d2nygn7OQMt3WPSEvC4g3Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmWXegqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmWXegqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265C51F00893;
	Tue, 13 Oct 2026 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901204;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmWXegqj7KtJ1lyMYsl7Fl8DBZIghO3/26scEkThnNXJR9iSk8wG7bS21yRyd+tTq
	 zV68QD51DW3/1orfziWTC//tuOBNA50t/WC3gYQ7/a8IjxijY48eErpAMzQoPZ7ylt
	 M2anpLUrVtprE9VvpFmc54fEFW1pdVGl1KGJdTJxQDMjvlO+QBoOkX10Qpm47PBIE9
	 S9U3X7CidhQGrUdFdgfYbPUGaB2U0zHnpiIG11UVAFDhd91dC6ZyG51wiKZs10u6mb
	 TRo0nJWx3qZJ3lnr4aOlYQBAt27cjdf6PAL+1mZR7G3+WZe2UEEI0Juk3fyMofJRgg
	 1ae0UcrdBxcvA==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v10] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Tue, 13 Oct 2026 14:20:02 +0000
Message-ID: <179190120255.2527009.1699844827628717041@kernel.org>
In-Reply-To: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
References: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
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
