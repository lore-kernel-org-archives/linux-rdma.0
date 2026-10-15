Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EAB3E40EC;
	Thu, 15 Oct 2026 09:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055077; cv=none; b=C3RLZk556DfD3a/TAi800DQcw4oibXATX8i6LBeQ5bi6AA89uo2s6cRj+IKWbnux6qgWtX3dFdfV86w5nSa/FhzIAZUNtffLuW6SkJTr0L5+CpkSIZfufmDcY2epaitGanjVh99rxLFc70TtmRoO+PeHbHbn8LKh1EYiqTxQv4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055077; c=relaxed/simple;
	bh=rIcgzJ1ny5/J3daVISJQD+ulG+XxhvSZdvi/N1YkZ/0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=o0kJY21WI9x6Zs9RQbg+Ep6QsJYTu8qHgcsH6qBUAokFT5X2V0+BA7lHVzdKlUt5njrnblvj/sQcwH34qKM6OimBAG+VOwrN2oYxkErQXYgwNfH8EzV8ySLxViNlp/WBRSYn/llspyx1nPgxuwIx15nWVP0kRLbMF9tvDMNS4bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecah4T/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecah4T/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12481F000C4;
	Thu, 15 Oct 2026 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792055076;
	bh=tmt5C5wnNkSte67ei197UKPIQT8pB7GNLGRn4j1UgVY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ecah4T/LRzgVLyo61rznlNkAwRcAcAOiNjcy0rFYcMcAdV/3sok0n5XsJMdrHmUjA
	 oH77Id5eC4pgTpY/0CfXa6HMmApjBka2PtFGDWykas/vz9TbpVccHRWu5///+qG8j0
	 z69JMW4OpfDhrp9wKJ5xCmQk79Jf7T9wTi1E5U9RZEcKJKgDU0XvmrHCy3sTQ3HCsk
	 P8Z0uhKynOqPbyN0ogokG+qaHe23MHSg83o6ue5Vom9avR5mhHAlJvW6jfBKyw8jJj
	 gMqMnESN6I5YZ9Y3AjdsfUagD4gHe2Xs7wUquVaP6yydkBSHq9owLtdvDuaQFh35sa
	 tUhOtfnVQJ0MQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Roland Dreier <rolandd@cisco.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Carolina Jubran <cjubran@nvidia.com>, 
 John Popplewell <john.popplewell@nmc2.ai>, Cosmin Ratiu <cratiu@nvidia.com>
In-Reply-To: <20261014-ipoib-cancel-work-v1-1-6c0faac016b8@nvidia.com>
References: <20261014-ipoib-cancel-work-v1-1-6c0faac016b8@nvidia.com>
Subject: Re: [PATCH rdma-next] IB/IPoIB: Cancel normal flush work on device
 stop
Message-Id: <179205507348.3945842.17418999970026945894.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 05:04:33 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 14 Oct 2026 13:47:04 +0300, Edward Srouji wrote:
> ipoib_ib_dev_flush_normal() can race with ipoib_stop() because the normal
> flush work does not run under RTNL.
> 
> Before commit a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in
> ipoib_stop()"), ipoib_stop() flushed ipoib_workqueue after clearing
> IPOIB_FLAG_ADMIN_UP and before calling ipoib_ib_dev_down(). This ensured
> that any in-flight flush work completed before ipoib_ib_dev_down()
> performed the final clear of IPOIB_FLAG_OPER_UP.
> 
> [...]

Applied, thanks!

[1/1] IB/IPoIB: Cancel normal flush work on device stop
      https://git.kernel.org/rdma/rdma/c/66196a559be596

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

