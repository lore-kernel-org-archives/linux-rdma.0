Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F2D3515DC;
	Wed,  9 Sep 2026 03:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924587; cv=none; b=slfR4EktXAyThaFCg7Pf0Wax6zf5+qQwJqzfBJywn5Jb61vygsbxkoThUmwMzGz2QaqzSlseoZ9+4NvXjEjIXS1TFi+6A0B3Jr2RpB+a5mcUlrpIYWrK1ufi6jFHRUR2p9zRv4dA7b0su7m0iSx4HGU1PUC7EdxM+CLyUCF6Kkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924587; c=relaxed/simple;
	bh=paBVgdaX/j0fkXZfUZZ+mEjUo5NQbbBeKEi/m1LMVTw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cQ1gdOBAF/P4/Y9gc9907KhWHiuZqnnHSrK/YyJmsXwFM8K+yb9kLK+Om/AY/YQWOmjA/OQ9jaHxbaot71eaurK5pshxLd062nicxP++fPhvrHGY4g9nZ46yBcei/qzRdIUEPGGvW2/gr/JQ0x2w7iJV9xXco2YWKwND6voYoM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OATgKCg6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OATgKCg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE591F00A3D;
	Wed,  9 Sep 2026 03:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924586;
	bh=paBVgdaX/j0fkXZfUZZ+mEjUo5NQbbBeKEi/m1LMVTw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OATgKCg6XBfQOodD6JOz9cNJvaqhyTrpAA7v4OXmF9qWTeUJtloPg+sJPsIkJ9U0t
	 7EdPQZEebAhteokuAtl1oFJQAYniijl1InN+2MWYFnsJXJ/k/EZogZxrFBJMrY6duT
	 SRDRKMUFwOhrUKTVn3z/O1XpNYlcwCwqLq8D4biw/v0Hd4y5uFFjtanpRS/NI8opGX
	 QEviUKLVb02/pdL/lnItzH33c+InSTiPm7VcsjiijZBlUQIN+fEuDJO/xxHH/0hbpj
	 0uQEQWiG/yrA5EyxdsrfMtSBQ7k2FW18lRtPeevRRi390NfH0jE1oCB9Cw1kbIOOxm
	 FN7zxbhDAQ9pw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 08/13] net: mana: do not bail out of
 mana_detach on dealloc failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-9-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-9-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:45 +0000
Message-Id: <20260909032945.DDE591F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
>=20
> Remove the early return after mana_dealloc_queues() so detach continues
> its device and port-context cleanup.
>=20
> The return is currently unreachable: mana_dealloc_queues() only rejects
> an up port, and mana_detach() clears port_is_up before calling it. This
> is a robustness cleanup, not a fix for a reachable reset failure.
>=20
> Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D8

