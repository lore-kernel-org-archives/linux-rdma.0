Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435689;
	b=F3554dgX6gQqU/iC+rLq73hd0wFEZd1OuodBmjux3J1W0m4azQ9ooIybFWtbALLO28zi
	 vc1tKDegcVqJ0w/Glnoh5CS/ql3OUxhFl2CBHEGImfOANABtT/DvvgNQvJK4Lobem22BB
	 vqo1QXJOMfDktjo/ek7WxCHPcSeaQ1MTRLRRw7KmWuB1ynF7WuszqA8hV86B0mPBAT9d8
	 8oJZKiDLSmr5GL+mtxpN8e21xvDIky5sY/4+acBZIGxES5ot4VVE5wwhpyJb9ZgT2BTTq
	 uImO99upomrT7p0wMZFqj0oJ8f7UrLUUZY1pgnfvGdbFeM807FmUT0OomRfiMCCSO/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435689;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
	 In-Reply-To:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=akrhacg0cFqsWcufz/98MzPSnTNhvwT4AO9anWTNIAA=;
	b=XSMu+QsLqCeQ16qhasiJJqyF6wlTk/L6m1arRYys9ucrc4WrZFCSj8p/m8Siz6H/1r7Y
	 irsLQ4YVNON4bQ2k5YfcJwmFtL4wUB+twXBHV5BRi2mSwSIrVzw0xOGtnHMsTxApxB86m
	 epMj7AQTY9bxfApvFPnUezxPx2n9b40gJPxQ2EBvBeCYhIKp+UYZl7N8Rf8dNu3iE6bGq
	 QqxBPChkX9y3sh2ZxMtOmjagYrXDLr1wBYnpAny+IJ3qdVw20fjDmDtSBEcwdI2TGH7Ys
	 E+f5grWiGHMYepUArPKkYPHAQtKAU3IhfzrT5vG4Z5pIWJQNi1oYmGA8rBDXMGv2dtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="XV/b7lph";
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CE4606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 12:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70CE4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=XV/b7lph
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261123120805epoutp0440364550497f1e85904eecb01cdf6938~qqz5HAsf_2545725457epoutp04T
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 12:08:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261123120805epoutp0440364550497f1e85904eecb01cdf6938~qqz5HAsf_2545725457epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795435685;
	bh=akrhacg0cFqsWcufz/98MzPSnTNhvwT4AO9anWTNIAA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XV/b7lphJyyKfcaX/THzVnSHnMj4tx+l95LECMiyorjl7jEYL0pdofA4bdueEyqxI
	 p53/N/1UBqAtBBAYDsHa4t8Im4exzQBF+Lq+BvbMqlD/aYwa0N4fyW/BZM8kAPmnr2
	 7cEa7yfqgOcEO6YY/LaXP7DIOlTWYDRnVQLFPJJA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261123120804epcas5p3788cac14b0f09cb98132ffe169443142~qqz4pzvFC0180301803epcas5p3W;
	Mon, 23 Nov 2026 12:08:04 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jY4TH6rdNz6B9m9; Mon, 23 Nov
	2026 12:08:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261123111745epcas5p17516b453f15308229dde84316befc59f~qqH8P0YiZ0439404394epcas5p11;
	Mon, 23 Nov 2026 11:17:45 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261123111743epsmtip1a4e1c759b0126a595d8444f1f5a558a2~qqH6w5V0s0525305253epsmtip1R;
	Mon, 23 Nov 2026 11:17:43 +0000 (GMT)
Date: Mon, 23 Nov 2026 16:46:55 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, kbusch@kernel.org, axboe@kernel.dk,
	sagi@grimberg.me, jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com,
	joshi.k@samsung.com, anuj1072538@gmail.com, linux-nvme@lists.infradead.org,
	linux-rdma@vger.kernel.org
Subject: Re: [RFC 4/4] nvme-rdma: support dma-buf backed requests
Message-ID: <20261123111040.7b2q7fe2xd6k6777@green245.gost>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261121003730.GB14598@lst.de>
X-CMS-MailID: 20261123111745epcas5p17516b453f15308229dde84316befc59f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----vhhXPwE56qUOnQTJq0qPMy__lLDvQDDlUWfIrVOyiFlHsdqU=_68caa_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261118103457epcas5p17770752b910960b84cc259d007120965
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
	<CGME20261118103457epcas5p17770752b910960b84cc259d007120965@epcas5p1.samsung.com>
	<20261118103327.1788667-5-anuj20.g@samsung.com>
	<20261121003730.GB14598@lst.de>

------vhhXPwE56qUOnQTJq0qPMy__lLDvQDDlUWfIrVOyiFlHsdqU=_68caa_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 21/11/26 01:37AM, Christoph Hellwig wrote:
>How does this work with rxe/siw or non-PCIe based HCAs?
>
rxe/swi do not provide a DMA device, so registration fails with
-EOPNOTSUPP (patch 3).

For hardware HCAs, the dma-buf is attached to the DMA device of the
ib_device. Nothing in the mapping path is PCI specific, and if P2P is
not possible for non-PCI device, we expect the exporter's
pci_p2pdma_distance() check to take care of it. We do not have access to
non-PCI HCA setup, so that path is untested.

Thanks,
Nitesh

------vhhXPwE56qUOnQTJq0qPMy__lLDvQDDlUWfIrVOyiFlHsdqU=_68caa_
Content-Type: text/plain; charset="utf-8"


------vhhXPwE56qUOnQTJq0qPMy__lLDvQDDlUWfIrVOyiFlHsdqU=_68caa_--
