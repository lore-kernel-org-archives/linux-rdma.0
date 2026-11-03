Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793708105;
	b=To17ezh62GeGRC+y/GujRNgPL5c3q8Q/SvtEDj5U1fQTMW23WzTcSlH0Knj/MAdG8mgc
	 908Pxro6WrUbR1lbrUSfLSycuUTR4tOXT8cR3DfuR/eV29NMB+k824dIXeg5Zn/1lGIex
	 qAqfqlqGViYCKJtje9JKCfGhErmecFf1yMe/RWHuVk70z5xyDNjbodHeJlo+LPvFC3+v3
	 shrvzKzpdKKKvkikqdY5wgjNaqoqhfUgkBe17+oxJjg2hqOnQii3TO9LE4Yz+S/icO0MF
	 tGZbHoPQ4hE46syQPdXPdw1vWg4SbjSZPCfgvZ85U8kyT1pE2/ncRrCCbA6Vg9wm0EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793708105;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=YPuUVtDGgigWI04eSSxvP43obSKXgU81OUIabuAn5sw=;
	b=f1JUH8Bdy+gAjEUiQRYW/00l2Q4fWAkEi3Mmn1DOJeJlUSQl3zlq/spSp+Hu+bdGjKxt
	 XD1rTLKGwPk56793UcmE6151y1Pp8/NPAVzXFQFimZa3BkUKsWf8PmpUnWBgzUTLVtTu8
	 GFtxB0ccF/m7at3A+VihtV2P9NREYJU9djAZ74DmQi1+ICuwr38jw8xGcBCm3f5LX+HVT
	 KtskCAkcB+aM6Ii8hk6G8wgIUkDUI7G+uQ1NDpx5UzTsgAKWBU92l+2+jKPHDmcjX2PRI
	 scpS3SG+0MF4BOD8Iwiw4WPayhUYcwansXKiw6rfFY8GJC8jDJ/onzp5pJmRyntZVOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="V8/v3eCx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9323606A32E
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V8/v3eCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D412A1F000C1;
	Tue,  3 Nov 2026 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793708104;
	bh=YPuUVtDGgigWI04eSSxvP43obSKXgU81OUIabuAn5sw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=V8/v3eCxQXvaliqN/7O/8qYtNrTKJXIIH/7cuQocMBQMfIQhP9cEvpX5vhVnbUkn5
	 zu+KFUCDu9z7LhgJXplpsbxrelrL78/jgOE9u5KuMuFHFVj5yXGqLbDHloLYkjvXw3
	 5MOdeujir7Q60KXhpldZPM6FnptCs7fO7ueMnzy5o9RuWvT+vjUkxUjXcaDiSiD6g5
	 oE7a62qGv9Igzm1hl6QIStgE/FQyHUDoT/9myKr/gFAH2EmkvnAyvsr2sXVEuGzOTZ
	 aVOmu2M+6vI7k7/MpnA2lQkb41OPbO0gHM6jOOkNPk/jntuXlyPnJvBrmK09pC3ys5
	 zznnUzrLf5P6Q==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261022210650.1182000-1-jmoroni@google.com>
References: <20261022210650.1182000-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 0/2] RDMA/irdma: Fix FRWR and PBLE handling
 for PAGE_SIZE > 4K
Message-Id: <179370810170.1720786.3422648734982367754.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 07:15:01 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 22 Oct 2026 21:06:48 +0000, Jacob Moroni wrote:
> The irdma HW only supports 4K and 2M pages (plus 1G on newer HW), but
> parts of the driver assumed PAGE_SIZE == 4K. On kernels with a larger
> PAGE_SIZE (like arm64 with 64K pages), this resulted in a few issues:
> 
>   - FRWRs from ULPs that pass PAGE_SIZE to ib_map_mr_sg() end up
>     getting mistranslated by the HW (discovered by observing SMMU
>     faults).
>   - Paged PBLE chunks and the virtual AEQ PBL point to the wrong
>     offsets compared to what the driver assumed.
> 
> [...]

Applied, thanks!

[1/2] RDMA/irdma: Fix FRWR logic for PAGE_SIZE > 4K
      https://git.kernel.org/rdma/rdma/c/d706625c62b451
[2/2] RDMA/irdma: Fix paged PBLE and virtual AEQ for PAGE_SIZE > 4K
      https://git.kernel.org/rdma/rdma/c/cefc2270e42bae

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

