Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A53A1A58
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 06:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790231544; cv=none; b=F+HUE5B9F/OyQoDw40jlAMd4Tc4uP1RWU6Y1chKN6xWXMfbRjORQqfw1DuLWvTL2e89sjNGzbbtkTNql8+Ehard/Fu5l6Vzzl7AQTeuAJ/PYNPtcecch2lG2YtQcTEQ0l736Kt1MWAyYVPaNgywG3t/z/UH6BSgyacwt5AegxYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790231544; c=relaxed/simple;
	bh=EFaRjwP1InStqWRQKWu5ZIc8zIb4kDh1x91AHcdRX7o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hRZUehOrbDOjJ9SnUfXevefythRP8Pfgcps0HC5X40mTh2iA9mtfLK0uk4WJLTC8SqryylDCk9BTKCqAfiGPkxZeF1TGnpKnWSn4s9fBOGLu2ZWwLpnkz6QVAcg1Js/e8WJUMHi7pM1EXiTyvYvpFgYD9151tWcmbssydRlVVCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xt21xOxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xt21xOxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5414F1F000FF;
	Thu, 24 Sep 2026 06:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790231543;
	bh=EFaRjwP1InStqWRQKWu5ZIc8zIb4kDh1x91AHcdRX7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xt21xOxyUZ2Yda7sS2B8nTKDDNG5to+mh8yfdrr1ANZAyXKJiYEemulmw5RUwlhhE
	 c9djMrjgKFue57bxd22FRP6FwMoGYBOhf43NlKJIw9dynPrsN/Ua9rRakRoYJrn57E
	 MLXveW3CQZ9tSvL7/Jqy6BqXjCWLoL9fJPap05z+MNB4ZZxlZ3kzbOSFU9PFP8wd+4
	 khespRevAcYx8H5Vn2J7+iNZzJTUO7Eol8aQTbDQiTH3QvvjFo1dAzVMUaikWURdLo
	 x7eHcUJU9DSfzNofzEOZP9PUrxCpNYfbeISz4vgqK8AWJxG9LAVBT0pe31cHhO5Kza
	 oHxOFU+ulLZkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net/rds: replace tasklets with workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sunny Tiwari" <sunnytiwari@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20cbfc32678019daadd3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com>
References: <20cbfc32678019daadd3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 06:32:22 +0000
Message-Id: <20260924063223.5414F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Convert the deprecated send and receive completion tasklets in
> net/rds/ib to BH work items queued on system_bh_wq.
>=20
> In rds_ib_conn_path_shutdown(), replace tasklet_kill() with
> disable_work_sync(), and call enable_work() after destroying the CQs so
> the work items can be used again when the connection reconnects.
>=20
> Assisted-by: Gemini
> Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20cbfc32678019daadd=
3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com?part=3D1

