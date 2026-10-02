Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF90414403;
	Fri,  2 Oct 2026 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790974706; cv=none; b=YP0Rw+/N1wTPqDSSUTs57Cb1Z1/pECNonqsiJTdyE8bmvjlaLK2ZDZHlnucRRO4wujcTLP2RQryD4KrUcKJo9yAldYcwZrbZv6xqn+B9OPm5lEURoEhoJUm0KunKHw4oadNDA3qTXORbr5W8QWs70T/ytrxjDw6wFKV95DyzPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790974706; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rGYeFWBnxCrKNh0HMYcBYnVIeGCwJHrFSb68jTuHHXYPAXRHeRMZqFGjHe++zuqLCTi9gNvtehsezOFO8yefNVOaUP2oGyTvwkac82esHCEtf3vo33VCL7vB6He0ppSEwywL2YBlchxqR4enKHNnHG2JUyfzHV7mQxBQkWsnktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+c2iYe2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+c2iYe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2176A1F000FF;
	Fri,  2 Oct 2026 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790974702;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+c2iYe2YYPkc8j4tQg9FeY1F1uuhcVISQJm8Uqt6SHuDCJ/YeYw/ML+vaezMRDdI
	 6U+HkHMBwz/TrS3dl49xzJij7DoQpuGjOq1jhoFV5vF9tBjuRkvq17nplde04TPJVC
	 Llr+8n+3KEtu60RwV14vNF5Ttkn4tBVeU1BGUXZTUTyfgM5/DDwM7QsU3iKPY3udq2
	 mkG9A41kKkZxlHeC4408E1AfRVjvfXm7Zm7zmV2Sr0AoU4zmqVV2hteWwOLyhx6xj9
	 gp5CiFpLXIJ+TrJKpI5za/cYJFNd/QvW7uPiGgnb1XxrFWtk/5jiP2aIfviFVUbFif
	 agTYLCISWLIOw==
From: netdev-bot+sinfo@kernel.org
To: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: saeedm@nvidia.com, leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
Date: Fri, 02 Oct 2026 20:58:21 +0000
Message-ID: <179097470162.1402591.16776600563260914451@kernel.org>
In-Reply-To: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
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

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
