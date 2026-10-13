Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135573C1D47
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791882412; cv=none; b=aPjkwHufRzGUwaD2Hb1IpjvAIBIEZWsCGH2uBYVbsn2IxpK60Pthgo5jiYCE5ZfJD7CgeP2mZd9Gc/+N7wnWmt7V1Lq6spDDYCWF5XIwBWmfXYDYBKWE5VRAmJm1W3v41qNhiynVRcDPdwa9Xu8MmP8lcMFKaVNSmZ6lbHqDpLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791882412; c=relaxed/simple;
	bh=D0gN35Q5UVs6FDZ4g0eLomCoaMMTaEew8KdLRH+vvxE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KseaVywvBYVAT6qSLMGKBVV8gvuLtt0s4aeHXMRUPyJ94XyvaenlgGKVTrRhwnzYv8wTADlIAv4jQ2bG8/C4rrwQlzyvvS1YBDDj5vNlrWIKqjYSVmY8u6U0XuGjqCZR1tqlg5Ljy/sPbYxadlxaD6gHehZIZ9RV/qxpf7xIgOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5G//njG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5G//njG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836141F00893;
	Tue, 13 Oct 2026 09:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791882410;
	bh=D0gN35Q5UVs6FDZ4g0eLomCoaMMTaEew8KdLRH+vvxE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5G//njG3Ye//CBZ5UW1ljzJ8fUBTqT1H6cO2V/alDUJa/Mr7Wgf+iuY3a4ORfrOc
	 /LEdXsApv9JGYZ3f5nDHCPlqhkBF87lMJRRTiIiddbSsnm/1uxUmFU0d1CVlej1nV6
	 0EQmeJ2mplsSqKv4n5iBxzNcIGgl3ao+ZI0j4isHz/oF4IkunCXnvFEK/iTmbOMtD3
	 uatlzOpmMd1XzR4N/T0+DfVhMK2tM5nKFiZFPUonN6Pwp7TZ97uIUDC1SAr/UUxeoC
	 uRgilF+cF5ZtkHKUF715dIMFunziBSz6el448I2NBkzI5GV87OcM8VSI2wGw/FLJIC
	 BCstHNv8NV6+g==
Message-ID: <sashiko-outbox-169312@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 2/2] RDMA/bnxt_re: Unpublish QP table before
 freeing it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261013140427.256612-3-selvin.xavier@broadcom.com>
References: <20261013140427.256612-1-selvin.xavier@broadcom.com>
 <20261013140427.256612-3-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 09:06:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> bnxt_re_dev_uninit() frees the QP table before the RCFW channel is
> disabled, so the CREQ tasklet can still look up rcfw->qp_tbl while it
> is being freed.
>=20
> Clear rcfw->qp_tbl under tbl_lock before freeing it, and have the QP
> error notification handler bail out if the table is gone.
>=20
> Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013140427.2566=
12-1-selvin.xavier@broadcom.com?part=3D2

