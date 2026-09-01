Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BE5296BBC;
	Tue,  1 Sep 2026 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270766; cv=none; b=aoxtjnv2Q9e4/1Ei7YdEOxEPoTkOnbIuuI1mge7DNNqh0I4wbBXYkWi558cmXiPzdWkn9T5EfDVsw3nWEYrIWQ2HkgT7SaZ+zmbO+KHOxkq0kiDCtUh4mC9oIMRew2bBqloVgY6jWskZQbkGYeBzaHWRjRbNBCoqMLcksq08Evc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270766; c=relaxed/simple;
	bh=VldsCk1Qm3hkYo/GTFjNPOYlPDs4sMHV1cTIU8P4qA0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oLmz67PkAt/2qjH+uwinkxa3aU9pP0PZ9UEeo6hxjaPpVVotN8mr5uCNx4mcM81W4rMMNXmzCasCH5RDCXJILOPlPpbzbzCLxrdgpWqLluMATrJ+rtcNnHnjY3n4cdPdu/ooI8YEuIErkyVAy7XXKDVWNfWuHl2mMTWQDkN7GQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0hSvZHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0hSvZHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E1B1F000E9;
	Tue,  1 Sep 2026 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788270764;
	bh=Bs4KY62B1Bh2YHTD6J+XWmGFywnSJqMKIKiotArSJyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=R0hSvZHQnAs+zybn59owxZAFphNA0K6YbOTZjTM2tEcVnN+9q9j9rJX5OSe5JcyKV
	 127nz2SJQlWmUCloIP0TfKDaFt/MHLX0k16R6UdhGjKOC1p2XxzvQWV12h12Qyrx6S
	 Vd28DtoSStyMWU6UGkvtWx83+PbpiB7Y2nGvXIq3adM++qTgO3cHDOMrrLCurQGsyh
	 r40lpCla2ISJWMvgA8mOO4RWZhhESUIep4B2v4loJfsryHi8fAjMbcUOUxtX9xCJgF
	 SFvV4o0VbNZHwCTtnC0+AtxOpzifIdzj46YXUnz/u9I14ylQ429zGQE/V7egYMzwaa
	 aQp4mw0rYjshw==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com, 
 jgg@ziepe.ca, Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260812100531.2706494-1-kotaranov@linux.microsoft.com>
References: <20260812100531.2706494-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v2] RDMA/mana_ib: Enable multi-port GSI QP
 support for mana_ib
Message-Id: <178827076192.1371036.8093846568287394807.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:52:41 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 12 Aug 2026 03:05:31 -0700, Konstantin Taranov wrote:
> Add MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT so mana_ib can create a GSI QP
> per IB port instead of just one. When the feature is negotiated, the port's
> vNIC MAC is passed on GSI QP creation and each GSI QP is indexed in the QP
> table by port so the GSI SQ drain can reach every port.
> 
> Also move MANA_SENDQ_MASK to BIT(0), freeing the top byte of the queue-id
> key to index GSI QPs by port and scaling the feature to the full 8-bit port
> range.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mana_ib: Enable multi-port GSI QP support for mana_ib
      https://git.kernel.org/rdma/rdma/c/a9d53db40dba3d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

