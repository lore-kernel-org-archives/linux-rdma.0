Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E309D497397;
	Sun, 18 Oct 2026 12:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792325909; cv=none; b=ndSbAkh4A3VPBWCmJSMF2VnbZ41aw8cn2gjJOeQEgS3JysohabsPyTp+h5/9KnYxa+WC+PAO0uhxWjALKaMdtE/+Qv+6Ud2PRsX3h0D2mgOIqBW1pqRR7i89fKRpy49LyWXMQOdn4LDu3gS0P7E7L1cYIJf1kOHio/3z2OswjgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792325909; c=relaxed/simple;
	bh=JzFKbODBCqDITSYuKKMi/ioeCQuhBxzidDm8OGH7APQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIw3Mu+/I/uK4WWJP9Wh1DSS9lUDDDw1xUqhVeEJeGfbCznPcUUOTBQmciKdcQ8q7OyRTRv8c7SH5Cf5QgrevEJ7t366ulL7CreTdzIyxuRH0CwMDRLywdJlFqnDNG0OMz7pEa+JXvT2BbGLET15eWOpeF1+hrGNmzaeRv7b/IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGX9jNAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGX9jNAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52271F000C4;
	Sun, 18 Oct 2026 12:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792325904;
	bh=hccCCx/tW9VKP49Dniv/sGPS23PNohQsekM5NC4RLN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aGX9jNAVoq6Mfx1fP1oK9Mfs+FGLVirxgSTm/LIFveyusaXJcXDnAup0KxeShoTa4
	 ZzcORTG3rQCBU7SavMAx+9BDTuLzDh4wPwBrhN20qsepbjPehpioMnxdUMe5bejtQ4
	 RN0ecq4JhmBsZT452zCLQoVc3KZY4v1B8In2qQbdYLUy7FLFH6H/EHMcDZ+QBoMI+p
	 lJZWt4E8oUYi/0KhqYV2ZN/esJFYYOkJIT6/zV6a6hvS7how4HyJhlg6nIQFZ+sTMN
	 oVvMNSBfjfCOgC1e9rTUDVxr7M0ytCm0PFAi0Bly6fmDhlSkAILiLFTbl5kOD+XoSM
	 hlR8e2YNxuUHw==
Date: Sun, 18 Oct 2026 15:18:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-rdma@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: infiniband: Convert hisilicon,hns-roce-v1
 to DT schema
Message-ID: <20261018121819.GB64621@unreal>
References: <20261016223935.1496846-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016223935.1496846-1-robh@kernel.org>

On Fri, Oct 16, 2026 at 05:39:34PM -0500, Rob Herring (Arm) wrote:
> Convert hisilicon,hns-roce-v1 binding to DT schema format. It's a
> straight forward conversion.
> 
> While generally '#address-cells' and '#size-cells' are not needed in
> leaf nodes, there are some exceptions. Not sure if there's a dependency
> in this case, so leaving them in place since this is an old binding.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../infiniband/hisilicon,hns-roce-v1.yaml     | 173 ++++++++++++++++++
>  .../infiniband/hisilicon-hns-roce.txt         | 108 -----------
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 174 insertions(+), 109 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
>  delete mode 100644 Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
> 
> diff --git a/Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml b/Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
> new file mode 100644
> index 000000000000..d987840f417c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
> @@ -0,0 +1,173 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/infiniband/hisilicon,hns-roce-v1.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Hisilicon HNS RoCE
> +
> +maintainers:
> +  - Chengchang Tang <tangchengchang@huawei.com>
> +  - Junxian Huang <huangjunxian6@hisilicon.com>
> +
> +description:
> +  Hisilicon RoCE engine is a part of network subsystem. It works depending on

I'm not sure what this sentence is intended to convey in the RDMA subsystem
file, but it was before your conversion, so let's take the patch as is.

Thanks
