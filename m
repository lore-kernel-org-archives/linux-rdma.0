Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263324AB3C0
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017243; cv=none; b=FNpSKhcUFseFHQzEMcVJbWS1FbmlTnWCjVAe4gQ7A5Njb092bTxf4TjJUR7vhtA+sXqMSlLEHj/4sVWcnixl/T8hUWpQGeGjteiceBRrKwg5Z0j+gSlL33FC12nMUIQ0lgJQrSqq70vrV8re4kIvjFvjIeuiSKEsOhX7CbD7peI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017243; c=relaxed/simple;
	bh=zxE6cuXr2VUwpJWqBOYvTOsW7W71US2b9Kaq8E9rlBs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hXUAlcsIBhJfh/F53J8wSx0VpKHFvvsGTuclv23XIPirVSv9PUGMZI/Cscp/NcNHI3PLeZBH8pbOaPLMuFVvw/Y9/BYTDrz8Pq6zimiKQPtDGM8cp09VcDKBtD7d05HOKSGh+syU1jYNN26CS92YA6tQs1BWr6pgAv+YO4NABW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCBcmfG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCBcmfG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BBC1F000C4;
	Wed, 14 Oct 2026 22:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017242;
	bh=QA4FcZp9faacR3WgSzSfhoceDTPhsJ47EPpbCPKfLHo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZCBcmfG5nkV4LBUTrRve9ZXBIy9zeeUIV9Rfh9sNh6sb0Taq4EFbpaPDKgccjtQgY
	 Dua+P/4koaBjY030pPxYCKMoB2JwMxtdffGhSrLF5UzI3zQkJ9qHVGhpzRzAaNA+iC
	 kW4BgdGOKX11dT9nMctfeg9+kFbx+i0r1x1Ivx7AQHsMk5u1ejRImxUFHcij7ONEug
	 dxs0H80AreSPS/8pDpVJmDZLnnwbwBQIND5DUVYnHwm6lVc4OFant1SqS2EY93KrYG
	 G5Opb2uftaDM/6k3zyebkhwxwLf8vxHTpJ/HjR1u8b2WkAWV0cfPEtoqGNWb+Xleqi
	 eayNUx60Thb8g==
Message-ID: <sashiko-outbox-171975@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 06/13] RDMA/core: query the semantics a queue
 pair type guarantees
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-6-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-6-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:34:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma: query_qp_semantics lacks MR attachment capability flag
--

commit 5f36c96aa3fcf03ebbebf03d834b66a1b7642e0a
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: query the semantics a queue pair type guarantees

This commit adds a device method to report the guarantees of a queue pair
type, such as operations ordering, largest packet size, and immediate data
width.

>     An unconnected transport orders far less than a connected one, and how
>     much varies by device. Add a device method that reports, for a queue =
pair
>     type, which operations it orders against which, the largest packet it
>     puts on the wire, how wide an immediate it carries, and whether a mem=
ory
>     region may be attached to a QP so it's only reachable over that QP.

[Severity: Medium]
The commit message states that query_qp_semantics reports "whether a memory
region may be attached to a QP so it's only reachable over that QP".

Is this description accurate for this patch? I notice that a later commit
reports this capability via query_device instead. Could the commit message
be updated to reflect that the MR attachment capability is not included
in query_qp_semantics?

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 68f7a271cf7a7..003b704244293 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
[ ... ]
> @@ -2496,6 +2496,18 @@ struct ib_counters {
>  	atomic_t	usecnt;
>  };
> =20
> +/* what a queue pair of a given type guarantees (query_qp_semantics) */
> +struct ib_qp_semantics {
> +	u32	comp_mask;		/* enum ib_uverbs_qp_semantics_mask */
> +	u32	msg_order;		/* enum ib_uverbs_qp_msg_order */
> +	u32	max_rdma_raw_size;
> +	u32	max_rdma_war_size;
> +	u32	max_rdma_waw_size;
> +	u32	max_pdu;
> +	u32	usage_flags;		/* enum ib_uverbs_qp_usage_flags */
> +	u8	imm_data_size;		/* bits */
> +};

[Severity: Medium]
Does struct ib_qp_semantics omit the MR attachment capability claimed by the
commit message? There doesn't appear to be a field or flag here for it.

> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/=
ib_user_ioctl_verbs.h
> index 210f3f945bd73..3d05a6c7ca8f6 100644
> --- a/include/uapi/rdma/ib_user_ioctl_verbs.h
> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
[ ... ]
> +enum ib_uverbs_qp_usage_flags {
> +	/* immediate data consumes a posted receive */
> +	IB_UVERBS_QP_USAGE_IMM_DATA_RQ	=3D 1 << 0,
> +};

[Severity: Medium]
The usage flags enum only contains IB_UVERBS_QP_USAGE_IMM_DATA_RQ. Should
there be a flag here indicating whether an MR can be attached, or is this
omission expected since it's later reported via query_device?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D6
