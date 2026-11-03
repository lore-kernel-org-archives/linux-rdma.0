Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732845;
	b=x9WfUtSqJeYk1IITk+wGnhzsEAN7UJ6KwKl8oViF5KYpIL1cdp2lETUghPpvTooVP+Wh
	 e7T5qz6mTUooSW4rneNKgopGdsE3ohv6aVorq5NxYCP5PVfGOKkjwzMW42wsTEyZtZZbe
	 WgogUqN0QRB52Jd4PEkbLKMbs3BuKxRwE9EX1kbt0bftwkyD+eiYaNMYx8RS4W72DGOW3
	 t4L2JspabzVcKjO77pN60HCDvqjnjOgukj4lAKwAojNpirx/cYIU/x2TkY2nqEtqTzVrh
	 GFoOjgX0Qdq4Ai2m9v2tvmjZZmPd7M/BTeU82SNykqeJ/yAaU1Pz5MThjiz8Fimjhng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732845;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hpiuf3M094k+eUJB3HjtDKhVz83Nnw8OBVqB4YhqMp0=;
	b=QE4hf+8HTEkx9q0GiQT4J5iSH1OFsBX2XNaFPzQF3DEeXr0kM9W23KazcQ7Zq6g4oHza
	 Ab2o57ecievjK29y8eu5DleAxUZBn8gZ3DadhZi61DuZA/+jNWOHrg8vRoxiNnOCAxkpN
	 PXMPwLlsCByVgckzfhYacdW4yM2EWObI6Iac6vc47TdS9wyntj+zh0zKU2x2AssakfHHz
	 rITUUL1L5jdLT6tBge86KRaez7VML2L1cX5KGU902F0fN+DdlsSmYADA+9QgC+JEbQd5A
	 jR48IAk6OBRZe1LUrzlehygDNQE6aMI9gHiIFoJRcqcB8RqOPJUX40cXU2iQ1m6lB+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A52606A32C
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 19:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49A52606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53397554beaso61455681cf.3
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 11:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793732839; x=1794337639; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hpiuf3M094k+eUJB3HjtDKhVz83Nnw8OBVqB4YhqMp0=;
        b=el8tqfIRmBOBpfzqQWRkw5z4u6KkRBPdUbKJDmidz2ClNKNldsAg02FGBksK9H/q61
         eUGHEJO/xrBnqswZVtjmnvO6AaeX15R9eM4APu5OzPXjDtQm5FBabdgsh1lrDkipaKgw
         aep3NvYJPt+IEH2Nd9n3L1gbH76ELbGMGG2efUPK+b9y9Emq3V3qC8S+LGWqOC78CcRF
         dcp0iIWBDivUPoWQfdJHW6VX114dgA45Zv41dfeKcExEibzJLAdKVarvXVyXOepEJil4
         6UW27tseaFRI6D3/cmRdOMnY/pKoCPkAS7H3W548UNgfNxxRr4FqYzI2E2IStIkrnE2G
         j7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793732839; x=1794337639;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hpiuf3M094k+eUJB3HjtDKhVz83Nnw8OBVqB4YhqMp0=;
        b=BhOv1815veQ3sJTtl1jwJEPVtGmPz6PurAbTrB3AE90rO+MWN7JpXCePFxx5YgwimL
         bVw9PRfSgFfe1ebpSJkQdKpswSt6jkfofotPfoGITijOVzNeTtNYX6nXj9KvyrDaHsyH
         jbiMmBsdL4AoVALXegojy2ycliCULHjL5Jz1FlBtjtyrpvOQaCNFTL40nL7FHKwn+HNp
         /NX74fsFAW6Rgt/xZg/IQKUIkL6JIfXZNC3jbRBJGxbXms0HSQCg00GVpjqUGDPg0X7e
         wTlvYwRfVou0D0PyFNTpkeBWRlmO5SrEUF79yV8oUtBYD8AhPmHHfGNRP/p8+Lhycvgz
         m8Yw==
X-Forwarded-Encrypted: i=1; AKwUvBzyJRry68Uum9aqffy9bWG2ZhzRXV3r12h1qiRxC27xS6wECmIgWn3Rp/J/IvCxlC5z0DgLBMs900uc@vger.kernel.org
X-Gm-Message-State: APuU4Z+t65+WyL1RXbMgX8mmdreRm1KN0ZqXMhdUyleQ3y8z2/ZQg+rc
	8lncJkrqoRz4bKPOwYf6GUzbufxU2C2Y9I5KrsDKNmj7qCK6MOQrntIb63Rai2f7q+c=
X-Gm-Gg: AYBFou1jmPfqFdZf2SHX6g/ZmMQEOfm/tnltc2d+zICDxgfqrZxOO2677Nt3P/JCT8w
	Z8H5ISJUY/uo+5Tw4QVS1zvTtnVzEhMlbjh7LKULyJFoQ0D9myrILMf08SU6ikZN/pfQDje5M4z
	WLWOrZLOqEsLo0A5sTVirpoagu7asWyMUdxyS3k5HMgfxdHtfrB0CdvRRtaOah3nxBmwjbzP+VD
	g2FkhWbdxI+/XZhpcj3ts6kjUyAYK8KJ1/+epP8mht92GP8DQ5Pdw8eL7gCAouKjYdJwen1LVDZ
	pENIVXTkgTNosGbRSAXLDlrlvo2BoLKO9w60MoeP4cngcp+5o6vMiGnzEmS5fTUiszSL1C1Hzw/
	E539Rn5HzdKm1LOu94x+lj82yxTJYwalwFr6qUE0kiz+okyDgOlacjod6fsbh6PtiS/QAw/Ftdc
	rHJbWPaS7agQk65mobnRTYUvkUmbu/QF6HuIUL2W5GQWRDgv9JCZQoNkDh0J+IPYEmkKY7nujhR
	rDGAA1PBuMHm2mhtLvDA4eKowG60ts8QMYp4HCBk9KbKpPZSl9YPZPzOpxDu2bCjfH33E/E6GAF
	c/HbS3WXPl/xfjKpyS4x1mjYP4f4Dvq2MbagbXKxA8YHghTWT4x+sd/HazmkhWs8LMgnazTeXxi
	6i6B5ynbNew==
X-Received: by 2002:a05:622a:4d1:b0:536:34db:e7c8 with SMTP id d75a77b69052e-542b781ef12mr235987701cf.33.1793732839094;
        Tue, 03 Nov 2026 11:07:19 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b10a6ca24sm3525731cf.14.2026.11.03.11.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:07:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOJqn-0000000DiZe-48Es;
	Tue, 03 Nov 2026 15:07:17 -0400
Date: Tue, 3 Nov 2026 15:07:17 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Moroni <jmoroni@google.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, leon@kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH rdma-next 08/23] RDMA/core: Suppress kverbs_provider for
 adversarial_mode devices
Message-ID: <20261103190717.GM3889730@ziepe.ca>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-9-yishaih@nvidia.com>
 <CAHYDg1TnFq3EnG+6ej5SosbN02C_h5tobDtrqy5XQBk+g914Jw@mail.gmail.com>
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
In-Reply-To: <CAHYDg1TnFq3EnG+6ej5SosbN02C_h5tobDtrqy5XQBk+g914Jw@mail.gmail.com>

On Tue, Nov 03, 2026 at 02:03:22PM -0500, Jacob Moroni wrote:
> Hi,
> 
> Out of curiosity, is the idea that these restrictions will
> eventually be lifted once the ULPs (and I guess the drivers) are
> hardened? Or is it considered infeasible? I am most curious about
> RDMA CM.

I think it depends on people's interest. This is not easy work and I
would insist any attempt be "complete" in that it at least
architecturally defends against a remote compromise.

> Even if the drivers are hardened (no round-tripping WR IDs thru HW
> from WQE->CQE, sanitizing values from FW, etc.), I think it may be
> impossible to protect against certain bogus payload scenarios such
> as a NIC reporting a CQE even though it never wrote the data (or
> wrote bogus data), but this sort of risk seems like it would apply
> to untrusted Ethernet devices as well, IIUC. I can imagine it being
> very difficult to harden RDMA CM for this though.

Yes, the verbs user is exposed to some of the threat as the
completions are no longer reliable. The user can assume the wr_id is
correct, and they only get one completion per wr_id, but the rest of
the completion information can't have any effect on integrity.

Jason
