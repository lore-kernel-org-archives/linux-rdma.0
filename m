Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793702044;
	b=THldItwObUHfa/fg3RSywhLSB4Hos0tuNTSjETUc8j2zJjIYK9ECVaetBsxWrgr/GX0t
	 Rvg7IWcT6RMdkwxX0pAt9oWEHGP7GjEc2pTa8rtA29WF86ZqFgmK5SKE15Ory8y694+PO
	 znFIFCgvTbaHKVXYEPx2iIFX0lVHr4a65lZRhUAmNtW1033r8tlgftqpbIV2+TkfjucwD
	 GV6qCo96XoEBzMXsScX/ugX0I6Aa9nXM9vs96R09K7VqsejxrYcSAujALeGEvxDnH9oUA
	 +hmd4eBJ74K9URM5DtgDlUYEiSNptQLTnOSuXidsT07Ls9ZVxjeeyW2DsEQ4P4o+PNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793702044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=TWJd1Pv4Qx7w4DBtTAf7bQss8WOFTDZgvxA9IA5RgRIYkJCD5MCw4+Bbfj3L2HSG8hvR
	 IZcvGwLngDPjavPTI679tmIeRMJK4AtDbzJGwNExNybhVV8P6ifQUHjj443ZqH/ZaDiaF
	 r6br3CSJm9vfTfhxa0OjNj6WgTQpHPq/O2KqLky/bwo0qIiT05/OPYBVDYEhOhwiuWCiI
	 Ds1hY/qnJIEKDRRhcGoQboKKrzKcRO1i4rDPiKpR5+d6K2RhDcAgnVb6B2KD/7evoMpoR
	 1X3K+Ut2YmhXkAYDkKX/rqDxTFcBtoibIOIzzLQNZX1+UO+mqoIuoLzH9m+Gs9Yl3Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZ+VcDqa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90FF606C5AD;
	Tue,  3 Nov 2026 10:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZ+VcDqa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA6A1F000C1;
	Tue,  3 Nov 2026 10:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793702043;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZ+VcDqakHTHkNlGfSR+3mCoK831hW/EDLurxTbSTvU4XHglFcZ2n2iVp56JyD60u
	 ln7hJB3ctp03EkihAR+Y9GzzIwbSpvlraCpIlWo8TFCqCBnW03GumU/wgjLoZXsnd6
	 wLKs+6o3mQLhyirjh9GzqLb6uJMliBuTzPa58H0UHAG3NXlqSeO+PtTT+62Gqy5SyT
	 Rstcqkgis8k+vd2e5UK/dLuhTixZpghnr36sm+EBM76PkhmpRdFgMjXGAhhAz+I4+4
	 tKx5Xb3KsLCU5Y/DkZh1jKrzIp6LdXyRFv15x935Od2THGfgD0JDaAU46N/G10UoGv
	 iV+lbaxrevEag==
From: netdev-bot+sinfo@kernel.org
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: 
 Re: [PATCH] net/mlx5e: TC, fix internal port leak when a flow is reoffloaded
Date: Tue, 03 Nov 2026 10:34:02 +0000
Message-ID: <179370204232.488859.4418810588403081522@kernel.org>
In-Reply-To: <20261103102855.1340650-1-vulab@iscas.ac.cn>
References: <20261103102855.1340650-1-vulab@iscas.ac.cn>
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
