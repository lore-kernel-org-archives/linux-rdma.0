Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B24E3EE1;
	Tue,  6 Oct 2026 23:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330398; cv=none; b=AsfMk/bwTmJ/oHc0/jLxHCxnqxvmWcMtp8YqyWJLYae3oRtGqVpjnKtl38j6+zgMHSO/n+P0zaWPbkFBNDaNdkuq5ig79pqZq0FaIiNzjCCxeVgzTqtzycYHeJmZrDM/bmrskPz5eESiACuSJos9J+P9wvf5vj8LYSBlq1+cO1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330398; c=relaxed/simple;
	bh=rLv0z5JTXAheuOr697PgcnmqL1ZNjhyI42tLzTx4vjo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oplgvyFfnpJk6HRavp6LML1rNiv/k9nxeDYb6iF+yjNAk0VCQRdlM7u4a6a8eMI2dL4l5q82vBp8lGtOpCS++Z+6492DzKl4442pdoln2obRAhnl4My8Yl6zRt4SlTyXdPyoCJFpNaxKapIYIMeF3/2vNtiG1MpsGHv43KYPrEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZv9suYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZv9suYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541EA1F0089C;
	Tue,  6 Oct 2026 23:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330397;
	bh=rLv0z5JTXAheuOr697PgcnmqL1ZNjhyI42tLzTx4vjo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IZv9suYl5JcrmlScen9E1fFKJ0Y0gE2WZVqoBOUxEeZTD6RyzWoF+Je73OKV9GgYZ
	 H8thYNkAg8YWUlbrI68GOwkVm5P/dgpPHbLwTNhBRsVGzR4AdeoR4L4pjqExC00LyO
	 G+S/c9Iy4xuLNPH59FlSzO9EAYZbqs8xlg0MgtPamHImme7B9hzIizTFCEoX13m6es
	 PD8sju1IhHV6dz8zx+zQxQJwzJOzGMmelHEA56JMUheePGNT9GXdiFQKiDGlggz/WG
	 gpG5aHKWKXmgPaadfcqR72m/b+tM/pCJWIMFp6ril+OKBRET2LS9T/InHJyh99BvbF
	 Nq+KLnRXp7ehA==
Message-ID: <sashiko-outbox-162521@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 6/8] nfs: refuse P2PDMA pages with krb5i and
 krb5p
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: linux-rdma@vger.kernel.org, "Anna Schumaker" <anna@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <20261006233248.705086-7-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-7-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:46:36 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> krb5i checksums and krb5p encrypts the payload via CPU accesses
> while the RPC is encoded, before the transport can refuse it.
>=20
> Fail such READs and WRITEs with -EREMOTEIO in nfs_pgio_prepare(),
> before encoding. Check the task's RPC client, which for a WRITE may
> be the krb5i client that SP4_MACH_CRED swaps in.
>=20
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D6

