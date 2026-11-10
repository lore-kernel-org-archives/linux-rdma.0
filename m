Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279691;
	b=zxwslZiYYsMVkWe9sIDCbg2NSLVuhQsY295rblQcqlKVkbLbmBQ/TGoOgkDfYAgei63t
	 DEKuuMmWPC5GewNXpoHyUOpa1xx6iggDCdTajhXJqFZH/yFD85kyR8iDNcF1/oqg6kRsD
	 ONHun9j1cE8S5gNHQk9tiXuZoeqFqKK7D7B7JJOQ8I7w+ttw190k3NCnSD6tyORS7rRPn
	 KaFjIGtiF7ge27rZ2Y2iVFNKJ5bqR1gP1TvT6PPk8uV/lTBupCRgrFPs3Qk2OzfYW1bxb
	 uWgZSK3RBMo2uvAQRHSAwU0qKsIJCjFG0L0tMTsKPv+BMeVeqq2NpDaaXhSReNFINRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279691;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LN4eJmPzpM6arQM2Dt13mkYV9BRLanjZZijwPfJh85M=;
	b=D+QzvrKDpyo8qhStNd/ECuGPdrCR71p0v1J1XJx32SfSXYPaVWqVqtFp/Wa0FpWuQSPA
	 ZlBQSPzDU9Jbxsm2e7yzMBcS9/BG1YRX5mqbgno1ekZpw7OU2RnehMgJVGgnSIfxmLXYI
	 bTH3XoeuZcHKSxSSREPZ492tFm9w4yCBjR1tmoYa3QrDOYY0kymfgyRa/s+ew3Tsy4aa3
	 erGPkDTYW4O9BpZY9TRPZbA1M3J05DXQqnMix25DwBjXJYrPrpkUYCO+IRkx/lJ7JIVTK
	 Cvn5tfojXRs36ft+C4TuyooDnoe2D2eqXqCfsNXJ1Ba1M6ALroRj3gxNZivz/HnKB5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZSDG/Ccd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7292606A33F;
	Tue, 10 Nov 2026 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZSDG/Ccd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CCE1F008A2;
	Tue, 10 Nov 2026 03:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279690;
	bh=LN4eJmPzpM6arQM2Dt13mkYV9BRLanjZZijwPfJh85M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZSDG/Ccdulhu8pRffD8h9Nbcuw8fZeB8M2XuuiF/fliO/1DzLDUqY+6UfhlJh0GkD
	 G8sg90J83S3vuXhP+jAU/SYuPlbquEVvgL3DlEIcvJJ0FhEI5PbYwYonaMkzfNkjCc
	 gFDJwSjCVv3bidgEqPupHaWVspb3Qs/5jrOzoFcJthIc8M0t+AYRDVrvh9aBqGiiZI
	 j3DE4aYU/CpYhnGaVHgHgXUsjEShEn1Ceg5r8zoBmD2d0EzEJWZLvwbMkToSKSv8Ns
	 gJNsVG5cceUd6v5Wyv+CX79pR1KF/1UrpBmCsqnyGBBzXWgM7JABvwrTgJO9xITfwu
	 8E1m2UVUtTXOA==
Message-ID: <sashiko-outbox-206082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 09/14] netfilter: conntrack: annotate
 data-races around conntrack sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-10-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-10-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> nf_conntrack_acct, nf_conntrack_events, nf_conntrack_timestamp,
> nf_conntrack_checksum, nf_conntrack_log_invalid, nf_conntrack_max and
> nf_conntrack_expect_max are read without any lock while their sysctl
> handlers update them with WRITE_ONCE(), and nf_ct_set_acct() stores
> sysctl_acct with a plain write. Add READ_ONCE() to the readers and
> WRITE_ONCE() to nf_ct_set_acct().
>=20
> KCSAN reports it when nf_conntrack_checksum is changed while packets go
> through conntrack:
>=20
>   BUG: KCSAN: data-race in nf_conntrack_icmpv4_error / proc_dou8vec_minmax
>=20
>   write (marked) to 0xffffffff8ee29b6d of 1 bytes by task 568 on cpu 0:
>    proc_dou8vec_minmax+0x1ab/0x1f0
>    proc_sys_call_handler+0x282/0x3a0
> [ ... ]
>    ...
>=20
>   value changed: 0x00 -> 0x01
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D9

