Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745299;
	b=KA22Z2AjZFxuh82vKp9M+2RokUxgb8muZDNWMafdbPosl22CNvhf2CjuPPLW91CVBR1o
	 6YbbNgbGA2d3zO7XGemWY73vp3sMzSUxlZWmVtlwKJCAtsiHVsKu2wvG9fdgF/y/OWSse
	 4d2aRhTlANAwfVtvuzZIVgn2EfYZt0d3MA78iRDoLJeMBV+TGLPqgUVDwv25sEMad9WZi
	 FAqvKak2PmCWDDyf2qq4O2K5k9zUa1pycpo9aRsiINdwr63DQvfL8tpBEQ8mz6fYZwcrT
	 6KYy3G3VoJwsvkFD+d1+jnSVGx9HiX37tXDCZJ8Knv3W9kHjO6TeY3JpO6kHEMfRDwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745299;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=M9jzon2ftGtuV9KMolnBzJsXrKVJlSKvivagQseNR7w=;
	b=BT7EMB8Y99hdK921wdxmLIbqEs0b0kqaquieQUv6+9ksziobCCxihAFmgNcfxwjMz8WQ
	 QNLmujHNMGF2u+Yzq+ZJ6IoWxp6qU+AsiFzRblHrCA2yT5KHkcLgAS7CWsxm8EA0iSU0b
	 aaIbBz31liDVEZ3lB4KwoF975DPdLlJAXl3w2XZdiuVVshCiIyHx5PfCOUyZoyz3/9zu9
	 4lvvKaHVluf285I4zWXssONDfecB56YLUAl/ktfVy88VCx3AITAkzDe6q4Xr8lWRoULs5
	 ynZw6xoAoZ/QTje6dk6FMwuplNwb7Ua31AudJCs2sXwVdpSAEgZlvWL5h9/zL+RmQmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJEJrpbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B500606A32D
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJEJrpbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F701F000C1;
	Tue,  3 Nov 2026 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745299;
	bh=M9jzon2ftGtuV9KMolnBzJsXrKVJlSKvivagQseNR7w=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=SJEJrpbcuCiUx0r8j0FXGIhxqaYrY3zt6W4OqD3SM0EnkGDHjh/Cp84q0ynCox7SH
	 3NivzpSpx/ug0CwlWDXKxOMD/Se4IPt3KLkgJa9f/wwmwlXpeYv2hjwNW9lBLaXO+g
	 hee8oNKCz6yyL8uNA5XTXY//jfvNDHKljtoczOAtMwSZWsUU/oo8LQ3Bm0F3IJ6yt/
	 f0ohTaD+nXqWzt5kjzm8hUWjcrkwFaLw++H/k4wKUgMFmPBnJWFGLIpIXqOepl4395
	 bWy+alij9Qa1tlOfTfVkdeK3dmmut72OCiD3Ll3THk7Bz/V43GTqTWy9ZV69OXEeOe
	 K/BVxlp5RbX6w==
Message-ID: <sashiko-outbox-196130@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 05/15] mlx5: Rename IFC bits of relaxed
 ordering fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-6-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-6-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Align the IFC field names with the new naming:
> - relaxed_ordering_write_umr -> order_write_after_write_umr (cap)
> - relaxed_ordering_read_umr -> pci_relaxed_ordered_read_umr (cap)
> - relaxed_ordering_write -> mkc_order_write_after_write_ro (cap)
> - relaxed_ordering_write -> order_write_after_write (mkc)
> - relaxed_ordering_read -> pci_relaxed_ordered_read (cap and mkc)
>=20
> Update all references across drivers.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D5

