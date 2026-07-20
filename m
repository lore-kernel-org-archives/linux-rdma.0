Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7533FBB5E;
	Mon, 20 Jul 2026 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565125; cv=none; b=ahJY/wzSW2e48EEEtoaIZpUIn77cpBIRL4891dcdcbjSDjz1Tdb7hxDQalexRoW8Kab2a41HEz46Y4+9PobcvOr9pSVV7Bzflv5qwlma/3NdSRe5K5BhtIEHHePh4gyNWlV+un3aZNgI2qv4XMbb1kV/8KhBy0a8UikoLc7KxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565125; c=relaxed/simple;
	bh=1IUOQUOJNB7Oft+0Vo0FUIFqnEx2Z5XRWO74Zl7SwFQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=fZgJaZjElbKWUBJQOdMAcyksW0CXWF3wgvUAdp5Mm2ZllQTNsuoTIKUZUX70LP1AtC1NV1/By3b4V/aY4BFN/lF0jJO3XBcXuB5wFBC/yn2YZtHhpmZvFS85V3hIow2ywH8D8hSBGUz8rsg1y6LLaP66iqLcN9kWGVIu/kc/KCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=lu6ScZze; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="lu6ScZze"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=zRXSsjetSNYmOmOpH4xZfFcfMKaYN7wbn4FF3fVhydY=; b=lu6ScZzex9t767shyeadjkHcFD
	jIqOWVpDXLzH+x+Mxens/YQbWgwnbTdrItugJiyyQ6s5a0eoVQO5pv5Fw6m7/ZqjaC/AsU+8agptk
	dxyBdIWv6+aOEcZ1V9TCQvVOAwQHWxCW+522D8Ub0p810QnoT2jAiWPhagI0ntygCSuHN/4t1vQWE
	rxV9WdalxfZcqnRe3d1Hm3UwixD+t7sIrnp7+NF7jfVcArBN/XIwcYuemobzZOoicHIwRzUWEvaXy
	Zh0QKgCHSo+BYE2Loz8uVv9nj0w+nW/oQdz3w04MRD43RSbz+0WbaYCp5+aLZIgU/YdJc+L9Oqr1q
	bizf4Ong==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wlquI-0000000B6Re-11GA;
	Mon, 20 Jul 2026 10:31:55 -0600
Message-ID: <66e72dfa-cb03-49ea-ac52-cb171edef6e4@deltatee.com>
Date: Mon, 20 Jul 2026 10:31:45 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mykola Marzhan <mykola@meshstor.io>, Jens Axboe <axboe@kernel.dk>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-5-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260719105327.864949-5-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v2 4/7] md/raid1: don't use write-behind for P2PDMA bios
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-19 04:53, Mykola Marzhan wrote:
> alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
> a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
> must not assume CPU load/store access to them is safe or fast on
> every architecture, and bouncing peer memory through the CPU defeats
> the point of a peer-to-peer transfer.
> 
> Skip write-behind for P2PDMA bios: they are written directly to all
> members, including write-mostly ones.  Ordering against write-behind
> I/O in flight to overlapping sectors is preserved: the non-behind
> clone path serializes on CollisionCheck rdevs (see the preceding
> fix), which covers these bios like any other write that bypasses
> write-behind.
> 
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Looks correct to me.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

