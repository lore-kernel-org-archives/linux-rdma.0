Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11A04A0923
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717235; cv=none; b=q0OMgAQH8VrPSQ5G7UT7UuErx/bRTmn0c+DyqH5kcEtq5INGk3HOSxoiulMGvf8hoHfz/wTX2vnmK0fmzCJAP10vRvqMf4HRPmksGvmCJHRDLPaOL4QLSRH0LOcFCSi0zOCfUsE3UaFfz2V0swu3IeJ0xnUkI8oRCsr1MJU802A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717235; c=relaxed/simple;
	bh=YHlL5/tRbqHgHPR4E6YN7+H9QUQq60gMhkAxfRC15pc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HvCzFMltdpgpDMR+DAn02YT+3w9pz5P7P9xW6ZKBOZq/4NxCPJYoAR7326f2JMacJ/+/IsbWgBUYOmYZO/FDzcI/wUYjHfyH6EJNHzlYYyyeQlVdYf1iVnJwkTUDEDsqVFLvQ845Xoi/91NoxaWkxlx/ikoO1wsgcxUzaEn1hUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZicUfMZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZicUfMZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6058D1F008A2;
	Fri, 18 Sep 2026 07:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717214;
	bh=Hq9U9n/kIsskYqV2BcKYYf08/jpuQy93RX1SrgOla0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZicUfMZAikPsG8xE2XPTbTveAgLzftFyIM/mlJAEld/3+IIadndL7MhQp1dwdn3Ra
	 fwwzBUE3kCaSLQsbx2SoXnFN4E5YiJBAARomr+DjG/GzDOAXXiuuNg06B7zb0eoQu8
	 3CaDXXwb4Ql2AHHqLwFwj5eahJM0g8wK+yTEsaskfW0zLlfYaUhUSM4Z8Mfr/KeqMH
	 PeqjjD6K+xnO5aZP03azaWSbO3WXMjw8l/LwmutdhcXUEFsW1BR20AzzDZwX9QCGKJ
	 7BlroKb6IQgTTcOrr3U2bKR0FeY1GlgasZrsmM/T0vtDp+n52DljSAU7K51LwyJlrN
	 xyju9gtFgBnwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 12/12] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-13-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:14 +0000
Message-Id: <20260918074014.6058D1F008A2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by device removal,
> netns teardown or module unload - and every dereference of i_conn after
> that point touches freed memory.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> callbacks walk a receive queue after rmmod freed the connections:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D12

