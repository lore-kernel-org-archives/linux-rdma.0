Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C0149C4C8
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366222; cv=none; b=JqR2sBQQBBTkxo5lKDfcpmzhHWf8uUfXj7r7/XZ1ICzMlMCGnkYOKRH255GQnbU9HZWQfPuxxSwzar+MOgsREzjbUi2ZnevQsaBquQOBpIc7xp7sumqszz865X9/dAscvHnbfinhzNXmlC2AT5kJuzn18aKCc6rmKmj+ffjeTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366222; c=relaxed/simple;
	bh=MxH5ibgqSDj6ZGFg4bkHFSIBONNl8wYT8MgKGwYLqFQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Nj88PFnBmrI0m4TFQP1RfckUzbYjLW49YAbgh0uXLAykz4YyDRg2TgD/ldp0+MXKh2gOMBNmS7R9uAnqaKvVKiLWQEVeaYtdhqBBbWdF2DCD0XxcjzlM1yQT4Y1ZqJ5FERhjQ9b+xhQ7/7/QLmWQt7l7thCPW73VuRUf9hOtNxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkJcW7C4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkJcW7C4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9851F000E9;
	Wed,  2 Sep 2026 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366221;
	bh=CUX9QXrRFQ/4Y3F/hHTJt9n603oDp+5wrcPomFjytxw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=bkJcW7C4k3CY6KFHxVOJhTKeug9bWqo+1+uOnYUS9Y7Q/sbxEZVs95oVXJGIF7MMm
	 /++o7BqnTBm8QvpV6Vt5KRVTadvoh04tdBU8A5YLxDGIDzdMEUrCegETg8g/z289nb
	 3y2FpIrLxx8ysjBxG8xrGlekl3faB1uo+NvkDNokdWPwAycmViaQX5MXA2sYeu9YiA
	 uKcOYxBVH3AYiGIQFQmXrHaTji7O13EdA1RsJ35/eq5KkXCSABkVW11IsD2DSSB+f+
	 EaUcj0F2L1u/Lk7ehTTdNCzIJyOnEk8b9+4lQbW3KCvDqtlDju/13SGYBh05ZlMfCR
	 +Ksgvd0Q3eZyw==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Cheng Xu <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
In-Reply-To: <20260828030344.88021-1-chengyou@linux.alibaba.com>
References: <20260828030344.88021-1-chengyou@linux.alibaba.com>
Subject: Re: [PATCH for-rc v2] RDMA/erdma: Use IRQ-safe XArray helpers for
 QP and CQ tables
Message-Id: <178836621813.2566521.11374895753812623340.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 12:23:38 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 28 Aug 2026 11:03:44 +0800, Cheng Xu wrote:
> Locked QP and CQ lookups from EQ interrupts can deadlock with
> create-path XArray updates. If an interrupt arrives while the create
> path holds the plain xa_lock, the lookup spins forever trying to
> acquire the same lock.
> 
> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths. Initialize both arrays with
> XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.
> 
> [...]

Applied, thanks!

[1/1] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
      https://git.kernel.org/rdma/rdma/c/00baeade709fb6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

