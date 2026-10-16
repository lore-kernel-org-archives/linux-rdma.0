Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA71D432D
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 22:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792190490; cv=none; b=a7+s/3gPtTUT0meG0FtglN/+avzB6W+hlDza2FkP5Z7eyM8WcyxHoYQSd0PYvoeyr6bx/6TkWbxmjHtHCgHJ0nWKl/6Qra9KWxhQx77/O3NRjT7AdTtshUOTN5bdgy7XvSLdPgzHFYUMWixu+D3VauVIsVRwGznYh6i5W+RRmdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792190490; c=relaxed/simple;
	bh=7TRMvsW7UPRoPhHiO9JsR1mYh9Jh1oUeBvMXZXoVAo0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HN9TUrEE/xkgAVtVCN6mZyeppV3jdmf0Wy6cTfMe5yORIs+kS3BQ2WPd6gRIg9ae6nq+4XvHAn6dFvoc1Ni57EwBm7mnF4nhmTvsQislJpuI9zs4U/dKLm68acXx0iQivvQz1t/WlyxsRxRuf47nh1u6kc0QxEQvk1pv4o+AMVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NHiDZFdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHiDZFdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341671F000C4;
	Fri, 16 Oct 2026 22:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792190489;
	bh=7TRMvsW7UPRoPhHiO9JsR1mYh9Jh1oUeBvMXZXoVAo0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NHiDZFdMe90wApMsC0NipfmkPhIqfoWwCgalnlV7gPg9QBhqd3UpsD+8PUn9KNJi5
	 RlslsRG7pwkqWwVUYDtrl1T8Ii/dQ+Y6bhZnXk3O2U+5H4f3IN5kSwEW6XziXmZneJ
	 aGoXm4dsR4BNmEJ9rXNqHTeoC69OZEVtt32Yo/WNjc0Hv3gE3W0zKgqUby+h5kcjCw
	 PzXvisdpEUGLV2eEb0wm9zWj2stKwk/KFZDQP2M77+W00SImMptClDJHTgSNwQ0MI8
	 ci7MawDTbujoFLyZsHr1knTCXERRxon+n2iwCKqE+fggT7Ji8g5Qpey60rIGIwutxj
	 +3qsVhYD++VnQ==
Message-ID: <sashiko-outbox-175024@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dt-bindings: infiniband: Convert hisilicon,hns-roce-v1
 to DT schema
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Um9iIEhlcnJpbmcgKEFybSk=?= <robh@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016223935.1496846-1-robh@kernel.org>
References: <20261016223935.1496846-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 22:41:28 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Convert hisilicon,hns-roce-v1 binding to DT schema format. It's a
> straight forward conversion.
>=20
> While generally '#address-cells' and '#size-cells' are not needed in
> leaf nodes, there are some exceptions. Not sure if there's a dependency
> in this case, so leaving them in place since this is an old binding.
>=20
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016223935.1496=
846-1-robh@kernel.org?part=3D1

