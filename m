Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149F37F002;
	Sun,  5 Jul 2026 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260041; cv=none; b=NlWvNgd4PRVvPXfWnkWZxEC+FxMTdD1bw4oKFwmB/FxUjlaFflMXn9cZ92ancGKev+A0vFwzAlEvu+kOdCnZT76BIaCD4Z3CbZGeVygvIa21oP4trB5Bkd3fGuiWfQZQ52VHY7wjo6UJCo1mj/0uCRkDPXAWzeEHv1wMsUM4sOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260041; c=relaxed/simple;
	bh=dIgM/e/kirb9aRF1wwS6FyPm98YEncXJWIh0NBcJpWc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qLn/HA6Zs1llX14Z4viOsE6vxjFXyX8B6IBNpgPDPTkdu9pYP/WaXWzhYcT41/yhMr424YvpaC7AvZzUxyVoRvEWSK46kJAxV8a56i5F5mANKtGnccloipyLJ2mGTQrwZ/1d/xnCV683g5FpUVW+glV6qgKI3PyCiwerGRLLhEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bz8aMTbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bz8aMTbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DF91F000E9;
	Sun,  5 Jul 2026 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260039;
	bh=Cindx022M0lj4qSwLUTNCuroG/E6P0ePMlG+2zgvzhM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=bz8aMTbJIiVmyzrLyY8zv0KikaooJESjqEujeNzVAPE5DIKUwBq6WSi0XM9iVG5fW
	 Hqw0ScwaCqcMwIsLlyEkyzx4wX/b13PAeXI8A3VTBfktdCL+E5hJH/4QaaiHkPHLrM
	 5Ny35RI1HqTdOJCclpFBwxpzpvT2sGeC4pGC91qhhEk/k+9DjIdSecKO3+udSfOxIX
	 fRTVN7YyXGDornsAW7cthO3oOcXPOPQnNabq9myHg1wAeoooTs+aLWfW1jDEPKrB7R
	 cV2l79kG+W8tdjM8q3IG3XplkmeitcUqKOoBU64b8WSImQs3q4E/jFf8QzpE+uPngR
	 UPg/hOhxDsb+Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260612201611.4127750-1-arnd@kernel.org>
References: <20260612201611.4127750-1-arnd@kernel.org>
Subject: Re: [PATCH] mlx5: avoid frame overflow warning
Message-Id: <178290923937.307054.11359323071152941607.b4-ty@kernel.org>
Date: Wed, 01 Jul 2026 08:33:59 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 12 Jun 2026 22:15:59 +0200, Arnd Bergmann wrote:
> Building mlx5 on s390 shows a rather high stack usage that can exceed
> the warning limit when that is set to a lower but still reasonable value:
> 
> drivers/infiniband/hw/mlx5/wr.c:1051:5: error: stack frame size (1328) exceeds limit (1280) in 'mlx5_ib_post_send' [-Werror,-Wframe-larger-than]
> 
> The problem here is 'struct ib_reg_wr' on the stack of
> handle_reg_mr_integrity(), which gets inlined into mlx5_ib_post_send()
> along with a number of smaller functions.
> 
> [...]

Applied, thanks!

[1/1] mlx5: avoid frame overflow warning
      https://git.kernel.org/rdma/rdma/c/f5ad2ead846e3a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

