Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022024;
	b=bK2afqU4BjIrxydzqpQ1YE83DjQxqSNeEIYFOWjyBW2w5TyT9pLYSwC2w49XaBDpVgu8
	 ZprV8Dobqba+TRDQi6rqqK2Sj9EcBMEpZkzkCENCDUzsbrtrb2hnRrbwLCizCMeJXLsZu
	 Bk3ki7I6JSNn3GH4wlb7d6kkr+97TrCPQ8QO1sDirtQOIbNxEGcizRB73QU+BxgelF4Jf
	 q7frtqrSDJ4shkzAQsyDBiwxDjwr4smvgFh76kd75hZxfd8lqwswR9v2svM9N6mS7lW58
	 Ldfht5yEiAJ3Ycm7/oc9ibFWqEckNlJg+ZU83ygyEyTmLju7Djp2KiCPPpN96mYa9jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r/t538nw2wOEl5uzm8DW5LXpr+Xshsa0APDeJ5wGXL4=;
	b=B/XWk/ChdMqi22LUaUKyzjQbLlY5C4whk2o4Ry7ewMQbYYYDXuS4f5PEZragiKV9jN6I
	 GA9cQzwFvKIix2A1f3IDvH9xWGgwccos4dI9LMl5QwudYRZcPU3SVbELU+ltXOVDJCDNB
	 +PfqZLX8yMp425UHTa7yHgzgn8JVTBcx+C7J64hLaPU+XT7HMNiAL+OXBnxNtwal1g4mj
	 I2Q6TQKiwVJ86OXz0M0/pN19p6pd/IWONsQnNEmVqaF7NrFk5HnDTZTxNmcmJFLPilcwy
	 YHq3ooHmu9Xd0Jys1w2EwAqWvKXjDNS57mHlvFC/9zwTmz71X/u9NK/A82mO3l2aKVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSryH5kV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C628606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSryH5kV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBDB1F000C8;
	Wed, 18 Nov 2026 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022024;
	bh=r/t538nw2wOEl5uzm8DW5LXpr+Xshsa0APDeJ5wGXL4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NSryH5kVsRfL30RXaIoLgDIT8LBxUPTviZ+jbNHKfPhCywV8RA/gXQNLBz7dytj/i
	 QOQesa6siYjfFkYMw7u37lCISEAP6OobUgWqkS3x2dhaDd+jpZVw9wLAM1+UOs4FUl
	 Y7B+PhF/xTOU7gNbNJCmc7VJRs77YK8basPzfIV4T6H255XgkDaMvZStHDSdn2wbNS
	 2EoI+XNSc23BaP3x0r8TCjsTOGt30+fHm3aP3lcr27PF1OOjOa5bixZNnvDD11gVHD
	 j4wA9f9z9EEF/0ipX+H5YBrC0g0v2VRAoI3RaH1+zqEo4CT+2sDGjZoA8FI8sGch/D
	 M0ynAQUXOLpjA==
Message-ID: <sashiko-outbox-221607@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 06/21] RDMA/mlx5: Reject QP transport types
 not enabled by FW capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-7-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-7-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> check_qp_type() checks the FW capability only for XRC and DC. RC, UC
> and UD QPs are created even if the FW does not report the matching
> capability bit.
>=20
> Check the rc, uc and ud capabilities as well, so that QP creation is
> refused for a transport the FW does not support.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D6

