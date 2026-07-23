Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31772439F68
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801178; cv=none; b=l43Yz8nSX92C1r7MMTWTpF/0TM4xExJWtXUXLCYdY9NemSxlJhVdBZ6ezs0UiFLYKJV6oTf+9b9RwbJAoiJEVn9TjTogUfOvQlXymKpXVTeLhLe8BEtcGzdwmB3AUNlR6Ql3SUQ38ptK+HLQOzO4l+Yh2DJzWaWibODVpgK8XGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801178; c=relaxed/simple;
	bh=XLf16U/Z/PLHQPeH0cKsnYGYEWhPqCapFiOjuXc5geo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gcMioV5rYX841+QzZJQ/RF6SR1eLuqwoWbxqraHg/D5WZA259ktZKsOTQCjbxhxzrBmf+XwrffNcSDGiMhUpUWlWBQRmgslgXvSJVoNcWyCX94Oluy9FXAqQuLqws+VQJgKOQcIqDTyy6MKa4SqmYRtd9YTLe9XXIvHvheA73iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qul40GDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qul40GDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEEA1F00A3A;
	Thu, 23 Jul 2026 10:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801176;
	bh=+Hvxj9lh4t46LWSuIgrYxcl+G1QnAtbPIIRie6wPAiQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Qul40GDQ3F9fQputik30mmFaPaC0u7JqzeQdIZhSC3wiEaud5D+NmFGOKQnm+V+UT
	 ev/OkDTS/+sXW2JR4QRJX9qrPoOjXMrj05rYBKj9ADa1h7qsMbO99KFBPlBvaRqiH/
	 QiyoxToMNNb0jQ+YLo4/w/z/CJZxmu8O+VToIXYnTBwNt7NAUgVXjnBnzqS9gYW8Al
	 hpM0UHcvnhV3EcF4gjVKIqkfLe2lali9oV/3tgFV/SbnCgH+Mo7rNj1Q8+8+WioGZC
	 NbR2N8Ob24gixGys1UO+15zPxyODD/WI2U0MU7YvVWPxImLPjCgJYiA6Yx0iRkbtBc
	 +3OIn4p8xkm9A==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Dmitry Antipov <dmantipov@yandex.ru>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260723071448.568641-1-dmantipov@yandex.ru>
References: <20260723071448.568641-1-dmantipov@yandex.ru>
Subject: Re: [PATCH] IB/mlx5: simplify set_param()
Message-Id: <178480117369.3409014.3882257978509318867.b4-ty@kernel.org>
Date: Thu, 23 Jul 2026 06:06:13 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 23 Jul 2026 10:14:48 +0300, Dmitry Antipov wrote:
> Simplify 'set_param()' by using the convenient 'kstrtou32_from_user()'.

Applied, thanks!

[1/1] IB/mlx5: simplify set_param()
      https://git.kernel.org/rdma/rdma/c/db19e7c131c044

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

