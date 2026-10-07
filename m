Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCB52AD35;
	Wed,  7 Oct 2026 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791384277; cv=none; b=sL5xjJIa7S2zXLb3v329VA8BZyY8IBHgvGjgmSyMYYaGcpNVZdyw4YB2i7KFxpFvAlZuYmnmugIq665IiyQSS1VBeBQqgLxBUtNoVA/k3Cbw0H3PKxtjqUGdEG+DTCzNcn3ZzRqDK/D1bncPxYxGXZvKDivW9TdqPqFA92McEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791384277; c=relaxed/simple;
	bh=Frc+ADQTxRwKDWaoqMQMlUJQ/gCXB8qyIs31/48aD70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=obvELim45a6vIzTYQ6504Ya0s3SVASPOb70PEQimp+RRH+1XIfXKFsxLBFxFHUWcMF2b4j0IbWUpVQqLQGqQg3gMZua34BBaR6BJODSGJy7pCa7iIld8+WdvsHoEy3cPIrLutxAiz+uE5es0+NBmXSetCbwYh6CSIWEPIYaa4KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2cRuCNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2cRuCNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D064B1F00893;
	Wed,  7 Oct 2026 14:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791384273;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2cRuCNqxUlrgXit2J+8FwoXAOW+H+qgxRrwV/nn+ljfhxkrSNToNfCafUvDD7AyA
	 aoSFTvKkp+CGpArhNZ4hsAnDY+qt+vIrq+F/R2+O209zPGUfUoaXy17aWov5w9zg7k
	 pfIRpXOgHIxBlhijOy7ZQIi4fdeh0zwaybfS/+veECBmtqlXAetTjjNGlYQBcd9cQw
	 7tIIlWnw+NSzlpSkxjjVrmFqLgZEFbJsAevSC5kf7ex5Jc7r6W9PSgDxtUbbpgsLtU
	 VOB9HPUbapMRPLUD3k8j8fVcPM7salEMTcvtUesQxnFSH7A9jrsFgY01KEm8Y9zOWM
	 X+cdBffYPH5Ig==
From: netdev-bot+sinfo@kernel.org
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net 0/2] net/mlx5: HWS, fix reformat release and meter offset
Date: Wed, 07 Oct 2026 14:44:32 +0000
Message-ID: <179138427232.2527009.17766892902066077778@kernel.org>
In-Reply-To: <20261007143830.1733583-1-acassen@corp.free.fr>
References: <20261007143830.1733583-1-acassen@corp.free.fr>
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
