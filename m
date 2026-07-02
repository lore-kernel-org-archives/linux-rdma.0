Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6537DE9D
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260050; cv=none; b=b6UfZ1BSjidPS/gJ2TZtL7QuLWiGA84NFPamffzJdl+njqVpN+4PMiIwl3JNy7ISEY3tQoEpsgal/uwjK6P0fGlX4U878cKhXuqvGT6JrBGQZVwdCvFgU1fiZQE65Hqiqz+smVPqAYF3ftbZGJoiphQoc6r6C9Svjn2i3KXOfbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260050; c=relaxed/simple;
	bh=qN319TXaeYmRwxOpSozB9Hh25fWAFiHQJER0/QXq6Rg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CeLalmkQ/IMjvKKYXWgP2ipeXuHxp+TD6GD0eFXJCL417EuawX8jCQymCcqpRF0AyBslDOp7LP2gBfkPnE4QzOzClOO/1Vr3PqvtltvLeE5eodBqCWNfz3b7SgRZ65CTXWMYk2eYp/iqZdVjxYZK8APYD6PXOWbdKmPwqKNHUyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpygdvFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpygdvFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D71F000E9;
	Sun,  5 Jul 2026 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260049;
	bh=j6DuzcmkeTZrSDbVGek4Zy6e7b5YCkONK9X6hz+hltY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YpygdvFT8UtYvoHNvgV+XD/SUv3Y5UgGGWBkNOKytI2Tz3piKbobbpwMP4MDOXvVE
	 12PyU7/0goGTa+sY2iTY5yBh61hOYtVOW34iZp2z1SiJtByozAvzlFLjTFn8hMXBCN
	 15pceuMfGvh6JvIOOgD1CSYJ5lCKDAeRGgCtTAQF/AL9Vf3h7AeVRunsRmdvQEe/08
	 aTkee9FgtUfnNtOUK4PZRWUsNKGU1EpglbVbIEZ+pNHGfubdWEgqao0RTYLjarhGJ+
	 LMl+ncKr59e6R3WyPTTeXCVNBiPfce0vTmYA+Ck9IKIIKA+hn83Mhk7TtNDDE46W/m
	 8loNu/WN4cLEw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260617141936.3280979-1-jmoroni@google.com>
References: <20260617141936.3280979-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next v2] RDMA/irdma: Prevent rereg_mr for non-mem
 regions
Message-Id: <178299386411.615406.2919527433922934520.b4-ty@kernel.org>
Date: Thu, 02 Jul 2026 08:04:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 17 Jun 2026 14:19:36 +0000, Jacob Moroni wrote:
> When a QP/CQ/SRQ is created, a two step process is used
> where the buffer is allocated in userspace and explicitly
> registered with the normal reg_mr mechanism prior to creating
> the actual QP/CQ/SRQ object.
> 
> These special registrations are indicated via an ABI field
> so the driver knows that they do not have a valid mkey and
> to skip the actual CQP command submission.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Prevent rereg_mr for non-mem regions
      https://git.kernel.org/rdma/rdma/c/a846aecb931b4d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

