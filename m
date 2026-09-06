Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283D63CF208
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 07:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788680398; cv=none; b=d0oTB9eXhla1cNoEaGypHXMIZ2Y4M9Uod+RX2mOLNIt5RhicqLu57IiXNkIcKjMbBN/7HZ0HKZrnvk8wPNQWqB10ZJteex3RUibgDHE+xQkiqDeLNsiEGq6MzCyScMFWwXSBzdRGe/O+f7B39kRVDfpQklpadYmvj8zBNG+4Mi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788680398; c=relaxed/simple;
	bh=Z+89Q9EhEHtXfy7HAa5rjwCAlC2Ric8TqM2aTHHsEDo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R7woT10Op7a/axP3nkGWHpN+qZmiKJFJynnm+GxK8DpZDDfTCTmZfAPF7Zcd4htlSoslOQoWKhP7+0ZUyFdVe/HiPzURdVA7Fay4wXaOlpJpbjmJhbPmQze4+461rcwBjNJz16/Rarpy60OAS7rq5AHkPkgIUul/7pwnvgXKojE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVhpvMUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVhpvMUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC61F00A3D;
	Sun,  6 Sep 2026 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788680387;
	bh=0teosD1P+kiIDN8wILSLw0YBvrHkB+umWUQfSbr7Fcw=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=FVhpvMUGxV9qPHdYnY8XhZQe5j+VAK57gu3Bg1VGSumdgai/CvhCdxPe2hU65/1/p
	 f5C++pApwfYYs3bHk6F25qD0BvfcUVxc2UEPwn6Sxbx9HRm+6S0+UxV7hRk1OQ3lJt
	 fk7q9zs2wbOyfRvvLTpzINtQ8nJQ6pZReMUuCY1RnG/vrLWyP2Dl/zYZirvZPLK6su
	 /Wwq106J55Nm6v3XQDKnJeA/Pm+USZQVqDdllEmkVsZYPWYRVgVMe6UgUvbVGTq7Ht
	 SCqDsP8pxHCt/lUlxiJF64BKyWHFN3p5pukTM8TD8h1YJbu+igOv3q3jINQ8mZ5Tom
	 TseS8BA/TajDw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Patrisious Haddad <phaddad@nvidia.com>, 
 Jiri Pirko <jiri@resnulli.us>, Edward Srouji <edwards@nvidia.com>, 
 Michael Guralnik <michaelgur@nvidia.com>, Tao Cui <cuitao@kylinos.cn>, 
 Erni Sri Satya Vennela <ernis@linux.microsoft.com>, 
 Michael Margolin <mrgolin@amazon.com>, David Ahern <dsahern@kernel.org>, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260903082550.2257-1-lirongqing@baidu.com>
References: <20260903082550.2257-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/nldev: Put the device when dellink fails
Message-Id: <178868038433.3926550.13135245156793573702.b4-ty@kernel.org>
Date: Sun, 06 Sep 2026 03:39:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 03 Sep 2026 16:25:50 +0800, lirongqing wrote:
> nldev_dellink() takes a device reference through
> ib_device_get_by_index() and normally hands it over to
> ib_unregister_device_and_put(). The error path of the ->dellink
> callback returns without releasing it, so the reference is leaked.
> 
> Once that happens, any later unregistration of the device blocks
> forever, because disable_device() drops its own reference and then
> waits for the refcount to drain. No in-tree driver returns an error
> from ->dellink today, so the leak is currently latent.
> 
> [...]

Applied, thanks!

[1/1] RDMA/nldev: Put the device when dellink fails
      https://git.kernel.org/rdma/rdma/c/0ff7fcd6aac16d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

