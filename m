Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9904B4051;
	Thu, 17 Sep 2026 23:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689163; cv=none; b=UxU4hsTg0gHhfiHmjeAtSyNcymylb8UKK5fk+EzdpNS4LsdN8cNdPFxrSogY+XZmEh+y7arl//QjolZdqMQrjTTpUpC40BqR0lqsLXQsEhg+1HTgQzyl66woD3BVI6JY+uJuZtJY/F/RFHjySmgmj6Kga4+Tt28KlO8Pf1KjEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689163; c=relaxed/simple;
	bh=BLbXoGc44P8eqlpbUWWoEVqplU9wMzykYpLZozubVtM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IXHhGH4FeQYhZwrG+SkKFlEbD7lNdk9Kf2YKmsvaGQNPxK1dYBBgCFyZ3TAB6a7JmqhA5Q08jnWCDuFS9Urwta2ZTXABSlSHIsGePPItedCp0DpJnYK4M8lR2Ck6RzQbSwJtNlyLlcpIkFzG5h/vnhSQ5200ZkwtgzNA6Y1jcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6lsYO4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6lsYO4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335241F00893;
	Thu, 17 Sep 2026 23:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689162;
	bh=eqkdRzdYy0+LstAKmj5+1r39Uixneq5mTA31NBimCME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P6lsYO4g5C3Ox7hXDROtA4vWo2YMRjG2vaeC9XzNnUF5EGpFAFNz87wFY/rTjXKMi
	 vVwzvBEgqoxhurRDBf6QGIHdvABG7HKNQpKCqXGxNCzQev8L/ThaevH6iy8cME9hO2
	 ntEskXtxozsG4f3uD9tdVLf+KHXvbyOoEA2RRSQm7bfWHJ4iGh1IZs6QGQuZ5++hZ/
	 QGLuQ0Sqg1iDGLOf9T8Yrg9oVTHvV1w+wtGmDMKuNYS9d1p9n/6dlqbdi0lhywWrCf
	 e6XhLj1Z0BmxrZU9TRKXQ5Ic9Q3dBovt/61ddbJvGg0kJ8eELaZoJkqyl3AfeEwGuH
	 DbjCZevOVZMTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/10] net/mlx5: Add IFC structures for CQE and WQE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <1-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <1-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:41 +0000
Message-Id: <20260917235242.335241F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Building the WQE and CQE using the IFC system is easier than with a
> C layout struct. Add definitions for their layout. Structs for:
>=20
>   - wqe_ctrl_seg_bits (16B): WQE control segment
>   - wqe_raddr_seg_bits (16B): RDMA remote address segment
>   - wqe_data_seg_bits (16B): data segment
>   - cqe64_bits (64B): 64-byte CQE with error syndrome union
>=20
> The VFIO mlx5 selftest will use these.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D1

