Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE854A3F12;
	Sun, 18 Oct 2026 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792329962; cv=none; b=W77Mu2sDIhuatW0QSDgR791TAvmK3Up/RxM/lgNiiFHUWi8aFA1LJ5/P/DA6JtDY/tDTCwC2iWPkI+IpVRpa7coU79oNzrKSXpGE3+IgZKZ5dcCLgXcYNJDHSyx0blek4TQWdtQMtYfb30NpiEz+jhJROxwiuQoVBSeDd7V6yAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792329962; c=relaxed/simple;
	bh=TaBJ2XjqJD0vufGWf3fe7VbQNbqInz71wGw+5qLddA8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PttHVFgwHWs+YIX0SEtRHnFCXUukgxTVZ69vabLGsFDbtlTN7qR+mhKlrSrCz1IcUaSu2wTD2cV21TNjNQ92obIcimanb6clRfJm/BatTZgi2kJV4dx2JvIhrcCjE+pPlHsPx7QbxrLt51RKHrOAgGXPd/V5BQtM5mjy/FTpCjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0U74tLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0U74tLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E231F000C4;
	Sun, 18 Oct 2026 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792329961;
	bh=4BLIYMVdmO7AI4+H85PRdvFmHnT+4p0sHt2mIz1H7G8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=P0U74tLrRu265JbOiGWmhmxcq9t9VzPiadhr+a5j2aK1M6l21t+u94MSUzLbXbHJw
	 WZuriXjtbgZylNYYH0MLtwrd8ZCA1o1teR3q+U90L4ZjgCmm9g2oymLMXLqrMSgXpA
	 frNftOOr4ZKpRJH4tHUwnOH/OwDQNVqQ9Rr6PUWF4BEVX0QjZc3vMQkpL2NYlFT2Hb
	 cf2ItX/5zeK5W77NlISy/ITFtvSo7xzZyko6f+cDyYrUhOmbzwnl/drfOKObN/rtpK
	 tC93Sfc0dt3fA72e+1v934CoWqqHxwtbwDepnuxEyPYG4Ub1buStlDxVdoUwD8nhGN
	 Nq4MxfBrinCkA==
From: Leon Romanovsky <leon@kernel.org>
To: Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Serhat Kumral <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261017185028.1019445-1-serhatkumral1@gmail.com>
References: <20261017185028.1019445-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/usnic: Bound buffer size to sizeof(buf) in
 flowinfo_read()
Message-Id: <179232995899.27545.3304722348406051194.b4-ty@kernel.org>
Date: Sun, 18 Oct 2026 09:25:58 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 17 Oct 2026 21:50:28 +0300, Serhat Kumral wrote:
> In flowinfo_read(), 'left' tracks the remaining space in the 512-byte
> stack buffer 'buf', but it is initialized to 'count'.
> 
> Initialize 'left' to sizeof(buf) instead of 'count'.

Applied, thanks!

[1/1] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
      https://git.kernel.org/rdma/rdma/c/9dd8b9a337af84

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

