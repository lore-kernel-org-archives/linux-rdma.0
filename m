Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695531;
	b=XJbzY1JW9spPrMkZllVT44EN7uz7vYJPGxCbq125PYMjPsOFjyIl3ZCpGNt6rnzIy0B+
	 M6GCsI1fR/JChKSrzKGCqR1Z1N0bQK8spGOJqQ2O45o+moPo9UBqAeWFj5YfUqpFpCVM9
	 dWxJ55gFLi2VF6ZNvOmfvwl2enfD3WoIiLGTxUR0sWahQ4phgdkZDS05NtTCcPZp3brV2
	 t5taj7QB2Hjnjuo7RiRtsb3PpbyjJBshPP5tt7eipeA0wOqpQvVJQtZ/2utDXpbPjqmC/
	 A/HeY7KgMiPNEkHMCfRqYvL/JPoxwQEa+vvzoDbaWeNlndjonXmmwvMsoOcQQ+dtt4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695531;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N/k3Z2oxYwWYYQ3hDZ2q/nSnk+cGWSITXdi5mL1nwAI=;
	b=m79nyuSmPWw1b3BmnP4QjeAMT5m8gjB1EipOXGlaqaG2sldr1HVj0eQop6shq43oR1Dl
	 aPtwuzHIVTSwM7nZ5UGhUqruLfNjKKpLhxxr7r3RUMPzeUwT6K0zHTDnJjalVXo4PoS7D
	 7rW0maRNnvomPoNq84x5z/cF5dEr/1V/ovtJel7zk2/LQMMRqFOuHbvDGB9fqTCseZySB
	 Mt3exJsbmdKaZmx1xU1nrWVbEtCxiObrikefOPYMKB54dxX220UXQe5bU1j+DVlhq3tOp
	 a2nfCO/ThFKdR8JPc1aiZowGEG9wG0cLFH7DVNe/ek/F06mFqxMBzB3pmDdPt2zm7HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5cQ3xln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850A606A326;
	Tue,  3 Nov 2026 08:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5cQ3xln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9261F00A1C;
	Tue,  3 Nov 2026 08:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695530;
	bh=N/k3Z2oxYwWYYQ3hDZ2q/nSnk+cGWSITXdi5mL1nwAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K5cQ3xlntBMbyC4tnB4IJ/Xc8BCWn94slHjZW5U3yKsWnTNYbHmMI1tWc56UD/5zj
	 O1/ugZNPtJpsSjIUEo+6SeOS5Bt95TErXzthbm3+WUIonmqpnCbrUX5Dmu7/EBipIx
	 PEkEdi6WmXO0dt0kApjo7v3vXlw5bp1T0ANGSMOcbp8kqW9l4n46LpzjJZHVQlc9s6
	 eui3nPZZI9iKyH7a2PJuc4ZTXq9izSw72MfEToiWMmhC7+zqYaWtpYIGN3YyDkee5F
	 mZglAIJZAeXZOjNqaUH6UiiSMn3e4Ho/D2CmVvgz+tq4VQyD2Cy/shGo2JRbsR+Wsx
	 V4TnsUnyFTarA==
Message-ID: <sashiko-outbox-194865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 02/19] PCI/P2PDMA: Document the TLP attribute
 assumptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-2-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-2-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:45:29 +0000
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
> P2PDMA selects a mapping without receiving the Request's ordering or
> Address Type attributes. Its ACS handles only strictly ordered Requests
> carrying an Untranslated address.
>=20
> Document that the result is not defined for Relaxed Ordering or
> ATS-translated Requests because those TLP attributes can select different
> routes through the fabric.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D2

