Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81590373BEC;
	Thu, 10 Sep 2026 22:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079126; cv=none; b=tpqxqN/jz1jCoxk/Txyp7O0aqvecNxc9BmbPau8KPhc3Mz7L8iBbgqvowqw2iiKYUCMazDQ5dTdMbY0itwJb2523F3HWsAhXN1jOizjd57R+2Nsj6wE48M8KEUoU6QRDu9uNHuyRVqT5uFtu0Lzo3+7LK4YFSCpiyYYmX45pnZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079126; c=relaxed/simple;
	bh=jbODVDEIbJyiJHUpxQkAWn09ZJ5z9AJDxBp8LWdynNI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pLSzHUcOfc+66cuiZ2dAPKaB+AxCgGT6UGOcQe8+kFkd9QjX7PMQGnlD5GZ/asG5tRUB7JiwZfRu/gPUhnhdlpm3CwUo4zqygcDE1i6RsyMaZatT7GBuT1tBjN/nhRRr9zlU8d1VtgbVYMS3beuVwQ8iyueva9sEoQOxIRN48jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CmrmAKgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CmrmAKgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C021F00899;
	Thu, 10 Sep 2026 22:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079121;
	bh=YMxxbW2sGwBYbZwFbiU1ZaJVtkelFwrQhevZzd2WBDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CmrmAKgU0bGloquXYaNzYe8iZo8V+0gLnHiXfzlPPKR577RGXpQEOpyTmr2Tpujxn
	 yWyYILAdyN9zu8TZiUXbs3GwKY51TH3PXrKObutWl9C21Y24MOVEvIHeDoThmVWGQ5
	 ZmDDK225CvwkYmxnT7M9KWJ/sYMsNk9QPbXEq7EbQSS3WLouG64Ommwdlzx/PILd8H
	 gSCMakJyl+H1AD3ZuC3Wa5xHBUPelyeJloToc1kSErkG2nPF8ZAxjbkpzzygzidP0U
	 q7/wSzoIPUM0uV8GlPZlKH6mMGJnykp3e8IJyw0ZQC6IywwsgLb5G56WiuX8q72GiO
	 3T7p73G0Nqv8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 04/13] net: mana: swap queue sets in
 mana_set_ringparam
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260909222416.884246-5-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-5-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:20 +0000
Message-Id: <20260910222520.C5C021F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The boolean flag `apc->channel_changing` is used as an ad-hoc bo=
olean lock to guard the queue-set swap region against concurrent RDMA opera=
tions, violating networking driver guidelines.
--

commit 47803780905d457c79c09a52f280d496801d6fc3
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_set_ringparam

This commit updates mana_set_ringparam to use queue-set allocation and
publication instead of a detach and attach sequence. It ensures that failed
allocations leave running queues unchanged and keeps RDMA excluded through
failure cleanup.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers=
/net/ethernet/microsoft/mana/mana_ethtool.c
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -774,32 +772,56 @@ static int mana_set_ringparam(struct net_device *nd=
ev,

[ ... ]

> +	/* Exclude RDMA through failure cleanup, which may release the vport. */
> +	mutex_lock(&apc->vport_mutex);
> +	if (apc->channel_changing) {
> +		mutex_unlock(&apc->vport_mutex);
> +		return -EBUSY;
> +	}
> +	apc->channel_changing =3D true;
> +	mutex_unlock(&apc->vport_mutex);

[Severity: Medium]
Does this code introduce an ad-hoc boolean lock? The networking driver
guidelines advise against using boolean flags like apc->channel_changing to
guard code sections instead of using proper kernel synchronization primitiv=
es.

By returning -EBUSY when the flag is set, this forces userspace clients
calling ethtool to implement retry loops rather than gracefully waiting on a
standard mutex. Could a standard mutex be used here to serialize these
operations instead?

[ ... ]

> +clear_flag:
> +	mutex_lock(&apc->vport_mutex);
> +	apc->channel_changing =3D false;
> +	mutex_unlock(&apc->vport_mutex);
>  	return err;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D4
