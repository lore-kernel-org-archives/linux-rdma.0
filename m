Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D22354AEB;
	Wed,  9 Sep 2026 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924592; cv=none; b=IO5X3pdSDhHVo+8rFAf4piu6BI4d+dmkkqEdfWVpEr7rZ9eQEeLX0AlImfAiYBBFxNnBU1lLF1kmBs+a3FMg9onPlT2BmszmL4d2xaBL65OB2VwTFWJM0ecs3RzoRWPXXm3XQdAYPbmVT0gJlcXJdCdYz1trPYGEg6LORb1vIWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924592; c=relaxed/simple;
	bh=iW7pqS0bLIK1ZNzQBXUv6CWf5uG6Iv93Oocvg/GvSrY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G7HXU72cIPXz0tLtV6tAaVoF0mEQuBQPMvhR0+VangwizMbUwzh7AoREMLujJlEvx8kc4UjYpjKBya6PU3BHyJhjyG1bbCYWB5wiciD/vbr+iOdRykbKJGESIMSowoCx6JMpc60Q4458qosbh7NU0U3LaqtcjTeFw/0kajFQpKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRmv/DDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRmv/DDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F271F00A3F;
	Wed,  9 Sep 2026 03:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924591;
	bh=iW7pqS0bLIK1ZNzQBXUv6CWf5uG6Iv93Oocvg/GvSrY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GRmv/DDSCOSfEG7r+RT38w+GgBD+vddYzYRdMnyxVCw2wJ/24NCN5X+9ECmLTDAQH
	 19Am8S6ldaOAM6FHxbG0+ohI6it3VCChVBs2LmprllSdJFvYtsD9qsqbZStTdhcGZM
	 VEzLOcG0JB9pKUNUqIEhoN1C4a3vZy31Ei79ifSSr1qocliD5tpwPgNFKi8v8LerlO
	 Y76hns8z1Q6sqHBn7JAiIp1fifqkaDW6fBb2B9aaWdTmuQjM78ylniJ8Bfg8vu8hmn
	 U6UaMG807OfhlsTa+4p3UqxrDhDHfmOuewitCsCnKn2FGSPPsLEEHMgcTCFy10R4MG
	 ouQI3ISMY+RaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 07/13] net: mana: swap queue sets in
 mana_xdp_set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-8-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-8-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:50 +0000
Message-Id: <20260909032951.07F271F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Carry the XDP program with the queue set and install its per-queue
> references before redirecting RSS. This keeps the RX buffer layout and
> program together during publication and rollback.
>=20
> Do not replace the live program during allocation. This also avoids the
> pre-existing failed-preallocation stale-pointer bug; its standalone net
> fix is linked below.
>=20
> Link: https://lore.kernel.org/all/20260904202640.3900685-1-longli@microso=
ft.com/
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D7

