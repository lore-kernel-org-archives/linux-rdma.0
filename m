Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6663BE659;
	Sun, 27 Sep 2026 07:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495834; cv=none; b=tmOCEfR3jFU+s+rZv9TKoBPQKxV782jPhcb4i48BJDJbS677te1UtoTti09zKZi888XYyhl+5Wx/bH31XSkeG+VuGuNtUFaF+99mLiELvNxYawBUsEu8RVzHDUSCbZUVX9PdvRN8jPH1LjMN/RXUFdp+gxqKyJ19iFO0+LHqYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495834; c=relaxed/simple;
	bh=U9uuAZtKdLkOqap+9gQqf+J52MVbxtLv9CejKmeOA9k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hE4II6oAzBDq1p9oFGf21GkD7IZ5x14VXN+x6VdDrAE3XyDw+CHQrgNsPr5JwUtMYHlY9uy12IuTsNb5Df1MKGau8nM6yxG/2C3PluVJ2mGgF07T4RZLcJr55lEcj1gClXHgQcGSOBXV5Ca4zc5bd5SfASSLlbM5BYcN9ftTfFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3Vh9Y3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3Vh9Y3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DEC1F000FF;
	Sun, 27 Sep 2026 07:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790495832;
	bh=+fxIRUUtyykaY0ipTcQZddohmjaKnx3NF9Ly992ZLRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G3Vh9Y3KMZ/DQYn3IyhcbWCppCZfxVepPvYwTFunWpn6epljSkbgVsQwbvOsPLHVa
	 mAdr+Cvp+Gp3ugf4MQDFovnH3Ds+Rk3g/fmBoVtni92hZfHngSe1IYtmuU2SIRWWtH
	 4OrlyHWrRCPp7CbY9D55qkLa/T+h2ZoiZ6RwA2NSH4NhmOa3sD52YtkIIznBu4cECw
	 BmXS0DG9EuGV64zPGxShxOHQwO/4m1/1pr6xbtlzxe61q0ksAEBOD8m/hSRey5MqcY
	 TKkRnyl/JdrwpQCpVd+9d0NfgaRxOrN43WcwABHfp6vj2OJUqRVLKTG+ctce9gLpik
	 q2VPKC+Y8MMfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: Serialize CLC preparation with link
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260927074600.3694802-1-nicoyip.dev@gmail.com>
References: <20260927074600.3694802-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 07:57:12 +0000
Message-Id: <20260927075712.69DEC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smcr_clc_prep_confirm_accept() reads the RMB memory region and scatterlist
> without holding llc_conf_mutex. The connection's link reference keeps the
> link object alive, but does not prevent smcr_link_clear() from unmapping
> its buffers and destroying its RDMA resources.
>=20
> The CLC handshake can load the scatterlist pointer, then an LLC delete-li=
nk
> worker can acquire llc_conf_mutex for writing and free the scatterlist in
> smcr_buf_unmap_link(). When the handshake resumes, sg_dma_address() reads
> freed memory. The memory-region rkey read has the same lifetime problem.
>=20
> KASAN reported:
>=20
>   BUG: KASAN: slab-use-after-free in smc_clc_send_confirm_accept
>   Read of size 8 at addr ffff88810efcdfd0 by task poc/94
>   Call Trace:
> [ ... ]
> retain priority.
>=20
> Fixes: 541afa10c126 ("net/smc: add smcr_port_err() and smcr_link_down() p=
rocessing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927074600.3694=
802-1-nicoyip.dev@gmail.com?part=3D1

