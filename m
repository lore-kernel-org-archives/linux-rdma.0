Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5111C4EFFA4
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483419; cv=none; b=ReFDinEEFo3E7+3gXSXhxhodq4WR1InYKz+8VyH/nmtlINSiZd/A0qjh9ZMWlJEA7vyfEJWQygNG6gT1YUnkrYPiUFZFkkKgipVDYwex8i6KTdVJ9FfprOHxImPV5xRwn76/gOvBA/tD/yGF4v45h89+oV0DgmVbQudAmXT+oR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483419; c=relaxed/simple;
	bh=zeRhfgucDiYDRXBrg5RKJZnRlcSO6PNZddXe+xANQNg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ahwKK4iPyDsA869uLrIxtO9fUeZ1rmqV9IL+62m8sWVdqS6/bX803bQR0IXgg3PQAmWviwWcKP9v5z3pcOt/Ivkg46rW8cLqlBFCddm/oMs8NucEcjpaqaqkKpfQvuEOzDfR4DA0mThaTcUlcIgCZR5KhPO9ZkNBWN4fHgTvteY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYpmkON0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYpmkON0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2331F000FF;
	Thu,  8 Oct 2026 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483417;
	bh=b/UMPJhzMEWnAvCXn5WFnSaqGrB9Q1emra2FhBKhl5w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TYpmkON0iTyzmGVShlx50kEK2hWLB06Zv2tfJ2NjmBs/5ewrMyLX/qMLk+g9hW7Zb
	 OkXIqjj84uMes6On5BfTgyQhYc76LLdqZ1A31TuT5EgwHqJao019t5q7u2BtUE7pdi
	 2Yd4dXZzeWeOVhyx7/pN680E6cQ6MdpiNDLrHacyHb0m85WQwKozf8PUj4T2XNZQli
	 qM9rFiPXCIerfclplJPyL7yV0iPSXsrWJYLAPmadmAcmfk0obflmIs6/KyXConeyTW
	 CM8iabSlM1Lk2QPcGZiJTFcD5+OBQB6bDRzt4TSKu0raax69+wjlqtSJnx3cxLh5/6
	 p7785AJi/Dzzw==
Message-ID: <sashiko-outbox-164445@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 5/9] e1000: use pskb_may_pull() in the 82544
 TSO workaround
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-5-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-5-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> e1000_xmit_frame() uses __pskb_pull_tail() to pull up to 4 bytes of
> payload into the head for the 82544 TSO workaround.  It already checks
> the result.  Switch to pskb_may_pull(), which takes the length the head
> should end up with and checks it against the skb, so this driver no
> longer calls __pskb_pull_tail() directly.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D5

