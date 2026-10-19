Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85FB4E4C5F;
	Mon, 19 Oct 2026 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792409163; cv=none; b=RcJOWh1tyV+clKzGEfv9Nt1Sb4aJTx8qIM2+Y3x7yA6iztsqAulnV99UEsHPCDmMFQ1xyQrYRjQkpkEgMIHp1Dw0CZ/J9PjCh8eqsfRas6hRP0RxMvKCN15AB8lJJL7NxjbsA6VmmNQQnpY12z+J73RWuX9HNL51ILlyGRCe7uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792409163; c=relaxed/simple;
	bh=0M8NK7acgTOQP2lI5pyeF1cRmx/Yf69OKVwoL9WX6Pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uq3nfRIGKwi3swzQC2QvpowayHmYh47U01RiacIn909e37ASQQLtW3fqPIx9hlUvPDXZEogIDFOJeyWgcLySLSRg7oDPqa1fs6Yhlt8OQK3IkRcfZan+3U3i4iqTygxjli2suMbnBWwygx7xkxuvnEGcHcK20Zb0eOMT7I+tZQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=RBiTowmV; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="RBiTowmV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1792409155; bh=0M8NK7acgTOQP2lI5pyeF1cRmx/Yf69OKVwoL9WX6Pk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RBiTowmV5nkHMpQoysagLMhb5oZhX56Py3FkTTwA1BfNOvgi0FT35LdPXJ5MuUmCP
	 k0YRCCEXDhkjxcL0338XDvt1c+DoVv62qypa2T1lncsrEptX2zBWT6zRDCtvZQ0gzF
	 k0TzAVofiKuGAmJn/7xl2crpXIIdHy5ISok25LaXz+B1SCjgVGdYmEwTQeVam2tclo
	 AHBy8Z7HoFRJ1yERh1iiEaslRPSsGowusmqkETBOnZnJq33JzNIGgoEJUREATnx7uD
	 xUd8Dp/j/FJcC1qDCYmAQsIGjUSGZZ2OBN3k1Tqe5QOe4/CDY+2nWH8aECOujwa6XY
	 VzXsVq7dGbaoA==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id ED1A244C03A5;
	Mon, 19 Oct 2026 13:25:54 +0200 (CEST)
Message-ID: <40737896-10ea-4d95-883d-3c53f658c007@corp.free.fr>
Date: Mon, 19 Oct 2026 13:25:54 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool match
 for copy actions
To: Yevgeny Kliteynik <kliteyn@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Hamdan Agbariya <hamdani@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-3-acassen@corp.free.fr>
 <b3e5ce46-b6a7-4b90-b92e-2ee737ae79cb@nvidia.com>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <b3e5ce46-b6a7-4b90-b92e-2ee737ae79cb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/18/26 23:43, Yevgeny Kliteynik wrote:
> Please move this to pat_arg.h instead - this is not really a part of HWS 
> API,
> but an internal helper function.
will resubmit a v3 with it

-- Alexandre
