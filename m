Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B230E29E114;
	Tue, 27 Jan 2026 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769523615; cv=none; b=pXoW6lxUm/qsosZgXWpYjWYHx33I8kR6Cla8eEWT2aNeKdvDm31wio4S3Oy3bFftJ+Q74g+ML+mvI5mQikn0iAG8WiafcYJA+CNej5WO4O/SOc0PaXWCPzo5zOXEbqd5vQuLyPzdECCMZGpECe+HAtsv4KcnQYwplxn8wKhhggU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769523615; c=relaxed/simple;
	bh=5/BIwDjsuMiNJM2ybUWB4GvMU0FnNdBhO4rgbB4iTrg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=soxr0qcFIAhfrCwuzC3l40Xgo26DQ7jbHRFSSo+kyM6/5mDiM8TQIKf4WyhHDJ4mCsdO64QLn5Anw3M6TkabsMi4dF0Ir+3a2jdwH63I3MMd86nQjBvpN45JL2utao1jb9xtugrFhzwtg7TFcM6lSgxGZOrMNHccL3XrGujK4Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQovVQGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQovVQGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E159C116C6;
	Tue, 27 Jan 2026 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769523615;
	bh=5/BIwDjsuMiNJM2ybUWB4GvMU0FnNdBhO4rgbB4iTrg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=OQovVQGwPz00xRNOjkBIqX7kTtGJO0En6REya8c2uDYIyX9UKefwDF85nyj59al0X
	 gObyK60ouviEYbcOKFdNB6nvNcdUPYvwGqYN/D9TkJGn9OBuKbOzcAnmUmDUxXHT/9
	 /49ArINJKxZr1CcQxVwNNUR8m4s++pX1383Ogi+7wwd30SVI9lp1W9lx5PaK0xqD4+
	 okdQrXw5TvIZpRavMpKWmUCEulwHuASDHZtlxuyi+Hfklfys5X1exQp1+o4eVpF/LW
	 zXokxvPVnXIz96MNNL9/Mexxy8YYqXp7L5bd9khgpQGAIXglcbmoB1LCSsjhkL7R9z
	 9UYXfvJEAbjuQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
In-Reply-To: <20260126074801.627898-1-zilin@seu.edu.cn>
References: <20260126074801.627898-1-zilin@seu.edu.cn>
Subject: Re: [PATCH] RDMA/mlx5: Fix memory leak in
 GET_DATA_DIRECT_SYSFS_PATH handler
Message-Id: <176952361266.919365.7397232673824655302.b4-ty@kernel.org>
Date: Tue, 27 Jan 2026 09:20:12 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Mon, 26 Jan 2026 07:48:01 +0000, Zilin Guan wrote:
> The UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH) function
> allocates memory for the device path using kobject_get_path(). If the
> length of the device path exceeds the output buffer length, the function
> returns -ENOSPC but does not free the allocated memory, resulting in a
> memory leak.
> 
> Add a kfree() call to the error path to ensure the allocated memory is
> properly freed.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Fix memory leak in GET_DATA_DIRECT_SYSFS_PATH handler
      (no commit info)

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

