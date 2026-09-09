Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92BE2C237E
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943363; cv=none; b=kji3HGZKv7B18NZWxLeYJKji25QFfttCdcPZBu45n9T1CKjEGL6g3OlHJigNcZiP8VtL+NiNUd2S7xANtuS9LnHFkiFhHmi/MQ0if+B7IK2575w8nE04dGiyby0fcsL86TKVU8oG6v3fLXR1Wm6am3xaSl4HhDC1lYdrW0ACTng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943363; c=relaxed/simple;
	bh=sR+e22bImaxnE7j0rISI+qGvmPeQl3FIGoSjJEyJCEs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uXwAPQNf9qK+peQw+JM1ubSZlSbkLHjvAgLhaCOWDR0vO+kqNymt6lYlAk3qUK3NbOfwu86kS7i294z2WoTHTRgXER636SUa2dGYEBkWAHg5D56/HhdHQtuOAWywtJjIRWrgcLA5qwuNfPuf3ncjCVF80pmdr620d4BiGWFNN9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yw0C+9cz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yw0C+9cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570431F00A3A;
	Wed,  9 Sep 2026 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788943361;
	bh=CvDVuTdbFLwijrqYtNN9cjrDz1wUE4d+06H43pNo/dw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yw0C+9czUFgeJHU3CzLN+X1zKLwkF9Q83VytHSP8sVOVKvH7A3r3SMWABNEUMKhOT
	 GrMF6lcbc/HDsXlcjsou+V61U65z/OAdmXkQIaSm7b4lFgkiFW1qmgUVfh4DPwhTrb
	 ZcEp3a9BJJttM5/i73RwYkjBIW03PA1Q9tk74qDrhFzKHi+PQEfoO+FWlJvKBtXv+D
	 ePX5A3XrxIJIdn7/dQarb8AdTA4MEQUv8qeCHBGRre0KV9+Af6vjD1jEn8DpyLU1nE
	 UZ+h44rCFyzGFN/mXQOWhx9XF7MZcueCVl/slojC7x4+D7gc4OTZ9W6p9dVu2ZnGRL
	 tWqJXaNgqlxzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 1/8] RDMA/bnxt_re: Reject executable mappings
 of the DBR and toggle pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-1-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 08:42:40 +0000
Message-Id: <20260909084241.570431F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch rejects VM_EXEC to prevent executable mappings of the =
DBR and toggle pages, but fails to clear VM_MAYEXEC. This allows userspace =
to bypass the restriction via mprotect().
--

commit b5ba6f660e81b67fecc55a7c6ceae5f0724ddc0a
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Reject executable mappings of the DBR and toggle pages

This commit updates bnxt_re_mmap() to reject VM_EXEC mappings for DBR and
toggle pages, returning -EPERM instead of -EFAULT. It is intended to prevent
userspace from mapping these pages as executable.

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index ccd2702db78b5..d80a22e4ac70d 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -5057,9 +5057,9 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struc=
t vm_area_struct *vma)
>  		break;
>  	case BNXT_RE_MMAP_DBR_PAGE:
>  	case BNXT_RE_MMAP_TOGGLE_PAGE:
> -		/* Driver doesn't expect write access for user space */
> -		if (vma->vm_flags & VM_WRITE) {
> -			ret =3D -EFAULT;
> +		/* Driver doesn't expect write and exec access for user space */
> +		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> +			ret =3D -EPERM;
>  		} else {
>  			vm_flags_clear(vma, VM_MAYWRITE);

[Severity: Medium]
Does this code also need to clear VM_MAYEXEC? While the patch correctly
rejects an initial mapping with PROT_EXEC, failing to clear VM_MAYEXEC allo=
ws
userspace to bypass the restriction by calling mprotect() with PROT_EXEC
after the mmap() succeeds.

>  			ret =3D vm_insert_page(vma, vma->vm_start,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D1
