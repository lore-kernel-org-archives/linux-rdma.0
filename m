Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0BE403E9B
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270254; cv=none; b=Z8yYmcUvZZFt/ZEP/zSFOy6gBbQBLJb4A6lvoXs12+1Fcd2Qz11UF1DCluRlDkVW9i0y+J+CL0P7appeHQugu9BqMN8G71fVuOgflbXm1D1JIcYoF4MKE2HmU3n0mCKrDr+Y2V5tmG59+rHITaIyt4gFdGyJ1uu1w1k085E+LjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270254; c=relaxed/simple;
	bh=N9G2xDWLJkhjpVHjPudlC9eB56JQvy0Q3UFpvQ70GnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kW/jTB9MLNEwbYTxidsqZaovFyr0CwnL61kvTRWs/q/JuVy+jMjaJs68XS+F2qOvos5GasjlhGMtnpfQDH0QJNFQfXTRM3CTKzR5AEnMB9d0D/kr5vsJDF6B6t8ucX2WR+OXdlmNOOLkss1Hf/EvaeKwWItBn+CFKRb+Dxdny5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=tprV5yBU; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="tprV5yBU"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76bcb1eso559531cf.3
        for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790270251; x=1790875051; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=feTLx7y3sxZ57LB+c+M8YbdddVhljMzyHzPRAu6TpA4=;
        b=tprV5yBUII/qRzLyqKPdJDICtcHMIXdxXt3R1PhRppTAqbBmNEs7Uqtgc/IauT7bas
         6q+btZ6riiYDfPxMNxJ9LlKIzVy4E/rMZS8FF2kWFWhC/RTZ0m/dLDIeIJEc6DmgUeKW
         rRe5l+D4Gb5EgFoh0bNUVpRhgcRfueygz54BCmywUEAofeJDIrYo8R8bOOlnVVhbm8Xx
         8y1PvkD+okpXc2BYxVcdIyuBwaEwabsdPE+xSDWc5coaNizNqVaWAFRlWZ+CHrBLXEHc
         +ibea7n8Gc0GPrQRe/RTIUKy7LATsQy5mAZvm52IfaGHNyUnZEVBqjo1InS2m+tWjzj5
         xc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270251; x=1790875051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=feTLx7y3sxZ57LB+c+M8YbdddVhljMzyHzPRAu6TpA4=;
        b=pcZZbIOA1HMH3H9/A39niTJNreQvPNuhcqGO3bLr7IOmH3PuS2McLkh4HHUTq906vN
         V/HmyOPcrgdKxcE+IuQmIAMdOFzdmbTQkq/zkuMzD074+MKi61k1V+ZopditAtFByWT5
         yp7yzM8VUGKZnM8FOFcG4k3d61xv8IuthkgvhZxT3fRtLP/Ws1FTPDymxRAgNBWz3Yzh
         hehZEHbx4Wkik/FCsADaflo5MlYlWvDPmF1+Vd2ygVPPbGSOFxYX6pORHmElvQ1xm2FD
         bGClI/qCaGWZNV0EdXYddAgpZpCwrZohovlgj98GRCXSWjJoe0QzTkLeC/kdQQs3BiOn
         W0JA==
X-Forwarded-Encrypted: i=1; AKwUvBz8jOx7aYBwlLAJLRqixcrsFzOPCjt+UiZRa6IS3P0FhwcV87bofdYkFaTXjj/vtUcmaiRo0feQ9BH8@vger.kernel.org
X-Gm-Message-State: AFuF++kYoKdFMdak2opNYJL3tyUqovmhxDrA1AgMxNoCR6YqmzMMjewe
	bDVip91y0+yd0cDwoO85B3VzY1qqkEPkNWswpiNTjPDf+/8E6Ns5BvjrqoPGFHczRSE=
X-Gm-Gg: AYBFou2SN6BCC998Vq1HeZlFuX9vXiaJYM8XpoWmaEkqVGJqvCbDMMi77k0CgXQa0dk
	jfB7TmWTn1uZjXv2+AjOZaNNo3Sr8Xryr2qwM30KctW4kPRAT6fD/O5MkSJhSkueLFPOV772P6/
	J5vAB5X0zMH58OPWGyoiQPvK3EVcxK4wE+c50y8bMS6C/ISX7eycgaDRPKmOUM9ys2dWwoWMdeU
	d88S74TUsG3iUJZvDY2pu9hBNijq989ieHSzu7ObANFJaTWuJtng4olI/zGOkyxJLtSyMi/W3ba
	vmmBDL7+Yg9tD+Gvze8do553L6GIZLopG7hmqyCYcrp0HPjIujT2HQGokpOBJE/sDHrs/HUWIN2
	Dm9itliW9+IUT9QwDFEmvOVqE71Fw1u2ItTDaxZt45DJtaQMR1aJcfTXmDTGiWllQoFbNxs7+//
	oXlviKpGVzvm40GFm+xbvB1j5GPZzk1ALJDdgGQqM9X3Pdn/uYVCMsXZJYGMRvdRP0Rn8AmoMom
	48aNpulrhXgDp9Ak4g6Y8RwNbM/8Hwo+e/UMy1md5r2x0nqc2FBzrs=
X-Received: by 2002:a05:622a:2b05:b0:530:42e4:f001 with SMTP id d75a77b69052e-532feb3025amr31555731cf.46.1790270250746;
        Thu, 24 Sep 2026 10:17:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532f8b7174asm25743881cf.14.2026.09.24.10.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:17:30 -0700 (PDT)
Date: Thu, 24 Sep 2026 13:17:28 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Message-ID: <arVW5i8pvySq6Co2@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:13PM +0100, Lorenzo Stoakes (ARM) wrote:
>  static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>  {
...
> +	err = mmap_hook_validate(prev_start, prev_end, &prev_flags, vma);
> +	if (unlikely(err)) {
> +		vma->vm_start = prev_start;
> +		vma->vm_end = prev_end;
> +		vma_close(vma);
>  	}
> +
> +	return err;
>  }
>  

I indepdeantly validated the sashiko report on this chunk.  Seems like
close() should be deferred until after __map_new_file_vma() calls
unmap_region().

suggested fix is to drop vma_close() from mmap_file()  and update the
cleanup in __mmap_new_file_vma() 

if (error) {
	UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
		    map->prev, map->next);
	vma_iter_set(vmi, vma->vm_end);
	unmap_region(&unmap);

	/* Release driver state only after its mappings are gone. */
	vma_close(vma);

	if (map_same_file(map))
		fput(map->vm_file);
	vma->vm_file = NULL;

	return error;
}

Example race:

  Thread A                              Thread B

  mmap(MAP_FIXED, address A)
    driver remap_pfn_range(A, page P)
                                         load/store at known address A
                                         hardware finds the new present PTE
    validation fails
    ->close() frees page P
                                         UAF
    unmap_region()
    TLB shootdown

With that fix

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

~Gregory

