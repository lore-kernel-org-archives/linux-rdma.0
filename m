Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A68625;
	Thu, 23 Jul 2026 23:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784848029; cv=none; b=IVP52pwQxaPT/aU3YTYpFZgPgiH2FA1RdQTkYZ4Tl7kk6YKs6ADU4ryvP9/w7zWVTuwElhXbgcJXiY2nL9dQql667+9CDyRS+gNDLVqRIJ6tcZZCQw4gRFv2KbObraYf+qyuv7o+FVbxHCPd42eDXHPyq1ZTZs+kHKGDqTGWJk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784848029; c=relaxed/simple;
	bh=Wz8cEJMRh2XH4EKMpWGFFOL268MKKJ3OPqAGSkvWQp8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pikhN06QUoXI2y/ZZRMWrNeNDuWMa6YoNHmTY513LNnsIXIG+DkdMalEHZT2VcsHsNulldmMZ/wEDgQDsvag35P06HLaqBuNE5PefD9VbAwFm3XtlF/i7wIuG02DW+4u8bb++sCJbUTdBfW2Chs+2T2AJUyf9MfIzVxNSDqqh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=GYds4gLZ; arc=none smtp.client-ip=185.70.43.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="GYds4gLZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1784848021; x=1785107221;
	bh=Wz8cEJMRh2XH4EKMpWGFFOL268MKKJ3OPqAGSkvWQp8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=GYds4gLZQceKAm0Ryyo+DhJj7I48HNy1Jw7aXVd77caC6eUz7uW5uDac6Yz98w9bn
	 MmDitxiqfJV2XoJQ419oXDskOEBmQrExtxSsf9A5WlHUlIHMWdqUnOLAFjAu7bYLyk
	 nyc8lU0LiS6BaxfuxnkpU5Lv7Kq0Lnvawora3K3kXRM+mvty5e0YlDot8VLtC8zFmR
	 YB+PrrTvDwctqDF0CqHceUN55cIQsgNhZd8RtXqT9otqJ+6gKqXwRPW6LEZFFsUfwE
	 H27SzL9hU7TkQ96XCaSdz377zmG53Mk4Kxbv/T5XMVFw9gCzE5XAparnkl2VitxQ4y
	 v23+IZ/cDCMIQ==
Date: Thu, 23 Jul 2026 23:06:56 +0000
To: Ibrahim Hashimov <security@auditcode.ai>, Dust Li <dust.li@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>, "D. Wythe" <alibuda@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursor against RMBE size before accepting it
Message-ID: <20260723230647.138311-1-hexlabsecurity@proton.me>
In-Reply-To: <20260722102929.38218-1-security@auditcode.ai>
References: <amA9XGOWH3z4Z1fu@linux.alibaba.com> <20260722102929.38218-1-security@auditcode.ai>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 4bba3ea34234488ebd5e18be57079a17775b21e0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Agreed, and thanks for dropping the competing one.

Patch 1/3 bounds only the cursor count, not the advance: smc_curs_diff()'s
differing-wrap branch returns (len - old.count) + new.count, so prod(W,0) t=
hen
prod(W+1,len) is diff_prod =3D=3D 2*len with both counts in range, and
smc_cdc_msg_recv_action() adds that to bytes_to_rcv unclamped. wrap++/count=
=3D=3D0 does the
same over several CDCs, so a per-cursor bound can't catch it.

The out-of-bounds copy you point at is closed by patch 2/3, though. It boun=
ds the
derived readable length at the consumer:

=09if (readable < 0 || readable > conn->rmb_desc->len)
=09=09readable =3D conn->rmb_desc->len;

so copylen <=3D rmb_desc->len and smc_rx_recvmsg()'s second chunk (copylen =
- first,
offset 0) stays within the ring no matter how large bytes_to_rcv grew. I ra=
n your
wrap++/count=3D0 vector end to end on the real SMC-D path under KASAN: with=
 1/3 alone it
trips slab-out-of-bounds in smc_rx_recvmsg (bytes_to_rcv reaches 6*len, rea=
d of size
5*len); with 2/3 applied recv() is bounded to rmb_desc->len and it is clean=
.

What 2/3 does not fix is the accounting: bytes_to_rcv is left > rmb_desc->l=
en (and can
sign-overflow negative over many messages), so the documented
0 <=3D bytes_to_rcv <=3D rmb_desc->len invariant is still violated at the p=
roducer even
though the copy is now bounded. I have a net-next follow-up that records an=
d aborts on
that. Your

=09if (smc_curs_diff(size, &old, &temp) > size)
=09=09return;

catches the single-CDC 2*len advance cleanly; the wrap++/count=3D=3D0 form =
slips it, since
each CDC advances exactly len (diff =3D=3D len, not > len) and it is the ac=
cumulated
bytes_to_rcv that overruns. So I'll pair your advance-bound as an early cat=
ch with a
check on bytes_to_rcv after the atomic_add and abort+record there, which co=
vers both.
The insight is yours either way -- may I add your Suggested-by (or Co-devel=
oped-by)?

The v4 series otherwise stands as reviewed; I'll repost it for the netdev q=
ueue and
keep the accounting bound as the net-next follow-up.

Thanks,
Bryam

