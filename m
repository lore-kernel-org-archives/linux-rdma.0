Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E3B3B8D7E
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784555552; cv=none; b=kzq0U5+7CKUKaEiVO8XmLbJ3mX1qVI0Sr0eXgsQpEWf54+mKR90VgLkM173zTQ7RDUvssdqDH8e/jymiNfScyhbBu/x3hDBJTIC/yL6WT3aqEFthlVW1vBNyfeR3kdxMUx+1t4y9xing6wbvCA66p6MFxT893nPmGdLkUKK1kLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784555552; c=relaxed/simple;
	bh=8NPcPX4VGMeFf788LoU11J1w5DXTi+oJnAW8j3ghSEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vmm1gaQH7QC7dYpRd62iuc3L1dWj+myIAmZiaim5IyCFManWWJT2h980Bav1yXJC8ywmX606Y9ArGw+XEU0jHF2nGKTwyJcMuug/GgkyDC1W4kD0PKi/9FfPcs31w0r0IsnZ++i1p+9DrA2TIa2SqrzHFfyozi2exYyk5IfDyHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YcLOK6ed; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YcLOK6ed"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10ed63c0so861321cf.1
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 06:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784555550; x=1785160350; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UgD9bXXwSeM0164tZRI/2maKOOM1j5/MTHlzcI24yvE=;
        b=YcLOK6edcDgDMraLEk2hRLTiWx9CcMO5wHhz4ltS/LgHi41Xr/q+dlsdVzLZ7hGTiA
         Z5HrIwzXykoqMd/33zoKExEE6EFzC4Jpo/nww/MGH+Juv1ivE0CviYLbFV64jNLAFIhA
         +dv7Ww57RGCrhVd8iB7eJAWOeygd+alTWVMdOnaQaILl7IXfwYLlNQOnZOWFpe2v3i4r
         Yqd0BvzS4gLhaEc35XNnTnerjAwyW9hPJKm/lpelRa6ppJWohSwVpYHA8PEX8IERwz0a
         qAB5eQsY8faGzZXJCh+EkmUHx0b6iEVvRDVv7+DIVpA8Eg4GzuSoy0ln8/HtSQF0kjp2
         tpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784555550; x=1785160350;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UgD9bXXwSeM0164tZRI/2maKOOM1j5/MTHlzcI24yvE=;
        b=JVKOju48pZAWTc+MSHixwY9CNqlAbHZcJHuxqlcQ+GZ0yVH3DhohSyr+81b0bb87K6
         pslhl76EDImaSQG8x4mphS/YxpC2O4PgOjfZUEfzas02B25/mnqiYiOPjSlFxlnCaRmE
         v3dJeOQ8iwNk73tWU2CSDBgOM9fRIOs4RhI5v/OgV+OYBnUO8/kvX7ISubcLUkWFusS3
         PwGNeKI4hpuKyNlfidKONef9rxYxxTxp/adpKpLWGYQGDC/LyT5qaXhBaD96Fp11LAcG
         1gtuUvJptYOsVGV9JU7jQgsZSNxmmNcLRBUexXWXMXhgKszsoQW6BpoZi+5MZv8HDzOE
         6+zQ==
X-Forwarded-Encrypted: i=1; AHgh+RpcDVf9CKS1UDYeWoDU3ahMMh1z1csutxFyLDy1kJ92acGgZNqnQYCHq+EdN0v5DfLsePMOLhS3bTsz@vger.kernel.org
X-Gm-Message-State: AOJu0YwOLd6nVY2f23F5rtiVBlNGqe+ZDrInyVuH7Q02X815iodTlJoP
	OGHfWOa6qte/geL6UdnLj46nnzbUN18IOVXqJK4DL3HzkW7mkalC/X9FYB6/W7FFSg==
X-Gm-Gg: AfdE7cnTeIBgmiyBR88c/bLu/mHVvIhgq4v7dpJQC5Wal7O61Il3wqRltJm9QRCaZ4Q
	m9z6+LSTqZCaREsBFkhU3nPrNQDHre/paxNBZkr7RLhOSZbMUxdtdgYlznu/unzxUzrwOYbT9J+
	5z15EcVjcPaRNdumCY0m/nha3i8KeLEu24p8bdP0Dn1S9i28VMbD8dt0aHI3kmjo1osEa1/49Ji
	+NbFk7KNgoKtz4No4GMfibjjS7o/bsjBI5DQWZDJ0+eLJjofvgtJU4oAhtQBsjA1ElADy4/a9C7
	l2J4VtCQLN4UNwfXcqFvRZkkPGLsH1kw3vZLD4rxvwrYALueu/ryzI8/TK+1NfBIQ1LmorGrqkl
	D2rL2vzNghU39aqNcsImmx880+utNzoFmwjlemP3ovtDH0CJeBhlT+Jjr7i7oQP8J1N4uE0qLs4
	SQE3/3UO+9Wi++irR9/2eeQ4mpuERcPEKsbHhu
X-Received: by 2002:a05:622a:5e88:b0:517:5e32:2d14 with SMTP id d75a77b69052e-52600a85199mr1590141cf.10.1784555549780;
        Mon, 20 Jul 2026 06:52:29 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef42acf2esm50683247b3.33.2026.07.20.06.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 06:52:29 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:52:22 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
	linux-nfs@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>
Subject: Re: [PATCH v3 1/5] nfs: make nfs_page pin-aware
Message-ID: <al4oFjOLaF3LDeyB@google.com>
References: <20260715143540.3597616-1-praan@google.com>
 <20260715143540.3597616-2-praan@google.com>
 <20260720091322.GA24298@lst.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720091322.GA24298@lst.de>

On Mon, Jul 20, 2026 at 11:13:22AM +0200, Christoph Hellwig wrote:
> It would be nice to avoid the overly long lines, but otherwise this
> looks good.
> 

Ack, I'll trim the long lines and post a v4 quickly.

Thanks!
Praan
