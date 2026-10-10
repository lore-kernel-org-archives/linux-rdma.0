Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8774A5EB9;
	Sat, 10 Oct 2026 14:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643331; cv=none; b=nYrT2QEbn6Ez2cwEw7ozeFaTGSgrjSu93n7s6FfsKGDzbIJ/IJiD6BysJGWOVAfgV0AZIgjxzSsqgfiDfClK7VwZDJDIO9dZSkNmMQHMjrmeyuWKD8gpKtfLLWMktbEcuQuoXeFYXNZr6LRWBUm4B+DMokR8UqRRydu5KHRU9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643331; c=relaxed/simple;
	bh=IWQi5VBZiT8JwkZD4YTgP5QY2avI2t6peCKXLR9ukrE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iMhGM1VBVidz21Kq4Yr2LPkgg/cAIf26FMjGzfnwXGjWmlsBNsIZyt3J7NWnpNpIXSgQ8qB8Pwnh5MzaIJWlOb44tGSgb9GqLdVX6Ykmu+ld/qAddbx02uxwYLZ4IIApwrtqOk17tUaZ4YcD3zbkHjZ3/KE0PpI5NZJb+JRFTfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LbcK5/hS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LbcK5/hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0299A1F000FF;
	Sat, 10 Oct 2026 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643330;
	bh=wMw9ugio+8c42asEwVrgY6p0HxvV0o7SRz0rhFG3wgY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LbcK5/hSiF0RWeDyfL9mdElK1DOB7hYPyTNpXqhAQ4U207L2CrXZBtUFrxcounB77
	 pUwabB2PRANs5/pteHRmXqEYEJJ9C7MnFwjItkJKUnnk3m8a7zxEWGDzB5MphAQ2AQ
	 md21ecbkUYvsDmeTn8HxKM80PvzoGwdY4FDXUQLGnX3Svh8P9J8QF5tzqhx+6v0Yfg
	 f72H+2ffaUgeIOCvogh5zZ724LnqNG4WCvDxpWpKMdpArHPWxV7W0BBd6PSY6HzOAd
	 bc11It1ntx/1SBWIG5j/IiV3IQ6CaXQXJokqvw9BJTjpq/Yf755ILg4al5fSpTWUC1
	 c3qLLO41oxotA==
Message-ID: <sashiko-outbox-166664@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 09/13] net: mana: do not bail out of
 mana_detach on dealloc failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <8c515f9f2d4b6db7a29d69ebb53fe18c6c751caf.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <8c515f9f2d4b6db7a29d69ebb53fe18c6c751caf.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mana_detach() unconditionally returns 0 making caller error checks =
dead code
--

commit 69defa182668486dbe34c62749b906b0d4dc31b1
Author: Dipayaan Roy <dipayanroy@linux.microsoft.com>

net: mana: do not bail out of mana_detach on dealloc failure

This commit removes the early error return from mana_detach() when
mana_dealloc_queues() fails, ensuring that device and port-context
cleanup continues.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 51f9bfc64c6b3..9297ce15efceb 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -4537,10 +4537,8 @@ int mana_detach(struct net_device *ndev, bool from=
_close)
> =20
>  	if (apc->port_st_save) {
>  		err =3D mana_dealloc_queues(ndev);
> -		if (err) {
> +		if (err)
>  			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, er=
r);
> -			return err;
> -		}

[Severity: Low]
Because mana_detach() now unconditionally returns 0, the error checks in ca=
llers
have become dead code. For example, in mana_per_port_queue_reset_work_handl=
er():

	err =3D mana_detach(ndev, false);
	if (err) {
		netdev_err(ndev, "mana_detach failed: %d\n", err);
		goto dealloc_pre_rxbufs;
	}

Would it make sense to update mana_detach() to return void and remove the
unreachable error handling paths in its callers?

>  	}
> =20
>  	if (!from_close) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D9
