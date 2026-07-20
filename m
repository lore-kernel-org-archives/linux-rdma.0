Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3DF2D0602;
	Mon, 20 Jul 2026 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565150; cv=none; b=EXyUYd+gPAPwQFG+8+JnfmxglMDLVgKgS2fkugQm/mPgMm63TUUWfTuu7yF/a6vfWk4+w0Y/lA2CjN1KO1bz5Kl5MZkqabCX1F0xBN5rv6tfrBAKIpa2pOYmrCsjepQVnJ3i6YyL9rMLAV7nREaqdOlGcJRBLJOv0m6lGw4bJX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565150; c=relaxed/simple;
	bh=7WxZH/aP0Plov8+NXa3GcdVoiew72vfYFylVtuzHZaQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=uWjXlRvOLJ8aS0jOptwWTK5rxIKFgoSLgMLLotA8wj6yKepTXGIbEy2HFFEdD/NzOJaBWI2/ae4cBbEPxIs6zTjj2SmIVVIVrNERS+oIdHMd+mnwsmDYXX/GisHteL2OqS7S87vTgwTZM1Iuo7XWLcTlYwIwqEjegu/A+4xEbd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=XfEJilhz; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="XfEJilhz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=UejnvKJ6g9gMJanunWLrrKhYBZB1/JIBg8RLC+bnqec=; b=XfEJilhz7K3/u1syeao1OiBuv7
	cPb46Ie3iKQCESnfHFjcSvEiS51mxQmcWQHidb5UeslC/dPkvy6x5rsSd69D5FYW4CzGWS+soUzm3
	qG+YSRRP3+YlDlsvF6eiuALUNxqhRts/xTm6JhYu2C4XJIZD19Aqi9ZItYNeGLBh0aNNBmZAQMXR0
	IqaAdBGQGwJpUDTA1ouAkyK0aqkGW/S+VFhHWLeEbOo4yvlMrgXt6G83ACdLa5rv5FPXqOcGXgo7z
	CKbU8WGpdp07CWbVn/17UUeJA9cq/ZIBxJlNVzThwKgJX/Zv7qWjjAQsGRll2EO7jlMUv9D0leJMj
	Fx2gI0Lw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wlquk-0000000B6S8-0KRQ;
	Mon, 20 Jul 2026 10:32:22 -0600
Message-ID: <8e34f60f-c45b-4455-9486-7c1eba60c0a2@deltatee.com>
Date: Mon, 20 Jul 2026 10:32:21 -0600
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
 <20260719105327.864949-6-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260719105327.864949-6-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v2 5/7] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-19 04:53, Mykola Marzhan wrote:
> narrow_write_error() re-issues a failed write in badblock-granularity
> chunks, cloning from the master bio and resetting bi_opf to a bare
> REQ_OP_WRITE. For a P2PDMA bio that reset drops REQ_NOMERGE, which is
> the only request-level protection against the member queue merging
> P2PDMA segments across pgmaps or with host memory (see the preceding
> md_submit_bio() fix): the retry path would quietly reopen the hole
> the submission path closes. Restore the flag on P2PDMA retry clones.
> 
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Looks correct, thanks.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
