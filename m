Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795887159;
	b=vl4n+9SQeM7h7txagTEvxAVFJMDs/IvSTH7ZB1klLTwysSsvy8EgYRso/Kyj1JpFe3FO
	 tJbbTrTZ59lrQ6q/lxukeS+OQMuKEZ45ACVFj7RQ+LgVMXcXe+Uy07d5sIvOK/X+zX0t2
	 x/OyWeL8i71QAc07Yg4g0/DwV7ebMwbZdrQQuipc41kKBDBR9iObePlTl8njCtzxOIGca
	 8O1b8a6IruzK+I4JW6w9UsR/G8ZZ2sUreazdkD32rRvNb05ptirhCxSd096rr29kvOrUr
	 nZNrYv6FlVo3I4cGA49Lw0Ndz4STUM8s3aRZg7ZX66PWj3LqS/JQeD2RCxcEeVkuGOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795887159;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=wE/49ekBlumL4F2CL05c9HqPgXV1chIy7J5KbOlZzOo=;
	b=W7QCeL+FuEt49IpCEz/IIGrbqvioY1dNjn0UDM2tqjA2clyvBNqrfx/LgzKOZN5KCP3+
	 x13ITxS4kNaEicbttt/xs1If++eqQQHrqovjxMmzDFEy/DO3791Ni2z+l/B0swt3ninUK
	 G7YELyBGmBm4FQZEV2HqkF+WdoRNR5ACZUQaKbC/K5HWUMYnHaUGS2t5P8XhxKrSR1VIo
	 TS5gNknj/uwT1RgwuQj3lP+NDC8ngwC0uvJ67Eg6Rewm0soLheEnCWORyhSD4dJTfkvPK
	 qDyb8tYDlwugXIr1gTNWgaw4EA1T5cZeCKo54INraARL+TP/+Wcc+gPu8mgnRDOi0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=jsssifPQ;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15509606A31C;
	Sat, 28 Nov 2026 17:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15509606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=jsssifPQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=wE/49ekBlumL4F2CL05c9HqPgXV1chIy7J5KbOlZzOo=; b=jsssifPQdFJQGpxT+Y83zDHoh7
	wUqee4/OnQCjkS6jl63c8b8b7u+r+E8iyF7U2xWM5ax4oB8GXAiPDOIgNeLsCYYbQHs1yHSlQUaCT
	D1g9vH/w+GXX/j/eTE3JYsBUEOzg6Y65G9iowLAOym4rdq8Ao0gUS4VdscFUAy9YQERE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xXMHS-0020su-7k; Sat, 28 Nov 2026 18:32:10 +0100
Date: Sat, 28 Nov 2026 18:32:10 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Xin Tian <tianx@yunsilicon.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Junxian Huang <huangjunxian6@hisilicon.com>, weihg@yunsilicon.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Subject: Re: [PATCH v2 01/11] net/xsc: add Yunsilicon XSC ethernet PCI driver
Message-ID: <d16e0b39-2f00-48ae-8012-95461ce94ce5@lunn.ch>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145711.70868-2-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126145711.70868-2-tianx@yunsilicon.com>

> +static int __init xsc_init(void)
> +{
> +	int err;
> +
> +	err = pci_register_driver(&xsc_pci_driver);
> +	if (err) {
> +		pr_err("failed to register pci driver\n");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit xsc_fini(void)
> +{
> +	pci_unregister_driver(&xsc_pci_driver);
> +}

module_pci_driver()

	Andrew
