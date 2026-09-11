Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018C03AAF7B;
	Fri, 11 Sep 2026 10:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123508; cv=none; b=CSusJrY+t3yCRbQJ4axuElfXYJRViEUWdTCRGy7zXx6anpY/oYFw2ybsykZMMZMZis5tymUIDjgbINTycfYJBu2mQgsVFgchqgvEj6ZgMSb4DrwVpcfYekWck8LSuHGnLSczvZMK/tKPH01PVfGEuXXN+lJwl00KDJACtHYzRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123508; c=relaxed/simple;
	bh=qNmZndnpGRGIa4f6EdZz33sN8ED3ZErXgojh/aSPLn8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gx79LbNlbWXw9UwPWMoUg5/oEdDsOX6pn/UttHt4XAGpy/r7Rv5a0lZwis8k8iafBz0/Ws7qeymLKI01w6RyXZsm9swfVcUtbMqgfpC/cF8AFjtzmDVdRktz59dvAtgzxPqNxjeqMfhuSJFKccEm1z6rIdCQsx+wNi+t34JW8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQSeJol5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQSeJol5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BF01F00893;
	Fri, 11 Sep 2026 10:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789123506;
	bh=38+XSPAe0nb7UKr7PA7cVu1kuFhN9oZv9OYUqvMD7us=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EQSeJol5d7w7LViZJnSmNYrev53VOkaAQV95DzJxxKdz3JWeLFcQBEzW/LWFyLrRZ
	 DSEzg2KQ9OVBg2RjHi+N2wOaqYg+Gc4k7YbJrRDlayuGT1HGUx1meYFD2kbBJ+m9/s
	 8yrbgy4yZTr+E7qfEgxzIKObJn/tgHkW84f7AhxBkXIFo1twUfTRJKfouQxdG1AMh2
	 ESWkuPPjdgmnpdwlQP9QuTwnM4Qd5wR+PUECP4RgBivx+cfNAw4Ujc/rWRvQdpIG4B
	 SzYOHtpfbHcMeuS6sBH9Yk5Gamutv0GNbBBb7MfVMu2APe5yiDlTGYzpV3sK5V7x0H
	 ZRMOloLe/6bqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] net/smc: clear the correct v2 slot and
 buffer in smc_wr_tx_put_slot()
Reply-To: sashiko-reviews@lists.linux.dev
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260910104446.41423-2-alibuda@linux.alibaba.com>
References: <20260910104446.41423-1-alibuda@linux.alibaba.com>
 <20260910104446.41423-2-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 10:45:06 +0000
Message-Id: <20260911104506.76BF01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] DMA use-after-free/unmap during link teardown due to ignored v2 TX=
 pending state.
- [High] TOCTOU data race condition in V2 slot management causes data corru=
ption of outgoing LLC messages due to lockless memset.
--

commit 4dd2538a0566b239179ada14640f3f763de057d5
Author: D. Wythe <alibuda@linux.alibaba.com>

net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
   =20
This commit fixes a bug where pointers were being zeroed instead of the
structures they point to when clearing the v2 pending slot and buffer. By
passing the pointers directly and using sizeof(*pointer), it ensures the
intended structures are actually zeroed.

> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 97ba46893b17f..def2ab84b0c71 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -288,10 +288,10 @@ int smc_wr_tx_put_slot(struct smc_link *link,
>  	} else if (link->lgr->smc_version =3D=3D SMC_V2 &&
>  		   pend->idx =3D=3D link->wr_tx_cnt) {
>  		/* Large v2 buffer */
> -		memset(&link->wr_tx_v2_pend, 0,
> -		       sizeof(link->wr_tx_v2_pend));
> -		memset(&link->lgr->wr_tx_buf_v2, 0,
> -		       sizeof(link->lgr->wr_tx_buf_v2));
> +		memset(link->wr_tx_v2_pend, 0,
> +		       sizeof(*link->wr_tx_v2_pend));
> +		memset(link->lgr->wr_tx_buf_v2, 0,
> +		       sizeof(*link->lgr->wr_tx_buf_v2));

[Severity: High]
This isn't a bug introduced by this patch, but since the memset is now
correctly clearing the struct, could this create a data race with
smc_wr_tx_get_v2_slot()?

The first memset clears the entire smc_wr_tx_pend structure, which includes
the idx field. Once idx becomes 0, a concurrent thread calling
smc_wr_tx_get_v2_slot() might locklessly see that the slot is available
since it checks:

    if (link->wr_tx_v2_pend->idx =3D=3D link->wr_tx_cnt)
        return -EBUSY;
       =20
If the concurrent thread grabs the slot and starts writing data into the
payload buffer, the second memset here will then overwrite that newly claim=
ed
buffer with zeroes. Could this cause the hardware to transmit a corrupted
or empty message?

[Severity: High]
This is also a pre-existing issue, but while reviewing the V2 TX pending=20
state logic, could there be a DMA use-after-free during link teardown?

During teardown, smc_wr_free_link() waits for pending sends to finish by
calling smc_wr_tx_wait_no_pending_sends(), which relies on:

    static inline bool smc_wr_is_tx_pend(struct smc_link *link)
    {
        ...
        return !bitmap_empty(link->wr_tx_mask, link->wr_tx_cnt);
    }

This only checks the wr_tx_mask bitmap. However, the V2 TX slot does not use
the mask; its pending state is tracked by link->wr_tx_v2_pend->idx.=20

If only a V2 TX request is in flight, would smc_wr_is_tx_pend() return false
and allow smc_wr_tx_wait_no_pending_sends() to return early? This could all=
ow
subsequent DMA unmap operations to free memory while the hardware is still
transmitting the V2 message.

>  		return 1;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910104446.4142=
3-1-alibuda@linux.alibaba.com?part=3D1
