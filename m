Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F41D5CC9
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790042240; cv=none; b=hqWf2rKV5lZtMGbiMLZ3DzWxju/6HYxc7JhEsBgiEACrWQtlEqVj1pFEDjfGtW8/m7O1itDOf+0hgRrV+GGJtDC20Tfavy6tNiJ8s1rWkVbwUN3d1LYZRRlnze2hv81U/Tws3wYSIPLjamRNqBhmPUVYMY4khLvy30NkJp87+1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790042240; c=relaxed/simple;
	bh=HD3y914/ovRR6oOTlsaA2FO7LkRmB/tos8zcy52UNx8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RiiOjs2lE4UpETEqrZeS1U50s/NFhz3xHZ8/XTFWMvsdhsHNCIJPO7DMIMc+29rWL7gjShI61EmCWctEo498YG4yz9K5kro1EIpqoItNv9O3HGAexWu6C4/dcrSg3+O+nduiS6eaS88+JEu1O3ZUd4eRFExI8rftG6VNPKbwApU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V965y9vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V965y9vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1651F000FF;
	Tue, 22 Sep 2026 01:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790042238;
	bh=HD3y914/ovRR6oOTlsaA2FO7LkRmB/tos8zcy52UNx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V965y9vr8ziNOmNbbGjU+ka8o+zXIrbSRIAvuPjktABHLkYkTvNXz+f6I6Z42RODn
	 xvO53AaEw5BVTrWci0EyXltqgC3lka+h6/042O8vTzCQbeWNvzosNriD9LbyL/qBeb
	 Ru/ThznhfjPokO2wqvER3k4GkOFFkUnBAgR5CXz84KHdBZLn4kzfQnCwCEeRPWPjLE
	 SU6MNRCslYhMrp+599PqNhgDFZBmsVS2MogylyS2BEEqfdJD4dA8yk18xRj5BiGzJh
	 9bDhsZta5sXeQlJNaiBNf2uAfa968EDSNhoulLoDGtcr26GZTpgewZWeX8MhsnQrex
	 4V6NmDt+bsksQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/5] SUNRPC: fire svc_defer_queue tracepoint before
 publishing the request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20260922015128.240977-2-cel@kernel.org>
References: <20260922015128.240977-1-cel@kernel.org>
 <20260922015128.240977-2-cel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:57:17 +0000
Message-Id: <20260922015718.2D1651F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> svc_revisit() adds the deferred request to xpt_deferred, drops
> xpt_lock, and then fires trace_svc_defer_queue(), which reads the
> request's XID and source address. Once the request is on the list,
> an nfsd thread already servicing that transport can dequeue it in
> svc_deferred_dequeue(), process it, and free it in
> svc_xprt_release() before the tracepoint reads it. The window is
> narrow, but nothing keeps the request alive across it.
>=20
> Fire the tracepoint before the list_add(), while svc_revisit()
> still owns the request.
>=20
> Fixes: 8954c5c212d3 ("SUNRPC: Clean up request deferral tracepoints")
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922015128.2409=
77-1-cel@kernel.org?part=3D2

