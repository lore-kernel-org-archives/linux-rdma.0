Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8783481DD;
	Fri, 18 Sep 2026 12:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735794; cv=none; b=UpanJ8NIOF8PkzAFQzN1tSsm9LYBpErxEDufuv7h3cA2SDQVVPh23/GnilIcB52vBl5oj+z7zO7Nyt9EArGZIW/RQ6xMUD57flw6sFzXbTx8mZ20nspvKdDck+qcvxGgYrw5U3U31ltpBMW64/MKcGbYel1OL0bwnBNEZ/c2rMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735794; c=relaxed/simple;
	bh=gTh/tPlraQ66bgzHt3G1YiYQuo0eIsA+aNYbnoZvGNA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I2i51GF+XHS3Pe1/tjg5+Sk65YqOk9+noVJNBmFs9RyvzpInFia7FZg2pD2N+4uefA++AWpJKQagPfrrKPyQKa9ezdiFFWfJyImuGFO3cOCL7fir8YaflvtRlMbA9mpMBUWac0FWOKbgt2QEHCyywLF+qY+01EQgIoMVDJcMzbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XjbQNAh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XjbQNAh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D672B1F000FF;
	Fri, 18 Sep 2026 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735793;
	bh=p+Tkpytj57aBf2zcBucFW4+NKk4xDs7Uvser+s2irfs=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=XjbQNAh8VBZFXYxhviMRHwh/O0uwmBtkMkDldAUg+NRaTvMBW0qoCDD679U1Im66Z
	 9KdGGCRk6+bKyrdupCyCufWjxMNJfedvpydsJ2rfWcAzghOomEusUCLpwxNOmUTuZ+
	 p+g5J0lj72a4iUvktlpKqGZzvifkiDgsIyDNB0ST5Rsezvpr6PIftzWybhTz8yn6q+
	 UNRSSPMhJhsIJ5dXoml5STEjt3P4SGGex7a9fFDW8HvpzaX4bAx8Qylu4NlKm8lyGH
	 5WAjee8ueZfgXc5eVG/CBxppE83/f5s9ziXuTPY39N2dkPYJPxabZ/iwpE7Y13d6wU
	 7JI+Q1HvQf4bQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, 
 Yonatan Nachum <ynachum@amazon.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Michael Margolin <mrgolin@amazon.com>, Kees Cook <kees@kernel.org>, 
 Parav Pandit <parav@nvidia.com>, Mark Zhang <markzhang@nvidia.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260916064435.2180-1-lirongqing@baidu.com>
References: <20260916064435.2180-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/core: Fix swapped list_add_tail() arguments in
 ib_add_sub_device()
Message-Id: <178973579053.2688475.14483307453857409532.b4-ty@kernel.org>
Date: Fri, 18 Sep 2026 08:49:50 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 14:44:35 +0800, lirongqing wrote:
> ib_add_sub_device() links a new sub-device into its parent's sub-device
> list with:
> 
> 	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);
> 
> list_add_tail(new, head) expects the node to insert as the first
> argument and the list head as the second, so the call above does the
> opposite of what was intended: it treats the parent's list head as the
> new node and the sub-device's node as the list head.
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device()
      https://git.kernel.org/rdma/rdma/c/fad7b0dcb0821c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

