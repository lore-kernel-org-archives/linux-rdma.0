Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47910409275
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872665; cv=none; b=EkuFso1LPlGLTMeRFLVQeMTS1mCQGAKrumLS3GS3oAhUxXanCNu9IpkuZOVaKWuYwQaCgv18hf3ZPwxRv0i8wuoF5hvhwm26MbGtWKB1XFS4Gc35T2zqj4Jwwa9YblnhEtG/vsAJOId2ETfmb1T0+IJgoYhLAldSd4GJd+OqS5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872665; c=relaxed/simple;
	bh=maFdvv6mBtJfwKTwXE5+k62D0fBfVZYOZbNq42l3Nac=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tQv3cqdhHGinYmReIlpQptql7gjX3Lt3LVYn4Cu/mM13QkUOVA7W+VwUs3o9OgvCLXqQDdcQT6ZwQ7JYw/L8lhyrzGyVTzNsBauFeyol6W9yj02IhnmkmxRFoDYJCyWw0AzSFxcwyHlnhE5OQzHn6r9efPLHLcZeXTpgbtcR1rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRqBRDHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRqBRDHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE79C1F000FF;
	Thu,  1 Oct 2026 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872663;
	bh=maFdvv6mBtJfwKTwXE5+k62D0fBfVZYOZbNq42l3Nac=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eRqBRDHGR9qcgmqV8ovIYZ9RS+QgWv61KmSj2xOJu5rQHwZaJYoriQmbL/edCJnnf
	 V70mv6fWc2MwAZh7S4PzxV9fYvyDVPYl+xHu1G0rrABqKYCa8UVDbHWT6D743qATyl
	 7j82HgriOcR5NkVSD++ZqdFNPXHx6s+Dsvde/RlhOMy6kbiciAlpYbH2q+zpF6gTO0
	 77zW9GyNYzxuUMLvJ0qXbsnDljcIh4TocGNBFaTU02yfveAqmVLSXN44BPlfj6amUP
	 PvVfbpAjJQZNkDkgTmjmvgCm6Pjf5P4itGclC/c18fSWOSOb1IMAbyIz11BVUdguBT
	 6Kh7InOMJU/zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/core: Clear driver_udata before destroying objects
 in rdma_core
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001162628.3187887-1-jmoroni@google.com>
References: <20261001162628.3187887-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 16:37:43 +0000
Message-Id: <20261001163743.BE79C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When uobject creation fails while copying user output data (i.e.,
> after the HW object has been created), it calls
> rdma_alloc_abort_uobject() with hw_obj_valid=3Dtrue which then
> invokes the object's destroy callback, but passes the
> uverbs_attr_bundle from the original creation command.
>=20
> The issue is that drivers are expected to validate the udata
> and return an error if there's unexpected content, and data from
> the wrong command counts as "unexpected content", so this ends
> up causing the driver's destroy call to fail.
>=20
> A similar issue exists in the rereg_mr path when a new MR
> is created and the old one is destroyed.
>=20
> Fix this by clearing driver_udata before invoking the driver's
> destroy method.
>=20
> Fixes: 6e0954b11c05 ("RDMA/uverbs: Allow drivers to create a new HW objec=
t during rereg_mr")
> Fixes: 0ac8903cbbe6 ("RDMA/core: Allow the ioctl layer to abort a fully c=
reated uobject")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001162628.3187=
887-1-jmoroni@google.com?part=3D1

