Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD24AE109
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017060; cv=none; b=GLIajcs8ZZiy4UNJN6HrWShLXqitJVs4nH4ZOFixlg0fm7i9HSzHI8hjefczVwV8ZBMQVrZDo8J3RHaMnNnK3E/QWmKDQRe2dnR60dQSVla90l9K8LUIsrXsgvBJjdHNORujTmD2fJzvAfqKFIkV81MZxivzyIecSTyJ8+DNUSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017060; c=relaxed/simple;
	bh=Q/CrlpDooNrfGPfQ4WZ95OQpCX/zhW5OHU83Y//e4W4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hFdlJKvZ5ZYMLxh7MyePpS2uFT3NG7MsuktTva5pUN8fTglohardquk20M3RAMlE8KexXQCEPq7sSV0/4BZUYgADkYRiRtd4kOtM9sv7iRVVrVCAp4hQK/CS300m8V6IcLrMoLZR5MsEZKdmKppdd9UIDvYN3kVuslbWkFfh5Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAvig9RC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAvig9RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ECE1F000C4;
	Wed, 14 Oct 2026 22:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017058;
	bh=Q/CrlpDooNrfGPfQ4WZ95OQpCX/zhW5OHU83Y//e4W4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oAvig9RCDyyOTxeLzJOY+GZlMuiqRep3HX5lnrbfDoNP5fQF/QsB0bkmPHbBOrLWp
	 dMOCBKMFCRLcGLlyfqR9+DS7CVeQB3uD7Q9KiLv1w9FaX4ZWw2yrl+IADhtec9VsoW
	 uoyqCDVONT7HxVzpRLDF2Cpe4EFXJKNWTgXHMlQFJEk2kKLofuoEMpIwvgfug2U+cR
	 KFP03USAyd7SHLdL5yWSjLEZpKuPAW5TAwTfSfR2LDAGCwikwZ0W96TNQF+ShFmV4k
	 f7ESApZyo50XLee/0Vt2HjCncVch7Y2PJ7ADskP3yMROrGtGjg7ozGXjU0GyHj015Q
	 lRJixiKOKEmxg==
Message-ID: <sashiko-outbox-171973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 03/13] RDMA/core: report the reliable
 unconnected device capabilities
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-3-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-3-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:30:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Add the capability bits a device uses to advertise reliable unconnected
> support alongside additional features. The transport itself, 64-bit
> immediate data, 64-bit memory keys, caller-chosen keys, and the four
> memory region access restrictions.
>=20
> Report the job, job key, and address table limits through the extended
> query_device response so userspace can size against them.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D3

