Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826900;
	b=S3u/578d7YN1ljxhcKa3MugM06mE/oxydBZ3UHGEwYkcDcYGcDVYY/UTPLtwATBNXur5
	 R8KmkHdNgfxfvgu5QgraBwoCCcpNr9OtyE8RGvMzEFxqANSFPD4NqkyI2bqVydFV3QZbw
	 OGMxmd3TEiLF3oxRioBpKWmZvNL1/uCG5LcIiTN5v0X/NhboMoMrvM2aNcOvAVAF+8UAP
	 E59GrIh7+R6ZTQ6poWGdfHoBqgAA3B72AQlglaooGqlUjJ0Dk59HHygxg6tvNqzg5p0FZ
	 NVSD0FUWAhgGXbk+weGJsML3fhBEuehei9J5o89qKWikDcUXvFmmcwejOc9jGypC1qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826900;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4XJ7Y5ih6U1SYVWC8QWWlkNzc6N22IY1SWBmX+mrZY0=;
	b=Cc/Xeeh/iYDp/2QnhloP3prCSjrNvhgFVSFav848OAqiVftM41HL/jlXo5xSpkziE7wm
	 wsg4ZB6zpwCovuEsMuVcNsXPMJj17kkqSrsJ66v9HhpMw/quvfV6ehXucubbfabKZxpYk
	 g7ROSavODuetPREMYGZ+yXT1v92rHxgpQdQfmB0kPmYDZqaV73PSjd46C1b0J2e4lQ36m
	 DHcnLw+jyhD5sA/QpUaSaX+VNPKVthI1Qh+Dd9oPKatZ/GFsU+gzpVpb/aySJ96bpw0fK
	 5Fc2AjVVG6vLfc/YDvMFAivT7cxD9iAjwDiggurcAA/mkUA8oEMEseZcrSmMh+HpsLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gaB/PHSd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C00560B47A9;
	Wed,  4 Nov 2026 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gaB/PHSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94A31F0093A;
	Wed,  4 Nov 2026 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826900;
	bh=4XJ7Y5ih6U1SYVWC8QWWlkNzc6N22IY1SWBmX+mrZY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gaB/PHSdwm3ayXIkQKxmV2Y1Um9GvjkQz7Zjgd/ySnMF2jptmuXLSNKXq9Ig+HP7y
	 pNvrdkOSQRAbY42HUxxqiXTp86QYqoxG1aDHLoc4TMAw9SyLY/O/XlegJUPLdeRt6+
	 FD+wrWnvYZh37mXMQJqQMu9lDmbiqZ1Re5yy+U2/F1SmKGRxeYUeeYoMXRIaHZazpZ
	 lmvq3SrITp53j3vHS+vq3emnzHtahBj9Io/MQc3RhIzGWVTKIDaciUxlQ488O4P5I7
	 ZlTDEzTBudt8LTjKij5+ip3ahY8JTFDCJLhX51pXrtFdJlNXDEplSS0Hq0685g96Qy
	 8NzEDShFJgg3w==
Message-ID: <sashiko-outbox-198074@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 5/5] net: remove skb_mark_for_recycle()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, virtualization@lists.linux.dev, linux-rdma@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261103211424.127627-6-almasrymina@google.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-6-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:14:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Now that page_pool reference counting is dispatched directly from each
> netmem's type and skb->pp_recycle has been removed, skb_mark_for_recycle()
> is a no-op stub with no remaining purpose. Remove its definition, all
> in-tree callers, and its reference in
> Documentation/networking/page_pool.rst.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211424.1276=
27-1-almasrymina@google.com?part=3D5

