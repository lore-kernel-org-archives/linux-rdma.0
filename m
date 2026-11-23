Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447313;
	b=Th2Qtz9gvd8qHl5sfufMbif/38Ku2xxvJs7CjyfOL/PfWX09Axu0fSNrCK7i61UjE6CE
	 cu5YHuc6BrkTJrSenly9ILLgRFn9w7vn4r8/fbrXvjRZgMAhCoNccWZyvgpJonv250Uco
	 6E7vBykVafigbMrX98WAZCSrOxJjh3CpJ30nBHdTKvglswENopvlZbO/x2HRboiaRlvK1
	 Ruy3XF/TdI6Pzjxh+DwgIPeW4PwnAQDV3l7ZYkftsutXeRRdn3fB8TQNtZ8Mpf25JFDQG
	 OwmKTCmJ3r9t+4/auFnthLvVfiZ+V1LM2ZUx7oOt8M6fHXFRzhL1o5DskhOn6TfNXRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447313;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FDHhwxCxCbXmvaM7MXxMxxf1AWoTVfTVQx5EL51XTSY=;
	b=yYSuOLPysBvNcF5tNTNBjcSzlnMiTUAnyQhJ+sOfBJe62Rjabv+HFDPUDtEw5dVlMx9j
	 QO1lzKqZsXR2PJ9pggvg9ogqu1iAkVfG26qx/aCo3NLS7m+DeQuYKC6rs4YJe8Y7LCjRm
	 5RiBnpsRBIcEi+6aI6hIoPGebAv3+2KUmuoyRNuKDZs/5PyOkNsD3dajbiUaSIirfsvPE
	 2Ll3Ymz97ABJfsZc5EDBLu8GcRuATOO4uIGFt8uvRWG4FBbWCEjNLfNSlBJY1FQZRIg+6
	 xOq+nZjbJLSmBGHPudO8TND3aZRlTyKSEH7sCJHlVhLqQ2Bj8198zrkLUCubdyH2TdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=J1P3PFoa;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3441606A31F;
	Mon, 23 Nov 2026 15:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3441606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=J1P3PFoa
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 87B0320B7167;
	Mon, 23 Nov 2026 07:21:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 87B0320B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795447308;
	bh=FDHhwxCxCbXmvaM7MXxMxxf1AWoTVfTVQx5EL51XTSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1P3PFoa9nR7k2KaZQn4p3MoCICXl+phdl58ZUlBuX/wXLkMPyF1M6ne2cWYQ+n6H
	 gpBWeFkU1+O/zbw8VIgfThH8iyxKUaCaa4NLLwCXPbM0lryhPuTH2z0kOpxjGv9br4
	 ALdYvK1B6Ch0CB/X6qb6ZfvKG/GjqRTum51UIGLM=
From: Wei Hu <weh@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
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
Subject: Re: [PATCH net-next v11 1/4] net: mana: prepare HWC ownership for safe reinitialization
Date: Mon, 23 Nov 2026 15:21:44 +0000
Message-ID: <20261122064231.hwc-v11-netdev-p1.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179527856753.3135.1812581824985082274@kernel.org>
References: <f94c7f71d4228c7c30838f9c901b429ec5b1428c.1794751992.git.weh@linux.microsoft.com> <179527856753.3135.1812581824985082274@kernel.org>
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

On Sat, Nov 21, 2026, netdev-bot+sashiko wrote:
> Should mana_ib unpublish the slot, wait for a grace period, and only then
> free the object, as the HWC teardown path in this patch does?

The HWC teardown protects the table itself, not the lifetime of each
RDMA CQ in it. The individual CQ race exists upstream; v12 leaves it
out of this series.

> Can this leak repeat without limit through the existing PCI recovery loop?

Yes, in v11. In v12, if probe cleanup can't get a DESTROY_HWC ack,
the driver doesn't schedule another PCI probe. If teardown fails during
removal for a driver-initiated rescan, it skips the rescan. A bound
device can retry the destroy. Final removal can still leak the last set
of HWC buffers: the PF may still be using them.

> What happens to setup_active when the PF returns possession with a
> well-formed ESTABLISH_HWC response that carries a non-zero status?

It stays set. Once the VF has submitted the queue addresses, an error
reply doesn't establish that the PF has dropped the mappings. The VF
still attempts DESTROY_HWC and waits for its ack before freeing them.
A reset notification isn't a substitute for that ack.

Thanks,
Wei
