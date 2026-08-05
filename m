Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF89C37881F;
	Wed,  5 Aug 2026 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785942353; cv=none; b=RjrYtPE/G+0SLPbBfmkzbGlzLeO3A2tjdo4l4RW3aIhJ0DGteTvHpC8nbILT9JQZIZbhS3O3xuhg42D6KlW1J4VCiN14rfVVsDC4tyn0/UTEwhRf5jU1f2u6rFZ9/ygHJVsXaWyUFmzDu3S1DNzgcU02aGnhGQ9T34sVkG+V26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785942353; c=relaxed/simple;
	bh=//w1IcMY+aTjw3WEN9HiCL3TEl/fd28MIrPyFuhcsTs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Nlb4E10uf2pwRwBMwO7X3C9vjYS0Rinar1tqJ40yxbXXSgg4QuzIhZ2nhaAlGJDrXkyPJRHhvJS0NQsb81536aiG/iHHNY57dUBuFqpocob5x1zCw9c3h8/eL1XYl6wUmihPYG5BuDgqN9Sojs8bx6Tc0Oc4q635spMO0xM/zCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9BZ+O6J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9BZ+O6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDB61F000E9;
	Wed,  5 Aug 2026 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785942351;
	bh=vaXfEcO4LBoLj41Awf0nQTRo9X8NRHo2gDGmLJSMVxg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=I9BZ+O6JL+KsjIcfO0E0y/ujrMWTil4OT1WusoqVyzP8hVked0pqStdlS4IC7dLVs
	 7pTLn6f9XVgFyQCl/uQTRI1mFO2V+xXq+jvqKuhj4+1c8Hxg8Keftn2hVmphbwU3y9
	 AAX37Ad/UM36/ctu486+5saDC7AKcMqmQ9y1AGVjWwk9dXJniQRPSZMAf9xrqHyW/Q
	 EfXNN5LHWE98i/GN/6E1xvOKoTKvEl1MuetUnlsDLkhs6lmOTKXaWzGRPlIwcjigaH
	 tENa0+TsnU8DQfOayAphMryfjN2NjLI0ivmd9JW4ZGTaL1o1XPvLvcTQjGPh1s6LMi
	 oeFJN8ZAsvzSw==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: bvanassche@acm.org, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260729093203.1503201-1-yhlee@isslab.korea.ac.kr>
References: <20260729093203.1503201-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH] RDMA/srp: fix heap information leak on a truncated
 SRP_CRED_REQ
Message-Id: <178594234881.4143885.2201729230389309180.b4-ty@kernel.org>
Date: Wed, 05 Aug 2026 11:05:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 29 Jul 2026 18:32:03 +0900, Yehyeong Lee wrote:
> srp_recv_done() passes wc->byte_len to srp_process_rsp(). It passes
> nothing to srp_process_cred_req() and srp_process_aer_req(), which read
> fixed-size fields from the receive buffer without checking that those
> fields were received.
> 
> The buffer size is max_ti_iu_len, which comes from the login response
> and is not validated. A target that advertises 8 and then sends an
> 8-byte SRP_CRED_REQ makes the initiator read req->tag from beyond the
> end of the buffer. req->tag is copied into the SRP_CRED_RSP and sent
> back, so those bytes reach the target. SRP_AER_REQ behaves the same way
> and also reads req->lun.
> 
> [...]

Applied, thanks!

[1/1] RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ
      https://git.kernel.org/rdma/rdma/c/961ac0f0c5e414

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

