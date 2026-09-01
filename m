Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8959647DD4A;
	Tue,  1 Sep 2026 13:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788269310; cv=none; b=CEpM0iJUFcD7grShSx2YDUdwaLYBjMM8RAGU3D/oXzueNERmTtsECYFo806LARhOA+hwlrtj7gdXhg1L4vx/cWQ3Pnw35ke6KWQQ1lTHY3VzlX+V+dRFEFBV2MuHFH78C8TS/AOo6VgYcgiqJN800s9o0MuNWzBED3eZZrMT/qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788269310; c=relaxed/simple;
	bh=Lu0k7sjYQHHbQ2m/WT7qCYZW1SWPxZMolX6nsjpwv0A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TJPW71nMmjSQBz6us+y82SqftSA1PM4pzHknmxOw71N3Bj8wv7mmU+gul3UAhY5fsq7oicobW/suUouwq5WrDQs9fgWB4dLJCpWsiuitOGGqDz4yMttA0Atbkl8xQzIRnVbt+UHYzqDhIjR1WnyIRbmVEp1U/EBIi2h84+m3re8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzDXCcxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzDXCcxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA57C1F000E9;
	Tue,  1 Sep 2026 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269309;
	bh=zN3XYf0D0kctUoOKLG8Di1BW/gwrgOKCubyunL34Y0o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=lzDXCcxqOTOslXKesTHnHBaljHgBFhe7IB7Fz8F5Pf2DHiG1be6jcSukjTPJPRicp
	 tEeVud98jDAYWAihpHo69Q2ptZiZSu86ez1s6FXezRx4EZ0S3Hb6yBvfcbD3QxhuYu
	 UY+feIrmn+e321kl4Gv8zMI127mhGZno5z7nyoueX1bqJpv5pufs638mqSZ53IKDr4
	 03AZl88aePSwP1bozBvv2Qkmo3yr8woJ1sv+YNanf2XpWMJhoUs0JVhf1ukH/7Gz3R
	 6p0K4FkagLezvjTTjJgv0vkWmjD9ddT1jP2qcoYcJezYMnWaYO4ac+vhxjXVXMxKlc
	 f62sm+yKiy1Sg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Or Har-Toov <ohartoov@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Shay Drory <shayd@nvidia.com>
In-Reply-To: <20260811-remove-warn-on-miss-rep-v1-1-eccf399bc6af@nvidia.com>
References: <20260811-remove-warn-on-miss-rep-v1-1-eccf399bc6af@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Remove warn on missing
 representor in query_port_speed
Message-Id: <178826930675.1340197.11507310539690943779.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:28:26 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 11 Aug 2026 19:25:57 +0300, Edward Srouji wrote:
> The representor ib_device's phys_port_cnt is set to the total vport
> count when the uplink vport rep loads. Individual port[i].rep entries
> are populated only as each VF/SF vport rep registers. A NULL .rep for
> a given port index is therefore expected while VF reps are still
> loading or haven't been enabled yet.
> 
> Tools like ibstat and ibv_devinfo iterate over all ports of all RDMA
> devices. Some ports may not have an eswitch representor, causing
> repeated dmesg warnings when these tools run without a device argument.
> This causes dmesg to be flooded with this message on every ibstat
> invocation.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Remove warn on missing representor in query_port_speed
      https://git.kernel.org/rdma/rdma/c/2be77295316c2d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

