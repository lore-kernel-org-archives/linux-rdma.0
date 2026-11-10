Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316260;
	b=GqtmMeQD9h3VvHqRwPgln9xj76CN/Wu+g/hSfci8XQSqUM+e+5YDMD7VUf4RmeP4dJy2
	 +LduOSvKCPgo+Pt5OkTR3cmgLcKLwexxt/cQM0wUTkYfzt8kUOWVdGXVeaZjhXIqKTTC+
	 q03eDKJu5ZPToVTXc+Rs8KmYrG3bHRhreJkayBgOXGQ3ydTJgQiko+IuHggRF/LqP1HnC
	 /rY8LBlQImTBoZ5GKt/xDoR0pd0hLm8lS8ba0TEBtEkDw/CNeD94m7+e1N0GVpRmd+I/z
	 edcw0eLZWotvt3WMpABL/CbSy3nYwjPzFn7LxY8piESjfCt6b3sthe58rpAWbYsXBbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316260;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CetOTmI0iJtz63uuo6qpCZipRMFooXIxCv+Ha6n5UG0=;
	b=twXnUBd/399ngLPdj11G2MppBtMm5R8SfAl5/h3VZi+d5axtFe84pfk9WMU4AZdFqkC4
	 sm13r90jng1HZp36RqFnDQfpSsQujX11NZzECTf+TaYC1PAKbHh8mGcsraPGt7RBRo2Wf
	 wPaG0QvoeHr1WUf63yHE+WU7bPSewaMKQJaPBAkJ2tHwgG/VPKgli+lABVKEJbBFJEUXe
	 1PPUtAZBc2+IgDJVxaaerAUft/4OKpaWqut70r4JL71RjjmZNXRyu72wcD8jQxEzi0lm1
	 m4z2JkB7MH3DnTjlo+tka3YnduniI9tDxJJPpVsEbrDtuqgaHS/3pk2LlZB4/xH1NCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuK9xSef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAA9606A32A
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuK9xSef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C031F0089F;
	Tue, 10 Nov 2026 13:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316259;
	bh=CetOTmI0iJtz63uuo6qpCZipRMFooXIxCv+Ha6n5UG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WuK9xSefi2RTiyHjBTUDdxG3Ni5qfjTwg9QJkfz1tcPw/h1qO62RhZnjUbhLWLCsW
	 Lhx0YfWV0Xjde6Y1KgpmPH81Hoo6oB0va6Io+S7mYv29IfZcVIb9FqkTCw2ds62lv6
	 a/VklbIMz44ZE+nF/am3Gxe9f+jBQMrvUdnQc/MQ/cLtiZMIfXQWatqOvpO8I7Eq/d
	 y3ZIi9oskfUuT8WEotf8DDhJBUuJLyAVCgv1l99KYxvyXBgsfX3Ck+Rea6hjmiGm0q
	 UkkTS9/X/f2l5DhvNyPnC4d+uhI5GeOG5DGG71dk6WIDWAWxQM+x+D6CSL3URdF5Z+
	 E1T8IcYWi59dw==
Message-ID: <sashiko-outbox-207090@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 01/10] bnxt_en: require an exact tunnel id in
 TC flows
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-2-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:10:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> bnxt programs the value of enc_key_id and never reads its mask. Flower is
> about to accept partial masks. bnxt would offload them as an exact match
> on the masked key. Reject them like the other exact fields.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Build tested only.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D1

