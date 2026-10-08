Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA3E4AF17C
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470331; cv=none; b=oUnUV5B2xCSBt9VV6wSlQduziQ8jeQeFA6vqNRcQCgdnpaJfzf1qo2+aIAZme7/pXoUVlQPiF+gxZ/LwKCaxnZDw9TEakWMxIUlz2jKBKmzvvROOJnfLQb85t4s0ZOmq4xeW2ZIIxS4ZltYxziVa5jrlJ1gf+uBo9To8DnK4tew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470331; c=relaxed/simple;
	bh=NaMgPTClS5XWo2CKkyK602HunI1b1R0NN+M9juA0d/k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=An5Ad8ZRhPBrVanGTDPg8gFegomrzw32d60qyK+C6LEkbHnKd/UKOXB0X7f86BBoTDRVbMdOUnXRZb0/mA0cTsMA5agkvFYoSvwkw93LS7XUxcnnCuxrFMRqkg14G2QUxA5kP3f4ibzWEHCxhPJSLK9gfJ3Nn4rprSODHqHCDSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8mu23bS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8mu23bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C2E1F00898;
	Thu,  8 Oct 2026 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791470327;
	bh=NaMgPTClS5XWo2CKkyK602HunI1b1R0NN+M9juA0d/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n8mu23bSeimwEI/18hduIG/iLm5nOiZF51DncFsegMyfgc4JLuuxjXDYrNGWSx9PE
	 STCa0aD769YC/GVe5TfPNdgLasTiNkP6hcOPeQdCGb4SzsKo/HTsRhb+4LG5PDO2CT
	 H64jpP86tKIUIwriTO5pf9TrE6rRVK1hqoDphxtXiPKvz4KPYiqTJ00YAJx9QqZOxa
	 CwGyfl22neflDCjWdO/jQWsPnmwNmqb9evj9FN3zDMf+BuBHDl+NFku5acyf6ZiPka
	 CuU0E3YxzJCSbyATt4Z1Zfwtj9uoaWiSp89OePIOktAUkMTQL3+4JF3+HKW+HU/Dod
	 CNmdGtoyH1O0Q==
Message-ID: <sashiko-outbox-164311@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix flow meter offset within its
 bulk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007143830.1733583-3-acassen@corp.free.fr>
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <20261007143830.1733583-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 14:38:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The flow meter action is bound to the first ASO object of the bulk but
> the rule offset only indexes the meter within its own object. A rule
> past the first object runs on the wrong meter.
>=20
> Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS actio=
n")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007143830.1733=
583-1-acassen@corp.free.fr?part=3D2

