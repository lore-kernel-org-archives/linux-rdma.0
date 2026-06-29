Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC44194AE6;
	Mon, 29 Jun 2026 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782741157; cv=none; b=qG68tDvwrHYg0xJQ1hDH10ZKY+F92beX0mLr7Hhs6cnRKc9AOjXfL1KSs7Tp7lz2yYm8kuz7BlDYEGJUiCzmI+NfxejwlKBtq9krpHzy+fgIADenEqI9bnlRM2E9GjaIlcIxLezSWO77xjfi9mzbSud7WgNMbT6GBfcSCjImHmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782741157; c=relaxed/simple;
	bh=m4/XVnN1TFwjGs6KNCCzSTpzfOCjDJe0CzU0HOVrWyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1CP2iRxajo88MM+d75DbvKFNNqJKz1zwueOLCr5ckDkhpNLXpXVcBAbQO02AT2kPuOWes+07Dzkqn4TrWU+JeTN6ziSTm8jVe7x7UdoYnuo89Iv7gz6sqt06pK/olgYVDRxF+CbZ8ItI+o8v+DasRzV5jzevgdAgOo/5ZEHub8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVJ8KKjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVJ8KKjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB511F000E9;
	Mon, 29 Jun 2026 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782741156;
	bh=m4/XVnN1TFwjGs6KNCCzSTpzfOCjDJe0CzU0HOVrWyI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VVJ8KKjSXtnFmaPq1KlnJ0hgm/Q0zZbhOlcknNR0SxVQvkFQiaSDb+RcxuaSrqfwg
	 5CoNq5qjPTfPhH7nf4Uh343irRKQA/+JscOFKZUUUl4UaakQtA0y70WKTtSQAhfCz1
	 7WwfBF9tUlmJajUTHFnovgEs15x9Qvv+3xLEpKiFHdlyFoOgU4f93KYHcUB2HHIT9J
	 Z5kptw0GF1DnjJQP0yK8+n0cPv6J1+yXQmARE93f71fe8RomxDtr0JIB2XHL0e5H7O
	 Urkg+vNf1R10IEHv319AoWngnvDQpbT9VUD3TtBIFkQB7GcCk24nBmYpIUKrbS67Rr
	 72D1+jD7O7X/g==
Message-ID: <897088ee-7aea-4c76-8c4d-9d5fcb621a58@kernel.org>
Date: Mon, 29 Jun 2026 07:52:35 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iproute2-next v3] rdma: display resource limits in
 curr/max format
Content-Language: en-US
To: Tao Cui <cui.tao@linux.dev>, leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
References: <20260615005315.169582-1-cui.tao@linux.dev>
 <4d98d9a3-07e1-4333-b040-c72e5f561a63@kernel.org>
 <0892f5e8-7ca4-4efc-a002-8c1ed244b18e@linux.dev>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <0892f5e8-7ca4-4efc-a002-8c1ed244b18e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/28/26 5:55 PM, Tao Cui wrote:
> If you'd prefer, I can also hold this iproute2 patch until the kernel
> side has landed, so the uapi is already in tree when it goes in. Happy
> to do whichever you think is best.

That is the request - resend after it lands with a reference to the
patch set.
