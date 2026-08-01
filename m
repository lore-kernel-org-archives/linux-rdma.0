Received: from mail-lr2-f11.google.com (mail-lr2-f11.google.com [74.125.230.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD205384250
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785597983; cv=pass; b=WT/0OModDiWAKxK87LLgboKSYmLNVfHOBbabmhTzs/0owTE8t+t34ChQbXKcy4bYbVc/Wp3VIooZISQ1/LZHLNRjDmHZxOjAndSJ2FSTHOiE5PdsgeXNQctIIBSmw6VncbWUEhnxN8nKcNEDnAyTPCsAkBnktEwflgZ83x+wwn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785597983; c=relaxed/simple;
	bh=LIm2UyU4SrOpIYuSjgJwV8W2ImsnrSdSD9P/2U28RPc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=f8a8WbVRW4rYYCEfIDGVlnV5XvjbjXezuuiZRaScu/nABa2+0nXRb+J/K3AadrQyJcpjQAs/kXbvWyT2lukYVE1KPohvtwCJibHN83iSsluchCi3SglP036lYIj1HwyoyeOZtqTDtYzxgQdlG9mAOUj3oLvMGQngGeGbF77KoiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oDOCVIv2; arc=pass smtp.client-ip=74.125.230.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oDOCVIv2"
Received: by mail-lr2-f11.google.com with SMTP id 38308e7fff4ca-39c6d9f787eso10830441fa.0
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 08:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785597980; cv=none;
        d=google.com; s=arc-20260327;
        b=bB/ZfgAw4jKuE22sHI3oBHsAsqD6EzzSQ1jni57lUSt9Apwf+ppSWcCuVvq2AF3XNq
         ygPgG4Wkbmzz1x6vAyvqPJ0WCJwwF4LA4NXkdv0+GJR9To6M1mI0lEeJdRDOGR6G7vlA
         kRjgqeanGHzacGqGOAIiXGBR7QeDJSCK/NDH+U3p29TcHCf7Xsqb3/tfeV+zhLwAegQu
         EsIcXsd+/EaBR60MM6a6Cmz6tiodb4sRPUH9lWUA3RpHZspCny2ztcQ8RPETYtrTSCCO
         VY4AImSunYlI5/mslvpDt1UjVCt1dwLZnGYKqCEDYTszlpMbH0XyVJTC8LBc/L/+VJTx
         EtCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LIm2UyU4SrOpIYuSjgJwV8W2ImsnrSdSD9P/2U28RPc=;
        fh=kKD4ZcK7EiBbpPvy8fBui+gbh4y+MCKzWSOkLnEd924=;
        b=NQfnFPlVN27JFhQIZkWv9rHV/kONnZH9V0On+agIw0v9IuYp3VfCjiJTVW53u/iSCp
         Ecd1pBzXI/KETsQg6lWP5t4EO8+kX4Q7XhUkBPEuVmtpxDk03bcGvhaPsE8IRwED3ceB
         51I67AZHzAGKwLMP7VxE5l+8XLp4gIc4Qe6MmmpzTQTqQ04lAx4CIIiF8PcUduN1H/jp
         DbDXnYK3zbAA0ElYwgcl4xLEHnDATo9xIpZ10kIqc7PN02te4nAobEsiBnmavx5/WQDf
         twjxoJi4c5t3bP8vcY+8NIZEs0TTTconYvLWEmaciSBEaVTzXT4bCxN4b7wfvc9SM7Qy
         CVmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785597980; x=1786202780; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LIm2UyU4SrOpIYuSjgJwV8W2ImsnrSdSD9P/2U28RPc=;
        b=oDOCVIv2kotV0B5g6KQg3BO4vRrGX+PBg4RyiE7+E7iC69/UDFikAd9zGJSU1ABkCq
         CnShXEuNUb8T/JCOlp+jofNKwOfwEVWPZsPq6+dmIgrriz3yCpFwbtgWp435Jrf4a8yR
         JRWpo+ExyZ77bYmxeZfHfBU8E51SLmp+ZpyvjgaGtXnwS3nTQvOf8DvHwbRj8A95MZLt
         SxsZCmRryEpqFQ6QezJ9uvaVZlhyyaV3YuscANCNb3pXpQIREIBLkpgAuCm0988/DdZL
         DlT1huKtqYwUyudFtYJjZDzIyZvRRj3Sdt/rWMEh4N1Ip74+zPFPkrQP2awdF+kV9YkN
         Bryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785597980; x=1786202780;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LIm2UyU4SrOpIYuSjgJwV8W2ImsnrSdSD9P/2U28RPc=;
        b=Aezrcnm1O0zBSJV242d8DmK7Zv3KtdvL5fagDn3qvAAsz2nSSw1gLPmRURd1xNI69o
         E6cQLmQiD+koM3CrEYQUplsALxT37/oP6APj4Ckj3oJ5NSoVzxNKoBnzb9sEtlqgCzD2
         9B40cT+dA8zufJD4FiYLUPS9n5Zrmk1sPwD8nks2qrAMK3ZLFZbW6Apth/JlQpYIuc2b
         3S0Jkw6ld7GZQTCF1C67P7Otxvqm6ZD71wUn/AWWcCA1zT3Wca0ntPLncppdZI9CTYSJ
         no41rBykMP5ucZAW0fs31wzMx7gp8IFkt6C3N5ASc8cCjbrpj//XGaDj5NYo4yqKTRl7
         0ARA==
X-Gm-Message-State: AOJu0YysVi5395tyDeUNtUXgBOtwkL2AF/+9RWUcFOm4k5TbzEEIPX1V
	1MiIaNAHp4wRgBAmMfzK4Nw49YG9jnq2pSJjTa4/5hrzwXCbPJfszC/NOiSCjqNeSiLUjHIIv2I
	JYj2sYsN6Ll5hw7zdv8SAx79rdFLGwljMbl4v
X-Gm-Gg: AR+sD11sDN09n1lBsbkWLdMxHF8f2aT14XpwWEB2gTScaHf8QW/LPoME+8jdCbrtIfA
	UbP0syJeyfzIhfd97+nJFAxG0skY3bkTiwDtItYU/GkAaXjJi8GhGFpXQBwtLp7Szv8Rqkkbv+P
	29cyUf/JRNKtJnFzEV+WarZIBHAjfSANwiG/MwJjzcwHg0tro9xNGBX7FZtvhTj4+Ss2GlV5iNl
	ObdAQm8ZVuvJe6CqdAQbymFWdUALq+krQZDX18gwZdhwaagP4EivGzdIc+goLRotMA7jaddOGSZ
	T2JTLTt16S+Z/4/VFuag/IJ6Uy8nGlUV+qe5XhNTUYD9jKSKbjMeaX73wgB0VkKVJUwoxKzNwQI
	zPCsHqsvG+njcujl44+9NWThX+Q==
X-Received: by 2002:ac2:46cf:0:b0:5b2:9a03:aa4d with SMTP id
 2adb3069b0e04-5b2e4fa008bmr464535e87.61.1785597979555; Sat, 01 Aug 2026
 08:26:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: alu a <alu021031@gmail.com>
Date: Sat, 1 Aug 2026 23:26:07 +0800
X-Gm-Features: AUfX_mwwViPJq6mezwNzefAT66_S4xmqoUyMPTfGRqiIK4FHmtCjt69C44WcNtQ
Message-ID: <CAH+L_5ZuiRrx0J9u8aZ9N8YZDkC7uyQb=F+QZEFZ6ZqMF=sbkA@mail.gmail.com>
Subject: [BUG?] siw: RDMA Read Request QN/MO are not validated
To: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Resending in plain text because the previous copy was rejected by the
mailing list.

RFC 5040 Section 7.2 requires all Untagged DDP Segment fields of an
incoming RDMA Read Request to be validated. Section 5.2.1 fixes the
RREQ Queue Number at 1, and RFC 5041 Section 4.3 requires the first
segment's Message Offset to be zero.

On Linux master commit 8ba098e6b6ff0db8edf28528d1552be261af30d4:

- siw_proc_rreq() only checks that no bytes remain after the fixed
request header:
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L627-L638

- siw_init_rresp() validates ddp_msn, but does not read or compare
ddp_qn or ddp_mo before constructing the Read Response:
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L656-L730

For comparison, siw_send_check_ntoh() explicitly validates QN, MSN,
and MO for incoming Send messages:
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L277-L327

Based on static source analysis, an RREQ with ddp_qn != 1, or a
first/only segment with ddp_mo != 0, appears to reach response
construction rather than cause an Invalid QN / Invalid MO Terminate.

I have not reproduced this at packet level. Is there another
validation path I missed, or should an RREQ-specific check analogous
to siw_send_check_ntoh() be added?

References:
https://www.rfc-editor.org/rfc/rfc5040.html#section-7.2
https://www.rfc-editor.org/rfc/rfc5040.html#section-5.2.1
https://www.rfc-editor.org/rfc/rfc5041.html#section-4.3

This finding came from an academic source-level RFC consistency review.

Best regards
