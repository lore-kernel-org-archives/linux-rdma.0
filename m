Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49DB378824
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 08:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794907; cv=none; b=p8e5KMKSROmijmJZA/AOueNkU40TmoumjBS0qpBQu1nRy8ehX/sw/5ahxHq6RI7Hxr1ffFflZFYp8YZdXDRYKmygkFVa6+KIsv0glOENBOTc60OG4RzTnppqeHVLutA+nzkEbEhsKCw9kdDVLD+3lYrwfTzm6GxdIJFhhGvRFYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794907; c=relaxed/simple;
	bh=ee6BnYnzRu+7BbX182POKM10YkFpjz3BmrhEQaO5N+A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dVd7n0jYHbsT/uVv6+mFyi13MTVcr7PkGWu1LvlEjV+j6Xpo1HfQTFH6tVmYedidpaeBKoZ87NKJpspYU/crNBoiHf/V8mLd0ipSptj1G8C9rF4gj483HTIPt4ASy6NSWWIShctuP/AMcEtkV9pP5AKna9itLlWIZxS+nOEn8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2C91F000E9;
	Thu, 23 Jul 2026 08:21:45 +0000 (UTC)
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yonatan Nachum <ynachum@amazon.com>
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com, 
 gal.pressman@linux.dev
In-Reply-To: <20260722113331.2515247-1-ynachum@amazon.com>
References: <20260722113331.2515247-1-ynachum@amazon.com>
Subject: Re: [PATCH for-next v2 0/2] RDMA/efa: Add 64-bit SQ request ID
 support
Message-Id: <178479490355.3290360.6694329818597580561.b4-ty@kernel.org>
Date: Thu, 23 Jul 2026 04:21:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 22 Jul 2026 11:33:29 +0000, Yonatan Nachum wrote:
> Changelog:
> v2:
>  * Rebased on top of completion counters series:
>    https://lore.kernel.org/all/20260722083603.30334-1-mrgolin@amazon.com
> v1: https://lore.kernel.org/all/20260721070026.1635441-1-ynachum@amazon.com
> 
> -------------------------------------------------------------------------
> Currently EFA WRs support 16-bit request ID, this requires EFA to manage
> a translation table to translate the IB WR ID from 64-bits to 16-bits
> and translating it back on CQ completion.
> 
> [...]

Applied, thanks!

[1/2] RDMA/efa: Add CQ/QP creation with 64-bit SQ req ID support
      https://git.kernel.org/rdma/rdma/c/e5e8706dca4df8
[2/2] RDMA/efa: Expose 64-bit send WR ID support to userspace
      https://git.kernel.org/rdma/rdma/c/524381ef281bb8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

