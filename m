Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F28A214A84
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791225824; cv=none; b=s8j7fPbeN5c51jVCvOL759lwtH7jezCmMERzQfJNJrij2E0dg1E7AKSaA4UwaChqnzRxW3G65fmjuZe+gVP5fOotjKX+tXbwc7Es3wwDbifxysjeUOa2g1dUHo5gFNYfchqjO6KWLurvNgcPyyThmIAVED64rEa3Tz0brnL4DmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791225824; c=relaxed/simple;
	bh=2tN84x4G3STPvjx/iRRdg6aXMi4NKdSfO1zPW470k8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m4i3ActvoYOmxOlPyaTJISnRr7KDi7tHnH64g8HDLoBuFxO9tm4bFgLbU36v1VI+mgYxznCSNDbvOFIsz2lgrHqark93SLir1kIEWxzHNtDYdR/ek8GYcyT5oIQ/oEfsOj+9CIabYIrndpwmBiguoklLiYlQX0BQpjumT5Jlgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCfpR78Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCfpR78Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14F41F000FF;
	Mon,  5 Oct 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791225823;
	bh=2tN84x4G3STPvjx/iRRdg6aXMi4NKdSfO1zPW470k8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NCfpR78ZmekhmpJlCxYCzdIqqtqk9JFYGLTga7EmrUKLjDUIqPa2P8N0jHKGZCa3+
	 WgK0iKI1WfWuqTpyo3f8CC6IyzOA+9qQABM43DSm9sBjCsQ/8ZvE4J3CzR1ZQi6RZJ
	 G/aoMStfDb3A/puZsFh4/izE1OBJ1nRvUeXpEPcMJd7C2w21ggvEZZNQvECfFTBx0U
	 2GMiOnqXU8F30FRb+0bANXBuQtoT+/cVLwzF6ibyBqaTjiGG/oC/D+lFJAYlZg78UW
	 Fb+QCjWX9mbHKrwnnKNMWPLx3XVU5ekZXfHh596siKzC3UrDTR7uLnUt7my5sVif3X
	 io5GMz9fNIDBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] smb: smbdirect: don't wait for
 RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stefan Metzmacher" <metze@samba.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791224972.git.metze@samba.org>
References: <cover.1791224972.git.metze@samba.org>
 <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791224972.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 18:43:42 +0000
Message-Id: <20261005184342.D14F41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smbdirect_socket_destroy_sync() waited for RDMA_CM_EVENT_DISCONNECTED
> after smbdirect_socket_cleanup_work() called rdma_disconnect(). That
> can take very long, e.g. if the peer just disappeared, until the
> rdma cm gives up, or forever if the event already happened, but the
> status was overwritten afterwards.
>=20
> This is not needed: smbdirect_socket_destroy() drains the qp under
> rdma_lock_handler(), destroys it and calls rdma_destroy_id(), which
> only waits for a currently running event handler and makes sure no
> further events are delivered. The rest of the disconnect protocol
> (DREQ/DREP and timewait for IB, abrupt close for iWarp) is handled
> by the rdma core asynchronously. drivers/nvme/host/rdma.c also just
> calls rdma_disconnect() and ib_drain_qp() before rdma_destroy_id().
>=20
> So smbdirect_socket_destroy() now also accepts
> [ ... ]
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: linux-rdma@vger.kernel.org
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Stefan Metzmacher <metze@samba.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791224972.gi=
t.metze@samba.org?part=3D1

