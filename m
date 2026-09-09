Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9A233F38A;
	Wed,  9 Sep 2026 03:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924585; cv=none; b=UF0oGPnqPwJ0Ujl9TF79TTFb2t3VrLnd0LtCoShBWYjJ0wcAMGTHEyVd886bU7ClVhL3CN39xt2YxveXBcQnSNuryTO+N3gH94ZVlQaoYkivVyf/5k6SvzG+FAupl6D1+UuyZJr6KkqcIPB/zVgpHHWTLMG6le4P/r3+DBMluSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924585; c=relaxed/simple;
	bh=k7pHSNrIQKw+FMUWP1/4PHEXoi+/5IzqXRh9TJff+q4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I2C0zgWjcvRna98dLTqEbdQpSQPNQ9cIpaOVgOHmyV3us3mvFM52jni/P133PS4JIJThHhPkb48AJ2jXcyIGc4J3aF9DNdLZlkqjVGnTR2qGwqDrbS46euvXjiCmvq9loM05Ne9+VCEub4m0OMfyv2K1nm6fws+D1MXyKnQuyJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIT81BbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIT81BbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D32E1F00A3D;
	Wed,  9 Sep 2026 03:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924583;
	bh=k7pHSNrIQKw+FMUWP1/4PHEXoi+/5IzqXRh9TJff+q4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MIT81BbUlkGEtZeneoaSdkn3n9weCSa7D+v7jzmzy/5vQguNymAj9jJICAGHTjMPe
	 1cQlnzcLSQXtxgNaeYacTSAxGGFLO4RGQkL68+8LCAiZhnEToU3rZJ58ryIUwOedzG
	 JSEsXKqNnu9LNNNW5ndhfusy0vhijQATVToMYxmGnp85xZfaH5shHtqPzUoUXO92wt
	 kKv+zKjHJtE8wAkPWzYwpZ29fO/ZGdKtVhjumYhDiXAKucLiCbR//rwzPOLIYilabX
	 iIhZSTFixvg0RY7WpGf1mNg490FPsoYxQsAlj+61XYvKwEUmnDlbcWXbvg/vaDyK0g
	 i8jmlG+BeU8MQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 05/13] net: mana: swap queue sets in
 mana_set_priv_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260908032843.397667-6-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-6-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:43 +0000
Message-Id: <20260909032943.9D32E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Rebuild queues through the swap path when USE_FULL_PAGE_RXBUF changes
> the RX layout. Carry priv_flags with the queue set so allocation failure
> leaves the live configuration unchanged and rollback restores the flags.
>=20
> Retain the shortcuts for a down port or a configuration that already
> requires full-page RX. A failed rollback closes the port.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D5

