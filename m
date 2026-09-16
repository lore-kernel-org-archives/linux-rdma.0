Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC39A3A5436
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789561394; cv=none; b=co+WKTciAVYNi6hSMby/g9apowEkYCXr8A9ukwZndGu9NJIT6fCkKC5i/mTO+B34+ErINehxN3yF+LCC2S87XWzLrR1U92yXEAj2e2SF2jNhtzMMDyZs931cqqmx3js7xtxq6OOddZ/biN+m4NllMEmKLTNrGsn3E4BUIO0SFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789561394; c=relaxed/simple;
	bh=6Xe3DkdyDwsUapDIABSUzc+36hJC7LdZLN6DC5KAmFM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MfALinY8aPg9+zpfDnyUAfDemqETzbREUfgn9/R/PjtngCp94yrox3cQPFVnTUsUSZo841Gv6PVSKECtx37+Hv2/HJPXy4x6ZtjNU9EYhrpUMXKwoIEBA6OzDg11ijKJ18oXO39bTuu5gLdTilR13BexpguPZUuVLjnCG3sscYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiIeYDCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiIeYDCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891EC1F000FF;
	Wed, 16 Sep 2026 12:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789561393;
	bh=uLETUG4I12Vl7+vemSrZSwjXiqNGjIwY7yN49gDt2kM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kiIeYDCLnF+3WOb6Wbq/EKH00b5Vm3O5Ujt2ROrSvf20suZTqeZ25h0abAflgd3ET
	 pwlrhZ7oo0ahkUx/OWqOgn8+MoXYUkGhIzxnOimSIfSXlP2efoe0WBOZngQY22OaTL
	 wRN3daIqKKU2nQG7k5sw13Xz0CtDLPnHxFDRt3+EEiBAIFpv4j7nLPvzwlgpXFp++B
	 2zJ0g+uKkrfEOdJstlNavCUz2OsfiKJxSpMlBTWeGPKy48xFLsZ7j2t4rzzPQNSFOH
	 52E4m+VaB7G/iaIKGJX5z1iV7ofJAQqqSVFxlABsUgipP5pZ3mXxDE0TxR6KMPXSpP
	 gIcVLY52Z5MoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG
 hash skb
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916120926.1761-1-lirongqing@baidu.com>
References: <20260916120926.1761-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 12:23:13 +0000
Message-Id: <20260916122313.891EC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
> selection and copies the flow label from the AH attribute:
>=20
> 	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
> 	       sizeof(*ip6h->flow_lbl));
>=20
> ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
> array to a single __u8 and yields 1.  The memcpy therefore copies only
> the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
> uninitialised in the skb buffer (alloc_skb() does not zero the data).
> The resulting LAG hash is computed over one byte of real flow-label
> data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
> bonded interface can be steered to the wrong slave.
>=20
> Use sizeof(ip6h->flow_lbl) (the array, 3 bytes) so the whole flow label
> is copied.
>=20
> Fixes: bd3920eac1331 ("RDMA/core: Add LAG functionality")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916120926.1761=
-1-lirongqing@baidu.com?part=3D1

