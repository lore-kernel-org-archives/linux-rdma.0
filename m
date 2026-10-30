Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336067;
	b=Jy0d923bVV1GcaCYLsPivpLvIDJdhVZuvk6RyrGiwquw1jqbQ6U+wxFZ5oHopovTNPxK
	 I0FaG4enVvfCU0Y+ObO1VaYKi5PezVGq5g6MmH4+yDxEXgP9SgYB0teuVIpT4Kjvx9hRs
	 1FiSBEUDL4rAlKuaw02QJr2PDcCrw+hpryH1rKMz5YVRPEkjgvepaGgE158vCEprqNIA3
	 JfRq051N2aTTUEtdWH41wHJDm4YdK6ZE1gVpD6ILMEn1mEeTMYkEpqH8qVugnnKr/PumS
	 DAtxVNc6i92c3wV4pIyDFt4fZa+Al5yLoSwty9Sagv8FBHe/GbZHEArzagHuGesOFeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336067;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=be8jusb60FcQNE/FBCMKG6kttiRMUGUijABVdReZfLo=;
	b=ZOFyRSFT2cMkW9z5Rn+lYzw1rmXBJbjoBOG1wITcvE/GKLtUUaCIChvhIzMniRwdPKBa
	 LrBqIDGXCE+YtILc3MJXjgboOjPrtIDwFWvTZVGpB4zpL3eB+CVy+Bv+5cPC36Cik09dn
	 RMa1DtVI3VERBSKmRNJaiKweE9abX6xp8TPLO+dcZU/4454N+pznEHWhw/AOg2JRoc+io
	 8UPGETos9XqdyKBI6mEwXYSl8sKisMJuUafrIFPUizl6weFu7+JnnZDIf++IH2oFNqaMA
	 ww0nFvkVrvjcS0wpESZyrgPQumMg8L2Mg7hrD8y867kA08+NXtk+malgl2Si1RVKMgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlUEJdxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9023606A324
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlUEJdxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC341F00A15;
	Fri, 30 Oct 2026 04:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336066;
	bh=be8jusb60FcQNE/FBCMKG6kttiRMUGUijABVdReZfLo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hlUEJdxAJvfQW0h9BlUvgK9hKRVdkoLG1sPWFdNxv0dxZyuSDX/1kL1nLZdfYPk2F
	 99i/kqQSdCbxeKP+SG0OW8KE4hzotQw1r6eWyDB8duUlzuaa7n5JluBqfnPQIFlyMi
	 1DzPINIHmyUUaVIgixzPrF170xf48Eu95LaoY7I8NHqvPdd7e9dV34ckaCC47N/Fm1
	 AY8LtG0Niq3JMU4d5e5vSxvayJC186HI6LTZUZ4suX8O+76wakD+zX4WrRHg1mmcNU
	 mcOjnT//suN7tz1ZzFZ/5igEIl98WXIvsHzcsXl8x0JxrH5GAHXz6nkOzDhwGKyGPL
	 QjsBUsIhoyLDA==
Message-ID: <sashiko-outbox-190465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 3/5] RDMA/ionic: map PHC state into user space
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260610154216.712374-4-abhijit.gangurde@amd.com>
References: <20260610154216.712374-4-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Unconstrained ib_copy_to_udata causes out-of-bounds write in u=
serspace memory and ABI breakage.
--

commit 92d10c24093a8b27cdd06722f8f50e627c7ca437
Author: Abhijit Gangurde <abhijit.gangurde@amd.com>

RDMA/ionic: map PHC state into user space

This commit enables user space applications to access the PHC state page
when firmware RDMA completion timestamping is supported. It maps the PHC
state into user space to allow timestamp conversion without kernel
transitions.

> diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
> index 7b589d3e9728e..2c70ac149c4ff 100644
> --- a/include/uapi/rdma/ionic-abi.h
> +++ b/include/uapi/rdma/ionic-abi.h
> @@ -48,6 +48,7 @@ struct ionic_ctx_resp {
>  	__u8 expdb_qtypes;
> =20
>  	__u8 rsvd2[3];
> +	__aligned_u64 phc_offset;
>  };

[Severity: Critical]
Does adding phc_offset to ionic_ctx_resp break userspace ABI backward
compatibility and cause an out-of-bounds write in userspace memory?

Looking at ionic_alloc_ucontext() in ionic_controlpath.c, the driver copies
the response to userspace using the new, larger struct size:

    rc =3D ib_copy_to_udata(udata, &resp, sizeof(resp));

Since this commit increases the size of struct ionic_ctx_resp from 32 bytes
to 40 bytes, and the copy uses sizeof(resp) without restricting the length
to udata->outlen, won't older userspace binaries passing an outlen of 32
receive 40 bytes?

This appears to directly pass the larger length to copy_to_user() via
ib_copy_to_udata(), potentially overflowing the userspace application's
stack or heap buffer. Should the copy length be bounded by udata->outlen
to safely support older userspace clients?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610154216.7123=
74-1-abhijit.gangurde@amd.com?part=3D3
