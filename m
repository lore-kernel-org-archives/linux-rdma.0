Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098A93ACA6F
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784749829; cv=pass; b=MJD3397C4b/DfJwswe6S9MNk7coC+IjnpT3LJZ9t9XPuI/pAn0wznijPG5FjuUrL2YlGUr5kwR13lbEnHZexlRYOO0CBBnXxVdWb47CWWT8xJciAYDsCcofXe4WC/BeFvcaQFytvRFD4ZBvAYO8rN87SAz2SXibJDfmYMVA1gNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784749829; c=relaxed/simple;
	bh=oCdr0VyYuWFniik+cq5m2m8gRYzMe6MoyKAYOFWNB4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C04VhQy94vlZ5/N9a24EjC8Nl4hqr6IrR/DaSME2vFbcrc/o0dP//41Dud9jpYvdsmBNO2m3iNY339K8o9FfAOfQwEkQsNYBhQ9unSBlwPAbK3jGWR3LtX56W31o7lbW3byTrISKcYTrezmhRN6EoYooACC2v1Kl3BOoXjbUFpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=YeIXLrM4; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="YeIXLrM4"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e08baf860so10691395a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 12:50:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784749827; cv=none;
        d=google.com; s=arc-20260327;
        b=I56kvHjcSaF3MMms46AJMCvVPsEhYLl1xs9hyGvqQZgDf0wuvWOORF9x2bXBGoNyWO
         bkFElhoPL/SR76lPM5eix4hjTlVSH/SvivdMGGX1t8FgRIyVX4pwwUUBxgkEfwu+PynF
         ZCCQOWaiMWLWgGFUCgaKX6cM64td//eZP6/9/ZJsApWBufK46BLSNvnm/TgREWOmqpvm
         4sCHJPXeQkI/sB8KXNtvJ8xrT0FUlLG36OaiFlkMZBS3jy+J4Qn4fPUDBFEDLRDY2evD
         sgXVOIZkKBxuCjiA3s4idi3L7FQ8ZicGGgh3XIKyqBd+xdK3sArRC4mgukGlHLYISskF
         cOkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=L59f6N/a3yWmzrdAG6ejPSTgLStmVPx9Cs1jpRvp2rY=;
        fh=1mRPMbksfHFgy55IiLUvFSp7vEdzPe3kwmureQ8Mgx0=;
        b=e+/jYm2CuyZ+yAXDwW2lFZxjOEIfyYhMK3GwQOkWHMfPaelO3cDTvNzvenW6Wy64fX
         /5dkxjwYHe+JJ5QDlCqIrF8zO4GuX+8yfJMjM/Kc3qIBt74x1LnO/lA3Za2hads4iFfu
         mZCGW7G/NsSCYVBy386Ddk2CLGQ7HeC0lPpRgQJ/64STyK+lxsrXbn0V7Xm/du+0jSjX
         iDFaBYm1MODKIyoj/8OUfrAkJqfaZRp4AMKr0GQjmmf5K0xvGgTRWR3ffel6aS713dZq
         GxWOuTDQd9JLbRGDyKNZCpf0AfZh386UMuE6R+6pSaqWpH5NyCsc/gwgfo/1skwEtFaS
         583Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784749827; x=1785354627; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L59f6N/a3yWmzrdAG6ejPSTgLStmVPx9Cs1jpRvp2rY=;
        b=YeIXLrM4K4HgxBCvURWc8JwUoFLnuTm31u0ZBw1QqoSyqXcCXd1B/ilcUDzWDg5437
         qjmIgvAvp9KTAatdM4wTzp53MVqpI6Iptu2xH2fvHG1DdIej/dRvcM/RCnWLDC/9KOuM
         1jqvVvWr0EcNNv9ol/xRweVpHmQO38bdcXge+wQDEYGrAqDjX6goVP/IyBdSht0NdeTt
         p8wiKX5yH4XTkKkZ96PP/zLgXuGb6N2J2Jrg2rMJxbfZY5RyQOwvpINnQIn9D8DGaDMf
         DK8TgMX1Av8WtyC7nH+87La9CI4wxSGfOh1IkBiAlrrbmA6kCXVtqYIREDD8aUaDidPs
         diqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784749827; x=1785354627;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L59f6N/a3yWmzrdAG6ejPSTgLStmVPx9Cs1jpRvp2rY=;
        b=ordUYQc6Nu7wXdC6XZPs7wRRQxjKyI6ZIUa8xA7HHtUKLTU9oQ1otz3yvah+YDhXIr
         gS+dkgGymWTOSjgXae23DydhDvJfGJV/iPf53ieuoaBR14kmnrrvtqKoF0enZxAnNYqK
         SbCkoz+eu/qVcC6BMOb1tqSHHIeC0VXJdtyK1WdC2E+NaB9gkGF08vSkyK6Wu98B5BPs
         vfqQepoKEqqvIwyHAZZzbWnbACAg6YkYJZvAwnTFTl/epxp65q0ZkMYPA9neTcqhmAG/
         UOBXNFczOzKP6ghPHpfpDGG40MRXnc609PJe0F5YP1RyLk7N+HyHbpyz3UUXG+eiGd/P
         JFfg==
X-Forwarded-Encrypted: i=1; AHgh+RqVKIJKG2FaC761WA0Juq2ZhAYJ1nAToaB/uC+6fCLlcR0nhwOatIBd/0jcfQWaUaubHac/IrdiQ+oA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx310j4sJuCvt/MdifJlGIXKEAeQGWYX80ppzpQG9872IvZzZMp
	VmuKUd8AP26oTp4/w0kKGxKfQaWfk5VAUERPFIuaGTUtviK0kHTwtZULch0jjSpA4g33emm5mpi
	C1KGqr/GaRDE8+iNxbp7V8zBG8lgumoEyqWaJITFS
X-Gm-Gg: AR+sD11GB8OCf1IVTJpwWIqJkpoHxP5J7bJOha+5uWi7hbJOCmjnsKc21aK22cuH0TE
	01LHG96nXkB0LiCEcq1nRJDgop/60+U0/C2ruo83v0ugEaC5q0vO3HDrz2jOFwbVvHEwbXsDLjz
	jQYPdH8WaGQyG26FseuF4e4TNON4XH9+6yddUFqZ57Y/FCVShkm/RKR3a5Kiws4GhWoxO6ZzWkr
	gNJArQeg9ZfqfMe7w9vPklC+ldeSojZihPoX/9dRSpsjfyaP6bo9N1Tq8mo7QI6F7L5yNcr1H3Q
	lWcR3gdLFgs0oO5jKdtjKArXcAh9OyBIGLvjp/nK/j8vI/TP51TzajgPlaHoURq5ZTUbJJ8m52B
	kcePoCVBJBvZa5rdgnBP0wJpOfJjd
X-Received: by 2002:a17:90b:518c:b0:38e:b3fd:d582 with SMTP id
 98e67ed59e1d1-38ec6657a87mr93881a91.39.1784749827092; Wed, 22 Jul 2026
 12:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722185841.449934-1-mykola@meshstor.io> <20260722185841.449934-8-mykola@meshstor.io>
 <38c44536-51c0-43a1-b83c-b94915890aa2@deltatee.com>
In-Reply-To: <38c44536-51c0-43a1-b83c-b94915890aa2@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 21:50:14 +0200
X-Gm-Features: AUfX_mxD5xjrC5SGVG19NWXUUrwiVViRlgsz7kddupZQwNnofwkXgV0KRRHwCnM
Message-ID: <CAPzsNDtmEFf2uyJr+gSs4iw_E+LYiH5+3uojxhGMYKYku+fw+Q@mail.gmail.com>
Subject: Re: [PATCH v4 7/9] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Maybe drop my authorship from this patch.

I will do in v5. Any other changes needed?

> I'm not sure I follow the point of this new comment here.

I will drop the comment; it means the failure covers the whole bio and
won't change on retry, so we record  whole range rather than per block.
