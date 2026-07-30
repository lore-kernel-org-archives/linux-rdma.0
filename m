Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7BF442FD3;
	Thu, 30 Jul 2026 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785420554; cv=none; b=U2z0w9zeLW6eBVJqzcXn3MC9R4TVD3EwfrBv13bGcdZo2elpk3OYU3i6MI2oWoeK7mmKbzH3NMC7mklMwEacXvaihk34wRI3+RYKsuK44FX7eWcrD7aWsYPbuyTttDxYnuSsDimk5T7y7LzJNq7CfUD8E+sMvTOuW1Ykzj2CfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785420554; c=relaxed/simple;
	bh=7Cyh1iTBwQP5EXcMXbfhlnHQw0fucb41GIsRUtmG7mI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6rebFLXk0WrkgA6A8jkgQLlttap/oVNkbDLOgIxnLo7ziMqd4o//ZokqtpVhSKGM0sytnuVyGigpJpbZMtT/eodpEMi5iCceG8MKwyXY+A3EnWwVsHYM946c3ewLszstDr0+CWQZPVdEBmaIPdx1dUy/TWUv4lgE1qHSIUwccs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTnt1mAO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTnt1mAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B061F00A3A;
	Thu, 30 Jul 2026 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785420553;
	bh=Ui9imCOTXzJDqlZushyW4JmLTnOaxVZXtq/QjV/4zns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BTnt1mAObezCbRex+mIcXZxa8x0Txw1VjQG2xZUadgQ37nVsyIekOS/oUheYGFN7l
	 21muiFUgf+vyRrHN31w5CB5uQ+OUJtP/eBfICish0jPMs8TaWtnO6COhgLuUENfAW9
	 qo5WYleQjZXFtIXpEhC0AU1qp14NHD4GBCCRmiigKK0FGpkjXnUravEiyhE109FmB3
	 fl2Dxd8dD+AmdLVUDjbb8pM3hTUl3sV8V424miybs54IuuPEQJQv9cUaQbhT4kVBSu
	 pcMnKiPwcSgyTpzU/xbO9u9pRsUgKbP2VcmTEr2KR4DqrGgeR3/adiHnpyzi1+CuXt
	 iqJw7WpcKLKMQ==
Date: Thu, 30 Jul 2026 07:09:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Alex Vesker
 <valex@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: Use unique names for software steering
 caches
Message-ID: <20260730070912.3c7f24ed@kernel.org>
In-Reply-To: <3b0a153b-f47f-4260-b7d0-efef5ec0bca7@linux.ibm.com>
References: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
	<ee358aca-dfcb-40a8-9dfe-dce1ebb9c063@nvidia.com>
	<20260723061352.3b4b5e58@kernel.org>
	<3b0a153b-f47f-4260-b7d0-efef5ec0bca7@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Jul 2026 15:30:08 +0200 Christian Borntraeger wrote:
> Am 23.07.26 um 15:13 schrieb Jakub Kicinski:
> > On Thu, 23 Jul 2026 09:45:39 +0300 Tariq Toukan wrote:  
> >> Acked-by: Tariq Toukan <tariqt@nvidia.com>  
> 
> quick followup. I cannot find this in linux-next.

If the vendor's maintainer doesn't respond in reasonable time the patch
has to go via the vendor's tree. Tariq is expected to resubmit the
patch.
