Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422324;
	b=Hj3Fw9GxoerngWm0+wGOF9/2BuhxsApgq66ErVsdcEDGrx4aTgWI/l3hkEuc8E0g7Dsb
	 gkynDPc0nZJQj2Q6mu0J2dEe/0YDjaeDWs3z/fkxt7v86S9faGHnLWSnQ9E64+eZO8GpT
	 2wLKzDAuHyh7UNj5tWQaubFujxQ7EyE1eGqPWWpfweVTWiI6ORU5LSYO69yiCzsVBSUwe
	 S/BLQ77kLJn7cZOI7z5XiR6tb/wB56JiGiXcUN7Z0+GyWNARO+pAHTKz3l6H6p6ZOWxr8
	 oBCcMvzw3dWyLHxg9w9wbQ+M6T0z32GeLODtUo2aPDHm3mxFp+lj6sn/IkgKXfD/u8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422324;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O1cL3w38m0W5CfV/HTGX2lciE9L7Oh5ExaJQVHqC0zs=;
	b=wswmCp2ABff+7XfvMdsFU2Bb++2lBWhayPkRKwaIzULEWZsqPTSdOj451BCT7Cx/DwJm
	 01lWutYGNxO8RX1Hu8pxtVYtBy6Go8PkmMSUrn4CP/evYf92XSYJTw6SPtNrGPLhLMa97
	 enMSZF2l5TomSGyYwzjb3xvHMVgjWtiY/wwqES6V1ErWLbs8ERiC3CyipEQCxsvcTdBHt
	 oWrrYaXiXkEIJTaUXkxo9stukAXPcHwJPZ6QwJjgxRYLO/Z0KfgVOoukg/4KiOLP8kh8R
	 aaVkL1Jadu/qvSFz/SFz2fy2fbUya0o27haoUF/Z6Lkk8DioQjlfUZ6uPkESaAVHFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pd0WMaGs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745416080A97
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pd0WMaGs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087181F000C4;
	Mon, 19 Oct 2026 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422324;
	bh=O1cL3w38m0W5CfV/HTGX2lciE9L7Oh5ExaJQVHqC0zs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pd0WMaGsWLctvwum+l1n9YYfDXLLm/SqY+SEubVzBc6OIs4DllcKibi4ITkinA74c
	 hU04SVeQZAc7z2/xrioSxBLW46wWi5tjaZXkfijcMXtVjiGdwh0zlAdpcTotUkO23K
	 eVzdDcPdp4h4tNHGtoEtCIkJIV8IsXtf9UJwb1xQ0Df+rxFJh8WXBnHk5bToLFlDne
	 bBxt03pjO7oaik68YX7AaNLgYOWN6QnuTWFD2YhrvW9aqfLJjckgumJ+gWQmw5uEaY
	 aV/6b0RGykoGLlG4UoPAh1o058GqCV/6dQK1g3eF5bG+jPavenGEeOge3QjPvogRxp
	 nrwRPZ9IK9hsA==
Message-ID: <sashiko-outbox-177605@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.12] RDMA/efa: Add EFA 0xefa4 PCI ID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-330-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-330-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:05:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/efa: broken >=3D4GB MR registration on 0xefa4 in efa_register=
_mr()
- [High] RDMA/efa: missing AH cache in efa_com_create_ah() for 0xefa4 devic=
es
--

commit b286b983be1758d745ca136c6fbfaf1703d09edf
Author: Anas Mousa <anasmous@amazon.com>

RDMA/efa: Add EFA 0xefa4 PCI ID

This commit adds the PCI device ID 0xefa4 (PCI_DEV_ID_EFA4_VF) to
efa_pci_tbl so the EFA driver can bind to 0xefa4 devices.

Link: https://patch.msgid.link/20260712134413.19226-3-mrgolin@amazon.com

> diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw=
/efa/efa_main.c
> index 6c415b9adb5fe..460d77d965057 100644
> --- a/drivers/infiniband/hw/efa/efa_main.c
> +++ b/drivers/infiniband/hw/efa/efa_main.c
> @@ -17,12 +17,14 @@
>  #define PCI_DEV_ID_EFA1_VF 0xefa1
>  #define PCI_DEV_ID_EFA2_VF 0xefa2
>  #define PCI_DEV_ID_EFA3_VF 0xefa3
> +#define PCI_DEV_ID_EFA4_VF 0xefa4
> =20
>  static const struct pci_device_id efa_pci_tbl[] =3D {
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA0_VF) },
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA1_VF) },
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA2_VF) },
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA3_VF) },
> +	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA4_VF) },

[Severity: High]
Does enabling PCI_DEV_ID_EFA4_VF in efa_pci_tbl break memory region
registration when a page size of 4GB or larger (page_shift >=3D 32) is
selected on 0xefa4 devices?

When 0xefa4 devices advertise >=3D 4GB page sizes in dev_attr.page_size_cap
and a consumer registers a large memory region via efa_register_mr(), the
64-bit unsigned long return value of ib_umem_find_best_pgsz() is stored in
a 32-bit unsigned int pg_sz:

drivers/infiniband/hw/efa/efa_verbs.c:efa_register_mr() {
	unsigned int pg_sz;
	...
	pg_sz =3D ib_umem_find_best_pgsz(mr->umem,
				       dev->dev_attr.page_size_cap,
				       virt_addr);
	if (!pg_sz) {
		ibdev_dbg(&dev->ibdev, "Failed to find a suitable page size in page_size_=
cap %#llx\n",
			  dev->dev_attr.page_size_cap);
		return -EOPNOTSUPP;
	}

	params.page_shift =3D order_base_2(pg_sz);
}

When ib_umem_find_best_pgsz() selects a power-of-two page size >=3D 4GB,
assigning it to unsigned int pg_sz truncates the value to 0 and causes
efa_register_mr() to fail with -EOPNOTSUPP.

In addition, upstream commit 6a57af838b1a5 ("RDMA/efa: Add EFA 0xefa4 PCI
ID") was submitted as patch 2/2 alongside commit 4266547bdce74 ("RDMA/efa:
Extend page-shift field in MR registration"), which widens
EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT_MASK from GENMASK(4, 0) to
GENMASK(5, 0) for >4GB page sizes. Without that companion commit,
drivers/infiniband/hw/efa/efa_admin_cmds_defs.h still defines:

#define EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT_MASK      GENMASK(4, 0)

So in efa_com_register_mr() in drivers/infiniband/hw/efa/efa_com_cmd.c:

	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
		params->page_shift);

bit 5 of params->page_shift is masked off for any page_shift >=3D 32. Should
pg_sz be an unsigned long and commit 4266547bdce74 be included as well?

[Severity: High]
Will creating multiple address handles to the same remote GID on the same
PD fail on 0xefa4 hardware without the address handle cache commits?

Upstream commits 97ba15272e8e ("RDMA/efa: Add initialization of AH cache
rhashtable") and 234895fa8be0 ("RDMA/efa: Add AH cache handling on create
and destroy AH") were merged right before commit 6a57af838b1a5 because new
EFA devices do not support creating multiple address handles to the same
remote on the same PD.

Without those commits backported, calling efa_create_ah() ->
efa_com_create_ah() for the same (pdn, dest_addr) pair unconditionally
sends a new EFA_ADMIN_CREATE_AH command to the device instead of
deduplicating and refcounting via efa_ah_cache_get():

drivers/infiniband/hw/efa/efa_com_cmd.c:efa_com_create_ah() {
	...
	ah_cmd.aq_common_desc.opcode =3D EFA_ADMIN_CREATE_AH;

	memcpy(ah_cmd.dest_addr, params->dest_addr, sizeof(ah_cmd.dest_addr));
	ah_cmd.pd =3D params->pdn;

	err =3D efa_com_cmd_exec(aq,
			       (struct efa_admin_aq_entry *)&ah_cmd,
			       sizeof(ah_cmd),
			       (struct efa_admin_acq_entry *)&cmd_completion,
			       sizeof(cmd_completion));
}

Should commits 97ba15272e8e and 234895fa8be0 also be backported before
enabling PCI_DEV_ID_EFA4_VF?

>  	{ }
>  };
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-330-sashal@kernel.org?part=3D1
