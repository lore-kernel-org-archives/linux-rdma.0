Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8CC24A05D;
	Sun, 26 Jul 2026 08:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785054206; cv=none; b=h552D0ZuVT6gOS9dUIXOxR2+/Mq4uDTi55wPzVh9bx639XlamxKrK9418V759HS5QFEMhXATcV9vPVybRV/crVVPxYiS6tre/zuFwM9mWHznZACcJynxLm+R6x69eFrjQuflH5+unWLEcHLns0r0Qf9q8zvzJAFe6bcPJDO9m40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785054206; c=relaxed/simple;
	bh=RKObnhVHSBxHTtARrmzuvzZd6anxvQ4Z3TG7J1Vn4JY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z3aL9+itvT8Ogu59pBR1vLmJikQGzwk65OLuKVj6CZUXcOQ+jYwjiz+ObAaxiItXwoJUylLyPiqlGf80FBJMtAqJaLtIxhM70O7H8P1PTa0kXOuJkWactC/ZMIalatbXNFBfrOL9/tdyO5PChYC3+8Rv/qs4WHDGeDCP4UPicfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeXg6iMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeXg6iMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB45B1F000E9;
	Sun, 26 Jul 2026 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785054205;
	bh=EURZIPTZJFvZM2NBjtixgY4zUoPQrTRaxQBigdxQ/mU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TeXg6iMcktCeyB0+3f1Wqj6isZ1zp0BU3PodckqWnMC2VKkG+ycD66oY2ApKlngBf
	 yAlCvF0EiSAcdRWOHejLHvFI2lp/BfVYEJaNEAezyC1m7Z22pItQAbp+G5n7Fw7F1/
	 7rHkZrbYeJQC0lUoE/g5t+gYdHVntH5IjWPqatLleUPfDUGmpwWFAv1WIK5Td3Iztu
	 JvyEsSwzlU8o+f2iHWM0Iqfkryb7ufpyENncD3S78477VweJHa2DypdYjOEzepQBD7
	 6Dyr29IFlCQZX6ZEICY+Ba6YdflI6c05BKNRGKONCtuOWHMgQXReJZs33Ey9qNuJz6
	 /Ff3R3RjZRV0Q==
From: Leon Romanovsky <leon@kernel.org>
To: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
 chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
 tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
 jgg@ziepe.ca, akpm@linux-foundation.org, namcao@linutronix.de, 
 ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org, 
 Gou Hao <gouhao@uniontech.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
Subject: Re: (subset) [PATCH v2 0/6] remove dead NULL checks after
 GFP_NOFAIL allocations and fix xive use-after-free
Message-Id: <178505420268.4050106.14417810250582879470.b4-ty@kernel.org>
Date: Sun, 26 Jul 2026 04:23:22 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 24 Jul 2026 10:28:45 +0800, Gou Hao wrote:
> Changes in v2:
> - Remove the now-unused out_free_domain error label in the xive
>   patch after deleting the unreachable NULL check goto.
> - Fix a use-after-free of xive_ipis: when xive_init_ipis() fails,
>   the error path frees xive_ipis but xive_smp_probe() ignores the
>   error and proceeds to dereference it in xive_setup_cpu_ipi().
>   Propagate the error return through xive_smp_probe() and check
>   it in both pnv_smp_probe() and pSeries_smp_probe().
> 
> [...]

Applied, thanks!

[6/6] RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
      https://git.kernel.org/rdma/rdma/c/a273210687f255

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

