Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404814;
	b=ikWt6zgBCXTW/1BKA2bZaDyA5A2xXGiugs7HZV0eU1rOqj6qTMcBeO0KaKrfkTmuEBUE
	 z2rGsZ2Src2/wg4270i1dthcY3KHCCcuAxrNNY2SkcFLMEYYOHs03S7TaaPOnbcIGvK6g
	 vxHtE3kwIIu1XN3sBpm2XpKOa5W80ovBZwJ/de98HTzWLzcVKmrP1HkAgBQ4b9mRv9jrN
	 uO2bP45D2j6Rfh6IKBFbbC1l4ItVAwNKaUnIljg2SIaEpft0CxWrmVXqYgubKWtxmjuZV
	 mOZqV+KZIXJt0LMl3OahaBYLzBq8gtvuFVxIqZgg2X5qI+usjx10iVmZlA265+TAGJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404814;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zltEMOunFn6LtO6paPx0RzvGE3pc0r/DdNGSyvEggcQ=;
	b=UAoj11J32+55s66T51XXwVScIrjjAyFBU3F63QfjaYWIgPBluocXXGKF9TtY4qOvJ5/g
	 wQkwjxS5lnHOLqRo5P3tzi0Pq0ea+M6Q4Chx/JCs5Al0Z7hTTLPxs5Pq7JR2hZiQ2WKqd
	 aclSYSFbh6ExvHN+A1+i7ljhWfpHpbvwAgcf7d8t9IvgEB+tPT962AGNmZUPQTEeLsJ/p
	 iMRTVHjD0x3caDnDmKVXQu6L0i7H5uVSbQBjUxvLY3mK1ctpVMkdO2Fktt+8yvr4cXTKk
	 7VBxJlQQtfIUKu4z925URg3yXXA3VwzoTobbsVuODIuGk/MfStLB6IozHwAngB6/IOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BRH+emKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB54606A335
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BRH+emKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64601F00A06;
	Wed, 11 Nov 2026 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404814;
	bh=zltEMOunFn6LtO6paPx0RzvGE3pc0r/DdNGSyvEggcQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BRH+emKx/1AfhBfXeHxVjgGe1vOmspBpzYIPIguYvlcNJp6pXulMV3/MILkKJCyhU
	 ezXGgRnbAarS8bHLThPJiVG7dtcGtsCJdnyhy6odxfRDnMW0jj8B6cnhTJf5jAYDhq
	 dEDoOEMJd2yacx4wNzziqL5VddwoBkQNjMlp9lNwI4E2TcYlkJGy2sefcs4Ybv1WIP
	 A/xauTCxZLgO08axBFrUKnAwhVNcDZkTOObTlFsKHImjpu4BxO1T+9FKk51YCIZcbI
	 P6CRrm0Czo0G9YsKS+30BBpot5bFXhv5lwjn+gchFOFFQUpcKsasKvxElqi8YqZSfF
	 FwKAFJ94BPK2A==
Message-ID: <sashiko-outbox-209100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 15/24] RDMA/mlx5: Block generic CQ poll
 path in adversarial mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-16-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-16-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5_poll_one() trusts the CQE content, so it must not run on a CQE
> from an untrusted NIC. In adversarial mode no CQ needs it: the UMR CQ
> has its own poll_one that validates the CQE, kernel ULPs are kept off
> the device, and user CQs are polled by userspace. Refuse it there, so
> an event on the UMR CQ before its own poll_one is installed finds the
> CQ empty and no CQE is interpreted.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D15

