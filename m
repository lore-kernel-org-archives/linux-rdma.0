Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB82372EDB;
	Wed, 19 Aug 2026 23:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787180587; cv=none; b=uuRTHLryW8hOus3s7PRTrUU1Wmnh1LLNOm8xctOWfRd1kJBXIiImQwpnC8QHE7rLy8dQT9JuGM33KiwN+ztKlZNhnjauomoLBi3C4MEjtswlb/kEi0QcQPChUTdSvZ0GzGrw1cXnSAjI8Tq8N62KFJhB+0O5qgWRPc8X7HUgPB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787180587; c=relaxed/simple;
	bh=qhn51gYeAGC8nqUN2qqotQ8nh0WloeZzCgd8YvloXTM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRhc7dMk8v2hGxVWj8ZKwDkJ0lOU5f4FcA9a0WkYYFAqiEMNzGdJpGJcSfYWqP0UGsjPKyeERojRHd90HU9zRkzJCSghHl9Wbl69cgSqL/S7ItXH/23fvKITEdiv6kJLiOqLvnTCj4mew97frbmQlTxMIZBf1wsBNkQS88Y7uIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nozWdGdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nozWdGdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747121F000E9;
	Wed, 19 Aug 2026 23:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787180586;
	bh=G0DbIw/UmTL3sc44ANnnA8LQsdKMPqOQ8mvMdo1S7AQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nozWdGdUg/WpVfBN2EMdnJQrlgmh4MKkST5xu4pUdYT5jfM4u0sl8V3Xu2QBiQF7M
	 taq86518jiQKP+2LNK6XRzFJXOWvkRSzk0Z8awLH6uSnHsyQsq0reqtZnvjoqcHlCy
	 dZRPd+RZfpbkXgQ8H4N/pZDGEwP2bsMJoUsY0GcuIStZonYQkSyc3Ygl+dzcjaZf+X
	 VyS4HNfawiRS7BE6uRPPaOEF/xzKmD9V49z11BMGkQ4ZBiiiPf+RBkc4Vf9QLOvKwa
	 WJ8k7EkLPho4B6XrJgY1I5f1YJHgsKUP2/68jbKJJzWRSrkh6hRmHnzrnQqMDHddBb
	 2WIvJDlCEtBQA==
Date: Wed, 19 Aug 2026 16:03:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tianyu Zuo <cosmosocket@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Khalid
 Manaa <khalidm@nvidia.com>, Ben Ben-Ishay <benishay@nvidia.com>, Dragos
 Tatulea <dtatulea@nvidia.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/mlx5e: SHAMPO, Fix IP length overflow on
 large HW GRO sessions
Message-ID: <20260819160303.4be803c5@kernel.org>
In-Reply-To: <20260817181618.2786456-1-cosmosocket@gmail.com>
References: <20260817181618.2786456-1-cosmosocket@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Aug 2026 14:16:18 -0400 Tianyu Zuo wrote:
> mlx5e_hw_gro_skb_has_enough_space() bounds a HW GRO session by the
> payload held in the skb fragments only. The L3/L4 headers that
> header-data split placed in the linear area are not accounted for, and
> the limit is inclusive of GRO_LEGACY_MAX_SIZE.

This regresses both ipv4-large-rem and ipv6-large-rem on CX7

# # Exception|   STDERR: Expected {64896 600 600 }, Total 3 packets
# # Exception|           Received {60840 [!=64896]4656 [!=600]600 }, Total 3 packets.

we could have fit another MSS into the aggregate, easily.
-- 
pw-bot: cr
