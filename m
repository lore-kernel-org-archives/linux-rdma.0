Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A90368D7E
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010502; cv=none; b=thb/Nswb7jYAgcnSZjIx+U+sjjmt5iDz/CbgQCggpzvKCD4ckITuubkRCavKQhJc+I8sAbZMH7HL3yEDqlFH11PjdN2nD8gyIJ/oB/Re5zXvnUZrisxpn8DglMf6IysyaVou2TTlOYWVtcZtH1S2Ty2M3f0Kn0wV9eo2m4yWKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010502; c=relaxed/simple;
	bh=0p3EKOwAyBSxGYfC+xgiRjnbrNZ2dNUVfrUllwisbVw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VT8kZJ3wtFHH7lbr46849tOXE81mEb0x6aDGfrzoW0BIv4g8bpN2hQkHQ0jKFJ/an9FXKZK/+3JFqd8RyrJQUv4Dr2fARbBpLzhRS8LQ/JSNaISZCG2B/MROY1uHmAg4q6HcBFlYZ5yNjbfmSfSuLiD6Ftv2xT7saV14Ay2fd+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV2XdH0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV2XdH0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4581F0089B;
	Sat,  3 Oct 2026 06:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010500;
	bh=0p3EKOwAyBSxGYfC+xgiRjnbrNZ2dNUVfrUllwisbVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WV2XdH0ha112HZBpZ/qff4MEg0uaqxg8HSBZrBi5p9h9qvlzELOxKNrABQwVR44Lb
	 TWf2+I8ryFIGydSgNneItxhiQQeY9/EPY8dK3gQ0FvJmjaj/nbffpE6W5Uq3rniH0Q
	 S64A8GCtIGIU5k0JW8q4PSMn9NfUYu3BL/b8L25CaIruSD8PjfhgMZRlrZ+uXEN0UT
	 puplKLKTVRo1ExS61wCoUdLiwKlLrn6oCmPm10DGHEL6CElISaU7/5Ow3N3bHLwmI/
	 LRKPbftMfE1hgrT98MNSciFGET9SjBtPOGX8uB/oq5hXOB7B+yd0XJIb0Szw5JNj/g
	 CMUzHsufL8OiA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 01/10] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-2-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:55:00 +0000
Message-Id: <20261003065500.AA4581F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D1

