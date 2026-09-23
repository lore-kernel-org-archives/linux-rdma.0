Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8146A61D;
	Wed, 23 Sep 2026 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150912; cv=none; b=M4Jwy+6pAzjOHxGI82JCkCJcmEgC0TcpjKmAr7fpfIKTlOnbCsx8jiUw0azGKCD7i+9C/WzLfrP7zmhdsSzgZxUsiPiu4fkpruOX2flKo2wJiFmY/OqqYitbHSugfpwC6gmJYyknnjNleoMCVpVsJOh8BU8LWZmOBzvuyWLs4IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150912; c=relaxed/simple;
	bh=t8/hxgedctI0Dvsf3hKWNfMQNSkPUJj6HY7c+tYblIg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m5N84yfu7XFdG3rfZ1pUWT934ADiXIgH8izr2CaSDm41XH0mt8lALx3Qvfa4IcmQvGsFJUcPlIS+7GRSnf085201vcyWQ4YYXR8dIZ/40Zjdu+dbt1YhKTeOR+4IdvgfhSdVB7bxlwJg5UBZ8kC1VOFUrxDXoDI9C79rFpj/Ep0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrlBCDGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrlBCDGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C7E1F000FF;
	Wed, 23 Sep 2026 08:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790150910;
	bh=e1T1y48cEgwmJAfaUoutpuHvuSHo1mQtRYEOTbsoU1g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YrlBCDGeSuQwhnhs5FCBSQHfA41wUR+Qs1ol+aQEd7/MEx1q1R+pePNgNGEhQ9HkP
	 upRWPBnBqiGAjzbxhMi1kT/BZHmNH+oyCCAiKSbxjJxy+QOr4ig2HDcE7PsGrnuWDR
	 bkIPrdCq8Fnii3TNRlPvPPkFHo1+59mXYgWsDumy7ie40zNXOV3dGsl3TCcqRizrIT
	 DSsPya7PZtq18YQ0POUqs29vTCN5gtobn8lrhnbPLrOd289lyGZbJhynsn0SO13E8W
	 Qe7p3Js3MzqgKwZqTslTFVWyI9dA8tMveww8Z2i2K8yJnFN54GnCEe/DFmNrKGQIcT
	 ArPBRlo8cAkZw==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 markzhang@nvidia.com, phaddad@nvidia.com, stable@vger.kernel.org
In-Reply-To: <20260916183921.2092821-1-vulab@iscas.ac.cn>
References: <20260916183921.2092821-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH 5/5] RDMA/mlx5: Fix RQ resource reference leak in
 mlx5_ib_wq_event()
Message-Id: <179015090740.3392134.1949790134082058932.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 04:08:27 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 18:39:21 +0000, Wentao Liang wrote:
> Since commit 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in
> workqueue context") rsc_event_notifier() expects the event handler to
> drop the resource reference taken by mlx5_get_rsc().  mlx5_ib_wq_event()
> was missed by that conversion, so every RQ event leaks one reference,
> which keeps destroy_resource_common() waiting on the completion.
> 
> Put the resource reference on all exits of the handler.
> 
> [...]

Applied, thanks!

[5/5] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
      https://git.kernel.org/rdma/rdma/c/65f3eab4319444

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

