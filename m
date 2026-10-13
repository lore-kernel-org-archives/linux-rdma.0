Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01377522695;
	Tue, 13 Oct 2026 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911588; cv=none; b=piWl3lx039p/0OwdFYgoIonbhsYh5FcrNxPIPc6GAsDdfEl6TiLxMvbWgNS65D5bk5vrVmb5mu5ldA8Jwz18GuVdDtAJ9thn3MIIOiYHIVPD0+6nq/hUXnA/DgBRr2Y+pNGWNaj3vDltfDhkKpZgQpE8XOq6zI5W0XfnToYHlno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911588; c=relaxed/simple;
	bh=xG/7/HfmonOV22Af1a0Cj6sHLtZxxJjdfDnawV8SIHs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gKiHQBFI3Erpz+uquNdJBnSo8XrUY769i6gYI0K+jFmGwfY2YasXLVdNYSc5GsePjm103+MNA54Fn+1WHgbSaIl+Kz6bKN8S/jSHQHICt5g+KW4XVqi/Gr0K272IuPWl8jlmtITq3CYESQFYGHR254DfJoVLcnyaL5Zke/5K4d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRmqcyPm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRmqcyPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1454F1F000FF;
	Tue, 13 Oct 2026 17:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791911586;
	bh=xG/7/HfmonOV22Af1a0Cj6sHLtZxxJjdfDnawV8SIHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aRmqcyPmx8r3MNXAIW/5F6d9Ts5mtqovBoH+GmENAtrKY8cRwKw5nR1ve4bo+uvd2
	 t+UrdLhYiqVm4MkXAPJyHlktjVYVlixpY7t6+IWKEUB3GkYUmMuws5tNYobEVpT4uY
	 WRa/BGp7gkc3l1u++XsXnQLbkReE0rqhf/HzgtMzWH84MMHh99WAuMEzPtnAIE3jET
	 HKlb8Po+aIGLrSeVvF5KiGPh0hf8TgRaFnyvSdAV9hIQEODQnlIh2nH+LO3bq8eveA
	 GSh+F2wvS79jbNDbI75I6by45vS2togNzjV4ZyqRBuZQUQLS8TSc4Q7lVSiq/Vr8Ii
	 0cfxw/7v+4STA==
Message-ID: <sashiko-outbox-170195@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 12/39] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-12-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-12-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 17:13:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> kernfs does.
>=20
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> check in sel_mmap_policy() cannot be reached. Remove it.
>=20
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>=20
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Acked-by: Paul Moore <paul@paul-moore.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D12

