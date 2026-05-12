Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4FC38398D;
	Tue, 12 May 2026 10:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582491; cv=none; b=dOB3giR55MlI+yiH0QVmDX0XCa8m2Ie4nZmSY7+Y3rpz0JFJORyRkD8PPteUrPEG0Qn8CIG/X3D/ASvpma+AQse+exzRhgQMA7Vhtxd984tY/KXXRIBY67mhyaQcvX2bs6UQvPEhPJrUtZJEm1jsiSP4jjfPFXJ3WIit6XOdnH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582491; c=relaxed/simple;
	bh=UoJ9DZYobAlGVmjJh7ijtxeOP8tMOKkc/vPcEbtldlg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jjI+r/UUfzgvih/mGtmg0W3aFWHJ/lePMWhEiTqYHy3wtTluXD5S1Dti9qLRWNvYFJANGXvOYhYlgq+zCYJ9PpneRDnEmXq/173+TndUpt3lorB8q2gw2YupshSHpSbhqPcp8Vty196G5YVdlTVW25qkTUSBqP2PStQH0flEKe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHcox8Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHcox8Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51406C2BCB0;
	Tue, 12 May 2026 10:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582490;
	bh=UoJ9DZYobAlGVmjJh7ijtxeOP8tMOKkc/vPcEbtldlg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=MHcox8AdoN5YeADzHWLhXDR3dzNx3GvmPwolUGANg1xAWld6VQWdRSIbKscBZi654
	 TLYzbOi5Dz6noOjMHV8Xman0sWd7kce9qVLwHyZKBsY6GzPPkrylGKvvJuuzM+Vmyg
	 FPdEDk6wXaBHm6E+2tC68iisER0u3oeRD9mvKhFopdLtcbzN5ElH5NY0YsExkaeedL
	 HqaAkfPyzCjuCipqhcXu/UoxJQWu3/SfNZ3W3Vl6++5WgFEwe3oo4JB5t7VjqeayE5
	 Upb0+0mhdkR7UfgXOc8MsrO5PCl/xbip3cu6rXf5Aqnt6H7qrXx047jlJI+Om8MC8W
	 RssGOB52/22KA==
From: Leon Romanovsky <leon@kernel.org>
To: bvanassche@acm.org, jgg@ziepe.ca, 
 Sara Venkatesh <sarajvenkatesh@gmail.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 carlos.bilbao@kernel.org
In-Reply-To: <20260504080036.3482415-1-sarajvenkatesh@gmail.com>
References: <20260504080036.3482415-1-sarajvenkatesh@gmail.com>
Subject: Re: [PATCH] RDMA/srpt: fix integer overflow in immediate data
 length check
Message-Id: <177858248804.2277752.12077743618929897915.b4-ty@kernel.org>
Date: Tue, 12 May 2026 06:41:28 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 04 May 2026 01:00:36 -0700, Sara Venkatesh wrote:
> imm_buf->len is a user-controlled uint32_t received from the network.
> Adding it to imm_data_offset without overflow checking allows a
> malicious initiator to send len=0xFFFFFFFF, causing req_size to wrap
> around to a small value, bypassing the bounds check, and subsequently
> passing a ~4GB length to sg_init_one().
> 
> Use check_add_overflow() to detect wrapping before the comparison.
> 
> [...]

Applied, thanks!

[1/1] RDMA/srpt: fix integer overflow in immediate data length check
      https://git.kernel.org/rdma/rdma/c/3f716b34c639f6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

