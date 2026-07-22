Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9098B221DB6;
	Wed, 22 Jul 2026 06:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784700960; cv=none; b=jL47yHMEsJVL8Gu6ZEkAiXCe7gmijovf/2c1xuDeHcGOYsL6vcvKLlcHMUlUMR+TUcUs/XkQ36kcHJyX0gtDSqU+G6aEwP4YAs4qwHW5ccKgxU89HKj71codPBhE5lCOn5jw0/8zlfUDjMj1rPCbUlxmSEiTeP/M7uABr1/Bi8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784700960; c=relaxed/simple;
	bh=bXaZHpjqVLdb0AfQWNiKeLwsbOuIHfDIUKWxFlCcyhs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=G4reS7UJnY1Rs/KDEDi0j35+ruGexNRyxFyXi8BcE9+ZZQnWBIRmok8v+LkAFuSdUpIgffCni6abZLl5j0XMMxlkDdcACwJHT9YrbligA86+/prbh3z97umzSGexBn5EL/zxIzwlzotIzDLg5GKHK9e/KS5bf5WkKoHZApbYlBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rlo/7k1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rlo/7k1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9367C1F000E9;
	Wed, 22 Jul 2026 06:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784700959;
	bh=2gcxC+q2wB3MELBfIWeQ+FEFbvTiKQ5ZmTKWGSceVnw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Rlo/7k1DkGlijX/CEkcyPw+IZhlQ/QYEtrt+Ms6wo1NyPiXhFIKWd5fiI89wvn3wg
	 ftdL7uB+Y/2aEB+HY1YAuCf5pxcThCnUYKQHqzmXRCrVdceVujCI7rSYlALTgIHphk
	 X3r2xLKO/H6p61KgigHu592H9RXoQiIzYof8lC6mH0nns6YVEuZeRmVYdF06zloccA
	 bcSrhMWjifAlTcsu/5gCNmz9wr3cjUENMSBOfw/dTLXiweYY76oRRQ7rJCutt1oXFY
	 02zBuBMm2fVm5MQ9tCN0ClEaUbGlYDwMt1+2zu3Slp0qxQU3i+QzajaSu4oaN/y9T1
	 UjC49KYsAL0/Q==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicholas Bellinger <nab@linux-iscsi.org>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260721-b4-scsi-ordering-violation-due-to-hardc-v1-1-07205aab71bb@nvidia.com>
References: <20260721-b4-scsi-ordering-violation-due-to-hardc-v1-1-07205aab71bb@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Pass the mapped task attribute to
 target_init_cmd()
Message-Id: <178470095626.2740144.18166564217348824321.b4-ty@kernel.org>
Date: Wed, 22 Jul 2026 02:15:56 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 21 Jul 2026 12:10:56 +0300, Leon Romanovsky wrote:
> srpt_handle_cmd() maps the initiator-supplied srp_cmd->task_attr into
> cmd->sam_task_attr, but then hands a hardcoded TCM_SIMPLE_TAG to
> target_init_cmd().
> 
> Pass the already mapped cmd->sam_task_attr instead, so target core sees the
> attribute the initiator requested.
> 
> [...]

Applied, thanks!

[1/1] RDMA/srpt: Pass the mapped task attribute to target_init_cmd()
      https://git.kernel.org/rdma/rdma/c/ef63cc44170341

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

