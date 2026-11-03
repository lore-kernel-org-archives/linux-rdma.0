Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705841;
	b=ijL/J8eJKkjw20P1GvwPThP3qMLUXT9AZWAK1KldjdfLZrKlOxIPvMmMlgms/lHPPrwr
	 7ekdKHQD908Ev7s3YZ11y88jfQOfuwoI53yMc/EiZtYJssBagoLMYsfj00WBpFXAhRli+
	 6NAptFoDwvy3zZ/h/gaaPHFMcLlVc3al5YtRJNRXlSfvKTqcAxDy8m0IrB/2NiIoXCfMs
	 lM06yFFlJGi9vLuquTdbzP1ejNy6iThLGwAyJtOlImD0bGnPaM8K2skQ+cbMU5PqXAd72
	 BBtwFdQ0M3LQr6E7TiNt5PrT1zXQu14oRehOdGJxc93Tww8oyYcPR15QguTm/5bq3Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705841;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MRC9fMRMi3AKZvjTD3L5d8gFYfAnbT0iHQlzXtqfpcs=;
	b=lBTYhw3BkM63X4JNtMazs0lGOAyhNhDQDaXEbiS22jH+GKXVhyvJ/TWuVZrH9sSAXQ4m
	 /6eOx4vJQ+gfwVs+fWa5bszciToaenlQNJIA28AJrH8X7LdlGx9uXijmKDXxXF+6OXuSx
	 EBH3GD5gvgKq3CTfdvwIiDWh0wiCYvLXYFLBs9MDfxhg+raW8j8G72RDXf/6RLnlzpPW7
	 qLbnumhlylsNHVOKTTZJ6NjC7yz5lTEaQHoPNu9LH7xtFC7AnUzdWl70JYSjyuSKivtct
	 n4SAubfYgKyu28MzyGE/A0VZ1tu1CvW+pvj3xrR01yNMZj5zCUYd23bJqpWb1aAd7xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jb7J6LWo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03847606D815;
	Tue,  3 Nov 2026 11:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jb7J6LWo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711371F000C1;
	Tue,  3 Nov 2026 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705840;
	bh=MRC9fMRMi3AKZvjTD3L5d8gFYfAnbT0iHQlzXtqfpcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jb7J6LWo1bljK4dKZObJKIkGrAJ74h5Y1cQdYIe5IP5XIdVvfoGrqctaRLuQZcjvb
	 CzseApjv3kZx//ZyuDJPEdZO8K3GILl0q11ULJ9H2QDa3qiZ4aWc9ReY+8bcKeh/+k
	 zlMQzmqU+hoADiE2krXxiCTicpZuZMkHmIPItQPeVhvyjzGMLIKy1uFpklqij9lBW2
	 u/ThTH4fm+EuGlKE7B6oTWtLpipkVxqPeNbvCAMAul+MrrbS1H+gNXsUwRs00641OP
	 1VlaAbOwivqwtPYkKRwpa+7UrsUmIyNTLxr9kNPl3sB3em/MUpmPxgcPUBZLAcnzi8
	 abI1aJhEhGoPA==
Message-ID: <sashiko-outbox-195159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 19/19] PCI/P2PDMA: Test the routing of clients with
 ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-19-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-19-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:37:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A client that enables ATS for the whole device must never be handed a
> bus address, and Translation Blocking must reject its peer-to-peer
> traffic even when the caller asks for the default class. That has to
> hold for answers taken from the cache as well.
>=20
> Cover those on the fabricated fabric, together with a client that
> declared per-mapping ATS keeping the per-class answers and a client
> without ATS answering for the Untranslated Requests it will issue.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D19

