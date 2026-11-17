Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794925641;
	b=ZAoVwMXGMoy/tlZnPTnvp3szn/8NShK7b7khCouJXRbTIJL9LNHLAmKNKyItVwLlxEbF
	 PwLQfSdpCERczP+0YXOkwetn5VDgWSc0YTTVkTLgYzAnOX9QuZ8/PD0h15GlQR2jeHv9m
	 vssXHFhnIwYw5p7PhBxVuuIQGo3vDhAfcm/xfFntJpeA9JtxAiYvUKjn/TWRmmncTBbRI
	 Zr1ZOZT8BxFC06H3B+lBf5pQ7I+bhYgaW3wj88MGrQsqK9TcdSm+Urw5O0LZ4EpU83rCC
	 dF2qv8peQgNsUULJr2wX53EOUYCLqhuOcYxRUkTv4cTtm4pRidg+dg8FG8c1faOYXxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925641;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fI9qzV3+i/V6fO8Fng3kpti3i6R+DxMIEsf83E11Qgc=;
	b=Q4lDKcmA+xPq2J8+kFsQrscnPhitNXGbm5EidHVj7MvMeidfVTeaJMbptSZMacE2dRJ2
	 NDDFAlyxfNVrmfvIQHQLyqVzHnFON38F4GaSk1b/gsT2v+XMrhl7R2tRY+5Dbo9ayUSya
	 8G4S3sk2yLv3i0oQlmqWFz664ml8aJCbwz/wl5y1eXgqKgB19qkNMAFdmBzGomTg4X2Uw
	 JAwxKm/YtI/r1fZOF4JYw/ySnepP7yAjvXNK5D3645szOue2s5dqTyh3hd0Zjh0LHmnln
	 KPCquOKsncypVuTYQwDWzFAW1yye1XtSGXXZeGiF6+nc8tNwoAeAxv38iCtc7br9lLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6RLNLbD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF08606A329
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6RLNLbD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0971F000C6;
	Tue, 17 Nov 2026 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794925641;
	bh=fI9qzV3+i/V6fO8Fng3kpti3i6R+DxMIEsf83E11Qgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y6RLNLbD+DDF6RrxcUdz2RoYCODwOK3s3iSqGY2JHb2mwP+jDnRdBJLavefAlUJBd
	 oSLK7wqbHLLQbdQGNR92FK5GRD0s+4CpOSp0IKq+gJ8ocGSBRPBJmgXat5tsXehhEL
	 B0C3vbbaPETupChboNfWV6Etf83vGdgLBnGvsKhBwCqHYjz8AIW3gROypnrR/55+YG
	 +IBkNSkg6oXr18QAp9F/qiNo8qvjC6d45Be+IIqVtwQDwr0y9l4vNx2TtvYM3DmOfg
	 ObYxYwWvSzNMyLb1s49EfmPyjJNUh7hLVo1KIAwYwdh/TLmR8Oy8SWYfvPeENzFi2n
	 BgoPMkeebjeoQ==
Message-ID: <sashiko-outbox-218963@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/iwcm: Require CAP_NET_ADMIN for iWARP port mapper
 netlink messages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suyuan Wang" <shyckless@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-iwpm-perm-v1-1-11f1b87d6fb3@gmail.com>
References: <20261117-iwpm-perm-v1-1-11f1b87d6fb3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 14:27:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Suyuan Wang <stevewong@hust.edu.cn>
>=20
> The RDMA_NL_IWCM callbacks process replies and notifications from the
> port mapper daemon, iwpmd, but none of them sets RDMA_NL_ADMIN_PERM:
>=20
>     [RDMA_NL_IWPM_REG_PID] =3D {.dump =3D iwpm_register_pid_cb},
>     [RDMA_NL_IWPM_ADD_MAPPING] =3D {.dump =3D iwpm_add_mapping_cb},
>     ...
>=20
> so rdma_nl_rcv_msg() accepts them from any process in init_net.
>=20
> iwpm_hello_cb() and iwpm_mapping_info_cb() set iwpm_user_pid to the
> sender's port ID and mark the client IWPM_REG_INCOMPL, without matching
> any pending kernel request. An unprivileged process can thus make
> itself the daemon that the kernel sends port mapper requests to. The
> [ ... ]
> Fixes: b493d91d333e ("iwcm: common code for port mapper")
> Cc: stable@vger.kernel.org
> Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-iwpm-perm-=
v1-1-11f1b87d6fb3@gmail.com?part=3D1

