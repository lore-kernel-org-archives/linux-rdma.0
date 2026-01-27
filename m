Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DA923EA98;
	Tue, 27 Jan 2026 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769520851; cv=none; b=a830PBm4RdaU+aOM7NuTy8r1fAuAt5E1dClYZ7TqqS3nOXE8nWhFZDY7YYH4dyKC+SdxuAqFhAFa9/LociRbfszG71yt8DoIeSHJncRHI5dafym4QFwF0RetsxyGY0WyUjKJ7ZE+83Yk+pAjrfcxwxwQgwPsoQGlZIVwIltWOz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769520851; c=relaxed/simple;
	bh=xlIdn1HgUrM8LVXol/6g4rITYIjiwIO3VZ5x3FlD094=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLcS5l27uZv1UZx0IecPEq1n6KOkIxKKqi3IksJanXUwi5ULeownodkyo6bB16HYKZniXZFTmqMMx52QyxmwdVsua7xYyGhXcjU+FY0uwUVm5Ce0l6ImL7EPpV8QrmBzsu1xjDtNMsTWVraCt69yFthX8KYAmwhAsH7QK6OmZG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2bs6FiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2bs6FiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC67C116D0;
	Tue, 27 Jan 2026 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769520850;
	bh=xlIdn1HgUrM8LVXol/6g4rITYIjiwIO3VZ5x3FlD094=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2bs6FiZo5CMoGbkGTc+Tggg3c/CTZv3/9QKpvKwth1KTcS+eTXeentZVIH0AIBEJ
	 kPLvRCNDSB7YgZFL15PHFWIMHTWTnnlMEIeTIGj9+12VNt5ujjC6njTRArhfHCrWjj
	 rv3sQIJ5oG6n1RxBCY+8G1MBs+PXQxpHrnWgFuhMIozXenGD90ZhQQ1nPbES5r8cSR
	 RJ5rFSoyxfmBCJ82yN2b+IAv6ONNXfW0kTAWhdlsNUBFMhLNZ4ofGWwQBmvQtjmEkW
	 V4XLMUz7GcqwfeldE5EZEXU4DEmWnkYOvsPUV+b3HX9Qz06M1JMkrvXsa9jca4SUxT
	 NE90ZIV8IhNEA==
From: Simon Horman <horms@kernel.org>
To: tariqt@nvidia.com
Cc: Simon Horman <horms@kernel.org>,
	davem@davemloft.net,
	linux-doc@vger.kernel.org,
	jiri@nvidia.com,
	edumazet@google.com,
	donald.hunter@gmail.com,
	linux-rdma@vger.kernel.org,
	moshe@nvidia.com,
	krzk@kernel.org,
	leon@kernel.org,
	gal@nvidia.com,
	andrew+netdev@lunn.ch,
	corbet@lwn.net,
	kuba@kernel.org,
	mbloch@nvidia.com,
	rdunlap@infradead.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	linux-kernel@vger.kernel.org,
	cjubran@nvidia.com,
	cratiu@nvidia.com,
	jiri@resnulli.us,
	saeedm@nvidia.com
Subject: Re: [net-next,V6,01/14] documentation: networking: add shared devlink documentation
Date: Tue, 27 Jan 2026 13:32:01 +0000
Message-ID: <20260127133159.1404384-3-horms@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1769340723-14199-2-git-send-email-tariqt@nvidia.com>
References: <1769340723-14199-2-git-send-email-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html

---
    documentation: networking: add shared devlink documentation

This commit adds RST documentation for the shared devlink instance
feature, which allows multiple PFs on the same chip to share a devlink
instance for chip-wide operations.

> diff --git a/Documentation/networking/devlink/devlink-shared.rst b/Documentation/networking/devlink/devlink-shared.rst
> new file mode 100644
> index 000000000000..a455e70b1b6e
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-shared.rst

[ ... ]

> +Reference Counting
> +------------------
> +
> +Each shared devlink instance maintains a reference count (``refcount_t refcount``).
> +The reference count is incremented when ``devlink_shd_get()`` is called and
> +decremented when ``devlink_shd_put()`` is called. When the reference count

The file appears to be truncated here. The sentence ends mid-phrase with
"When the reference count" but should continue with something like
"reaches zero, the shared instance is automatically destroyed."

Comparing against the lore submission (V6), the original patch shows this
line should end with the complete sentence. Was this perhaps truncated
during commit application?

Simon says:

I looked into this and it seems that somehow the patch is slightly mangled.
The diff describes adding 94 lines as devlink-shared.rst.
But the contents has 95 lines.
