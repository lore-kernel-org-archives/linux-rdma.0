Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226419;
	b=ftXjqfeZJQva9IU2h2Z0B88IIcnlY3Dp3GIfbfhKcHCtNnvVQ9s4MER7tHEOEKu55cIb
	 g06+1xrhoADpc0YRLjNdxSgamOKjgwp75IoW6u71bUAa4JUZi1GDcmsSeQgh/NqIhPw80
	 cg9zpMoovr1FVx4wkTMt9QPVp+9DtZdH7dVhGn00tQAkOdGkCjZMjJPn0e7IyM5ePAUHR
	 cCimcTqL9Glc43lbb3VmWs/e1SwxRoxIUYQuJ+uIfsPXaszPvBDrIsmzkz7sDuCudxWvi
	 U3NQ6RoIEGUW6jv/Sn9gyVNhRKyPNevuRfcazjI1IQBF0xHnN54j93TvHgEFEbOUuXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226419;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yhPy2cl7PuMX/W3+q6ydDHHoA5VZJBDxPGD3CWUBeL0=;
	b=Y4agyw4UXEOsc0bDmbMuDGEtBsckyxTueZE7Bb6E5nY517Csu0RijMFeRII93ICkYMHe
	 eNfuiCT9Rpul0w5Rwy4eItReXIRhM9nEkqD8Ez6UDsXTz3gA57IEUpoifaWbCX0lXNlVh
	 Eqf8Y9BbiEWc652ki7ZBEOBlLjL5uqj9E3tXyJ5y/mRf/pORSpcgyfMb7ttRwEP2kqWVk
	 ue7oL4Eg23XRbGPYgvSBFWlTosyCjmkG7DQC3mVr1oKsuv2m94nomTRUU6IZtcIUDwWRs
	 MEByqjLtQm3ZhmCryfbsNBHbM0a+7AMwvhzZi7jpgh147l+M6/QOoDGATl/Rvk9vAsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T7FN4Ai6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64972606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T7FN4Ai6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEFB1F0089F;
	Mon,  9 Nov 2026 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794226419;
	bh=yhPy2cl7PuMX/W3+q6ydDHHoA5VZJBDxPGD3CWUBeL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T7FN4Ai6V6Zy66Zzgz77vW+4xcDcgwtFZc1uXpFraUkONm2uI6X9zlYiLEiornIXe
	 Dmyx/B03n8gKYrcf/U67FzisUdNx2ZOgZvu3KouIN7U9vVsOq75OSt3+G+Z058MV9Y
	 fJlunMYnpxXVPzzLBtL7yejX6DGKvEK2+VidjLumxyMwf9HbY0eDev/lKDe+dKtYQP
	 5+jKao4tQQVB+zyX5hqxkS94gPAmkFw8Tc9jUVPtiT17c3l/rf3oV4rrsKbo8PgjEm
	 S6/+uPb4NUToPWURpa+ztdep+K7jNpqkVgK79SxVCrM9Bd4A54Sws2KBbdqHvX6bky
	 +iDamOMre+PoA==
Date: Mon, 9 Nov 2026 14:13:34 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Dezhen Lu <dinadegttyarenko6@gmail.com>
Cc: linux-rdma@vger.kernel.org
Subject: Re: tests: CUDA DMA-BUF resources leave exported descriptors open
Message-ID: <20261109121334.GE8635@unreal>
References: <CC55B377-CDCB-4293-8644-602B54B28B18@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC55B377-CDCB-4293-8644-602B54B28B18@gmail.com>

On Wed, Nov 04, 2026 at 08:48:09PM +0100, Dezhen Lu wrote:
> Hello,
> 
> At rdma-core master a70151dfec390eb5f7fc5b266f51d601da2a7778,
> the CUDA DMA-BUF test resources obtain an FD from
> cuMemGetHandleForAddressRange but do not close it after registration.
> This affects DmabufCudaRes, MRExDmabufCudaRes,
> MRExDmabufDmaHCudaRes, and Mlx5DmabufCudaRes. It occurs on successful
> registration and on failures or skips after the FD is obtained. The
> integer FD passed to the pyverbs MR constructor is caller-owned.
> 
> The following uses a real process FD and a mocked constructor to
> exercise the first resource method without requiring a CUDA GPU or RDMA
> device. Run it from a checkout with an in-place pyverbs build:
> 
> ```sh
> PYTHONPATH=build/python:tests python3 - <<'PY'
> import errno
> import os
> import sys
> from types import SimpleNamespace
> from unittest.mock import patch
> 
> sys.path.append(sys.path.pop(0))  # Prefer the built pyverbs over the source directory.
> import tests.test_cuda_dmabuf as test
> 
> fd = os.open('/dev/null', os.O_RDONLY)
> res = SimpleNamespace(pd=object(), msg_size=64, mr_access=1,
>                       dmabuf_cuda_init=lambda: fd)
> try:
>     with patch.object(test, 'DmaBufMR', return_value=object()):
>         test.DmabufCudaRes.create_mr(res)
>     try:
>         os.fstat(fd)
>     except OSError as exc:
>         if exc.errno != errno.EBADF:
>             raise
>         print('descriptor closed')
>     else:
>         print('descriptor still open')
> finally:
>     try:
>         os.close(fd)
>     except OSError as exc:
>         if exc.errno != errno.EBADF:
>             raise
> PY
> ```
> 
> Observed: descriptor still open. Expected: descriptor closed after
> registration returns, including on error. A proposed fix closes it in a
> finally block around registration and, for the DMAHandle path, around
> handle creation as well. On Linux the RDMA DMA-BUF registration path
> acquires its own buffer reference.

Please open PR against rdma-core with your fix for both test reports.

Thanks
