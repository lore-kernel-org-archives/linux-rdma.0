Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336038;
	b=g7IYZtjyy0XUtoAartrIeo9jB+Npl5ROik5Dfoi+DYEv1sZeEPaSRPrfuPZLlh9GCMxD
	 J/fqm75hqfyumciBLn+rdgk2bmBecIBc3CmecDVvypWTSSfx80ssjri13MdoLnDQEIKO+
	 vp/JgFLbnxiPWZ8o/qJY2L9jK3yIKsy+FAZwpECZieMbkEyyhZqKiy4m+Kiw6tSzAnWVh
	 bd4wvlQmf7/wugVax4JKNBLXdU512fzz2FabiMqtJLHSUmX45e4iHflnf6AmWxeKrBC59
	 9CWcWFJQl1sG9zve/ROFTIx9+LHLqKuYyIl4RJ6QfSsBgHMXGs9reoQRu+PjhDNW11Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336038;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FtuHOInK3WYLeUSV4jZVTcQgw8H7zRhJxAyhsovLJTk=;
	b=t4s26f5vgYUhLXb5WoEL8c8lnCGR5R2InujXhL49d3PL8YQ0ocVsC4N7Zv9Soxe7Vyed
	 kbnWhGXk5Nj2wN4jmwIj7nivp9FRh2UeTNmVHHxFmM9MqecnF6r1T/2vptM6s+khFuQ14
	 I/YUbXQYWAu378LWGlhzkL3Bfq9G2OIYcp/SX9WS1lKQrnJA2vF2MDsA/sArz7jM+YmTR
	 V8dSsDIoBrNdOfAScHeb9hol2H96NWHsIQf/MBngqenhZLamNKuLOEraC/wAnuZYq9mEo
	 +i+68VYY7ML9pM4tI6eTHMZWOywU/U9mUFr7eoMrAhLrvnsvCjr/hUZYudf+2dvmriw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORle0YaV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CFC606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORle0YaV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6109C1F00A15;
	Fri, 30 Oct 2026 04:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336037;
	bh=FtuHOInK3WYLeUSV4jZVTcQgw8H7zRhJxAyhsovLJTk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ORle0YaVnDG9fktvJ1F2DrMfzeLcfBihA79YM8hOPTZWWagWffLh/jomAJ0zwbXvY
	 vL83eH17txj2aCJh+IlnTuKPmckOhlb84jYQ5Ms0xEB9zPVr03fVO/kLxdgWQJPb02
	 rwY9T6ikmXdl8wrYn/w2i9crNxlYjOBDj+NwJohF6iWz5TY2UiR1PgJBfHG0115GfB
	 F908xATPk8bFFC9aVS8874qYeLZ+HFjC0Hk/FGnrn2dQb0P55gm6qnbWxjgHYQSWCz
	 VyH3wikVGz8Gr6J8I9q48H/s8z05I0YczOhrwQ4ZVzgXafsfv+P9dd0GdJ+MO5Gc0g
	 VM11VlN0twT8Q==
Message-ID: <sashiko-outbox-190385@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 4/8] selftests: drv-net: ncdevmem: add -n
 flag to skip NIC configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-4-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-4-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bobby Eshleman <bobbyeshleman@meta.com>
>=20
> Add a -n (skip_config) flag that causes ncdevmem to skip NIC
> configuration when operating as an RX server. When -n is passed,
> ncdevmem skips configuring header split, RSS, and flow steering, as well
> as their teardown on exit.
>=20
> This allows ksft tests to pre-configure the NIC in the host namespace
> before launching ncdevmem in the guest namespace. This is needed for
> netkit devmem tests where the test harness namespace has direct access
> to the NIC and the ncdevmem namespace does not.
>=20
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D4

