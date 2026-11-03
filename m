Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745302;
	b=zCyRuGPRZDgArJB9LgIJbmkBHrtHtmV7HgvC1kQvDIQMSYXw+Xm7aCXhHd8v1euuPL8I
	 l7aUS4LDXDYOhiAHhVe6udDy7i3/w2uCPPV9QVPPiFcCgBPxcVQOP/1zRDFX7oUFshXMh
	 xdv8atjl0Oi27MH9bt2dCpRCXrs3t7v9ICo55M2HT2cPNvadCTDk8j36e+MvfNjRMEs0u
	 XDIhEWVlJ73erMcQiH0W77oJ7Bg3IA9WCgKLiZLKKaP5RxYrcb1d2tHV5JfJe8cOSTO/b
	 BrbM3pMzhqP/z0cflMukinVma0jMcen247ZSVEtgtIgomAejO3XGwlWDXuGmV5c9N/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745302;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kjfITJfUEgIcXdW6oK6KIFxSL4tVxPlmlG5mRnx2QS8=;
	b=kmjfGdKNoRV5k/5eHYnpNBpBEke07RUfCY+tOF46wQVHuU6lAuKG8nLQlk/rJEuQ3piT
	 +sDfaoD0ho/RuzfjRNVLLIu/H2R4yivQvXNGibxObaJq5SkOj0lg3vx021rT1rZ3yRtG4
	 nqRLSN49gYN8aLaXMbJhTfqWEiAxT6RG/rrJ3qVmm8wt76xw59n3ZfMbSUwO9YoiGT6ty
	 LuzFSCdqs73Ju69W73uikDQeeJGWO/ApW+ZJJhQra8O+/bXrPmN6OLEM+V2sSWyPbTOrV
	 qv7T+sSPH9U/RtehjUmZIClo1CLnsCzHIebyEQAwf8HccjWpKly/DLmMDipThLyG7Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh5qQG3L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFFB606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh5qQG3L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2901F00919;
	Tue,  3 Nov 2026 22:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745301;
	bh=kjfITJfUEgIcXdW6oK6KIFxSL4tVxPlmlG5mRnx2QS8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jh5qQG3LaTSn+UQ6X+Wjmxd29iFOD9QSANQYnRjw46SAHAXUdgzvXVxwLMw/vs1iX
	 G/dvGwGyOIUso/kWiQx8rSwlpiUwpnSR0xuWP5LcuFGM4vZw25fu3TwDQ1Swxm7mZu
	 2tZ96islGgMRepUj/YV4K7CdpjamOAjZbb+w8oEHKtjNOCAymj4a2paIdIZxHd0GYt
	 ErvK2yC+HVw5NTrOzUunGK+MAdXmCwb3TdMpyxR6LH0wp36PJEpuEGhn8xkWaUwB2I
	 Jk/tJbhI0270lsPm90AAJ6BwgojjWwg1utgye6fm4oT8G0a2BQ1HTzrrS6gpl0vk0K
	 JuEl09AOnDuHA==
Message-ID: <sashiko-outbox-196134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 09/15] net/mlx5: Enable relaxed ordering on
 FW tracer mkey
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-10-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-10-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> On HW that restricts strong ordering, mkey creation fails unless relaxed
> ordering is set, which prevents the FW tracer from being enabled.
>=20
> Set relaxed ordering on the FW tracer mkey only on such HW, to work
> around this limitation. This has no effect on the ordering of the trace
> data, as once the mkey is configured as the tracer output buffer, FW and
> HW write to it with strong ordering regardless of the mkey ordering
> attributes. Strong ordering is required by design, as the driver polls
> the buffer and considers a block valid once its last bytes hold a valid
> timestamp. Out of order writes could expose a partially written block
> to the driver.
>=20
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D9

