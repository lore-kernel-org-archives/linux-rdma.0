Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8633C1085
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482667; cv=none; b=PWk72FIVV03uY4cOF8ct/o7W11ONBjoVzoCaq0lKM/+v149dySzulDGKXbxS+9McqSnD+X6VMwsWHU932zM3U4WMTH8b5vuXEIV6CSW/v60rmZPpnzhNxX1L1Phy+HGGFs7/Xn2ZhAIGZ4rD2nh9fCV1wiyAg40+XyOlla+6waE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482667; c=relaxed/simple;
	bh=xOwHSYDJlEyhFKKeQEA8Drry5ohdDeOPa8ux9l5ThMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ICtZKZWwZXAIN/hJpgVzmZmA3VmJkOTnfvrQET02uYv5avPud1S76VH1LLicooIMfAkeOq29wyyb3DaEzpeUIj1GljzG5CZtayTgxH80gsbRo/GEweGxlA2uuFedvBX3Y43/3t1UqEHOOx5F3evDPUdufl9vGKsnJkUPJxTLX4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eniv4T4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eniv4T4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DB31F000FF;
	Tue, 15 Sep 2026 14:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482666;
	bh=xOwHSYDJlEyhFKKeQEA8Drry5ohdDeOPa8ux9l5ThMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eniv4T4TYEp0UmWWPTVUIOw538sHOUWueT1/E0SYOMAW6ui7ZBRkOHD/oA1xjoXNX
	 MirWytv3W1UcV8QMMQjepKilhll06h1WFtM/LRgBYyD4k1qJTMz/IhziEHcqIDj3ga
	 2QRcIBuN+zlkB+NDUDuTZ8iOBjpquvX2DF9DBjl5vKml2tF4JZ01KTLXadurZqu+y/
	 spb433q9GXXy2c7e6Tfb4+BmlrP7ckyQsmWjmDYmU5Ly6MRhFctY5iMTHs992XeeIe
	 DlExX6cgvwfqgt4wuA7THOdJPhGQTlo7gBdWvn2f2I7SJiUrxyanuiSFd2cDpmMSWn
	 bHX2ZEdiaiuJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 15/15] RDMA/mlx5: Fix signed integer
 overflow in EQE qp_srq type shift
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-16-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-16-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:31:05 +0000
Message-Id: <20260915143105.F0DB31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> eqe->data.qp_srq.type is a u8. Shifting it left by MLX5_USER_INDEX_LEN
> (24) without a cast promotes it to signed int, causing undefined
> behaviour for values >=3D 128.
>=20
> All currently used type values are well below 128, so this does not
> manifest with current hardware. Cast to u32 before the shift to make the
> code well-defined across the full range.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D15

