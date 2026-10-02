Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E0537266D
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932382; cv=none; b=Ajj4JbL7Y9MhGK4afCjc8+Db3vPT+ueCc2qR6edNFuNO2vunX5XAle3YIBCzkObLh9wkWlmSHokpRtbagEkC14SuRXzCOV3l03VIp0AZyMP5276taBlOFdS1WBF/gKW0adzxlb7bO6pfNx9MiubX5bgSmlC8BtVOaMwqMa+yEEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932382; c=relaxed/simple;
	bh=rab/0GmzRftEOGBUtrdMSISL3KO7zlsyGNIYMEMdmlo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i1dIk7RS5L7FZx8efNfTOf2YnQPviWYYnw+GKWyNfim1/M3TwMghoVS0QvPEKp0yf9VPipPquWVdn7N31tXOqykDUkIkmlXlJ4KHbQSXUnuPMG06abD0Von3ej8VeEuHVNHaFwsKvuYCm4g2s7/jwT/ge9SDkwGW9CCvnVUusYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGM9fbIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGM9fbIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21011F000FF;
	Fri,  2 Oct 2026 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932381;
	bh=rab/0GmzRftEOGBUtrdMSISL3KO7zlsyGNIYMEMdmlo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hGM9fbIKvufrGPn9sfZzNjNk8DbK2XZ0bZYUPvm/0gC1NlBFFZOU5VVYDwkvwraZF
	 HjRdmzIT1vrvrMds7gRVBh4dpl6FAK6cnPmiPT6JcaZ9FkFZhJo17fukBJC7J1lXnd
	 LBCbw4hixwQrZ5IlMmmIUWF4Zjk0UjeDU72+ysie0Fn9Q6RK+w98T5x6rUkny0KjdL
	 0awAymagKWa86m/buoDvTA3F2jb88r4XNnuh20HoCxV3FJ13F4Y/S2UvsvC5epKI86
	 I5Hh6iTy86Px/CrRNN8DeVYqaPmHuffkNQ0sCbE6T3nfmU3kxPKQD7937MQqaN2+8n
	 KEVQW9wqIU02Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 05/10] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-6-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:00 +0000
Message-Id: <20261002091300.F21011F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D5

