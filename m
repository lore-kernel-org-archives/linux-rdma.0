Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794766641;
	b=cXJPVKvrG85cz2Zsr2onVv+UMhCuPHWwwEYMdHQrUjw4oatpH5VaEenANGesjt+1E0s7
	 qzWiUPFnxpJJIsYtTSqs4I2l3/XEOsU6wnBt2VpB7s4CIfdShSPtmGehv0QFcTG55E1Kw
	 lwRS/TzuzBEJoEwb9YkDRJaq/z4klXdquiydPic3Aoe2+NAR0iAP6+OHpme4LVUTNVQew
	 IMRBz6I98ZfFHEwJaroPnidAgiXdJHN4j8tHloTsYM+4dEXzfEFi/RcTh0za/VyeToYEZ
	 aGOwFlGmTcTmC0qJtzJl3YEK8eUGN2FDW1medULYPBeyM9XJx1NIS93wcytwEO4sT8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794766641;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=D24zbDDsqNVQzu18iGUhiBUb7/SO1VZtJ75iu6RuGD4=;
	b=ojqyydzV76Te7ottF4FBfXkokvoe5Jbemzte6aXRpxQbpP+IJsnksRvbKgrdk0D2Kis0
	 RdArL2wmuazG2kYv6IN4Q2o9/+W2kl3RUJzKDMiH0v8HvVMeXeD2irB8fl/5dLobP4YyN
	 ACTUDgN9eqcZfki1QRnmhggyq8jWZqG/jKF/K1molHgSRw6LAy13SbB2DuuQDJULHsRJg
	 gWucRE/tWxi8+PVpOuGEhi3KdgRCf3z9z9IdJ6YJ327CGBKn1iLbwbK8eFOP5GApndPjP
	 qbh/U1lZXwKq0AaOMGkEvQVTyf8Ajc1NLFXjyd/2Tvbajp/WKQq9TE0VozevNyrnzPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ayv95JZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F4D606A31A;
	Sun, 15 Nov 2026 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ayv95JZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F411F000C4;
	Sun, 15 Nov 2026 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794766641;
	bh=D24zbDDsqNVQzu18iGUhiBUb7/SO1VZtJ75iu6RuGD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ayv95JZ2N/2DYsVaxiuyF5C5PzLf+fUE/kFWhb2rwxpNJZbBcCxHk40PCXMuhWRcE
	 YrWycUv1ORYlv3JIAGDHXL4z6F5ir63hrZL5cCKARgvqww83mbra1Ezo+usCn+qrLO
	 uSdnSbLD5oDz0mW+VUmfflZUgMIBoH6VHVhJgNe2hZw64DxO8inaXNhqOve6xDqV1s
	 oeZsQrRuV8oZ6xT0JK7GK0yM5F2iiLCStr/H7rVS0X+1K5Y2C2hWKJ7ZExUh4HHjrl
	 fFxFRRJGf9KX3fzWiWc+1Bb2mHa58pax2WZf2uPSCfO7UMXQAsqmAFDbqvRf+wZXEp
	 lY2r48oFtuDhg==
Date: Sun, 15 Nov 2026 10:17:20 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman
 <bobbyeshleman@meta.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin
 Ratiu <cratiu@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, David
 Wei <dw@davidwei.uk>, Dragos Tatulea <dtatulea@nvidia.com>, Erfan
 Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
 <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>, Leon
 Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Matt Fleming
 <mfleming@cloudflare.com>, Mina Almasry <almasrymina@google.com>, Nikolay
 Aleksandrov <razor@blackwall.org>, "Saeed Mahameed" <saeedm@nvidia.com>,
 Simon Horman <horms@kernel.org>, "Stanislav Fomichev" <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>,
 Bobby Eshleman <bobbyeshleman@gmail.com>
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
Message-ID: <20261115101720.5fffb5eb@kernel.org>
In-Reply-To: <20261110183826.2927274-11-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
	<20261110183826.2927274-11-tariqt@nvidia.com>
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

On Tue, 10 Nov 2026 20:38:23 +0200 Tariq Toukan wrote:
>  include/net/netmem.h | 24 ++++++++++++++++++++++++

I haven't done a proper review but this jumps out - does the new helper
really belong to netmem.h ?
