Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284741;
	b=Vwr/Yl6AGkRdlb16Dz0X2J5BO07HYOdUtHjcu+fVLwf9S1fKSFtG+GmT3J+VIJ1U5/x4
	 fS+xq4e/IKs3j7l0kDQ4CsXsgTJzNwKusmUM4pqk+GcAxO8oxKObUii8iQe8+P8od67Su
	 dyK/eFNbb+xldPwBHHONUWZQa4xX3HO518KCaUfYLjGorkw+WcVJJIiNj3iJYPBZIQsxB
	 ZHEbReMhbw4kaV1B8/ISzPMuJpcVt7NUNdKPMZjzZR1yMEAUvJFdBmy0rQK60Oy2s7Ubz
	 qEMxO1lGUsd8g6wzz3eTOmFJ4MmIDxh9LVAeA80CLEXWol68Zs5mGXy7+23ofvcz+Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284741;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eNAWy9QS9GIFgxceMXFlP3LiMtZFHcsaqDwDXMR89sE=;
	b=jlfBczb1zUzzj6zP49UXOMr7kpynKBPLzyeDW4dv0wGfpWujUOedCSuaPnhrTF0WAbhK
	 tp3FdgVZyt08Q4IrLlWBW6GPGceQOtMGUZFWm98e4i6tNTE4V9arhC0fhQ4ZxylJx3ZTQ
	 yBFQW9HmqXoQ1my2YxO8Cwv69sHaQDPVg6pEQS+VPaWwONUE3ygtYhnwFgNDYu0X3gaEc
	 L6eO9f4O5Ozl7YrJVe2YrE8si1lg1Go8FNNYs5DS/Tqn7hJSJSLkDRcUaet8X1ZFl9nAi
	 aZI0LBvrGvy3REo6gjxXCWNsnALqUgm/ax7psU5TMAqjJwTrIP+AVrtfBnE120OI5Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bh3Y+EJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7055606A333
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bh3Y+EJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6861F0089F;
	Tue, 10 Nov 2026 04:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794284740;
	bh=eNAWy9QS9GIFgxceMXFlP3LiMtZFHcsaqDwDXMR89sE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bh3Y+EJoChdBfnJJJN9CMS5BE2oT+U0KEFXp7kb9zwXO45KbV1PebL5s/npbIdp3J
	 xwzjV4un9Tv9FE3ugMBhLLznWO7CG8c7OIfZ8A0MgwxRCijpQFyXCboPO/wKdRjNNs
	 qvSZRXdD/gleZq3jI2whAEXeQMtOs6BT81rf6pb60ZM9wTkIquq0sPsX5bKC8uq7JS
	 lB9Opcx4pVmq4jnTqwz/76pQoFbv2tUPHuR8H5D5T6NBzBt/V/hfeoypJ4E/1wxC0m
	 TrlwL1hhMTXUcPlLjxe0Xi5EG1rdlTqfuKyTU/myzhWTl9lebfzsWFb4iBQRazsXvh
	 av0/MXuB/dpWQ==
Message-ID: <sashiko-outbox-206193@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 03/13] RDMA/core: report the reliable
 unconnected device capabilities
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-3-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-3-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:25:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Add the capability bits a device uses to advertise reliable unconnected
> support alongside additional features: the transport itself, 64-bit
> immediate data, 64-bit memory keys, caller-chosen keys, and the four
> memory region access restrictions.
>=20
> Report the job, job key, and address table limits through the extended
> query_device response so userspace can size against them.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D3

