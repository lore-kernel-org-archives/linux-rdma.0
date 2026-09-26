Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF8D374E5B
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790411342; cv=none; b=GOv3HXzlRNPQ5sokLYQcPunOAg96zCsOTlZRwJSBUxc1+/9iKpPzB0DU/MHNGB6c/1GiUyhVDxY25VHQne4MHK6i2772d4zUoMm62+BTKQvESdsFjLKdpZy9iB6lpaeCV6JT7JuwPQeqzU74LJA5a/uOoM8tRen9yLwvy208mp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790411342; c=relaxed/simple;
	bh=v9VoSSz2IcPgIB1S5v7zi6AEqJrgjGu4lFsgiHcknMk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SrhVzvq2nJWqexhO2T8bajKgD+em5KKxUYAwfz9Mddx7oZFq0NubxIOa1kDRTrKSfTjWZb3kD70zwoVSGLlVPkdgjfbhk5ogi1z4FV7SjQMsfy61JN+utDC0v2KbaQ7tRG9Pk/8tUs/xokJ1U+tygqmDWNpf2ptn5uzFekyLA+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5+zK2i6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5+zK2i6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3B21F000FF;
	Sat, 26 Sep 2026 08:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790411341;
	bh=v9VoSSz2IcPgIB1S5v7zi6AEqJrgjGu4lFsgiHcknMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X5+zK2i6eeG6Le6nXKs4yAFj6x1BXISWgLapXUcEARjLZwNfCChYWz4KVjJVUC2rr
	 gdB9KnScDc22Gy8dySn2wAEw89IOGVm+Nw4Moi3YMG+GJkhnPhzE0LR2MF91Ebd9uZ
	 9Sn/C+yp7KALV8ZoFeSqEfiecAEnIow7bi313yT2pJg+WgX922QKtW1wEyr4g8bB23
	 kpltlVu+3pxWVHzeNLGovUIJQ/bkgMidiZS0vaOl7Yq+r5h8eM8hK3yucw1uRT/2Gm
	 q3tn2MAp7fK1Pob1K0pKqPO8UFwFy/GwoWgewlFyM1asete3MqWowk4n6piU71FOPu
	 l8nJJjmjQdgMA==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v3 3/5] RDMA/ionic: segregate rq related fields from
 ionic_qp into a new ionic_rq struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925082802.2675902-4-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
 <20260925082802.2675902-4-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 08:29:00 +0000
Message-Id: <20260926082900.CB3B21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Amit Kumar <a.k@amd.com>
>=20
> In preparation for SRQ support, segregate rq related fields from ionic_qp
> into a new ionic_rq struct. This refactoring enables both non-SRQ and
> future SRQ code to leverage the common rq init/destroy infrastructure
> around ionic_qp_rq_init/_destroy with no functional changes.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925082802.2675=
902-1-abhijit.gangurde@amd.com?part=3D3

