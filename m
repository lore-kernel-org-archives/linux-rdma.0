Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795876008;
	b=H0J6YfppzEbDP2nbYuPR1sf7woNOgeflxOOW6ccIdKLbKA9Y6yeS1QM8nnqMnBeXHzYq
	 kz+AwHdkWml26W5r2zdA9bLqXwsQwAkl8UNsbaHimgNkgDc8207x8n1TPvSA842XIdAyg
	 LowFTKQ4GN1ilmOCZIe+U1mizuxEYmrGfUXLomWCZQbf482A1/owq65SYOIB2H3bSTXR8
	 rD5sR56THdoMQtR3vIgKd7/kiOzS8hRH6j5oXlOAh3uDXHQoP1HUFp/NZ/J6t+jbo3MvL
	 BSTK2dUVjW5TqAOPDG5ktraGRV5AGMp1RZlU7wvnV64a/H6lVj4GLEVMyRs/u8F+7SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795876008;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e2/fexm2U9S5322f7JgRbfSNw2D5JDaRe9gCRL1ntp8=;
	b=snebD0t5rVhhjbYuLmLxXBWVXjYZxDAWiwr19ZqE8gRvJGJNBJI5M/q1SwZhXuiqwE7e
	 l5eF1QsQcUIRCdoBks4mdK1/MrpX2T9H7UkbOuSDuW8F+8hPdn8zEhgV3hOEC5A+j6mwT
	 a+H5dJGRmvCcKRk7Cjy5B+MVKOm1KreAVl8XiQfNbWW/27GLcxLZBFestCht9fBJwWflC
	 c3Utrkfk5yR2yDhwKPHFZYC5uorNDxMNDulfQW8q4Z3RcGoKoIuujcrdicNaDCG4brBzc
	 WH/mH9tcjtXCtp39wKeWjeZxtF0ce9b3HWGivo4H9cxm9QBSicwIqvBUujdS8DWtarA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atCOYuB0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EDC606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atCOYuB0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533AF1F00893;
	Sat, 28 Nov 2026 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795876008;
	bh=e2/fexm2U9S5322f7JgRbfSNw2D5JDaRe9gCRL1ntp8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=atCOYuB0cBoohtcHjAdXokOlCRHzqcTNsGf6h2mLjtMND+SVPrNoGa5XKekhUt9Vs
	 V6LxyywK3rbkjNP+pXxYWIptLQeZQwX6hohFadwtaW7c+qeI9s/f25qzT34SvrQbma
	 L7WJFpiWvgRN56BTtMZExDVQukKRjg6sqB2ab9DFcuU07CdNAxB6XsCPrJa1rc2eTT
	 ZJbB5vTTlroji6iJdgb2n3GLUMKk1rj4kPHksJJ2+LgG1Ga3QU7qBYeTAGFxvmPoSw
	 fMBE83jEEj88JDHchxOn74jZlsCK2GDLCYYzke5YZClSJpmi3F08oEtX4mJ/ascLnX
	 WbvW49eqW7Zdw==
Message-ID: <sashiko-outbox-238775@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Reject an MPA reply too short for the
 IRD/ORD block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <bugs@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261128140838.58976-1-bugs@stellman-greene.com>
References: <20261128140838.58976-1-bugs@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 14:26:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Andrew Stellman <astellman@stellman-greene.com>
>=20
> When a siw initiator uses enhanced connection setup (MPA v2),
> siw_proc_mpareply() reads the IRD/ORD block from the reply's private
> data without checking that the responder sent one. The responder
> chooses the PD_Length of its reply.
>=20
> With a PD_Length of 0 there is no private data buffer and siw
> dereferences NULL:
>=20
>   Unable to handle kernel paging request at virtual address dfff800000000=
000
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   Call trace:
>    siw_cm_work_handler+0xfa8/0x1b5c (P)
>    process_one_work+0x5cc/0xc90
> [ ... ]
> The fix and this changelog were drafted with Claude Opus 5.5 and
> reviewed by me.
>=20
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128140838.5897=
6-1-bugs@stellman-greene.com?part=3D1
