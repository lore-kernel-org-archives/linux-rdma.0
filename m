Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793227185;
	b=qZcmhISQyi6TdzAqMupV1AEYhWftqAtYUDKBUt+bG5AG26faClGau7qxSoZkrJ1ToMCe
	 NLABihxfP2VhcasfogEtx8bd8hUFAxw1TTxLvk9agJHXPwUztng3jFM/Ug5XBm2psdsVI
	 QTHAp7TOApruQW7QixtW9uitRUAZTig9IXORAnkDUdP0KJb/Ykwi7RvekAmDJ46KBIdHA
	 Ld8CMQXf7PrAFTd5x2Uo+rQ0vErAwpxAw1ijowHG6NVzKfMdBVkwEcSaj8nQwvC5V5naM
	 tEGaV1efxK7Id2NbGiZVpye9RvYEsWdo6nl47H2nBLGZz8/M/MVAgGE8wyEKnT93cNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793227185;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=cBlWh/wjjyeI08eIEMAddy3oyXh1KBJoF5Yfmm3DCKo=;
	b=vn46nZizSFABmaPJYC1fTxu71C6crvoUvIooJi+we0zjDhgPTmjPdA5rKjXGvhehhB2D
	 fR6RQZYvZ6qvi8in0ws/n6MzbDKkX0MDG4WVo97OGZdvqQaBElyJ4CrDCK4hc1c/Gf3wr
	 gwF6L7cynh7nnagTjjlNf81jD+uVdYaSZVt/G3NZRz6ePcCxwZyEoBpSUSvRnmBBCvlkY
	 B3s2hGsW9RrDYVPWnL2C3n8cVVPSvoIckLhfKIXAqmEO3QhkQGDhOSMW29Mh8k4oAkwBb
	 1X6UtKXSpJuk5HyhqxMTYf9PlO0aqcf4cMINdogiD0oUYLCl0zfJDWPRhaLrAepAH3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzB2pDwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D401B606A332;
	Wed, 28 Oct 2026 22:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzB2pDwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4E91F031E2;
	Wed, 28 Oct 2026 22:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793227184;
	bh=cBlWh/wjjyeI08eIEMAddy3oyXh1KBJoF5Yfmm3DCKo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YzB2pDwEMBOL/lwIzwU837qtSLmCMriyYITQRMwZMFgVCUVEZ2OLS6sJsrR2GteeB
	 gXOpsonkwThnK8Ac7mEwOcXS8eSHpYLYw2XUAaAAXnBl1wOMe/Qhaz5Dj7yLiRakgN
	 WAk5kye94ou+Tr1pPegjHmF+65j3HpVdf0ndYx4D9JQwaDx/5aZkoo8WBIhKrryhIm
	 f7+5q1j+2guvYV7wyoVGId4QnpWiJLTvVo6GiaF6DeYCgz49Adlq/LmnZyw3tlMKj4
	 0DVGxe2lHeHY8pcdnC18MKCXnVaL25E+Tvlujic7KE0GGs81qhWPSSzAhEzN4PE5kA
	 7ubuu0DZmHh7w==
Date: Wed, 28 Oct 2026 15:39:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Lazar
 <alazar@nvidia.com>, Aya Levin <ayal@nvidia.com>, "Gal Pressman"
 <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
 <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Fix false WARN_ON_ONCE in flow steering
 cleanup during RX init failure
Message-ID: <20261028153943.2b1428bb@kernel.org>
In-Reply-To: <20261026072253.4118892-1-tariqt@nvidia.com>
References: <20261026072253.4118892-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Oct 2026 09:22:53 +0200 Tariq Toukan wrote:
> Subject: [PATCH net] net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup during RX init failure

reportedly does not apply
-- 
pw-bot: cr
