Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810632;
	b=geJMQbsKJK5CaaNfxHG/9RrIVr5EsMDaWUO1u2v5k21MK3iUtJDmpH90G3QUBjIsHaWj
	 LcOf8rfzBX1njWWyAKlT2TXQlcgD1S8d15kLVPRt1qVo4Tm6ou4vQUbekHx1WaIfNU52r
	 FBpMW8C2VCpPCY6cJIVOZkqiXwRZcMmaYHJKpAMnPWfHC5cPw5PBfiURVph/bWbsfG2Hg
	 85X0krtbNGYcsnjzrshB5Y5yz52zjVFje+dQyxyo0onjcJi6+0iOpN2id8wz7eImgir+f
	 eUNyjC4hh9QyZZfXUXntNURj5Boin0UKr5rFSOTMSQ2f18vMK5vt2CbWBxXCbc7t6kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810632;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l7LigxnBdF/xxe/OmYkLzheTvQmETmd3GtPVOlmJiUo=;
	b=XUccfnrwFi0eRWPkb4KXZfsF4YoNGmevZtEFkrGRWIM3AfZEuEQsGApcK0VJ2jaoUufw
	 u1KFIvm6gx+F++LYkHPbm8Dxb59IDrenaO/j5CNihUvvfI5QO/ea6cK8QIQY1x74eXZTQ
	 FHY0u3NzgH1lT5+alYhIVO9tgOzWiJKKFmP9itJFAUlqgSFIOj0+F1+/brz82qODxaF9y
	 Lu3UvngRbmD3pt7zirVR2MItDvkwFvlO3+9+wAuy4ZQqq4Gw0R+du4kgyR54LrKtZ9GMe
	 eweb3Q53lUKjwCOd1zs+HdeaFuMlb/uw5puiReU4LboXenE1afNylYEoH2eA6TDjFwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hB2VBzyQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C68606D80F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hB2VBzyQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB3D1F000C1;
	Wed,  4 Nov 2026 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810631;
	bh=l7LigxnBdF/xxe/OmYkLzheTvQmETmd3GtPVOlmJiUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hB2VBzyQRJODOoEv9CLVhMtOS6dEr9kO8DfYYNOwaIi21K3Uaw9eH+alM4ecXE5rh
	 vvsy4eTSSeaeqMUpaoiQs472WfYt59AAkc0Ro5+t8hoVR2nkGkB5kCIv8K8P1p3fb4
	 Ku52amHjK1puPtPX+JfXNIzbcQ7qyyx/ZIN5xRuU65/W/ClHUhZ/S8ha5A7gryPs5I
	 ecE0CHZY70b9GFB/UHAsmMZfTwxteOcwa9Hgi4gZpH/7pv794jHhws149Y/SslTN+z
	 u1AkfIB/vKCgd3TY4ggUx0sqegVT6B8Dv9VzIEI/fs9MIg1H7fFv2v7fn/js+fRUqj
	 dyzx5qNRfeWEA==
Message-ID: <sashiko-outbox-197671@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 18/23] RDMA/mlx5: Validate firmware RQ/SQ
 state before sqrq_trans[] lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-19-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-19-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> sqrq_state_to_qp_state() indexes the 5x5 sqrq_trans[] table with the RQ
> and SQ states returned by QUERY_RQ and QUERY_SQ. The state fields are 4
> bits wide, so an untrusted NIC can return a state above 4 and the lookup
> reads past the table.
>=20
> Reject out of range states with -EIO before the lookup.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D18

