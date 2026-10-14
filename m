Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0082262FD0
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017380; cv=none; b=MWBGs+Sk+YueFw3+S1YdyVaiu9cVkrve906dJ/QP8VQ6rR1mH0HSSOmVZWWkELwUd95d6+DLTEk/uh0+DqTrp9tIKf0TisfWmOQwE9wj6Ou7WX6n9Wu42IudoT5w4568IREXG1jkQzrVjIU3LM0vlPYO6FHABxArjlqfnow9vyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017380; c=relaxed/simple;
	bh=EBl5UIZc3qlxZK0hiiyIFNrZeUtvLqUEi9Z3JxPkl7Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cejFyPSiCIzMvARs5l1UgjzL3Gq+WTEWhEchsD7rO1PujqGnDLyEeAZrLrJiSWj15riGWJnyRdsiI4ZYbh5iUy96wg7hgtHtIXGKKvckL4oQLs2K2enkMUlUeieNaAwz3JKuXvNZLDP24tMU8O7gPFeuomwf6ctR2YKL6ORPNfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHd3y85+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHd3y85+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA751F000C4;
	Wed, 14 Oct 2026 22:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017379;
	bh=EBl5UIZc3qlxZK0hiiyIFNrZeUtvLqUEi9Z3JxPkl7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jHd3y85+q5e6ohelUS3KCSK3SWLZ+ZL5/yWhDeRPAtmJomfWyhDS2ZJ/KYElDjksn
	 mw5h90QuLhYH0ZJhc6YChKqPZaYBSX7TefNrZxPkEs9kn6+VyeZHaMFYjJdWiGAfAB
	 EzG5wvhRC80y2Ectgue0IodUE6Az7p8zHj7Zjrd13gbZ2K4efc1EJiuQ4M+2m7LfgV
	 8hriW1fgx5opDiL4kVcKd1Z1qhUJEWeUwjsxC7f2+uJDxPDBYV7EXN4zegbqmO3d5z
	 c/ZWjLrK2FrIOvDt0BSGiDPXgKw3Sv76WC/eIgP+mHH7+aciYm4XJVvTDBeyjesqP0
	 vDgvElGr/+XUg==
Message-ID: <sashiko-outbox-171978@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 11/13] RDMA/core: extended memory registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-11-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-11-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:36:18 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Memory registration for an unconnected transport may take more than an
> address and an access mask. A job to bind the region to, a key the caller
> chose, or a region carved out of another. None of it fits the write()
> command, so add a device method that takes the wider set of attributes
> and reach it when the ioctl carries any of these new fields.
>=20
> A region bound to a job holds a reference to its job key until it is
> deregistered.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D11

