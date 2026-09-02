Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293AE3A83A8;
	Wed,  2 Sep 2026 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788353952; cv=none; b=IbDpJTSPJ4b+JCYqdUZfb+SD5ypJvDciTVSA19tv7TIfBDglgy1yhX3G7BTDW7HLNIzs3fiCUmS+fw3QX/v0hBM5M4DXXM5fgDw2JHy/J2PRQjADtwgSHlSKjJ0NqI/3LQX5OWYchD+zAhFrwQGGT5rxDZ6dNPUNSm3tRrUk2X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788353952; c=relaxed/simple;
	bh=dlu+G5N0rLiUgaFmkUsCU76BkL25uYsMQL+sKXGb6x4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aLQ5QO6gkYG22sOaka6HBcaT5NxgKBEh19/wUS70aidQ7IQDxJJuujOdta7GdNuwv0JTmRucohoFQXGPpMOxHL+i+E/Obx+PKF9+4ENDIDp3MO+HTI2EcGShMuQzDVjYoupvmK83zpUakIuKxDKapIljt3P3FrVVd5zJLia9BZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIsQ0zHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIsQ0zHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7281B1F000E9;
	Wed,  2 Sep 2026 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788353951;
	bh=fw2l8OQKEt9/APsq1H1chBwWp4X6fUlHwraagDsilZs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=oIsQ0zHO+ed06k3DGbl+vJMgYc9/qQDmkupfM8Gw1F/plqgLG+IdUxrm9YwkXW8fF
	 mn6P6LEY35szwW7YmMT0+XKgXMO6Jy+9r+RfRI/umejRv/Au/qVgzD9qlF4l1NdkjU
	 Ev3HPKmq8moFr2ohR1DRF08obNp1fxDMojdycsh0SsknUQvsReIsX3JtTogouLaTVt
	 iGwGlw5AKIkyZbJP74emKLkWVM01iSSAOpIattLy1FAFMjW1M5JaC6eQRYEv/X5nOw
	 SygA6UEdAXn6pqriazxd6+XTIsXsgq8dwM+3yccwSz3ZgBdP7hAUblHniZX+gwS2La
	 s2HcarfZpYmNA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: bvanassche@acm.org, jgg@ziepe.ca, linux-kernel@vger.kernel.org
In-Reply-To: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
References: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
Subject: Re: (subset) [PATCH v2 0/2] RDMA/srp: fix use-after-free of a
 request in srp_destroy_qp()
Message-Id: <178835394804.2431629.13448768133099421237.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 08:59:08 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 18 Aug 2026 12:52:27 +0900, Yehyeong Lee wrote:
> Bart asked whether reordering srp_remove_target() also fixes the crash.
> It does.  Against the same test target, the report appears in 5 of 5
> runs without his patch and in 0 of 5 with it.  The drain still finds
> the same two completions; the request pool now outlives it.  A
> conforming target was unchanged over 5 runs each way.  Both patches
> applied together behave the same way.  I never reached the SCSI error
> handler.
> 
> [...]

Applied, thanks!

[2/2] RDMA/srp: Fix srp_remove_target()
      https://git.kernel.org/rdma/rdma/c/9cdfad5dd5529e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

