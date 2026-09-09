Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5291D4606;
	Wed,  9 Sep 2026 03:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925969; cv=none; b=kOZ0z6PXnd0ti6Fuok6CZRzVi63C+zRGrz4IjYzpfAZSwlG2ptsIWiuX8hFDmiYm0XOWyeT6Fp6GtKu/xdO+52vhYdaVb/Jw+gHDN/fAqalwm+/J35md8s4P9OCcRn0Xz1y7TMka6neAghEQRt8qIkzach2dLlI+jw8XDhIixqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925969; c=relaxed/simple;
	bh=VpaZ5wrXBNTIWxfNWVdx0rKiTxsNmWrg7nTrfO1wXIU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JTyyCtyE1gBC396ZpH5zUSfk2WqyAcFKYWydrLQN/BTjn0BzbX7Oe5LvORkatpruh/JtpSHBdbSy+kY8/LQ4mOiEBpi7mrbz9G7q63APfo1tVNQnxHFSdpU80DlnTrwmEs2047YNB2w0fhrZq0KO1lu0BG4QOwk9NFn3aaifWEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dtzo5+Ya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dtzo5+Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0721C1F00A3A;
	Wed,  9 Sep 2026 03:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788925968;
	bh=VpaZ5wrXBNTIWxfNWVdx0rKiTxsNmWrg7nTrfO1wXIU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dtzo5+YaC3qG2EJPhY4Qstw0mdwUeB1RM0BpaA8hbtX5D4I8hCbQrjGZIy5KI7c7L
	 MnemO+jNlZRp2yv5QwPZxU1dCR2NETH05VL1t9/zfvAXUssSCVVNs165x5RAn/iK99
	 WiKytA/QUjlEDGfwk6z6NPRrdjb6lAqiSnRZjADDEMuVx9URww9LJbJ7YXFEuN3OJl
	 0tUAnr7JS5LhhoJOAUjVmgiFgRnRhAz8Whwmkobsau+i/E8I5Us++G7FYkOWmbAZPx
	 m2YOdVpDR8PHv1l7gCELcobrPmRFkBrFK1x1KeGd6LywrCXWYcNq3hfK4G1h+gMGqo
	 18MYYH6MOJiXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 1/4] net: mana: track when the HWC has been
 handed to the PF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908035201.402424-2-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
 <20260908035201.402424-2-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:52:47 +0000
Message-Id: <20260909035248.0721C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Track possible PF queue ownership with setup_active for HWC reinit.
> Set it before submitting ESTABLISH_HWC. Cleanup now attempts DESTROY_HWC
> after submitted setup failures even before MAX_NUM_CQS arrives, adding
> potentially tens of seconds of polling. Resources are still freed if
> teardown fails.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908035201.4024=
24-1-longli@microsoft.com?part=3D1

