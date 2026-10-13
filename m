Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1535379EE7
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879732; cv=none; b=qYtpXhGhLvQGvg8F/GYy1hQismyTL2K5FNSQ+3/nxw+xQcpT5wRqeoTqLEzA++E57xb3x1a6RpdBwvoJQOtQuZ8j5rFni15tmH0YUhvvVxq6cdTdUZFQK70qd6vSvEhSkPxehOu0NxhUe4m5nDvB0TLZ4QOkIXxIQoFT2xADcFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879732; c=relaxed/simple;
	bh=3o3dWqfjzoi88z6KBe800+v2k4iW9JHEXe4AnByYQ+4=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=IvnljQzv9Zi2OBYJmW1jiEwjjtfVnGdwCiRG2rbUnLsHW0tMyIMR/rB0dWxCCh1P1tqpxRHduHfA1DH4x4muW6h+AqBtFk0mtWLrmemCicn1AB3deRcyFftJaoT1uu1GxTFd1Y6aXxSWAnQfwWpZOXxYIoZppk++s+QdVtF8i0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qou12gbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qou12gbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16CB1F00893;
	Tue, 13 Oct 2026 08:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879731;
	bh=3o3dWqfjzoi88z6KBe800+v2k4iW9JHEXe4AnByYQ+4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Qou12gbT5jZJtOz5Ql/UTwUAOPZTVCdA7enz+caGnUw5EXCfpmbJpuMR0dKA1INlV
	 9YFLWJuValbUYPFWrg0h+ZtGbPxLSlrwD0BdVA2Y2rFAAnHbMnlqUgbvvjYKaGKdKQ
	 TBVfCQz7ceBXpczPyZP32ePGvWRWUF6OgEtKw4pYxZresdw5jf+0A3PYTQ1+duSXjj
	 RcdhLVhZX1dREG2pE80mRnjX5WXWtubLz+nxFnk2zYYcAkuAnV06srUelBOkGwuP8u
	 ySTlkxSDzJg/nR+Dyi7Zu4YrTmm5Gh+7jRfiu4BVDev8mgEm7jskc0NWqSLoLidqyY
	 Kp37SrOXto0Ag==
Message-ID: <sashiko-outbox-169234@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 2/6] net: skbuff: add napi_pp_get_page() and
 use it in tcp_recvmsg_dmabuf()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261012082148.1698596-3-almasrymina@google.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-3-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:22:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> While napi_pp_put_page() releases a page_pool pp_ref_count reference on
> a netmem, no symmetric helper existed to acquire one, forcing callers
> like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
> niov->desc.pp_ref_count.
>=20
> Add napi_pp_get_page() to pair symmetrically with napi_pp_put_page(),
> and use WARN_ON_ONCE(!napi_pp_get_page(netmem)) in tcp_recvmsg_dmabuf()
> to match WARN_ON_ONCE(!napi_pp_put_page(netmem)) in
> tcp_release_user_frags().
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012082148.1698=
596-1-almasrymina@google.com?part=3D2

