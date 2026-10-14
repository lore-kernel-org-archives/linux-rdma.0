Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2945E4A6CFA
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017340; cv=none; b=d4U6rwWVQcqQx0/0/iz3hCb8kSRtcokKHcpl4Ahe6ekaGylRenR+a4MtOZ8jH3DYLu1IkzrYGPWZZDBiYEsScTSqEB/lgVplekfYdi+x4ZKwNLou6YKdEwpgllUG8CY4jHlcYZCGdMVd3UR0fnlp3SLr7gO7pSKZzXeuhKc6rNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017340; c=relaxed/simple;
	bh=Ta/mvpiGZPwUDaR2GWZpQZ0NxRZtMYDoXECQBbSpOwg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Xnpw5Gi8oACAnQJKgc/EK6FgOlDSygmsUzmVHZQDKsZaioNbYrpehpIRZkTXabhNeesvItlQ9JbDKGwro0qU6wzfCHGCH+mH3Y8rMoF3hILW13msRsbRuvU9/aoZadQ//W4efOkuyUfIrFG9uJFiA86Il2W1OqyDRIW4hf1/SIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRaRssjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRaRssjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EED81F000C4;
	Wed, 14 Oct 2026 22:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017338;
	bh=/dIa592qPVsfWbmSFVaYkXgF3R7HcnGekOiSaD4t9mM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TRaRssjWGOxYU8ngeDWJoOMKTBK4cD3KFmUQ6pRhMgHwXo/J0UA4sK30O8Ghag6q3
	 W4+z7NvhCZPsmm4pASs1+N5xwE8iyJTq2q8yJGaaJfizZCkA6sAd5qDRqJheeF6kjI
	 +9FK6tuaiR43epAiWtQuofLX56pUWaRt+WHjC1WuvScGjQmyWuwcQneM6m0tM0FVjq
	 ijZPm/VcPAYIFE5uCMNVyP2/vZzhSeITgzjFvPKFFo03WIvmMdiC0t6JVn8cUsqpaO
	 tSEWXlEzk6B28tPNJmwf/he2Xx3FcSjLxifAlYL35X/UjveZrWt9NE1nKode4FnJFf
	 ZuQRNDZgLBo3g==
Message-ID: <sashiko-outbox-171976@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:35:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] RDMA/core: Incomplete UET Address Handle initialization breaks inc=
oming WC
- [High] RDMA/cma: UET paths incorrectly classified as InfiniBand, dropping=
 DMAC
- [High] RDMA/cma: Missing netdev checks cause UET to fallback to InfiniBan=
d logic
--

commit 7479c85e5472864148025ac811bf445ba1cec04d
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: add the UET GID types

This commit introduces the UET GID types for UDP and IP encapsulations,
allowing a port to hold both UET and RoCE GIDs. It also adds
rdma_port_gids_from_netdev() to build the GID table from a netdev for
UET ports similarly to how it is done for RoCE.

> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index edf62652f9d3e..24db88e6d3fa0 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -862,6 +862,10 @@ int ib_init_ah_attr_from_wc(struct ib_device *device=
, u32 port_num,
> =20
>  	might_sleep();
> =20
> +	if (rdma_protocol_uet(device, port_num) &&
> +	    !rdma_protocol_roce(device, port_num))
> +		return -EPROTONOSUPPORT;
> +

[Severity: High]
Does this explicitly fail Address Handle initialization for UET-only ports?

Returning -EPROTONOSUPPORT here blocks Address Handle creation for incoming
packets on UET-only ports, preventing the host from responding to connectio=
ns.

Additionally, for dual-mode ports, this function extracts the IP network
type and passes it to ib_network_to_gid_type(). Because ib_network_to_gid_t=
ype()
was not updated to handle UET, it unconditionally maps IPv4 and IPv6 to
IB_GID_TYPE_ROCE_UDP_ENCAP:

include/rdma/ib_verbs.h:ib_network_to_gid_type() {
    if (network_type =3D=3D RDMA_NETWORK_IPV4 ||
        network_type =3D=3D RDMA_NETWORK_IPV6)
        return IB_GID_TYPE_ROCE_UDP_ENCAP;
    ...
}

Could this cause incoming UET packets to be incorrectly mapped to a RoCEv2
GID index, breaking the UET transport response?

[ ... ]

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index d6eaa3fee66e3..4e3a5c38cbe8b 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -145,6 +145,8 @@ enum ib_gid_type {
>  	IB_GID_TYPE_IB =3D IB_UVERBS_GID_TYPE_IB,
>  	IB_GID_TYPE_ROCE =3D IB_UVERBS_GID_TYPE_ROCE_V1,
>  	IB_GID_TYPE_ROCE_UDP_ENCAP =3D IB_UVERBS_GID_TYPE_ROCE_V2,
> +	IB_GID_TYPE_UET_UDP =3D IB_UVERBS_GID_TYPE_UET_UDP,
> +	IB_GID_TYPE_UET_IP =3D IB_UVERBS_GID_TYPE_UET_IP,
>  	IB_GID_TYPE_SIZE
>  };

[Severity: High]
When these new GID types are passed to the Subnet Administrator (SA) layer,
are they incorrectly classified as InfiniBand path records?

In sa_conv_gid_to_pathrec_type() in include/rdma/ib_sa.h, there are no cases
for the new UET GID types, causing them to fall through to the default case:

include/rdma/ib_sa.h:sa_conv_gid_to_pathrec_type() {
    ...
    default:
        return SA_PATH_REC_TYPE_IB;
}

Later, when CMA attempts to set the destination MAC address for the path re=
cord,
sa_path_set_dmac() checks if the path is RoCE:

include/rdma/ib_sa.h:sa_path_set_dmac() {
    if (sa_path_is_roce(rec))
        memcpy(rec->roce.dmac, dmac, ETH_ALEN);
    ...
}

Because the path is classified as IB rather than Ethernet/RoCE, this check
fails. Will this silently discard the destination MAC address, causing outg=
oing
packets to be dropped due to an uninitialized MAC?

[ ... ]

> @@ -3407,6 +3420,34 @@ static inline bool rdma_protocol_roce_eth_encap(co=
nst struct ib_device *device,
>  	       RDMA_CORE_CAP_PROT_ROCE;
>  }
> =20
> +static inline bool rdma_protocol_uet(const struct ib_device *device,
> +				     u32 port_num)
> +{
> +	return device->port_data[port_num].immutable.core_cap_flags &
> +	       RDMA_CORE_CAP_PROT_UET;
> +}
> +
> +static inline bool rdma_protocol_uet_udp(const struct ib_device *device,
> +					 u32 port_num)
> +{
> +	return device->port_data[port_num].immutable.core_cap_flags &
> +	       RDMA_CORE_CAP_PROT_UET_UDP;
> +}
> +
> +static inline bool rdma_protocol_uet_ip(const struct ib_device *device,
> +					u32 port_num)
> +{
> +	return device->port_data[port_num].immutable.core_cap_flags &
> +	       RDMA_CORE_CAP_PROT_UET_IP;
> +}
> +
> +static inline bool rdma_port_gids_from_netdev(const struct ib_device *de=
vice,
> +					      u32 port_num)
> +{
> +	return rdma_protocol_roce(device, port_num) ||
> +	       rdma_protocol_uet(device, port_num);
> +}
> +

[Severity: High]
While this helper correctly abstracts the GID table logic for UET and RoCE,
are there missing netdev checks in the CMA and Multicast layers that still
explicitly check rdma_protocol_roce() instead of this new helper?

In cma_ib_acquire_dev(), UET-only ports fail the RoCE check and fall into t=
he
else block intended for InfiniBand:

drivers/infiniband/core/cma.c:cma_ib_acquire_dev() {
    if (rdma_protocol_roce(req->device, req->port))
        rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr, &g=
id);
    else
        memcpy(&gid, dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr=
), sizeof(gid));
    ...
}

Since Ethernet MAC addresses are only 6 bytes, does copying 16 bytes from
dev_addr->src_dev_addr lead to an out-of-bounds read and a malformed GID?

Similarly, in rdma_resolve_route(), UET fails the protocol checks and falls
through to return -ENOSYS:

drivers/infiniband/core/cma.c:rdma_resolve_route() {
    ...
    else if (rdma_protocol_roce(id->device, id->port_num)) {
        ret =3D cma_resolve_iboe_route(id_priv);
    ...
}

Finally, in ib_init_ah_from_mcmember(), UET ports fail the !rdma_protocol_r=
oce
check and return -EINVAL:

drivers/infiniband/core/multicast.c:ib_init_ah_from_mcmember() {
    ...
    else if (!rdma_protocol_roce(device, port_num))
        return -EINVAL;
    ...
}

Will these missing updates break route resolution and multicast joins for U=
ET
devices?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D2
