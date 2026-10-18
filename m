Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C91049892B;
	Sun, 18 Oct 2026 12:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792325851; cv=none; b=HAAo/NU3OIVJvD6wVXSqFSLMP9ZIK5KjEG0pRNhp513DXy4NiFuKsM8NacC03fjejMz1X461Ib0ZyaPDz9Ee2gwa5Ba6TjCDahBh0hBkUA9G//8LXKDGJQCbdHhc34/oqL1ORX2x//NG7jpPlbv9cglCU5vnRkJ6Pd3Tf7TJEMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792325851; c=relaxed/simple;
	bh=bXbvlW+ARV1j/TVYxVU7cw3Hox7ScJJUpiFIIh+7Sss=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=U4Ds7tDXJ0bC+YtcDmkbxsYNaK/FXS1PHiTw0QZLcLOhMh+yFW9Y4MygQS43yEAUZPrkSHberb5VDqTW/oA7muvv8kScqE6ymMncvBaeFm3eUcargj8VogVjmCmi0bp9HW4Rw9gHul4rJWseSLk9pk06jTVsTGE0nMnmpPsx7mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUqc7g1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUqc7g1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72511F000C4;
	Sun, 18 Oct 2026 12:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792325844;
	bh=f6Q+HCrafoGnDVwH6z0zMs6eZpvDdr0q0SzWeML3oKM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=eUqc7g1r1xxorOO4YvZaow3U610JN7tPaWSboPkxC7SNVkswvecK92m0+0anYpg41
	 HYb4nOl9pqZeMnyG1YAwLUtPWNktA4znJ67i4gyW3Tpq/3gXowJVHqQLi2eBlWXuUb
	 1m92WpSAR2l8/9oKDNAsreASOxILo0lZY7DMHBD5G5vFTHWOluPc28mOmSFwiBLtA/
	 aGA8AqmBU++1Hc/zwGwlECOq8/RceqhyYyYAcRb3JsR47h2fB0CV140i9ZPyHgBTf5
	 EQ5SdEObQ7AR5Fm+hWFG8w0HBZToFNNUqbZQ40WzBsdz0/HOt7B5PVbuKd2hcNUAaC
	 LUR3HJZsQH8fw==
From: Leon Romanovsky <leon@kernel.org>
To: Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-rdma@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261016223935.1496846-1-robh@kernel.org>
References: <20261016223935.1496846-1-robh@kernel.org>
Subject: Re: [PATCH] dt-bindings: infiniband: Convert hisilicon,hns-roce-v1
 to DT schema
Message-Id: <179232584167.21056.6053695100206918948.b4-ty@kernel.org>
Date: Sun, 18 Oct 2026 08:17:21 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 16 Oct 2026 17:39:34 -0500, Rob Herring (Arm) wrote:
> Convert hisilicon,hns-roce-v1 binding to DT schema format. It's a
> straight forward conversion.
> 
> While generally '#address-cells' and '#size-cells' are not needed in
> leaf nodes, there are some exceptions. Not sure if there's a dependency
> in this case, so leaving them in place since this is an old binding.
> 
> [...]

Applied, thanks!

[1/1] dt-bindings: infiniband: Convert hisilicon,hns-roce-v1 to DT schema
      https://git.kernel.org/rdma/rdma/c/d89ac72bd2deff

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

