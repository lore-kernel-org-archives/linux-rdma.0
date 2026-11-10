Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794287062;
	b=eepaerUS62WbISnhXgLfqJEDalo3zX1TlQ7owOK6rQrW+O/fa3kT24t+mpEKSEFG4mTX
	 IU5yn7YWywvbWdkqOfnZFJVYZVBtcc1cqLGYhNNuaYWcLjbT1pQw8D3tJGifhBAZQni4b
	 o4Y1AZItuP0c+TlSr+Og9qHZdC8lZWkC4HJ/GUiTC6BQIVYjRFa/KkYCoM1gxgEiUMOMj
	 7VDJsU/wLflIqPs/7mm27NGIksYJQKxI/JXOJR8NuZwew7ucXU80+pRkMTtVkXdvtHgdJ
	 TmNnvq6919BCvJAIHu9F06LqUqYvw9gnQRtJJhyLy/ZP5A7AufujDwiTbUkyXjLU4WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794287062;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jWkgT+gCZgU2enygCXizqf6/JIkZXdI9eGo08Grj7LY=;
	b=SHs8uWB51HYPAb+D9YxRBh2KbRTOvqV8HSG2wkuR9av9IFRkvUoaKyn9+U/mtODkks2r
	 AvD8GjFbsuYO682RuC9hYDpQRnXIn2n0M8c2kwY5FVgjfk1wNboIcvbl1wzLs0AarruCa
	 Egtd9k4/SK7eQx6710RFGKU/apjpQNaCQiSjbEzrR0Kpyt3j7FBG78UoH0iKaPC+++iq2
	 ErVL8QhRiVnQb7YhLZ4qocrt8Os5Iru2K827MaSqTZAKRJL0S48APurRXNLrjkLNDR9jv
	 8vxBRpE/XCABb9YVXtW3KRwOaO5dT7Ys7m/IUptpql2+UhldkLzKJsV+5d8MC0FQOvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQXazH1v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFEF606B093
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 05:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQXazH1v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B508D1F0089F;
	Tue, 10 Nov 2026 05:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794287061;
	bh=jWkgT+gCZgU2enygCXizqf6/JIkZXdI9eGo08Grj7LY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WQXazH1vgo0Qj2gzTaz1fhXCKDOETODBxpX6gRV+gTVRENdp5lWdPt0+mPjv6gGKI
	 OamtE+M59GsYiEeqcIiaWL9LYSMqHop0tO1xsi3ur3eaO9HolQR1gQnZ93VAtR+lpJ
	 Lj4313W+SS553Fmawi5d6GXNrbnN8zGnFQBduvOmrBsSx4eNW7IZu89/rQYYnJC5K+
	 k43mmT3m+I2hOUt0H8RtUhZgKSU+Mo2HJlUbXmWiX+huaFkA2s0vjUK0ljwNwnfcFf
	 5tiJL5rYnojnJ86+nWWTM425ty8emn3ARGDPPWSjXjwB7eGhfF5QAzB3mfJQBXZoDn
	 /LxEC8Flu1OiQ==
Message-ID: <sashiko-outbox-206255@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 08/13] RDMA/uverbs: factor out the queue
 pair attribute copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-8-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-8-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:04:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> modify_qp() validates a set of attributes that came from userspace and
> copies the ones its mask names into their kernel form. Queue pair
> creation needs the same work for a transport that is ready to send as
> soon as the pair exists, so move it into ib_uverbs_copy_qp_attr().
>=20
> No functional change.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D8

