Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3779A33B95C;
	Mon, 13 Apr 2026 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776091321; cv=none; b=pamljmHlZ1uRJYjJNYbYdA/fb7ASATvQP4BjZF2ZTNTGWtKGubQB18bQ+y0nM1EoHLzCZRsnU0iHylmbPWyTQh3bg2TwYshAEl4bvakci9pjk3v03ZbxIs2SRhets7L+O71G7JgGmbqMSJ6jTv0y196JITfM1vJlgE1E5woRCQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776091321; c=relaxed/simple;
	bh=6o6h5fuLccLhErJw7xe6EUatryTFXSRVrXMrYjd4sW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eypZYwdkQfHA59b1SjclkYYBZr8wHQDSi+sH6RMece8SfksDecPlBo+HZLKshrOgPXzH69OcHpwDTAjR5eR1TIglNUoVibGIqQz9gLfGcpIBSsOyOd4Tn6NAwPOy9aFVQ8X0+vIAX0BDMseSUUwnZsFNy2nYL9htcJd/ve2jtQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3HEiTod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3HEiTod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE1AC2BCAF;
	Mon, 13 Apr 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776091320;
	bh=6o6h5fuLccLhErJw7xe6EUatryTFXSRVrXMrYjd4sW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u3HEiTodrVVhaJzTIM3hkpo+hjeY/AkkdrfYIL/tAquc5ujZVn3kSXs6lXOdsqXPO
	 rkEp4Su2WA+Qhs3XEyt7M/Hoq1CbV7BNXKABjD5E7YSlrYuw+i9F1Iwny8ziLM4BwY
	 kZXA/m6rWdZXNesrF8WgUeUwJh67iojPsnx6qz90/jHzxYSTIbsuTbrmxl/Bx4PzzM
	 eYrrZP7zwJXe4YV7TcjlBYsdeAZBJwj+578OWSlfed6uSO0zIHvQ+J6zs7CWnQN2cU
	 19DL2RInMaZQCcm0D2rr6JoiJCu24TI22R7BFonqiXtxpU9EkkIr/IdH2PxCANlpvD
	 2TjLqqevolIxw==
Date: Mon, 13 Apr 2026 17:41:55 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, dledford@redhat.com,
	haggaie@mellanox.com
Subject: Re: [PATCH v10 2/2] IB/mlx5: Serialize force-enable state and
 preserve loopback accounting
Message-ID: <20260413144155.GI21470@unreal>
References: <20260412011942.13744-1-prathameshdeshpande7@gmail.com>
 <20260412011942.13744-3-prathameshdeshpande7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412011942.13744-3-prathameshdeshpande7@gmail.com>

On Sun, Apr 12, 2026 at 02:18:50AM +0100, Prathamesh Deshpande wrote:
> force_enable is shared between MP bind/unbind flows and regular loopback
> enable/disable flows. MP helpers updated force_enable without lb.mutex,
> while regular paths read it under lb.mutex.

Yes, this is intentional. During device probing, a device cannot be treated as
both MP and regular at the same time.

Thanks
