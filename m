Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2934A0904
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 12:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167501; cv=none; b=FmScbwHBmCceA2JJRpAJ9m34ZmWIIvidFJebDbtxDC39Y5vlI+76Y8h9Od5ku/uNOZ/bSbezP7eGmns5I7F+PwfMQ2wAb2BtTgHVdeepSCmvJCIYT3U+4LBmUaZMLk1tI4Hc+0XLTiyIWFOEFh8epR+tpLbG8RJk9tZdSL5G3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167501; c=relaxed/simple;
	bh=oZ8mIXBjEODzLMj+j1sqfRk7PD8CS3guEZn85LTepdo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nCon5lXykdINYfoA4F6pk6iEIjovHviMjGK6aK4snaF93y7Lwhu0m1z0psPVnQ/eU+rklNC+mvwTskuHcOP0i9C74AjLKqDDiLKAJ6tX3DPb8/z48V05hjYmWn7vZ9YmCk87g5OCyEGrowyduwSfr6NSeYO20H7lAA/rTCswvMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXCkz/kY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXCkz/kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C901F000FF;
	Wed, 23 Sep 2026 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790167499;
	bh=a783pN7GvbSYP6of6oc1ckeHpxdn35DZ27TC9CTEGKE=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=VXCkz/kYevOsULTtrJi45K+a1eP6lWZmtSvwy1X6JpE84lwYZCePDvx+zAEBK5yZY
	 1/h0jmTdmYQD0lF+A336GCEwEDkRi7l81z7IohcLnp0sGlE6qxhJFZbyFhjidiLFZn
	 6dVh1Y50UUQNmo7LLo2J8eqv4jZfoJdNVAwH20sfwW9aiMdWfzbP15zdgQJnrP0eOw
	 cq4z7SPaSIc9NnvS+POECep0szFFbbqa9SIS04uMIJiwSDBoBo2smYxjD9oXoNrEGM
	 1LCA/zPbv2M13U2l32Ib2c2lVw28kQgzHiSFfK+X4xZtM93YClZu8c4V5rKMIPZ+1O
	 /7qeD2vX8B5mA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <yanjun.zhu@linux.dev>, 
 linux-rdma@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260918092337.2338-1-lirongqing@baidu.com>
References: <20260918092337.2338-1-lirongqing@baidu.com>
Subject: Re: [PATCH v2] RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow
 attributes
Message-Id: <179016749674.3411706.6732193292368310779.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 08:44:56 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 18 Sep 2026 17:23:37 +0800, lirongqing wrote:
> Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
> the leftovers_specs[] array into two separate structs to silence the
> sparse "array of flexible structures" warning, but in doing so reversed
> the member order: eth_flow was placed before flow_attr.
> 
> _create_flow_rule() locates the flow specs with:
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow attributes
      https://git.kernel.org/rdma/rdma/c/e43913aabd35ee

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

