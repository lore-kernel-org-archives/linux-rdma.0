Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699616;
	b=1Gz5jF3rLBI2cX5R6HvfkBB1bxTM0foPUCTEkwVvqkghFxV7RU55QDS5AjREwYWv30TQ
	 SEs91l7ZBDKRn4SUMqmVfqwLlRD/gpv7NlG/xxYXcIL7cB3ygHUO28JNyvIKBRHPjKDjN
	 3TP1PB0UgGN/b0ELvUKD/GsKq9GLtvbpQW8zJquS8dJNt8igY4eWEqYR7gqyJfljnyqOD
	 abjSXV/0eTSl1DuZkMgSpqxoJlysRISps7az8vZBhb0vz8XKR2Gz8sGJMf4s/6FT5ZfVw
	 DVWvubfCgrZd1Jvfes1LYQajLUSQxgHaby2EvUEbFr55l3+wtvyvrUamCUbX+i/Stew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699616;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sEgS6M8l2DlGp0iy0oTdHaY42KKNYn6YbCYOh7uX8Uk=;
	b=5aBTE8Zav5ZOo1tnQasVascYT5B3+yWi2piO5Pu5n80aanNH897e5ixLr6PYneQJD8yB
	 rqIWjIkorUMumwW9QqdE4LFSxyw/FCnLOPYXwVFoYDirtOckcHSvp1Z7Uh1zMthXTekMB
	 0BHqDeNkrA3m8C/+oqrSj8Iwopg8K5Tq/TGj/es60nstourUA6i4zUnQsyI+/tcR0W/P+
	 b5CphHQBeHjsVixi21ZaJHkmiRJDl5d83xVZvEKrJVzDjV1BA28uJa2QaKHKJ5Ah3B8iP
	 3g5bHPDGfKodUxwGCpi3z7k3z+a1ZcQnIpRJU6e+5ezEuYqZ/CxUBBNtay8OB3//rzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTVFVc5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA91606D802;
	Tue,  3 Nov 2026 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTVFVc5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5C11F000C1;
	Tue,  3 Nov 2026 09:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699615;
	bh=sEgS6M8l2DlGp0iy0oTdHaY42KKNYn6YbCYOh7uX8Uk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oTVFVc5hIWJekLNawgFtET2tFSYtyBQYWT+bAgibRD2zISfHRn13AzcPbzZ/k8B3s
	 EcHXWfACvgcLZUFMQ4QVm9sQIv1ab1/XYFKYURDW7VjL8MQRq+Syjo3AR+pTlreZxa
	 4OXb8R+rX5hMRKz2aG9lwy+wH/egdFwFi1gmni3IjQ5R/+3+DZzszpCg575weOzwjl
	 aN9E8cBwcKFVupGL6JTaoWxMHE0hL2udlXwurHukhSinUs1xhwcD2p/vqytNhO5Ngj
	 OF3Ocj8k/TDpsNkvDMq9zxEYxirGIK0wA/pdeWhnORXAIgdIjz3ZiGZEhByJgrO9dL
	 GEzHblCuhBNIA==
Message-ID: <sashiko-outbox-194977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 07/19] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-7-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-7-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 09:53:34 +0000
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
> calc_map_type_and_dist() combines ACS reads, routing decisions and
> diagnostics. Adding decisions for different TLP attributes would duplicate
> the walk or thread each attribute through its counters.
>=20
> Collect the divergence controls, internal-route restrictions and upstream
> forwarding state in struct pci_p2pdma_acs_path, then decide each direction
> from it. Keep the existing rule that both directions must route directly
> for bus addressing, and reject unusable upstream forwarding before
> considering the host bridge.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D7

