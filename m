Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F164A3A3E6F;
	Sun,  6 Sep 2026 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788686090; cv=none; b=bf92EuMOKN8qYZnMbSwOA8R9/HgdEW5CwArPgEJcVoInXWsT3sigKsLnSEuI8hkk0ah5rBt0UnceNqNiuP39G9CVKsRVYa4UwJypywPG4DfabBtyxTLqqSKhJSdsuBz2h/5dm2ZbrutXLGhfXuiffgDRBpuLCAHLee5JcOkIfps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788686090; c=relaxed/simple;
	bh=GFefnj2tucIbasFP/1XYzmA3aEeeoB0pGc4ynSxBtfY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GFnrEsVXL2Aka2m+rUyXn/+VCcl1TNmd3lpn2jJJqdm7uKlCOnnt/aE16GK3oVISJ0WJCxxM3nShJ2F+FEcq05mBhyEKtB16g1FHOhbJ2Ya2zscEYhTNB1ov/GroebOyVbjyPHxmEREy8bA83EuILLxhex2HXIkhsjonuulUafc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UT1Slo4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UT1Slo4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8A51F00A3A;
	Sun,  6 Sep 2026 09:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788686088;
	bh=9B7SaszrpiVZRhcIiT2fiE7SI/zP+xXdH0uHnrUmZU8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UT1Slo4pbnzcFn8y5+0Nqq81I55Tqb5BjXwk+17Ga/gaVw3gZFA2XZnLuH155lfQe
	 MfoWT9V6bJoqNR953/4VXHGt5nCDPM4cZF5NnoqqOZQw2JitQeRjU7TWQ2ZPYJY+aX
	 tKXEvSAVkti2GBIKgQMR+2q4JthqjkQZw4b1KIA/u5shoqQ+DYzm7XNz8KDiVX8x7R
	 /66UWishm2Yy7KV2C1cybtaEeLrjEXoYsM9+K3lGRjn7Duvg7XNJYGUyHPnNUVY2eb
	 5vde+tSIQy6wolbRL4x54PGexLDpKZM+JjMB5YIUJpnNqyGkJcuKq4LLOFTamLE7XV
	 UeSOD9Kn3dVLA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Jeffin Philip <jeffinphilip14@gmail.com>
Cc: kees@kernel.org, pj.waskiewicz@solidfire.com, larrystevenwise@gmail.com, 
 Tatyana.E.Nikolova@intel.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+bd317784d628820741b5@syzkaller.appspotmail.com, 
 stable@vger.kernel.org
In-Reply-To: <20260904131437.12917-1-jeffinphilip14@gmail.com>
References: <20260904131437.12917-1-jeffinphilip14@gmail.com>
Subject: Re: [PATCH v3] RDMA/core: fix refcount bug in
 iwpm_get_nlmsg_request()
Message-Id: <178868608575.3952072.6967897863501813062.b4-ty@kernel.org>
Date: Sun, 06 Sep 2026 05:14:45 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 04 Sep 2026 18:44:37 +0530, Jeffin Philip wrote:
> iwpm_get_nlmsg_request() initializes refcount _after_ list_add_tail()
> making it accessible to global list where another CPU can kref_get()
> on nlmsg_request causing a refcount "addition on 0" bug. Fix this
> by initializing kref _before_ list_add_tail() so refcount for
> nlmsg_request can be incremented/decremented normally. In addition,
> also initialize every field before list_add_tail().
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()
      https://git.kernel.org/rdma/rdma/c/33fb59da49c4c3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

