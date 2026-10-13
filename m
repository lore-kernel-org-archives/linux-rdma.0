Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE73F476CF1;
	Tue, 13 Oct 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912792; cv=none; b=qxaMkHteg0kaz2Sq0AJwicMtVi48rS9vfH8KN0ojXRHIn44y7SMTZHlo+Ebuerq4ygkPqmhvhWM1b7wrJLHxlWHEYr8aRFzfBmInOkeuMsH8PHpHpH8kyXzPh3z/flq8UWLCz85ZIjgy475ucmdv1G7lWs0Zr5PkwXhWwPrtqcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912792; c=relaxed/simple;
	bh=JxBEmlqmo0SFZ6BrL4KxJFrWSAGDjEPKXHuQE8sFSxw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fAKYhTL9qEDHBil1trPwNX4Y8l9FzFvlPJuAgVCl/xmj293lzSH7XwLARBkwuY6fTnq0YGYk6RHmGPQhEq3kY/24RaLIAolaP8Cet2R4pBbvXmdKqeqKBi+AOS6j/5Zn9toCLnavglgnAt3iOAc40YPheuMl5lIm+K9KY+vIvR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Se9AUxO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Se9AUxO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473631F000FF;
	Tue, 13 Oct 2026 17:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791912791;
	bh=JxBEmlqmo0SFZ6BrL4KxJFrWSAGDjEPKXHuQE8sFSxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Se9AUxO5eY6Vv+WVzaPupe+gs++Esq3HeCYTZTp5Zh97WqhllkG/1eR34yjkEfdHR
	 jfzQa6D5croh4Mk68Q1Su4Ge3iWwoJar9L++6wq3Sq/Zv8Cpv1gFtTOEJIfEhopIS7
	 /H6CV+kd3yKmORsTigmX2N9smqc5KBdSezimu4p13JWfghKdHODFPbtQVMoA0Nijxo
	 +BRD98zuaLmEBjPTqplOlx9YpoF303OKuYyw3/ftPvtw1dxBehbaappWYOmnrxX825
	 m7YbJh5hdtI5UbDDDzL1j9SH45raE8bHyS6tnnKmEk3d2aDIPGR9ow0JsbZKnIw40d
	 B7Dw3z8sKzz6Q==
Message-ID: <sashiko-outbox-170235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/39] ALSA: pcm: use vm_insert_page() to map PCM
 status page
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-13-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-13-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 17:33:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> There's no need to keep a fault handler around for this, instead map on
> mmap.
>=20
> While we're here, rename area to vma to be consistent.
>=20
> This correctly makes the mapping a mixed map mapping.
>=20
> This works towards establishing the invariant that only PFN mapped or mix=
ed
> map mappings may clear the VM_MAYWRITE flag. The status page mapping clea=
rs
> VM_MAYWRITE, so it must not be mm-managed; the control page mapping remai=
ns
> writable and is left fault-based.
>=20
> The assumption is made that the struct pcm_mmap_status structure is at mo=
st
> a page in size, which is asserted as a build bug.
>=20
> This is safe to assume, as the size of the structure is 56 bytes at most.
>=20
> Acked-by: Takashi Iwai <tiwai@suse.de>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D13

