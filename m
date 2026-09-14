Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2D844A3FF
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388369; cv=none; b=ZqWT5mvxaGVSVlN7dbBpvd1kE0ul6E6uODlBVjaA53eyIccDgKY4daF2ZhTgUIKUraQJVBwWHZ+gswR0waby36tsM3lJUuZQMBcn+sOdouoh0u+oBehWVhc7mQIqr/ICAgkC5NaRClBVjCIyvN6d+AuErgABDC9ALFMo9OdWptg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388369; c=relaxed/simple;
	bh=HhdhLTa/M/rPBFCUVbglJr1BoY+BnBRDrvrc8J5Oz68=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tgKcoqlow8V52G5xrOkm03RQigAphEMzITrDOHaVo+p4W9uLRVNGsD9lPiSkOt5A53ucrajx7N8Hoz/BvTOHkz6Vp4cJ/hKiSbLKKVrrOLEMwHkTYudZR7ymXEo2DL7vX/Krp9p52reDM8Bdj/0YRDMbejPBdqkiKW2Hbwgw0i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ugo8+1hd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ugo8+1hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E493B1F0089A;
	Mon, 14 Sep 2026 12:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388368;
	bh=HhdhLTa/M/rPBFCUVbglJr1BoY+BnBRDrvrc8J5Oz68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ugo8+1hdsF2Nl42Oc8i4zMk5jKQ5GQ74PXe2v40y1Z4V5rATDyO7K3vw6DKMuKpM2
	 U66QIhjml1URgrv0uQbQ+Ej+AC3teVVbWyJ6wQS+uYmtSTtCU+1ft1MQD9UOryjGFN
	 q1QEs0MDCD/BSrb55XiGcJ6DdDD6tllhpLOduOlqui1CEpEYHiz0g8QuCyxzvbHEIt
	 BBGL2kTCrz/uIcdpCO3f6rUE5jHGH8/HRfwDhGsqTOcwGbuBlTJT83y8xsfpc4IPDt
	 au21cSmCqLEt0FQayYbfMj6ROOhghHeK8NDSH+c9LXP4mYy+zI6z6B9TWXNs2kJiye
	 TFmPJe44Cqtmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Print err code when create_qp fails
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914121253.2193-1-lirongqing@baidu.com>
References: <20260914121253.2193-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:19:27 +0000
Message-Id: <20260914121927.E493B1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> Add the actual error code to the "Create QP type %d failed" log
> line in create_qp(), so failures can be diagnosed from dmesg
> alone without guessing the underlying error.
>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914121253.2193=
-1-lirongqing@baidu.com?part=3D1

