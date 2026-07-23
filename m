Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06C459AD9;
	Thu, 23 Jul 2026 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812459; cv=none; b=IUeYxjL3F+QqnGC6cQ5U1unD8mble17Q8dWMgZy8e6qFubSaa7xDpE0xbO5WDSeI0h6uFLd8WjfHnCsN/YTKaeYnPCNJ2hRP1zBwuB3jCRnH3cj/Qcsignsw4CW3OB3OPH8yuHgsjWc24Rfd1bc5R85uKyoSaDmlHRdpcKuXF1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812459; c=relaxed/simple;
	bh=RNdPTSa9OKsAiO+UWlLyBfykWS8t2vt4x8TfT5mMLRg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Br/Swp9d3NyNuCidxSpXMGTogtu4YwZHe9zbJ2dj1ndgI2QvLPWwM6xi3uErh0DvlaLN92pQFKotctYaKzvIi+4vZJXHoDEW+y24spQmM2RYwsR5MC4MvPMSroXrtyhZKV8elfc7kj90mPTsNn4C1M6V3WO9iouoqo2KYEab5h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCED1F00A3A;
	Thu, 23 Jul 2026 13:14:09 +0000 (UTC)
Date: Thu, 23 Jul 2026 06:13:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>, Yevgeny
 Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Christian
 Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH net] net/mlx5: Use unique names for software steering
 caches
Message-ID: <20260723061352.3b4b5e58@kernel.org>
In-Reply-To: <ee358aca-dfcb-40a8-9dfe-dce1ebb9c063@nvidia.com>
References: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
	<ee358aca-dfcb-40a8-9dfe-dce1ebb9c063@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 09:45:39 +0300 Tariq Toukan wrote:
> Acked-by: Tariq Toukan <tariqt@nvidia.com>

Too late.
