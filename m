Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581CA35C6B8;
	Sun,  6 Sep 2026 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788676631; cv=none; b=Y7V6RE4oViVIm8ML/1F9Bgp35mRNAUO7eCczESfBS0/jgz67vXHPOBk4fhb8COrPV7o8sz8rtPAfLAZce1X1LOGjXHaRnry56Ony5BcQ3UzvErQg83lRaTRekSYsL+EJz43ellZUFD+BW/eBuYpWCzvOVlo8z2ADJQFqfbHt2CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788676631; c=relaxed/simple;
	bh=kurCCY/fwRGU5lAev+hEdiXtj2LafPxcVMsNXA0M9jA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=o7ZQEetTgi5RvEKzxXXH9Nm9yxMWbJPGwoYF5vO/jqJisb0GWZYOhFJmEohdIxmycJjuseZFSXJlve0YbSr0zro9rRlYx5lZNct/4DkdZ1L8qzKszGbWFnRbkWsECnbcOZUdvVfeLG1FWuegiWAgZ+hY8UIMBkHGdONRswYRysA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoyGnCmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoyGnCmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7081F00A3A;
	Sun,  6 Sep 2026 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788676630;
	bh=mX4KNwFhzb4NcpvCaUj8RlDjRNh0Qt/Nt6nfzm0Ur/k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GoyGnCmRmLFsOnWzdDfQ4NzxG8GIXj1vW95B5woVDsyNCfHTEUbQql6mqFGnu2Keu
	 jjy7S5PzkV6QZxoy8m1ojqJo/RavFkMJ7kuOVM7i/Ze+XDNsaLuI695NVCCnkZDzC8
	 YAzAyHsMsTZ1WpMpCqi9RloEXExBn6JYPxkMzB/9qibTm4raQKZp8rOcvI/5N58UsQ
	 PUKxriEbxpXPI3mmhnJsZQrqMd5KWZPmAra95HPTCVOX3wM3/MT19mVoRuNIT2au6e
	 Fj/qNCTsd7XX16Kagm11CRwVifu3i0x3QUYSSemsAWSKpmhMFjfTmCCeDXazS6NOVC
	 bG4b0Ngw9KqHw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Avihai Horon <avihaih@nvidia.com>, 
 Quanye Yang <quanyeyang@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+a6ffe86390c8a6afc818@syzkaller.appspotmail.com, 
 stable@vger.kernel.org
In-Reply-To: <20260831-rdma-ucma-mc-uaf-v1-1-b8eeb7046aff@proton.me>
References: <20260831-rdma-ucma-mc-uaf-v1-1-b8eeb7046aff@proton.me>
Subject: Re: [PATCH] RDMA/ucma: Serialize join and leave on copy_to_user
 failure
Message-Id: <178867662703.3918721.7053454013057973750.b4-ty@kernel.org>
Date: Sun, 06 Sep 2026 02:37:07 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 31 Aug 2026 20:30:58 +0800, Quanye Yang wrote:
> rdma_join_multicast() queues RoCE work that later reads the ucma_multicast
> through event->param.ud.private_data, then list_add()s the CMA multicast
> at the head of id_priv->mc_list. rdma_leave_multicast() matches only by
> sockaddr and destroys the first hit.
> 
> ucma_process_join() used to drop ctx->mutex after a successful join and
> retake it only if copy_to_user() failed. Two concurrent JOIN_MCAST calls
> with the same address can therefore insert a second CMA entry before the
> first thread's leave. leave then cancels the newer work and the older
> worker still dereferences the ucma_multicast that the first thread frees.
> 
> [...]

Applied, thanks!

[1/1] RDMA/ucma: Serialize join and leave on copy_to_user failure
      https://git.kernel.org/rdma/rdma/c/662ade4de9ff5e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

