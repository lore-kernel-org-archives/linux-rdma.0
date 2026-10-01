Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E03BB674
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 09:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846664; cv=none; b=KA20VafnBxOk+hUh1OufyJXQHnofFwiRhtEh7INgpwUgTdap8qrR5rbC7XxOZFIvPDDU1TJlFZZAu+/xi9MWPokacfWHcggGfw9n1MhyXxVZ5lKpqbmY9BT/IzxsyV14MZC+IsPkrJYNeutO0wMhLVJ4//IKVsPQN/CwcPo+oT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846664; c=relaxed/simple;
	bh=NzvKutXGbloF6IKx32cRj4y1rI/kniQFPCOByl0qCJQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TGVn83Yn/CNHUOljR3ctsLoYmr6nuoyDNl0Vp6rRQmSOFxH0xwxI5ROUOOYjG8qr+Puhy8EM57/yV8QDfLzqiBVb5GyO15xTPwidpSuxWhHJO34djG9Q/Mc/owf91KBXfWUYaNYkpDk/Wjh+6HAicyGRduTjYmQ9+jE4BLuJGjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=md+O3Csx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="md+O3Csx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322901F00898;
	Thu,  1 Oct 2026 09:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790846658;
	bh=NzvKutXGbloF6IKx32cRj4y1rI/kniQFPCOByl0qCJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=md+O3CsxMBHAeBt75/btnQuNxfjxth60+XGPgsvfLG/3N+uUU4Mj3jdgCaYPMU+dQ
	 M/ANFizO1k3Dvghe20RqQfSRLyNMX1mHuDLwr/EqfEU/OoocG/pFVqi5YKUYw1J8dJ
	 l5msdqXBU0sP0dgCBw1hLIvpciKds23IQn1FIk1FO7hrWSzL8psEn1X9CnJPgcD2dd
	 xHJWOShxxcgkk1VMor2oJUlUdzXLBvilBPptixvm7JEFf6qYWOU88c/91h44nPlJDr
	 /KoBjzK1Ek+Q0/vuJNOFhNXz5CUBRGknvQvUiCyFFfCUmgGlkRAEJzJ2Vz/D/TCMos
	 4aywIPe0LpIXw==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 5/5] RDMA/ionic: implement SRQ event handling
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930092111.3176738-6-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
 <20260930092111.3176738-6-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:24:17 +0000
Message-Id: <20261001092418.322901F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Amit Kumar <a.k@amd.com>
>=20
> Introduce SRQ event types and associated events. Report these events
> through the SRQ event handler during event processing.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930092111.3176=
738-1-abhijit.gangurde@amd.com?part=3D5

