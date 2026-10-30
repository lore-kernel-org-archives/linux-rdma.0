Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336039;
	b=w2RMLc6uHXCOcwwZQIhqzobzllTDp2SYGvk7+k9u/ytWDb+OeFPByFfQlAOT7GRaN4f4
	 HOles+EZLt+fck743nvLLogn02AgRtvqTW2BI2jgR8Sp7ghCzxFvrtnTaD1HBZ5+gI5xg
	 quBgPQHk2+3e5qOmCIN+m+V+EitP6vEF3U9J8/HWP1UTo6ByElDXlKYJ1WK+zqbjABnCx
	 Eo9dHsYCoe4IkNTVnppNuxnmuLHP2jZRzYd7xXNS3YUKOZp+Ecw0sTdswoJrCNQHdtmOK
	 vKnF+08YyS4LKs3E8e1Kq5BI91apAY/9/qfIJlyxf4Nx76BvK0wpbeVktQ5wtvtfifA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336039;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oxmGXofS5xrZ7ACyHxtlRvmrt6g+0VHbN8MBay/cgt8=;
	b=TMhEmsdmjwxCJcCrCi/UWA759J1MQhCTuk+iN3zJh11dTPLK/GM3QYX/WzKXduvljm3C
	 XZihtmcn8BBETJ9PWzKI/TlfP8rJcHAqdl6IEZaZaJANQDOYqSJsEdDvJN7/5NeFrtl/d
	 QcWbKRR4e8l4FkTEG5cKs1F5P3+NdWwvvIdjFHrvRbgRhU/3hniYKd8uZsZE/Vp39XiLT
	 yarQiXEtnHSnglq9hI8O81vwVqhfSBWTlyOjWcpDxLA9g+trpYUP6MfBmwMPiJiCG/999
	 dHkfIaYgjXw6jTmO+hBg5kbYLajRIITWA75hvYqM7HFcMJ40bwcNHN348GR/h2HdhlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBTarPqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B0B606A31C;
	Fri, 30 Oct 2026 04:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBTarPqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3C71F00A15;
	Fri, 30 Oct 2026 04:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336038;
	bh=oxmGXofS5xrZ7ACyHxtlRvmrt6g+0VHbN8MBay/cgt8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YBTarPqj7vwhq/+oXXgSfXfC9/kMV2m8aqRrwxPVt8yu3GqpLfTcZo4UrHcxllGH/
	 2eFOPk30yqd/RnyQpoWzDalW5nprR0IUdbUQT6Rn0841oFxXR+IdvbvdRFSKIKsfMb
	 pASyjaJi2kLChyv2TXtb8uc0juRgiqi61ddahFvGyLTveIfx7nbe54z1nv3KxcDxDP
	 HfJJGKY0/vt8gm0tbNgBYicljEu1pvCQht2u/JCGPHrinBG9dLSOJ+R9iJ/ilm/XE9
	 A1/BiC4vt/k7FQu1f/jy3h2MXK6PnIDJxkYa6zz3Vq9J6rGyslVITX6J2GYZMmhosd
	 UQoqmAzCZcL6Q==
Message-ID: <sashiko-outbox-190387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 7/8] selftests: drv-net: add
 primary_rx_redirect support to NetDrvContEnv
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-7-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-7-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Hardcoded little-endian byte order for BPF map values breaks tes=
ts on big-endian architectures.
- [Low] BPF program fails to account for IPv6 extension headers, potentiall=
y misrouting ICMPv6 packets.
- [Low] Unsafe dictionary access when parsing `tc filter show` output can l=
ead to a `KeyError`.
--

commit 431500c080b55b59605689dc687523876de45d23
Author: Bobby Eshleman <bobbyeshleman@meta.com>

selftests: drv-net: add primary_rx_redirect support to NetDrvContEnv

This commit adds a BPF program and Python harness support to redirect RX
traffic from the host netkit interface to the physical NIC. It skips ICMPv6
packets so neighbor discovery continues to work locally. It also extracts m=
ap
ID lookups into a reusable helper.

> diff --git a/tools/testing/selftests/drivers/net/hw/nk_primary_rx_redirec=
t.bpf.c b/tools/testing/selftests/drivers/net/hw/nk_primary_rx_redirect.bpf=
.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/hw/nk_primary_rx_redirect.bpf.c

[ ... ]

> +	ip6h =3D data + sizeof(struct ethhdr);
> +	if ((void *)(ip6h + 1) > data_end)
> +		return TC_ACT_OK;
> +
> +	if (ip6h->nexthdr =3D=3D IPPROTO_ICMPV6)
> +		return TC_ACT_OK;

Will this check miss ICMPv6 packets if the IPv6 packet contains extension
headers?

For example, Multicast Listener Discovery packets use the Hop-by-Hop Options
header where nexthdr is 0. For these packets, ip6h->nexthdr won't equal
IPPROTO_ICMPV6 here, causing them to be incorrectly redirected to the
physical NIC instead of being processed by the host netkit interface.

> +
> +	return bpf_redirect_neigh(phys_ifindex, NULL, 0, 0);
> +}

[ ... ]

> diff --git a/tools/testing/selftests/drivers/net/lib/py/env.py b/tools/te=
sting/selftests/drivers/net/lib/py/env.py
> index 409b419222454..af8e1de8ed7b1 100644
> --- a/tools/testing/selftests/drivers/net/lib/py/env.py
> +++ b/tools/testing/selftests/drivers/net/lib/py/env.py

[ ... ]

> +    def _attach_primary_rx_redirect_bpf(self):
> +        """Attach BPF redirect program on the primary netkit ingress."""

[ ... ]

> +        filters =3D json.loads(
> +            cmd(f"tc -j filter show dev {self._nk_host_ifname} ingress")=
.stdout)
> +        redirect_prog_id =3D None
> +        for bpf in filters:
> +            if 'options' not in bpf:
> +                continue
> +            if bpf['options']['bpf_name'].startswith('nk_primary_rx_redi=
rect'):
> +                redirect_prog_id =3D bpf['options']['prog']['id']
> +                break

Could this throw a KeyError if a non-BPF filter is present on the interface?

Other filter types, such as u32 or matchall, might have an options dictiona=
ry
but lack the bpf_name key. Using .get('bpf_name', '') might be a safer way
to check the prefix.

> +        if redirect_prog_id is None:
> +            raise Exception("Failed to get primary RX redirect BPF prog =
ID")
> +
> +        bss_map_id =3D self._find_bss_map_id(redirect_prog_id)
> +        phys_ifindex_bytes =3D self.ifindex.to_bytes(4, byteorder=3D'lit=
tle')

Will hardcoding the byteorder to little break this test on big-endian
architectures?

BPF programs access memory using host-native byte order. Writing a
little-endian value via bpftool on a big-endian system like s390x might
cause the BPF program to read an incorrect ifindex, leading to a failure
in the bpf_redirect_neigh() call.

> +        value_hex =3D ' '.join(f'{b:02x}' for b in phys_ifindex_bytes)
> +        bpftool(f"map update id {bss_map_id} key hex 00 00 00 00 value h=
ex {value_hex}")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D7
