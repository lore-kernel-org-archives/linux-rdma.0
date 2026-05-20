Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F583438B6;
	Wed, 20 May 2026 04:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779250980; cv=none; b=W9vwwoE6b1u0pfaVehTbaG3jYToT9qLEUosXgaWZ6X7AMUqPc9M+ApNkLHzXcWGR9tb2O1y8DYF0TuRzQQ77x8D9YholyZTlmeAlFbLn7nmNLG4o/Jb7dgVIn29WteLYBGJOTOVPGmMoHRYZh0j7bvUfHp0bCXqOQ+idTDoX3Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779250980; c=relaxed/simple;
	bh=mZCK0Bne8vxrpfLfWHVNdZQMuhMMUH3JwK3zvHwzQz4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uZuGo21ifyf8uToLP6kw9fMbcfb9oTqORPsYliQr2SrpHT8OnhDWsqL161ZFsbvnm+MWvmQRT6OVdSdURk/r+R5f2sYZcP9S0yOA1yA3mlPgwtmKwLQd6juSdWeRW1FetI602XvIsBqHNJ/4SOwTSvbR1MLrMlsw+pvrgfADLKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFw0SOl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFw0SOl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DECB1F000E9;
	Wed, 20 May 2026 04:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779250979;
	bh=cc0UIEMRSrem35vxrcyWPySXSMgJ6l/FNbmCJgtjbMI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eFw0SOl8lAEw4ERvfUKIHjUdPQtAmSMCwFqhaTj78d9WeKbwyewGVTImuZJxIDS/8
	 mClDkxLtw0I8KuzaQ+gtJs/T3ZxxNNECz0FCpV48BaZt3kiFOy7q53pvqJqiz+xPxp
	 1Jwhl7qBr/kNVtXxS1rtNIsNEwP+Dtb3y1LRqLM94cS3fN+ngEbeCo2P5LhiiB6QQw
	 X3jdm6OtO030/j8q4FYE2bZl5dii+Ua9qtUzkTgkJ5sC7K2VPQNG+2bGV6rmzSjugU
	 kLRjnLpnh1t6oREfUaVQHfVfMA66q3DRsrBV+IZmAQRx4hGPP7xjx/ejYdAEQKgaGA
	 grCFdSD5i6mww==
Message-ID: <8a10cffb9bdde6f90f0fd7b00679755a593f2d6e.camel@kernel.org>
Subject: Re: [PATCH net] selftests: rds: config: disable modules
From: Allison Henderson <achender@kernel.org>
To: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 19 May 2026 21:22:57 -0700
In-Reply-To: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
References: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-20 at 11:34 +1000, Matthieu Baerts (NGI0) wrote:
> The run.sh script explicitly checks that CONFIG_MODULES is disabled.
>=20
> By default, this config option is enabled. Explicitly disable it to be
> able to run the RDS tests.
>=20
> Note that writing '# CONFIG_(...) is not set' is usually recommended to
> disable an option in the .config, but it looks like selftests usually
> set 'CONFIG_(...)=3Dn', which looks clearer.
>=20
> Fixes: 0f5d68004780 ("selftests: rds: add tools/testing/selftests/net/rds=
/config")
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> ---
>  tools/testing/selftests/net/rds/config | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/tools/testing/selftests/net/rds/config b/tools/testing/selft=
ests/net/rds/config
> index 97db7ecb892a..3d62d0c750a8 100644
> --- a/tools/testing/selftests/net/rds/config
> +++ b/tools/testing/selftests/net/rds/config
> @@ -1,3 +1,4 @@
> +CONFIG_MODULES=3Dn
>  CONFIG_NET_NS=3Dy
>  CONFIG_NET_SCH_NETEM=3Dy
>  CONFIG_RDS=3Dy
>=20
> ---
> base-commit: 90fc1a393736063b2b4077115e215a2e2eebb797
> change-id: 20260520-net-rds-config-modules-cada926dc526
>=20
> Best regards,
> -- =20
> Matthieu Baerts (NGI0) <matttbe@kernel.org>

Hi Matthieu,

The fix looks fine to me.  Thanks for catching this.

Reviewed-by: Allison Henderson <achender@kernel.org>
Allison

>=20

