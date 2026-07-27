Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFCC37E5E6
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785145968; cv=none; b=B/H50sv5oAK+uesgjUBKaSYhU57AVET5Pi11WBxfN9Ey22RcAnx9amTlBwCQ2w9NZnHr64eydQXIk3RWBH66vXobRk7hBZyoWW22hWC9JYTLfmWMZvfMSTZ/x9Dk2psfyAWeQekc80M54SxVYvs7oFamjTqZ6D9B77O78JTGpXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785145968; c=relaxed/simple;
	bh=EuX27dEEm9mtSigcOYJqFoENh7SF4Z+LOMEjTshwA+Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Whel65dpNtjbw0HWe40PYwWvOnfOiIMdR8BCTLtvQP3A5pQmBj3915KRI4nJsiN/7wHfEK//cGey9GwfFiCLUWzpd3HWu5drYrSTiwNUXb/TwoC2p0IIsRkHXprnmCuFIjdrZznq0jDVpaKlgWv2DTILDERbaa/GYs3PNUSJqkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxAmi2g7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxAmi2g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD981F000E9;
	Mon, 27 Jul 2026 09:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785145961;
	bh=M8Z6VfAdgzI+aUK9+1G90liirpiGaB3gZTq2UUEuoo8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=oxAmi2g7u25ye/0xXJ4MQWoUyEqwnq8PgL30LgSpMFRvLqR+VS8gTukU1O/xNDGW3
	 08Vld3yekFInC206XvubLU1qessCEp5sVufJSLpensp2WX4kFpWOhrCUJCA/qtMoEk
	 kOybU6orDtSECy3hjzU61kd6KKvbXKugIjM2kZp76Lbtp01+G9gkvMDsV5BJgkcNd6
	 vIfAXPBo8+0XeprDBZBxI3oY3RZpYxDaJE6Te7/l7Xbo4aLL7liIPI5CDStYq+O7CJ
	 +hJTgTN6Q3BLknUKtjAvQlm7xGTQyINVbXgt0rrQr+MMub7RdGERoL5T+puT2oEyax
	 w3tI+Yd2JRRfg==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com, sriharsha.basavapatna@broadcom.com, 
 alhouseenyousef@gmail.com
In-Reply-To: <20260721115440.24021-1-selvin.xavier@broadcom.com>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
Subject: Re: (subset) [PATCH for-next v4 0/4] RDMA/bnxt_re: Update the
 toggle page handling of CQ and SRQ
Message-Id: <178514595794.631750.11108529920347390089.b4-ty@kernel.org>
Date: Mon, 27 Jul 2026 05:52:37 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 21 Jul 2026 04:54:36 -0700, Selvin Xavier wrote:
> Based on the suggestion from Jason (
> https://patchwork.kernel.org/project/linux-rdma/patch/20260615224751.232802-5-selvin.xavier@broadcom.com/)
> , adding the uverb object to retrieve the CQ an SRQ structures while getting the
> toggle mem. To work with older rdma-core, retain the existing code with
> modification.
> The rdma-core pull request is here: https://github.com/linux-rdma/rdma-core/pull/1761
> Please review and apply the series.
> Thanks,
> Selvin Xavier
> 
> [...]

Applied, thanks!

[1/4] RDMA/bnxt_re: Replace per-device hash tables with per-context XArrays
      https://git.kernel.org/rdma/rdma/c/2b248ac9c95bf0
[2/4] RDMA/bnxt_re: Defer toggle page free to rdma_user_mmap_entry teardown
      https://git.kernel.org/rdma/rdma/c/bc12898e33f52d
[3/4] RDMA/bnxt_re: Add uverbs object handle path for CQ/SRQ toggle page
      https://git.kernel.org/rdma/rdma/c/fbdb3dcef8440a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

