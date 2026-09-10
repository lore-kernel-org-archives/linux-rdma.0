Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5522C3C4176
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 08:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029496; cv=none; b=KyzzsW9U75ANmIYA0lPqKfwDJd3LhFjXrL0O+i9rS0qI+uHOD5GbCMukYWbGG3dKURWPhmIQtqtxoD289/x8tEnrB8FebOqJkvjYkz6oqVf4v6Im5UxxTOu6uLd2p6ktGcZNb70suovky7uGhL3aRN/1ZVgNzIRyT4KIlUQpFXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029496; c=relaxed/simple;
	bh=0D3wxIxSUM/9gPUmZrc0PYsPCO4Y37dsD73ryTUlmAY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ttN0WMrrDLdOBVb77TZpm7XJnJ8weNan4mzInIjnknk05DUHGdMg67Zd0S8iGlsmELW7/O0yT5qp8Sd94aJCQRa6T4XsVFC971GsfTvgI0QUoRFtOWr7L4iMBGiV+XfudSNhIQvZdW6W5vgetYFlzM4N2IB6cqBM8EtpnOM8Ss4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWLeYegS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWLeYegS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8FC1F00893;
	Thu, 10 Sep 2026 08:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789029492;
	bh=NP48wmWALxgG13Fj1ARHAjxbuvI0Gt+13c7X2GbriEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jWLeYegS6fSP5KUO6DLYeADRukBkSp0JK1uLIhYASBKjK/iaB8F5DgO1BLn/8X1ky
	 f4XkQQN4WO4E/RKCG10oueStzNvGZQanMKhDdGUXjQWJ9KHTWJvWpOuKD8Dz9kgSpK
	 yZyDi8Z0QCWF+J3r+oN5dsIsUdJBOQPfOMIx0QLd3I3Y1TGzlybCyOcxqzrhO0zYd5
	 G2hQmFSdEmXNOyyCa7fKsle6TDcYMflK0fOFxNVmIz2cpPCJ8PE2+nLKPDck8XA4EO
	 +UjL3rPzXGZ4WOEnn1CF+tR7HyZzLBWtDd5xsRdg4rcw1vvI/0EmsuRIIUY6tSuWKg
	 TLMgfgrZ6P7lw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] rds: ib: use rds_conn_drop() on protocol version
 mismatch
Reply-To: sashiko-reviews@lists.linux.dev
To: henrymei <ljp1205831794@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910083015.2695284-1-henrymei@tencent.com>
References: <20260910083015.2695284-1-henrymei@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:38:11 +0000
Message-Id: <20260910083812.3D8FC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Aohan Mei <henrymei@tencent.com>
>=20
> rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
> conn->c_cm_lock held.  When the peer negotiates a protocol version
> older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
> rds_conn_destroy(), which is only safe in the rmmod path: it
> synchronously tears the connection down and flush_work()es the
> shutdown work cp_down_w.
>=20
> That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
> the very lock the event handler still holds, so the flush never
> completes: the two workers wait on each other and the RDS connection
> workqueues stall for good.
>=20
> All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
> DISCONNECTED) use rds_conn_drop(), which marks the connection
> RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
> it here as well.
>=20
> Fixes: f147dd9ecabf ("RDS/IB: Disallow connections less than RDS 3.1")
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Assisted-by: CodeBuddy:Kimi-K3
> Reviewed-by: Allison Henderson <achender@kernel.org>
> Signed-off-by: Aohan Mei <henrymei@tencent.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910083015.2695=
284-1-henrymei@tencent.com?part=3D1

