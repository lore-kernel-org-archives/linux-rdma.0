Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88B518E02A;
	Sun, 26 Jul 2026 03:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785036394; cv=none; b=U4c1hrIzsnEVeEkp0rXlIjVowZiSdMM55glnPN+X0iZOdqPhyB9ZPNs3sjgFafQznv4Bn37c7Vv8wB72WoSUU0aQ8GAhD2/cPmMil4clv0ELijW2n46M8XNOwmk0y92OazIIBPAx+uhm71JkejM77g/DY/HMLGTmTHHUicw8uf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785036394; c=relaxed/simple;
	bh=b3aPK5HAdafIXDY89XqfZV/QdUZ03MiliNUhLXoc5+I=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CoODx6uHp2y2W4Gi5Uift1zHrtAkYyz41agkdoYY1a1eZiznvOkl0O/7m0yKnybAGHIq/gPQiJWstZntlcBNUc/umXtYE/J8j/UuXod+Aee/YndO/w0OyQq/s9cmNHc8c0bTzgAjQd0Ai0kMXM8nkY2tg87gU93XyifoUcxYvVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C5hXFeas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C5hXFeas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FE51F000E9;
	Sun, 26 Jul 2026 03:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036393;
	bh=ujoywRATcrbjMYNELLJctilgrlUcGvbj5yO2i928VnY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C5hXFeasm97leSm2ZFfgZdr5aKD+zPJYh6c32nLRB1bv6kA4jy/H7lC8P2kfLh68z
	 hpzsypaqVIG8c0DNYMPxTwYHqTO3Zwx0j7wz5lFUlc7HCG17VugyR3yUSar6eLk5qo
	 hyEtqM+UNXtcBuSoDm6nCAbM8QzwSd9ylJaeAjqA=
Date: Sat, 25 Jul 2026 20:26:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
 bharat@chelsio.com, jgg@ziepe.ca, leon@kernel.org, namcao@linutronix.de,
 ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com,
 clg@kaod.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 0/6] remove dead NULL checks after GFP_NOFAIL
 allocations and fix xive use-after-free
Message-Id: <20260725202632.dcb325658896a470df91cf57@linux-foundation.org>
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2026 10:28:45 +0800 Gou Hao <gouhao@uniontech.com> wrote:

> This is a code cleanup series that removes unreachable
> NULL checks (and associated error handling) that follow allocations
> using __GFP_NOFAIL, which guarantees non-NULL return.

Sigh.

Back when Linux ran on an abacus, I added __GFP_NOFAIL because four or
five sites (file systems) were infinitely looping on alloc_pages until
it succeeded.  I figured we should move this operation into the page
allocator so we could easily find those sites and fix them to Not Do
That.

I made it very clear (changelog and code comments) that no new code
should use __GFP_NOFAIL.  How did that work out?

hp2:/usr/src/linux-7.2-rc4> grep -r __GFP_NOFAIL | wc -l
241

So much lameness!   My immediate reaction to your patchset is "No.  Fix
the damn code instead".  But I've resoundingly lost that fight.


Thanks, I'll scoop up the entire series.  If individual patches pop up
in linux-next then I'll drop the mm.git copies.



AI review has a shower of possible pre-existing issues.  I'm seeing
use-after-free, double-free, leak, system hang, NULL pointer
dereference, usual stuff :(

They're in powerpc and cxgb4, if maintainers are interested.

	https://sashiko.dev/#/patchset/20260724022851.466017-1-gouhao@uniontech.com
