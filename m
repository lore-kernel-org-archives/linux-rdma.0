Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834697;
	b=b6QFJNxaSbyWj5BmjO7Q1mGvOxeCbQ5mPKILKt7F4JP8oXVwM1nFys/DgHxcb/oOOMTz
	 7oEm1pD1kk5wt0CPE6RMX9mXi9nn1I6Byxmj6b/G2uYrpOJC4MqTOTZo3gNfqfPGiu22U
	 Fht2DX+3X8lJHWtL012HCtgRLQjL21QvHth9w81Dz5OpOO0PcOdQ9qdWHV1MOWi2HK1XJ
	 y1vRgzO5d5qAjqr4ZBG4Q/fLEhl88tkFFzTkilLErfQMLhSohNEDFAV83G+bGyseZ4VGi
	 OX/LE3owQ0GBwXg/RrXSqkMtHC8Jb/3V76IE/LFMuIA4s4i1WWxY6H9KSSokXhWaGmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834697;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=QvOZUB/RJM7RA59o2HzugDz6reGFNGvasPNCOtqiOow=;
	b=lHplLQF9ZkmvD9FHr5TNNnIjAQhbHzSLAyeiesjU2/B4zmPMpHD+uAhtnha0cMus2RGT
	 C0nxUfwD7BB/3nC1aVYt8V0Wb9hzWAiGZ/tSh98E3fAN0uxGHs6GDc/2yTWSriYzViDSs
	 NPZgKnH+LkYPsLfzZucuJtYS68+VC1F5+zH4rTV+36zdMjwKQHZKzXukw6pnwL5KrV8Zs
	 PigVurUfFU+QYbVmOZXZjh/enbXWtWTwN8VGVT0ZXo+jPdaEBAGn8jqC55+BZ4W+1zBtD
	 nOdUQ9NdWUUuYcTFBSG56KLT53zhRE0ZUDBkMJecCMsZMaWCj9tzRfy25oOOjuM1lpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTnWeIN5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D45606A329;
	Mon, 16 Nov 2026 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTnWeIN5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330AB1F000C4;
	Mon, 16 Nov 2026 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834696;
	bh=QvOZUB/RJM7RA59o2HzugDz6reGFNGvasPNCOtqiOow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=CTnWeIN56AzF1HelXieHyQW4BevraD73r9z95vE7eTf9EO5wQHLSbxCnNM82ryzfR
	 b8Ef0ZoIO/eAljjIfmiUQw/9+wOTuqMsJAJyhxonywVTbgQ5cD1FPqPwhfG9ohwNeW
	 Nm/L9ULAMDLKr+Mfj28Czpq/KPAD1l8QPlurR9B3AnFqI8BQHr9ZD1akcUA4JlG5DL
	 EUTziSPx32M/pRKv43gWXyH2jrUD5e1O+5vkHUy49kkoLno2pMju+GEKxfB2hdz5hT
	 cgLcQiy2r9lH1Ee7lMptLGmI4+Lc32Qr8dIwG8v7GpTZ/fGJjD9ujHsvRg/xrs1+EH
	 e9gIlwqFbuHUQ==
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Ziheng Wei <zihengw03@163.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261115080226.910258-1-zihengw03@163.com>
References: <20261115080226.910258-1-zihengw03@163.com>
Subject: Re: [PATCH] RDMA/mlx4: Use the right list member in
 push_deleteing_req()
Message-Id: <179483469362.1364664.4297498596226179127.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 08:11:33 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 15 Nov 2026 16:02:26 +0800, Ziheng Wei wrote:
> push_deleteing_req() looks up the last pending request from
> group->func[slave].pending, but recovers the enclosing struct with the
> group_list member instead of func_list.
> 
> A struct mcast_req is queued on two lists at once by queue_req():
> group_list links it into group->pending_list and func_list links it
> into group->func[].pending. The two list_head members are adjacent but
> not at the same offset, so list_entry() on a node taken from
> func[].pending yields a pointer 16 bytes past the start of the object.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx4: Use the right list member in push_deleteing_req()
      https://git.kernel.org/rdma/rdma/c/a4b6f10a540392

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

