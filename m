Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC672395D9B
	for <linux-rdma@vger.kernel.org>; Wed, 29 Apr 2026 12:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777466317; cv=none; b=nsUEH17z2o/Cd/igTOu94W5KOhsNenaqW/23C7oLqbFNjWdfkbdcJ7rzITAoLhmj64BEtN1HAQztgfDEp8IjgcEHP9aRnkxXSHMLExlHwQLMDp8UicfbbBs1bF5zOcFeuqPjjnWL9T0lvVRkgXdZ4nzl2XiznniR6zacd+vLjDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777466317; c=relaxed/simple;
	bh=iHpwmB+CfCrQfHyCjFRN8f9V0Ieri4I2YDF29KI4xlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHOEnloBufEEK3g7C8Rr9yJvIlMGFqBAloJpEIxUeoaGuj6ds3+PeVP+Kvec+A5NIDVOlx87VSN5h3zk7h66xAcNDaJOj09UAtjjsK/2OIoLHuOiwBcVq6sxhdiISD23gkCbhYbj/tJN4BppX/66P3lM/ukm5ncaWAQZiUFhBeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XZiXlMAD; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XZiXlMAD"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8aca4e14411so147735086d6.3
        for <linux-rdma@vger.kernel.org>; Wed, 29 Apr 2026 05:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777466315; x=1778071115; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdHydDIb/tLq41hFtrRXORAUmUDG932baR6SEs+aAAU=;
        b=XZiXlMADd2M/GyS9WyNc+MXVh24xVPwDzCyakk22sstLYkuQ6hUYx4aNVtUPJH9hL1
         c261gnA1YL03B7qBDeY/v1GMKmeHkRiXcPxEFOXmo31Xtyxv5Z4vkK/2RNe/EwqkGxta
         +EEBfxzVNnWKReHIdZ4RhSYjVMWHxVi4vJ22Dki5OQpTVU6X1uaqLrN24aXXIMGzF4BH
         jVcYrqVVcat57pd94f+7Zt/fFVN+D4jQSW4Jc4q0ScvDheClBZxprODFXRJrMCbD+2U3
         oHyLHSSRULKLBgFN6/4KB7OJBHY4vda6gXlHlVRITo8ktUdP6qIraCctgjvoYAzlj8ik
         KGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777466315; x=1778071115;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdHydDIb/tLq41hFtrRXORAUmUDG932baR6SEs+aAAU=;
        b=idYZmrZYGSufTh6qG31nXg4CcR/L/eH1+WfmPZt7zHCFe/JJD7CAoAdo/VpqUxJK+W
         W2FocY7PRTLfN3jmWcApBSrXEXAIwalY1GmM7pOdWSSr7mXyOCWd5JgTyoGcruOC+5mP
         LQCPo73s2avzMdLPpeGnx+8qaA19PnTui+tjOUjZX4uxewNBX8YAKrERphbkdzHUdRij
         nJ+e5g7OnUK/VNEdh6BCWaqakYpjej3srN9ThN2pBk5OJx7HFDZ8v7rnTtsu6C6BS8Pe
         vER9ByilOYhK572rd1dVkd/9b5wyy6ga/TAKq62YM3WAtCplvD8eqBabSvRZQ82FkZPW
         qDow==
X-Forwarded-Encrypted: i=1; AFNElJ8Vp9DweARLLuDKs8ZEjCELkHK0y8WEV4PrwqACwLj7nh+fpc084tZE0Me9tHyRYHHnEleIfx4qaG3q@vger.kernel.org
X-Gm-Message-State: AOJu0YyCj4h1tuc/xHJY5+OjpdkbABsLKZzw+6EQi9VTAsjPOKHCKvXq
	Z7yQGoNNz52GTmgBHUwVBBrPxVZGLnYgOA9PUkoU4jxrOxjzlumlaueMvu0ZwqLW2d4=
X-Gm-Gg: AeBDieuuc09O1tw64C80U5zTqYy29j3SNqsPZSu+Xzfysf74P21KmbeR18cKzz7ce24
	UM+bku00ITHQTv0aWoyxWC5hUq0k2IuiANKiPIYopdEqkgJzQXb9APqkpR8F70LwoMwzTPgZi3H
	6x5VodQlf2UoSUoff8swf/E1+AC85OKNv0sebOXG/4689PVXbdqRgQ5JdaWBIPBBBjVoBUGjHiN
	ct93xXP0cB6uMfp+PlWPfiUi7vr1+c52Go6ZMyaarQgwkj/B/oMp67dJKAYiLTbcEzpiGEhFM56
	GXlBaPkwKpy0rXvXfrIFWgeiNNZbI7+Cw5Sg0nloz/mLsjyncpq7LmtpohSHzZVfuieE126HOnU
	/PbKUGqcqbUSeXpcP4NOxh3v3bRkwQxjhMF9zu/ZiSgpo/tWsZwPpjUyM0NhhE7/2gS28WWpfcC
	pvwvgor2Zy8TTPiu8l5npCQ+IaIFR6kMjmFZlHqo4Ohd5aEpFu3Hh6IEQUTB/UJj6/G7XSF+V3S
	Nc/eAzptLu/LoNFkJ2S98ZMJM8=
X-Received: by 2002:a05:6214:4d04:b0:899:f1bc:c6ab with SMTP id 6a1803df08f44-8b3eddb9459mr46950766d6.42.1777466314720;
        Wed, 29 Apr 2026 05:38:34 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3ef6fbc50sm19588776d6.10.2026.04.29.05.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:38:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wI4BV-0000000HLk7-2n9U;
	Wed, 29 Apr 2026 09:38:33 -0300
Date: Wed, 29 Apr 2026 09:38:33 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: mboone@akamai.com
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] net/mlx5: check whether VFs are assigned before
 disabling SR-IOV
Message-ID: <20260429123833.GM849557@ziepe.ca>
References: <20260428-mlx5-sriov-in-use-check-v1-1-c7b9e18c99a8@akamai.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-mlx5-sriov-in-use-check-v1-1-c7b9e18c99a8@akamai.com>

On Tue, Apr 28, 2026 at 08:04:14PM +0200, Max Boone via B4 Relay wrote:
> From: Max Boone <mboone@akamai.com>
> 
> When MLX5 cards are passed through to a VM, disabling SR-IOV by
> setting the sriov_numvfs to 0 will render the machine unstable.

What? How does that happen?

> -void mlx5_sriov_disable(struct pci_dev *pdev, bool num_vf_change)
> +int mlx5_sriov_disable(struct pci_dev *pdev, bool num_vf_change)
>  {
>  	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
>  	struct devlink *devlink = priv_to_devlink(dev);
>  	int num_vfs = pci_num_vf(dev->pdev);
>  
> +	if (pci_vfs_assigned(dev->pdev)) {
> +		mlx5_core_warn(dev, "can't disable sriov, VFs are assigned\n");
> +		return -EPERM;
> +	}

*barf* WTF did this come from?

Grep says only Xen makes this true, so this is all working around some
Xen brokenness in their "assignment" ?

If people care about Xen pci_is_dev_assigned() should be be purged and
pciback should be fixed to not "make the machine unstable" when it is
removed during a VF teardown.

Or at the very least this nasty Xen intrustion should be placed in the
PCI core code and removed from the drivers.

Also, no, you can't fail mlx5_sriov_disable() it is called during
driver remove and cannot fail in that flow.

Jason
