Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AB4282F2A
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 06:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011908; cv=none; b=M7aFgmoP1CJe/UU2MtB1fCGrRKJVA0ySXssCP9I+g6JHGZwPcfC0S3uLmo8qSxXXvbUb84NoEp9eVf7ZqSlriJ4YmRzEbnN8T8nllnM9Wbj4kkCT1xRAECArCsSTqmujdr/P1JSh/5qMTtcLSQ3XdhbiliXC/BsNNPfuAMPBK0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011908; c=relaxed/simple;
	bh=0wpwMzWx0zUeGiz0GrBYGzn7ZCKP8qly7eW1AXVCFx8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SjzTvi17EL/7ahlAUNrPFsmwcHMTMfPdXSn2UHgZmAO7wWMbAX54IfNe6vRR883AkKXAKpYNlzPzxxmsfHTs1Hvl+cq0G6yiFSMFuxPcmOrccvBjHmadYuN4Yu1HK3QVPuhZ0CI4BNKpHLMWlCaRnX1gmSrFJ3yWNCqL7IFMwBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euiE0QYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euiE0QYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E731F000E9;
	Tue, 14 Jul 2026 06:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784011907;
	bh=HYwSvi76+LIHCexu7iNlzxGLArlh6dRaX8AGY1huT70=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=euiE0QYtjCpl1jUHm8NKm0JD329RrR7GnPpo14h0WwkD+HtgJ4mBG3K/aJm9MZ4Xn
	 Irma52UguwAomwJ9nT4Q133x7JuUxYfksX/KmMFILw0U783KVpKkLdIhw3m8PRfU39
	 rzaZsIuDlE7EtEklZOIRq4TQblBFtRaFbYDl39qjOj51Kh2pG19BxayZj1A1lwdQdE
	 F+6Nxg7rAlXIjOSAsEg+2IwFAW457alC/oEefZlr95H76MHCUGtDjO+iWEfWrvHaSD
	 o3HUyW/LfCsvT6sU056LZC0abwME9nzZOV0lRP893nXomnSuqH+N572YFP8B/xo22Z
	 ikyGwbNf7xoFw==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Margolin <mrgolin@amazon.com>
Cc: sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
In-Reply-To: <20260712134413.19226-1-mrgolin@amazon.com>
References: <20260712134413.19226-1-mrgolin@amazon.com>
Subject: Re: [PATCH for-next 0/2] RDMA/efa: Add support for 0xefa4 devices
Message-Id: <178401190409.5911.11672275004586418241.b4-ty@kernel.org>
Date: Tue, 14 Jul 2026 02:51:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 12 Jul 2026 13:44:11 +0000, Michael Margolin wrote:
> Make a minor device interface change needed for new EFA devices and
> enable support for 0xefa4 PCI ID.
> 
> Anas Mousa (1):
>   RDMA/efa: Add EFA 0xefa4 PCI ID
> 
> Michael Margolin (1):
>   RDMA/efa: Extend page-shift field in MR registration
> 
> [...]

Applied, thanks!

[1/2] RDMA/efa: Extend page-shift field in MR registration
      https://git.kernel.org/rdma/rdma/c/4266547bdce742
[2/2] RDMA/efa: Add EFA 0xefa4 PCI ID
      https://git.kernel.org/rdma/rdma/c/6a57af838b1a56

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

