Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9039D6FA
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 11:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790420833; cv=none; b=TCxvbfOb/RspNw5sVn7aRwVuD0Goo0SOcTSjgmHNJBrhgtifnsJ1cyrzFs800YKKY7ClFIpLg6ocFKZ7tyxVjnVdJ0Evk19M9bzZOXPcbKzPLlEmh9oHoqYOZYbmfcXcN9VAreyYKKoHBjQN/XNEV00VJsN988wuCrpd1+VQyrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790420833; c=relaxed/simple;
	bh=7jkz2rDNKNxI3Ns6T1NUdo+Lzv9Lt9U/B95JoO5q6xk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FczL2XW/gqHK6mNgbiYsayXm6ZCvWvLTTNbFKQ94m3wpJd4x20TyEk4UJhadw4dGYcGVMn4CyizmQLK8Dq3AXOCJKqjL2Mms9UjESAwX6FEedofbSZj/V0lDQ1eOSGmq70XEFNrda9YY7rvdJrI8ra6I8/sIsNMRKGw9+yOv+qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSSRX6EF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSSRX6EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45921F000FF;
	Sat, 26 Sep 2026 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790420832;
	bh=7jkz2rDNKNxI3Ns6T1NUdo+Lzv9Lt9U/B95JoO5q6xk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dSSRX6EFFxvM9nD7b9XLgY5xB94j6w9cKKNAqlClDoJoYJQCqkaMRL0VmzqiWrlTk
	 r5jiFvIeJ1evdh67o7OMxzT8dn/rvuT9iH4Vog6bJ1Znf+eqiPQQDWAe3MgCt8TXFp
	 3ppKX32blklW8MbekYJHp74EPQifj926LENPI8PAF322tUglsCGRmjM10zwvTdI4mX
	 jG98bdEu2Wv4gCtt8162/p8+s1sU1zcfQsWnrluoZCtXHRSE6Md8LO2FDeU6GHHoWg
	 248thzHSA1a8CvWyVdoYwyplleX6Q5Rrba+J/9ohf4bRULOKImwQhHSBv4A3asPsED
	 7QdumI8wraknA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mad: Reject receive completions shorter than GRH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260926105927.3183294-1-yaojiale02@163.com>
References: <20260926105927.3183294-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 11:07:11 +0000
Message-Id: <20260926110711.E45921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
> size from wc->byte_len without ensuring the receive completion covers
> the GRH. If it is shorter, the subtraction wraps before the result is
> stored in mad_len and an invalid length can be passed downstream.
>=20
> Reject receive completions shorter than the GRH before inspecting the
> MAD header or deriving the MAD length.
>=20
> Fixes: 8e4349d13f33 ("IB/mad: Add final OPA MAD processing")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926105927.3183=
294-1-yaojiale02@163.com?part=3D1

