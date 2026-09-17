Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C7E175A79
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789647422; cv=none; b=H3UX5qW/OCETgDFuuVj9eV/cTN3ufkHZ9UI6b1zFOaRYiWyUR0QF3vkNfrMlNTvzpT+6uPejnmjwMZYKPIfP2/Bf0DUvgWd4MAVYg2MLENcWcyGTBVKqnPoaQClkSNZaeT+8jGWfwJvbFc5vGAWPEtuSy1BAuFC/fxi2Ww5Nd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789647422; c=relaxed/simple;
	bh=xAIEhWU667Ik6DIXEqOj++rKhoStMFJ5ESb60cc5LQk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WXYRH7Fr21HXfbGGpuIiX79cKHdViA92tAY/aEfkcJFfCmdCvDz7OnPiouxgcD/rXXGjYZo9f1eJgU1+Q9yZDHMjo2jstMrzkrTz0fo3nXJL6xb0EhRDCvRaIG9jR/zgDaqcbAjzwTMnSZS8vE1aGLDjxymumx+2fJ4mUGzBml8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqOTqXnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqOTqXnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1681F000FF;
	Thu, 17 Sep 2026 12:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647411;
	bh=xAIEhWU667Ik6DIXEqOj++rKhoStMFJ5ESb60cc5LQk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fqOTqXnpFD/B4bHmCmNe6WUII6P5jKkUsIKaXr/w1egPGdEGdKvHRcph0ME1/TJbI
	 jN2Cg3asDIkuk14KpOxVHW+WjwRF0jLm0KeQ1yF77pBVPqx77mlLa2gNDanWOd4+NN
	 3+VhBVz+jPzaWVhjKWvvKR2zo3ZHMfDeOBqCdKbdbA30CDV/UZ1qF2u9NYRWE3tOoh
	 iRFE5Z8m+z87ZJ3RHTnViCvxXAQiRsZ1Uvlw38a96Od9JT50naYPtLdfkFDoI9P7ce
	 nzg1MR26g8F1S5/PPn/I5WPSIFklPIMoHofqF2jJH1Ce74pzvE6Q0ASwYbW5Wl/woq
	 fS0CJl7CPBSYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v4 2/5] RDMA/erdma: Support non-contiguous
 kernel QP buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917120459.13286-3-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
 <20260917120459.13286-3-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:16:50 +0000
Message-Id: <20260917121651.6A1681F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A single coherent allocation for kernel QP queues can fail for large
> queues when memory is fragmented.
>=20
> Allocate page-sized coherent buffers and describe them with the existing
> MTT. Keep the userspace QP path unchanged.
>=20
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917120459.1328=
6-1-chengyou@linux.alibaba.com?part=3D2

