Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680257;
	b=KqEQKKzaI/v+pEO2g1lFUOpYih7PrueiCapuR6I1ra7BrWkS6S9yT5bRhQQuzOM7w8o0
	 htjfVliuAlDBgnF2Tqv6nhZ8E0IyjFS73ogQrLB7twhiyfdnZJK5DB+yKol0uDuX1zn9d
	 qXht6oXjz149n4xRcsaLmASZcIZjdTvkdRkPle8c7vmSbY8FDQj5tSSJ7aE0vQeY5cYlt
	 Yhoq95fWp4QtmYrDSSVXr2Dm3NFgJcPyszO1cd30pFo5+7pVIAJf4LcGJ8NkEE+NR7oqy
	 P/5bY77HJThH2mRRzvx+Jj/n9e52BTC44TUSsyDYfS/AdCiVFAySH1ZS7Z45qdBvKbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680257;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=iuty2+xJIN5LQRJAknFt1dp6ncxxbQEVN7EXoGwFcHA=;
	b=4kjyo1524wFyy4wISovYK5oHEXCB+Ke9v/Q6xif8NZFuHUJ4X/+VOITewmONVdEBJs27
	 OBUsOM6R0Mf4kt2jfXZq7p1rywynGmIQlpkuziAGtSp8c7VboKI6eF7SzfPIq4zEuO6rh
	 zNGao5KFAJ0N6aExT22579dOPhNkFYlct8zDUvAmNrNUQU0j+HmX2oYMBytu3215RhyZC
	 MvU6kS4O1EttgzfviANsX94Ez0AXYPX2aCJedP858SU+fpc/toCCwIIX2Yme4g5k6E9xD
	 VqTqq9Yu7nXKcv5iphWDfmhoFRqMPWnzHAPco2olccZf0nrAy+SeBbQWKDB7rmtsfdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="KxDDgiy/";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DC7606A319;
	Thu, 22 Oct 2026 14:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97DC7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=KxDDgiy/
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id DAE3A20B7166;
	Thu, 22 Oct 2026 07:44:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DAE3A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792680248;
	bh=iuty2+xJIN5LQRJAknFt1dp6ncxxbQEVN7EXoGwFcHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxDDgiy/cYWjkLNWJ9JEAY1Ny7IPFhlVNFlgJSp+bI+0oTmJfyWFLoWHMcZyd1VwU
	 3PDN+Wdpp2eD7rw2K2Y6wNHr3m4wPux7vAL9dRVMvro7hUYrcp/CmyNzoEqDk9PCof
	 2wp4p6Ta/+DGOvaYOLb87x2u1HsJM2M7zPFJcjPo=
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
Subject: Re: [PATCH net-next v8 1/4] net: mana: prepare HWC ownership for safe reinitialization
Date: Thu, 22 Oct 2026 14:44:07 +0000
Message-ID: <hwc-v9-v8-review-20261022-patch1-42c4b3b89bc66ef97a25@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179250338816.3135.13276488357316939732@kernel.org>
References: <64987f49ea13b5ccdc9ef95f4a9baf23a479edc3.1791998462.git.weh@linux.microsoft.com>  <179250338816.3135.13276488357316939732@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Thanks for the review.=0D
=0D
On Tue, 20 Oct 2026 13:36:28 +0000, netdev-bot+sashiko@kernel.org wrote:=0D
=0D
> This is a pre-existing issue and was not introduced by this patch. This=0D
> hunk now documents mana_gd_process_eqe() as an RCU-protected lockless=0D
> reader of gc->cq_table, though. Do the Ethernet and RDMA writers of the=0D
> same slots follow that model?=0D
=0D
The individual Ethernet and RDMA CQ publication/lifetime issues are=0D
pre-existing. We will address separately.=0D
=0D
Regards,=0D
Wei=0D
