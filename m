Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4C83168F8;
	Thu, 26 Feb 2026 10:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772100024; cv=none; b=flhTTqj8mHg0nq59bd1Fn2clg0aaVwKv85nkyRXfsJ0OfGBJXzHAiCY9Dkj+KgnomWaG0cflhfgGhAP5iOVlIov5IDVbUWaOtd2hW2HsUZoKVgiclBC7nd63UK6sHCqfMd2XDekeSSBvtqJlZU1xaYg5llrR5/81czxqScT59aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772100024; c=relaxed/simple;
	bh=/ImB/zyuc6oJqa60gC1TJKr6BgCxDL12UndUp5+Ml3g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fRa6RGo0ergX9fOK738xVarN7UpZ+k+y89HxtYHCng4UMAWY6Gj5PJpli9blWlWtnWBl4bL3UpiUewqqLlVIDm0oGZUNjIU8E2YPUR2gLDKaBl9L7Rv/S9Xe1ZbbyKCelqcOh2usDerRaLVP2Ux7Xa5AT2U4pBiMawcGstpQU2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/euXLw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/euXLw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B123C19422;
	Thu, 26 Feb 2026 10:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100024;
	bh=/ImB/zyuc6oJqa60gC1TJKr6BgCxDL12UndUp5+Ml3g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=N/euXLw2cGsQlL1RIY/d5ZSCI9fV5PWD3lmCpveWydrmYyGw8yNYmrOfo9uG0Wp7i
	 yExJWaJkusbNtKGUYJyrv6vTwqx32nN1Q5ILkK0yhjEwywd4YEkphvr3cImMQAlbmp
	 1VngtQdDtyhbavtmetFMeXHAskel7xh/5UZtj4Lvy1Qy4Bqdc9GUptAYotfJTZsI9l
	 gE9/GB+GeuZLhzLKlC60SLYSD2ZVUg9fz7BxQM31HhqIHZD9swTH3l37nDpxuLz9i5
	 LKw1BG1JDfuVEjE0/QFCGaLAYpVpTBBXNFrDbtaNhRVg44HLsCSy3qqwA2+WMQ6OpI
	 D4nXjhVz66CRg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260225-fix-uverbs-compilation-v1-1-acf7b3d0f9fa@nvidia.com>
References: <20260225-fix-uverbs-compilation-v1-1-acf7b3d0f9fa@nvidia.com>
Subject: Re: [PATCH rdma-rc] RDMA/uverbs: Import DMA-BUF module in
 uverbs_std_types_dmabuf file
Message-Id: <177210001519.180298.3476648221337967387.b4-ty@kernel.org>
Date: Thu, 26 Feb 2026 05:00:15 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Wed, 25 Feb 2026 15:48:59 +0200, Leon Romanovsky wrote:
> Fix the following compilation error:
> 
> ERROR: modpost: module ib_uverbs uses symbol dma_buf_move_notify
> 	from namespace DMA_BUF, but does not import it.
> 
> 

Applied, thanks!

[1/1] RDMA/uverbs: Import DMA-BUF module in uverbs_std_types_dmabuf file
      https://git.kernel.org/rdma/rdma/c/7c2889af823340

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

