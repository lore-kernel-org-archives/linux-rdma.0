Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903347;
	b=SnpWfSAs1+NFyjg8vk/V6omnr+VojUjBCnDO4RcInoQjeLInA4pdOtAVytTS3g6JASs6
	 zXdn/46syfQBgaz1qNl4g4v99WnPdKMhEKVZSqbxwJBRspZV7zvKERUXpRJ0H8pUHipO6
	 /vd1F8KMzcvuGXDUqJQvdE0z9DICOUqPBXefhMRHU25/GngSNeaN4Wd7biXoLKz+TFpoD
	 ELDfD22cKPSWwTGh+u6FhfzhVW6e6l19K8DRWiDrXCy7b0LLpuGqdtzjPYeW40bx3Vb/3
	 +mgW0lQORY0zW9ZI6DlnAjC/VmmHMqshQ0Wqj1/aSQRq4ALHvLpPY7ZgFtWDV96zGUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903347;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r81drtb07j5LclcA9okWb1Z308C4SgMDvZHCEkhNlrI=;
	b=b3O5ic8a2CS6M2Q9gZxMUaon0yRaPkCYz3riinA0GYeEjKGfje8HCtaSjSUhkVs/vTbD
	 dG85OXxzoGTbSSYMCGw7apQ9SEtOewx5CFCettCqQuDmhmtW42yE8zPMkrlUvhfsats5I
	 o6l7HWX9x3qcH54gZy8Gk/zzNHjpt31J29k8hzrSPlZ3z1JwJqnfMuNH8WBmOeHMZvPqd
	 VivJdn5wkWxM1Ekhn61r+VJGkus0oPtAmXzS47spWiiJYUwPUkmCqGICbsZ3hmzzSOCvh
	 vf4jDIfTPrFDvSJGJB9HhUhRsQejyXLcYpnQ0V7/JXOI73wWDY8CoYgNcEjp40iClkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HV3gxljN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E561606A32D
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HV3gxljN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63371F000C1;
	Thu,  5 Nov 2026 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903346;
	bh=r81drtb07j5LclcA9okWb1Z308C4SgMDvZHCEkhNlrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HV3gxljNVXHo+AhB+bTq972NvSwrb1Tdi4cK32p+SXHiv4HYZsU94/4jWrtWwg2X4
	 daAzHvDlGKNBeP3pU2nu3LGNlmuOSk5Ly9KQW9kzKaWTawWh4XAvb66F1atx6RftAu
	 StPd21FGphbdX702kUHuYKmFnq+KrWC3aMISO3MAboH84/+AXZGPPFVu4erJKymCVh
	 ymwhwyKge1LlJ0QvkQ+uwsq0grMLcHD9xSEY876T5dyDqnMPEl8A1cpjtEeilt2nhb
	 uSVm8v2859e3ZOhCdyVxBU8bTd9xCVVYxKA7bNnhKhfwR3b0C/TQurxKBO8jnCfzvr
	 +97DYP5uTZ6MQ==
Message-ID: <sashiko-outbox-199766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-10-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:29:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Decode hardware error CQEs and process them on the corresponding work
> queue. Complete the failing shadow entry with the vendor status from
> the CQE.
>=20
> Defer transitioning QPs to the ERR state so that the other work
> queues can be flushed. Complete software-flush setup even if the deferred
> ERR request fails, since the error CQE already guarantees whole QP
> shutdown.
>=20
> Clear pending CQEs for a kernel QP after a hardware RESET by setting
> their QIDs to zero. Discard CQEs with a zero QID.
>=20
> Mark deferred errors as pending when scheduling work to prevent stale
> work from moving a reset and reused QP to ERR.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D9

