Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792461065;
	b=1M43RoKUTLqAkbqilcN2kWK+LlB9ZEeEMr0hzhVrPrtqqhsSt55woLQXAPlEt/3FkLg7
	 ygCwxWiK2/rZSB4657LrchRRRHi2k8rlcKNyDiUEH0LrZW8xBIpw370crYr5nytDDfWen
	 QgpyNpVU8LgExTW+9vQCuF71SJ8UNWO5uuDgsq8LilO2h2RkVjPn7/N+WAqAZYxszmhrI
	 rF6nTl/X/E0RS99TM6E4gZUDt7ZBcyUa1p+nMgfkUcXX+Jz2xxPwmaSG7j7Wlqx+uBJst
	 ShIn2dKBRf9u7qXNly9DokfiwttnpYW0jVF9Iv+JoZmfjAphzxsRf4OokmyxhlP8LEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792461065;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=tAclDCAvrZuBYEcZfOzt2ooYsar0gy90CxtU6DCuXy8=;
	b=X16doAmxeWZQypglJlS/bgX9RkE50pof7IeEZnXK+amUkexe9Mv0z0rQgvpDqJ5c2M9S
	 T06d2U7I/bqQhLiQ7J7i6qjiIgcPmyQEf0TRxDZ9NgSEe2DID2XqZs57gng+w5VIgF86v
	 AXu3e9WbgGgzVQHn8XXZSZ04ClwGrXmWf8/Lj8l+zkM326OEODPWgYqf35odsCNV/Viaw
	 pMmQAlWPlG9HY7upkRN/M+xLGcmhswWhJOq4QYpe7oNJqcdm7Kqc4l8ioKb4favulSubE
	 8NxG8Mai4DXEdCq+ROGM6OrLXGYqkG+yd4stSaQf5tRaYQKkOqWABQDRILXYyH53MdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JFciYaHz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5AD606A31B;
	Tue, 20 Oct 2026 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JFciYaHz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C997F1F000C4;
	Tue, 20 Oct 2026 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792461065;
	bh=tAclDCAvrZuBYEcZfOzt2ooYsar0gy90CxtU6DCuXy8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JFciYaHzIWwzeQbguqo3zLJdoU2ISt9b8XYcbAS/5iXlbZ9BBBjSmNOGbh56o/arE
	 hOTy2kmo04sC/JGUkbirqGWJv9xSC8a7sL5MGbRatw41/yikC8qAtTuXmu9JAWkxuD
	 nh1xPckZeJdS+Z2iXLzAUiZw2PopM8pVre/bQoSEzERBuQaiPukhkKihLxOvFb9t25
	 EhwdNqoo8pR61+CSSlbBbik1O2wkiSnHRCpB8Bp2v88mMzdHrjcVaT2sWvQ7YMMhHi
	 KXdhehDDl0Ll17Su1Vt4WAKiJI9X4UON3ua5wygtZZ1RCta5ooKBuNiz+b7WeR3FsE
	 4g0hgLjiK2COQ==
Date: Mon, 19 Oct 2026 18:51:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Simon Horman <horms@kernel.org>
Cc: Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/mlx5: HWS, fix pool creation races
Message-ID: <20261019185104.7a2135c3@kernel.org>
In-Reply-To: <09192a25-f141-4a88-bc5e-ffda957da554@nvidia.com>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
	<09192a25-f141-4a88-bc5e-ffda957da554@nvidia.com>
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

On Mon, 19 Oct 2026 14:25:38 +0300 Tariq Toukan wrote:
> Acked-by: Tariq Toukan <tariqt@nvidia.com>

Clashiko keeps saying that the problem solved by patch 1 doesn't
actually exist, could one of the reviewers of this series pls
confirm that the AI analysis is wrong? The commit msg says
the problem itself was found by AI, so is it not a hallucination?
