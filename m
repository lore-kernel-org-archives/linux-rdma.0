Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445657;
	b=bnBOBJytON6Ew1w3g4N9/HvhWFN1RMavFPv1KRtlZVMWJfAw/dr902SCT7ldYkFZLbs6
	 Ob7rzdfnAzkA0445MGw1SCxTuptLgIFqF2uVN8NjD2AfUhuvGTzF+rT1AhdSna/VYpZzJ
	 MZE1+eK/M5UE6U2IIq0CorPlhYOQCHFO1qL6+HKE5xyCaJWYtXf3Xx9u09y+vjNEhSFIl
	 o4spEgW8lgPc1KqC3RgefQplA5slx0Vr5sHfoLNVS3ym/bVGFy+Dc+zuU3jbtBWy9Dwrt
	 /0u+X6w8c/F5P63Cqtdr6h611y9Nf3DLej0O0lvEJYplBL9CAS+eoXL5UqV3a/jOo9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445657;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=5mz8QsVAUaO9bj17AWP3z2R7Bqrr5CER16zl8mouvOY=;
	b=nffW55sFfg0oQMXpdW259AnT12muZnCGsYknFvfEWdBSuWH5cEZmGAk8p5Y+q5Sxy30c
	 oHNNmK6c2ZNPbc2t+uv77nJrKZkebq5eaAOrgfZckj0JtjGBwayY4WAZUVRhEcTbQg3yn
	 /9k7vqJ1WfVpMyXjfIF9VzD8s5u+jI+/kWM7ch/cUS3UwArj/yWVEDGsZGoTQBPwIX92j
	 DNgGrMPTq4ur7LVkDDR1OfHZCk8GBbH9hGgyTX6KWWwnic5n/nbmU54ef9AB9YjktAtOB
	 joo2str5oSY3pyZQzY0p04njM5mLnxdgCv7ac41Usj+wlyksYBbQYgmJR8qsoEM0p4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=J6UvCFbS;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A2B606A6A1;
	Mon, 23 Nov 2026 14:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7A2B606A6A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=J6UvCFbS
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1B69020B7167;
	Mon, 23 Nov 2026 06:54:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1B69020B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795445652;
	bh=5mz8QsVAUaO9bj17AWP3z2R7Bqrr5CER16zl8mouvOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6UvCFbSLosaA/sY38ZP7f283cA4sXlYq/8jEisLFAV6fKiG+2TVB06Po76D8uSFI
	 6QmaDFN5TcNl/ybumkiUfcD8nRs9p0KigeOSXu9QiAiS+ASmyIspz7kH1VQgGWDC9d
	 b2lHX5hHQViMf0gAIjQMLk7izPqGiCrB5eju+rxk=
From: Wei Hu <weh@linux.microsoft.com>
To: leon@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: Re: [PATCH net-next v11 3/4] net: mana: support concurrent HWC requests
Date: Mon, 23 Nov 2026 14:53:59 +0000
Message-ID: <20261122064231.hwc-v11-leon-p3.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117180724.GD162713@unreal>
References: <cover.1794751992.git.weh@linux.microsoft.com> <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com> <20261117180724.GD162713@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Nov 17, 2026, Leon Romanovsky wrote:
> Unfortunately, the entire series was written using AI tools, making it
> difficult to provide meaningful feedback based on the commit messages.

I rewrote the v12 commit messages to explain what goes wrong and why
each change is needed.

> However, in RDMA, object destruction should not fail and we shouldn't
> leave pinned memory for the user space process which already exited.

Agreed. ib_free_cq() frees the CQ even if destroy returns an error. I
removed the CQ and QP early returns in v12. Teardown no longer relies
on an exiting process retrying.

When a posted HWC command reaches its normal response timeout, the PF
guarantees that DMA through the old MR has stopped and cannot restart.
The driver can then unpin the pages without a destroy reply.

Thanks,
Wei
