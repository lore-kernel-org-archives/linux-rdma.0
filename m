Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821703;
	b=EOJz1rxmLrPQaZU2qIVxXOjnHNhXV9yFvU12HiJUkcyTkf46HSKiCCNaUvVEZ5ycV5OR
	 23DVFiB1EV0MijnMgNG69J9IDYSbT1Dwm/fMlyEE0FpuwWFHdtgZhrqWaQhXRk/5UGvOp
	 gB8CxiE3MNpe2X7/r1OqNDFIxu0PkyeHUnYHVy3BgWqE9YwTe5Mj4weSO2ESk2nvFI0h/
	 TerYDXX++600U4SUqXMfj35RajYahMNOvPPl1NUJUWd6GEMua04IbU0FPJ0odh3T2wgBD
	 t9IVHsOTDnGk+dpwDYo47BtFsXPkfB37CufohKcSKrrqYYOqkPbuMN9LslH2teom2Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821703;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Content-Type:
	 Content-Transfer-Encoding:Mime-Version:Subject:Message-Id:Date:To:
	 X-Mailer;
	bh=mWJ/MJNCwngKdrjjUT2OtUxYVLoeclNdMFGvzJi1Rl8=;
	b=XmBzc1fdP6MUYkQikmUroty5B/GdIMPaPsVhYJvOeA9PtHto4lOTZUiyGjpI5NQgiHJR
	 fuwyxiBM78Q/UYWbFXUU2F8OXNlFnert2+UP0uJMgWCVQK8Ww6r8b/UECUYBW7ak+ZRiR
	 etuMRAY4YWiRWqK6lS9x5h6WD58KLH+NqmPMoTNH7AD+YYfW3X7PSxb+cYp7UyLSS26yy
	 dzYS9CfV5Ec4HrZxYdbfXUBKe5TQDGUowFc0oSbbY1hj1l0F7XnMg7glA1DUfif6ipAHJ
	 5Wg7SvZJE6tGl7R6g3ModUnPG/CgZAv9N050j0//zDl3tCWZ1lGoWqvEbTP88MUnmog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="rArKN/I6";
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FB7606A846
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 19:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3FB7606A846
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rArKN/I6
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so13729195e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 11:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793821701; x=1794426501; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :content-type:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWJ/MJNCwngKdrjjUT2OtUxYVLoeclNdMFGvzJi1Rl8=;
        b=rArKN/I6bwLZgLyKK8MIR3daLjcII1ldgB+LfpdUDBON9Wr+Ke9wTk4cNsbd3BdVps
         Ej3WW+7a338nhnKYx7Iac6Q7hMKKxLGkzRESWUiXuZW/UboFXhIq79rOqQhU75aVu//q
         FLs3wH+ed44dAVomAM6mpjwN5fR3I+MQ7EkcKrC/efcqnS5OEG71CytZisj11EXD5D8I
         DFxTafg7rcE3AYnbBJ7CmghoxgZEBhFkV4qQl1Jz1xDHqigRbVBhuyjliv+UkVEfMTC2
         V4ifAjvoIPwK/4RfVjvi+FncvC+vdx7aaDVU+7TSw14ON8sv+ve9RbcidldXDEHP85ZI
         bbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793821701; x=1794426501;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :content-type:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mWJ/MJNCwngKdrjjUT2OtUxYVLoeclNdMFGvzJi1Rl8=;
        b=uSTHoEq4f5FsEIAktbknSNFRDSPKq4KSKevBBVS3qsW/DoQ3P1KLEfdxARxuHnJ2wq
         9uwzTSQJvJeFVmqGhuRpUlkLOxq0QOISVRlnXD57BZQOZ6PKy1v6UObWDtW7rLfMbQ9D
         FobhPiCf8pnhvMKOkl75eQf5QxyeGNwmKuk0OKQ0cUJwTuUSn4pD/Qj01JJ0OUWgqeyE
         I1ZOUMyHq2VyhoScI8mv2TsdmIenPEOnmhHY8BHar8eLhfqoe+KCF6FnyoMuyc0K4euW
         mp5Mied5r8Pv6cdfqNYFJCpX9YEfgsURGVjtgU8a5oCvKhNOuu2J9jm5saMFWPFo/ZxW
         CdnQ==
X-Gm-Message-State: APuU4Z9sfDzO/WeL/k4fo2qDfIYiPFc+uXElpmv7AhkbttFGuxbylRXw
	SMc0ySeI63cpuKOrmqSUmsztJyoK16BcvbzbEiZa27bJmge2bp5dSif4HFEe77Sg
X-Gm-Gg: AYBFou1YQoTTMSuraok9L3GJXHNwEY+mg6mDhCfQHK2gUYgUoFn2+0F18XmX0CkfaVJ
	GUrP91fyYmFIkRvnpq3IW5h2hyYEepY7/tIdGYkSxFbGAq3YXZeeN4VqqKbia2diSkOPsNIKsp+
	zfhrhy5d5nAZ8wKWCEvD8SJ0GOOAo3HxvextcJlnVfeCbwwQoLldEhbu2EuGZPUTHymtcl+Xmly
	cyEGKLOKXhtpMaKQ80WR2og79BOGloaXXYHs4g5WWnW5xlJ0k3MGXv7QIXACdgsBhMUpbZaL6sT
	1wgAPfp20a0I8H4j1MGJkiCG6FAMstZeKXgYza8ccHaSbs4sTMbfQO5N4gzKWDwqh/+RpHGMcJO
	x3jp/wx4Wde8SFA95ViQ+9KBYn0E+JzZxUl4N6UikuF3PyFjgQYvgal+nirphkjV8fypvLEoOw9
	pR43MjmQCOYAhZD7l/d29juQw/SlpH/gM/tyA7QuYq6eypILZJKWKJftP4dpxpkeSzAaSZYvMZS
	wL4QZLbe9qCA45wWqQZuEq3rE1VkzjbJ+YahkBkh03vP8IPS0Glyru1w4AK5P0QL7voMtK0l7px
	aQODK3FinUUEANqaK/+Cvh3HmaoLaNWI1CWFUWX+xcQ0nWJD7vDN4FyOQCuVye3l7AZq0pnVcUR
	Hf601ya9V2ThnqvY2yAiVmbT8wEt1C6pUwGhZi1CDlOZbBQ==
X-Received: by 2002:a05:600c:e48b:b0:4a1:d291:d863 with SMTP id 5b1f17b1804b1-4b55fe37606mr5433505e9.4.1793821701016;
        Wed, 04 Nov 2026 11:48:21 -0800 (PST)
Received: from smtpclient.apple (ipservice-092-209-235-033.092.209.pools.vodafone-ip.de. [92.209.235.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed08514fsm5424639f8f.31.2026.11.04.11.48.19
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 11:48:20 -0800 (PST)
From: Dezhen Lu <dinadegttyarenko6@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: tests: CUDA DMA-BUF resources leave exported descriptors open
Message-Id: <CC55B377-CDCB-4293-8644-602B54B28B18@gmail.com>
Date: Wed, 4 Nov 2026 20:48:09 +0100
To: linux-rdma@vger.kernel.org
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hello,

At rdma-core master a70151dfec390eb5f7fc5b266f51d601da2a7778,
the CUDA DMA-BUF test resources obtain an FD from
cuMemGetHandleForAddressRange but do not close it after registration.
This affects DmabufCudaRes, MRExDmabufCudaRes,
MRExDmabufDmaHCudaRes, and Mlx5DmabufCudaRes. It occurs on successful
registration and on failures or skips after the FD is obtained. The
integer FD passed to the pyverbs MR constructor is caller-owned.

The following uses a real process FD and a mocked constructor to
exercise the first resource method without requiring a CUDA GPU or RDMA
device. Run it from a checkout with an in-place pyverbs build:

```sh
PYTHONPATH=3Dbuild/python:tests python3 - <<'PY'
import errno
import os
import sys
from types import SimpleNamespace
from unittest.mock import patch

sys.path.append(sys.path.pop(0))  # Prefer the built pyverbs over the =
source directory.
import tests.test_cuda_dmabuf as test

fd =3D os.open('/dev/null', os.O_RDONLY)
res =3D SimpleNamespace(pd=3Dobject(), msg_size=3D64, mr_access=3D1,
                      dmabuf_cuda_init=3Dlambda: fd)
try:
    with patch.object(test, 'DmaBufMR', return_value=3Dobject()):
        test.DmabufCudaRes.create_mr(res)
    try:
        os.fstat(fd)
    except OSError as exc:
        if exc.errno !=3D errno.EBADF:
            raise
        print('descriptor closed')
    else:
        print('descriptor still open')
finally:
    try:
        os.close(fd)
    except OSError as exc:
        if exc.errno !=3D errno.EBADF:
            raise
PY
```

Observed: descriptor still open. Expected: descriptor closed after
registration returns, including on error. A proposed fix closes it in a
finally block around registration and, for the DMAHandle path, around
handle creation as well. On Linux the RDMA DMA-BUF registration path
acquires its own buffer reference.

I reproduced the behavior on Linux aarch64 with Python 3.12 and a local
rdma-core/pyverbs build. Mock-based FD tests cover the four registration
methods, unsupported and error paths, and DMAHandle creation failure;
they fail on the base and pass with the fix. No CUDA or RDMA traffic was
run for this comparison.

