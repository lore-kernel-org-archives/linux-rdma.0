Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366D73D6472;
	Fri, 18 Sep 2026 12:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735801; cv=none; b=hTu41sq2WsKNu6zXIhig07Z2XaYvNruNqyfkcFxusxIln4AnLZQagFmGTwPl6KKayxwactdRojSwaE2fZAakxBkoc4pOsMvkpLRUvG0haEPOfDelrbkLFAkbvOUV7GBvsH/inhGLBbUwMXxnMQNgCiXftg5YeBKY4NvzS0u904s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735801; c=relaxed/simple;
	bh=GoTot2TZcSAhCEUWndM+/AR1jPrbPVb2kXNlpfvX6kA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ltuNXMfx7CVryMpOz/91xECQgBRwtSHoK18myWiXpb9cmhc4mp8HL+dEbdl7K/gCJzkrl+s8gkgBlu4sQlHpVoRt6l9zSxgc3HfOnFvojk1bNF9MY/VbykrjQxYNHNfxAuO//82Yxs38MX1txWPtLiQUTqj5H1AymO49EW4hiqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSTYWqX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSTYWqX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489941F00898;
	Fri, 18 Sep 2026 12:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735799;
	bh=Ii9m+UXBVmNhPah32omsVnb8pN6ZGzu2lz/jtDD74hc=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=QSTYWqX7TBtevoSqntempXwFCLRnPZ+oToE7d5GXgyohik4yY/nyhkXdlmDkUjo5D
	 4YlLdAD0JM3ypdkeUnXup102wsO1zLgBG8GpgA0yDAIIdyecnFfeepxq20WxhKtqmw
	 Sf62c1P4SZKTTcH5OEWyLlYTB5c7lL+P98l7LzW/+K+OV/1z5iX6bxbIOHbK6x5azI
	 J5JQerquxQDZajSjMxIwgBy15aV2KFL0JSY3A8lIFpW7fXQ4yABEzQvJ4FLgZWtLP9
	 NwGbKk4fydNSP0c8qWf4MSIrc2QbI/TXsDO+wSTkvSlT64Rhnp+PX1AmneYghjygcj
	 BgaH840Amn+Sg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Yonatan Nachum <ynachum@amazon.com>, 
 Or Har-Toov <ohartoov@nvidia.com>, Michael Margolin <mrgolin@amazon.com>, 
 Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260916085529.1838-1-lirongqing@baidu.com>
References: <20260916085529.1838-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/uverbs: Drop restrack ref on ib_init_ucontext()
 failure in GET_CONTEXT
Message-Id: <178973579706.2688475.18141530561928965200.b4-ty@kernel.org>
Date: Fri, 18 Sep 2026 08:49:57 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 16:55:29 +0800, lirongqing wrote:
> The UVERBS_METHOD_GET_CONTEXT handler allocates the ucontext via
> ib_alloc_ucontext(), which calls rdma_restrack_new() (initialising the
> kref to 1) and rdma_restrack_set_name(NULL), the latter attaching the
> current task and taking a task_struct reference.  When ib_init_ucontext()
> subsequently fails, the error path only does:
> 
> 	kfree(attrs->context);
> 	attrs->context = NULL;
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
      https://git.kernel.org/rdma/rdma/c/9dcacdc41083cc

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

