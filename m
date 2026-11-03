Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793744914;
	b=GOynU/0YvN5eExiBV47sZYKI79NyrAp5SgylSjPuenm0FCHa4hwEF4VmGbB1U6cutLNu
	 Qvxfrr52zvyO0pic2NwnkCG/gyORG+N954ylOkv3IJ+lI4rmh3ZufV6ixJbAE/1DYATzI
	 wy9iyvAz/LdYXqH+XR6xQF2WItmRF3kdkAzwZhHDzEf0cJaJDpdHLEWoBQ3sDMzaBWbU4
	 cgV3XcdOeINyXL/jLyKITasM2HRNGEPGL3Npoh7Hlu0zp9OvrQhAUxCqosA4pYse5sDNW
	 eaDGYIWpuhNrXCQAMNhZTBNcFbs2WUqhC1QbVlnR1j71EWYszQyZVtz05+0mzXiCDeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744914;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kuIwDnkY8iwe1v7kgeTKMI5O2PRHlPSdnu8FIBKiE2g=;
	b=bTUxy8OurI6mSbusgZM+xaY8j0vD5RST5biz1L/0uVAwawyGTwP8r+1CeH2RXkhN/zqJ
	 nt1gIKM9EA4KzOwlYhs819ndztXRjVcES5jPbQ4z2q6UECwWszFSO9MU0jiXP3n7b/0Pu
	 swthBMjzUeslTYEZfjWBXe9rYYAfKdTxT+ipFi2Bwws+m9ksQRS3X9h4rYbdD9kvHSh5j
	 T7p6IWnWpV69Pk4afz0jK2nTgH2NTnNza5oezQt4oDixi9on1tnzDwAEBRc6VFbAIRpSj
	 AUy+/+6J5Myu3He/f9h2AP3KYesoByzPcMsm6imt9E6DXb7uCIeJ44++we6XFTVC5AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeGO9BwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002D8606A31B
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeGO9BwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2037C1F000C1;
	Tue,  3 Nov 2026 22:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793744913;
	bh=kuIwDnkY8iwe1v7kgeTKMI5O2PRHlPSdnu8FIBKiE2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GeGO9BwGdRhWvSSJh0sX6Ul7cGiAg231ACtCmofVliNbav+ti+HC3By7BVznyDNaF
	 zBZj0FR6FT+TSk3SrlgvipJy30Anz9sWQ/YduaePZI0MmFyyD8cLR4u7WqjLMFmyCi
	 GfXn88BMTOSVds1QMr2yrV/lvJ4OYtcqRkqEhWY257nRdlfmNnJ6FpkzVaeinfedL4
	 rqR76deFxYzwzFTorhodE2b95vpkcyx6SBIKENf/JFbZ2oI1S3sW6T59yaPj9kvDRz
	 XIob2xs2LSDP2IlzGJlScdqnM4I4OF0uxBO78axhpMf6yMT4qOTQT1V/l2fbio+fye
	 rI05Q1Y9qXkGg==
Message-ID: <sashiko-outbox-196111@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/3] ionic: make the command timeout per device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102-b4-ionic-cmd-timeout-v1-1-2f75c2d0a0c7@amd.com>
References: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
 <20261102-b4-ionic-cmd-timeout-v1-1-2f75c2d0a0c7@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:28:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
>=20
> Device and admin queue command waits, and the firmware heartbeat check
> interval, use the compile-time DEVCMD_TIMEOUT. Make the timeout a
> per-device value, so that it can be made configurable through a devlink
> parameter, and export it to the RDMA driver through
> ionic_cmd_timeout().
>=20
> No functional change.
>=20
> Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
> Reviewed-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-b4-ionic-c=
md-timeout-v1-0-2f75c2d0a0c7@amd.com?part=3D1

