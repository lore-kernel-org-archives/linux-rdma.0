Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D867049DB8A
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791301089; cv=none; b=e6Ma3M0OqSSpJirmwNRDeljcxA8zz7h3Tgg1q1BVuVPMVDIV6r5huh2ROI3J8DkKwyFI++V8KuEVQ3pOZTGCb9PSmL7WTl3MeMpkaIa72uXBM2heVzuGXMDLuLzvWT1NyiJe/X1/g8Td70E2wRmrhirebzY2vA7+316wzQ+EdAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791301089; c=relaxed/simple;
	bh=gC7LTqHOdotng80TX//AmZlZSvAj1ykR1cBjJQmHxS4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lI1m3pC4e+qIHEY9QOS9PIGCpP5NQc3bexPA0Beb4+DULIza3kJcy8z6UeYiUCAktHa8NI8VAZQbK17v7qD5e8wKq1sK42FQinkXHK1mcE/UrmGAlWpMaR5UGTip7J8RHUELOvg135noIubj3rKU4oazgb5HEDwAe/7hnmZ7s98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/BJZGxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/BJZGxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5667A1F0089B;
	Tue,  6 Oct 2026 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791301088;
	bh=gC7LTqHOdotng80TX//AmZlZSvAj1ykR1cBjJQmHxS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W/BJZGxlkEtFJtCIK9QFV0qSbMlg0NsdbXfMwHamtJC6oF7XBG56VKrFvuc/rhg0O
	 vtZe8pAPoHiMv021eo+uPqzX+p1KZgHwY6NYJfSEkhwlE/8shBbx+tBHWSYC9/nU0v
	 lyismWou9OxSfeVJCYDD6HmZh2EC6jqs3gJCVSMLEQIuaSIgCPDmdXjBmUW1ZtqrUH
	 Yb6E0dNGbWsJ47Sfv/PPcBY/CgSi7Agw9wLzH2CkHY7oQdzszYU/oydNTyMMHUGRmS
	 w55X0qZtHldxiN1D/9mWGFomsPIEjke8DuitG4MJ4LNXxFiZXAzlrVwGeecswSXAs/
	 t+Rllofk1ZzYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/core: Clear driver_udata before destroying
 objects in rdma_core
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006152908.888059-1-jmoroni@google.com>
References: <20261006152908.888059-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 15:38:07 +0000
Message-Id: <20261006153808.5667A1F0089B@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006152908.8880=
59-1-jmoroni@google.com?part=3D1

