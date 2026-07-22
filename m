Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2294B2D29C8;
	Wed, 22 Jul 2026 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712929; cv=none; b=o4cx/qxZoNeheCGsCNTEKM08Eep1ergsKYINOI7LQnAtGUmEhdOLiy2HXXnoZ9NgzjVFX45NCk1FndMk/z7SdaeuwKmsliJssOBLF4wN4mH4iQNK1npGSTQDDOc4yU4/gAYqstWAixUOEgJ9P+eCQVIjMjvA7TU+sr6qR5pTbyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712929; c=relaxed/simple;
	bh=QK/ncZnWzEC+p+OD+yhUSHI4ljMdz9jYq5wwqY2yHoI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aLpmL9ESi81vZk2fO2jn8TK6wL8uvQ+l2q451dypkvkMGlZ+L87S8EYPV5m1w0POgYpax/kjUfAL/buafs7hDsDlXCmZKdwiL2yLZTHVTxlMyFvjCnt8lQHQUZGj6RtgXSUnC9+BcexiXUjo8bq4FgJ7XD0jWVer9EEsqU6C92s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJ1K2BW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJ1K2BW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1B91F000E9;
	Wed, 22 Jul 2026 09:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784712927;
	bh=F/Ol0xABKKEr7jFyCju/mCLeB8UXkOxmSylJSsrEuEo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AJ1K2BW04dfAgNVr3xirHY/dk5QsZaI51OxYy4+4H1jIPZUAj3OuSxVF6haKfHco7
	 NoFtHUq0D+CgZ/6rxFIh9mxJW/zCtzgzpwFFx5oFNIxJQzKxM2mGAOkie2Afku+Ir9
	 PywCMz7T3RcWBkXM3yg6gu0SyKUUXRMLArElUthKuy/QVl6tm2WmPyVHQXk6dtZg2Z
	 5izkFVXeSB2OrwLgBgcmrAE3lbwtidt/7dGaTErx38861AihiMbIOcB9eziXUa4r5D
	 JhTCAHY5a/r07sJC6tZ8pqH6iGjnkYDzRmMK9UMWZkhnSL/p+7XMm3r+4dscH+v4y4
	 MmP1fPE51EbOA==
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>, 
 Konstantin Taranov <kotaranov@microsoft.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem <shirazsaleem@microsoft.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
References: <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: drain QP references after
 partial table insertion
Message-Id: <178471292478.2833269.3803392129606476657.b4-ty@kernel.org>
Date: Wed, 22 Jul 2026 05:35:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 21 Jul 2026 18:00:01 +0300, Leon Romanovsky wrote:
> mana_table_store_ud_qp() publishes a QP at its send-queue id before
> inserting the receive-queue id, dropping the XArray lock between the two
> xa_insert_irq() calls. A concurrent completion handler can look up the QP
> and take a transient reference. When the second insertion fails, the
> rollback erased only the send-queue entry and returned, leaving both the
> initial table reference and the transient reference outstanding while RDMA
> core frees the QP, causing a use-after-free.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mana_ib: drain QP references after partial table insertion
      https://git.kernel.org/rdma/rdma/c/97f7c2262c28eb

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

