Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794044713;
	b=02/JXZnbiTfv70h13DFZreG8XiUdoXnEf1WtLHWpQ6e0H1bDEXVV99pIDHa1NSsxxE1p
	 iPHOTOkEvTr2pApjkty0kxQlQBCKCRnLOx6v1KbdgvjxJB+ks6PV1xSn8OqiMfBGnqNSi
	 q+LW4ffxxSOsURaRWuQ/Th00pfo/44LVYkR67wgTuWz6z3y6/UvZBwIaprcirOulkLZvP
	 wz8EVeBQaCfbJFYp670p+zZ8jEH5DPxAKwyzXxt227YlIUQICHGNgZjnG0CKe3tW+ixJd
	 D3+/YHRP2VfkijRjWzVpuYd1IL6lSehoBCWCbrhuiysO4pIkrwK6UjJPDb8dnXnt/SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794044713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+VQweLQM8EjLqBzSRh5Rpw8qrCYCPsjPyZy4gz9Ey/8=;
	b=dCRNGViq1V/U75Wv0KXmZTuYanvMkiozni5vPHl6CvQBrh61wSskItmiu/+PcGf2dEUE
	 yGEK53mUKF9VRLDqn47OD8zwQZrvkypV0D2cwFMfXMvgaCEciH7A4ulBgbiEvWehVf7yM
	 6id+SXIBDyFM+tmCl/5HOONLEENOhXhvduMzrHpUIv0NU75X0dK6duZrWREcRuE0tDgD1
	 EYJo/UfWlxbYdY42fojP3OaSWyRts2toQOrD7cPMD8NfKrJPMEETi3VhohZLpjzH9l3A6
	 mrt1O6ZfW2FdsKS+MHyIk/o48JIFPcfMjkW6JkMV3pdGm8q88nHVroMl6RdpBi6YJ+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJfwcV6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA2606A32E
	for <linux-rdma@vger.kernel.org>; Sat,  7 Nov 2026 09:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJfwcV6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145AC1F0089F;
	Sat,  7 Nov 2026 09:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794044713;
	bh=+VQweLQM8EjLqBzSRh5Rpw8qrCYCPsjPyZy4gz9Ey/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VJfwcV6IFA11MtApE9qgntzqpD/b7tusEtac6sCsxVKFsZ+CgoL/p25YXE3no4YPB
	 rtk6PFzlzCmHOWlswFESz6ysZTIMVB8N1QI3YWoz7mjGsKb08AGj6CAv5ms5KudDU3
	 +TVxA20vV2jY/BzfVUUKLtmHhoFMy9ttKresSbjsjw6MbsKRklenprjr9GL2BUIwYE
	 3ICVO/mBEy7je5Aq87vKN0zR6q7vOA9idmjz3zxLxlkomOScavAQiTrq6D2bff3jOm
	 i2S77ylMQA8+e7Q4f1OZ8W0EtAnsB+6s1j8ZBmYVglVrBY2KhNRZ1Jzf+Oi/kthxl0
	 +FYsuTAmvQEcg==
Message-ID: <sashiko-outbox-202782@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/iwcm: restrict MAPINFO to administrators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sung Byeongchan" <tjdqudcks0424@naver.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261107093338.618394-1-tjdqudcks0424@naver.com>
References: <20261107093338.618394-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 09:45:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] RDMA/iwcm: missing RDMA_NL_ADMIN_PERM on remaining
  iwcm_nl_cb_table ops
--

commit 0d21801da4ca7ad844070c844f5a41cee7373664f5
Author: Sung Byeongchan <tjdqudcks0424@naver.com>

RDMA/iwcm: restrict MAPINFO to administrators

This commit sets RDMA_NL_ADMIN_PERM on the RDMA_NL_IWPM_MAPINFO callback
in iwcm_nl_cb_table so that CAP_NET_ADMIN is required before handling port
mapper MAPINFO requests.

> diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwc=
m.c
> index 4b05867dad895..8a3b5aa2dc5f7 100644
> --- a/drivers/infiniband/core/iwcm.c
> +++ b/drivers/infiniband/core/iwcm.c
> @@ -86,7 +86,10 @@ static struct rdma_nl_cbs iwcm_nl_cb_table[RDMA_NL_IWP=
M_NUM_OPS] =3D {
>  	[RDMA_NL_IWPM_QUERY_MAPPING] =3D {.dump =3D iwpm_add_and_query_mapping_=
cb},
>  	[RDMA_NL_IWPM_REMOTE_INFO] =3D {.dump =3D iwpm_remote_info_cb},
>  	[RDMA_NL_IWPM_HANDLE_ERR] =3D {.dump =3D iwpm_mapping_error_cb},
> -	[RDMA_NL_IWPM_MAPINFO] =3D {.dump =3D iwpm_mapping_info_cb},
> +	[RDMA_NL_IWPM_MAPINFO] =3D {
> +		.dump =3D iwpm_mapping_info_cb,
> +		.flags =3D RDMA_NL_ADMIN_PERM,
> +	},
>  	[RDMA_NL_IWPM_MAPINFO_NUM] =3D {.dump =3D iwpm_ack_mapping_info_cb},
>  	[RDMA_NL_IWPM_HELLO] =3D {.dump =3D iwpm_hello_cb}
>  };

[Severity: High]
Should the remaining callbacks in iwcm_nl_cb_table also set
RDMA_NL_ADMIN_PERM?

Leaving RDMA_NL_IWPM_HELLO without RDMA_NL_ADMIN_PERM still lets an
unprivileged NETLINK_RDMA sender invoke iwpm_hello_cb() to overwrite
iwpm_user_pid, reset client registration to IWPM_REG_INCOMPL, and
downgrade iwpm_ulib_version:

drivers/infiniband/core/iwpm_msg.c:iwpm_hello_cb() {
	...
	iwpm_set_registration(nl_client, IWPM_REG_INCOMPL);
	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
	iwpm_ulib_version =3D min_t(u16, IWPM_UABI_VERSION, abi_version);
	pr_debug("Using ABI version %u\n", iwpm_ulib_version);
	iwpm_user_pid =3D cb->nlh->nlmsg_pid;
	ret =3D iwpm_send_hello(nl_client, iwpm_user_pid, iwpm_ulib_version);
	...
}

Because rdma_nl_net_init() creates the netlink socket with
NL_CFG_F_NONROOT_RECV, an unprivileged process can also subscribe to
RDMA_NL_GROUP_IWPM and answer the kernel's RDMA_NL_IWPM_REG_PID multicast
query via iwpm_register_pid_cb() to claim iwpm_user_pid and set
IWPM_REG_VALID, redirecting subsequent mapping unicasts to itself.
In addition, iwpm_remote_info_cb() accepts unauthenticated
RDMA_NL_IWPM_REMOTE_INFO messages and inserts GFP_ATOMIC iwpm_remote_info
records into iwpm_reminfo_bucket, and the remaining callbacks in
iwcm_nl_cb_table are likewise privileged iwpmd daemon operations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107093338.6183=
94-1-tjdqudcks0424@naver.com?part=3D1
