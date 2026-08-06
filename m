Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2D3309EF9;
	Thu,  6 Aug 2026 11:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786015294; cv=none; b=fIU0SM+r/yAsWwJ9XmCynChIOZnRCSlNtNOGGnVr0XusA4klRREbqUML8iOW0FGNaARGWxcPe9K4tUVbr8c2g2LfqgrW0jfqh2hkp9v112u9REHDSV4AHbf9rohoT3dguBjj2eXBh+jsHdLYSPPhRHGrvGTVwOmerhx5wgNUEu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786015294; c=relaxed/simple;
	bh=m3/7icIUkkjefJKMyaCGyY6EgbjwLzr5A9TE/pe3m0c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gsm4c48YIhp7EUda/SgTbxGOVjgbueqRu2/Vr+0M/aBCLZCwqZ5mp4pwxjtgNecn9fz/aYi/x8LHfPbpRy9jZSX7IuAjnA0PL1iEu96GFayqPzaRw3VN9K1JvGCHvfShLcnT9sf53RVka6YwI1538GQC4hopN6wOyUfWSf6vODw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8ztNNvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8ztNNvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D341F000E9;
	Thu,  6 Aug 2026 11:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786015293;
	bh=ZDD6+0XKZi6JtuAwqphhZ6DltogrCIG8xScZAcqMxYA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=L8ztNNvNHjLLTJ0IN+6Lryxb7Y8A6Zc7NGTIo57/dKaw0Bj08JULZdbfzSwEI3UM6
	 p8ay+4suBy52TbGAzZpxnJSE6dbZl8fljtBQW1++8QxOE2I10IC0NrogMSRc2cUVzx
	 M1JAGDBUntZsnUJOnh05tNEEEI7+jCDF5+2nJiOfAjGhMB7OGq5xKNWrE7mV+hwARx
	 n8gPb0/gJYBmg4WIOfMKRPaLmRGh7qTB4ulIMQA7JKerul9/ggi686qRdUozWLHN5e
	 ihGVFzQis1C6ps93hO0KSXIy71Ulml3uDSFczKn1iDl/9qo/t5PAFjIJ4Sc5ihb9C+
	 0w1iUbtbbKAZg==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Brett Creeley <brett.creeley@amd.com>
In-Reply-To: <20260805053254.4023262-1-abhijit.gangurde@amd.com>
References: <20260805053254.4023262-1-abhijit.gangurde@amd.com>
Subject: Re: [PATCH 1/2] RDMA/ionic: Cap eq_count to the eth driver's
 interrupt vector budget
Message-Id: <178601529016.517601.9699220032266009457.b4-ty@kernel.org>
Date: Thu, 06 Aug 2026 07:21:30 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 05 Aug 2026 11:02:53 +0530, Abhijit Gangurde wrote:
> ionic_fill_lif_cfg() reads eq_count from firmware uncapped, but the
> eth driver only reserves ionic->neqs_per_lif MSI-X vectors for RDMA
> event queues. Since ionic_rdma probes via the auxiliary bus before
> the netdev is brought up, it can exhaust the shared interrupt bitmap,
> causing ionic_open() to fail with -ENOSPC when allocating rx/tx
> interrupts.
> 
> [...]

Applied, thanks!

[1/2] RDMA/ionic: Cap eq_count to the eth driver's interrupt vector budget
      https://git.kernel.org/rdma/rdma/c/1d0f877d593438
[2/2] RDMA/ionic: Embed counter driver data in rdma_counter allocation
      https://git.kernel.org/rdma/rdma/c/cf3ebd89e75401

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

