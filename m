Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3404772AD
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157565; cv=none; b=MvLJ8yDOeL5mUVCTunG5sxt8I6LcA0pEgcxObmNqSylLj2rskHE0ONsBIzPtNekEZH16yv8bmBUjuVIFa4op1UeZdsC2C2prYm25TpzmDak6vLd9Molv7ZVrU2b3F5EHq/CWvM66zk87h+IenT66xxZbaKlbJixfwHPcfTkoj8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157565; c=relaxed/simple;
	bh=hw5kEfvkUwCdH7E1t88ijtSavbuEUlhwYHoDEkv9gac=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bYX/uB1zFbmXIcSoVi5bBBodReqkYaexWrle72uJhENAWbRQk4EumjqTcRz54hiO1jBKFob8hiBeouUuGWGbD5TqF1NRrrs0FLJlHpRAplcZnJ1frbSrCmZjvcYGHufN4UDT0iSEKI75flT/HZmHFKW8hvB7ew3L+6lsCE4mMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzlL+Is8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzlL+Is8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E982B1F00893;
	Wed, 23 Sep 2026 09:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790157564;
	bh=hw5kEfvkUwCdH7E1t88ijtSavbuEUlhwYHoDEkv9gac=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VzlL+Is8LB6RVUlx10HYd26kc+NleORWo7SBepa/XBcIkZ392DVKfdigZel3IdYxN
	 GQwi5ipGvPfhMf7M5BIQauTlhV5/xUrbns3ydmUYHlNFsERkwwUc/Aw1Cxofet2HnQ
	 JQk/aGCrZ/XyXIi6yId4HqFN9TD/7XelMU2u6B8C3Hv7ZTAkiyEMWufgKXOQ9KC6sn
	 /SvjQWy06ciwDjCGEkJcJ0Q6iZSQbfDre/7H/tFrD8N19x0jzTrEJgC4N2Sn2UcKw8
	 wM9YP9Oa1CQWJXOy+1Q1alohkoABxu3BF93MEjMcXvO0aQqiSUHTINUKFegvXiiufv
	 V28HoI0KUC2VQ==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v2 1/5] net: ionic: Fetch qid allocation and SRQ
 capability from firmware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922095724.3683011-2-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
 <20260922095724.3683011-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 09:59:23 +0000
Message-Id: <20260923095923.E982B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Read the qid allocation and SRQ capability from the RDMA LIF identity
> reported by firmware.
>=20
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922095724.3683=
011-1-abhijit.gangurde@amd.com?part=3D1

