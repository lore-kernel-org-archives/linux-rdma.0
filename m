Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D693783AA;
	Thu, 21 May 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374535; cv=none; b=ZMwW9uzUhFCu44vEkSZ2LXmH33SPYLEqqmAPrgavzCO+BFr6W+4DwKzNksvDhViK6ONbEiHnt9iomf3p1QJLvreo7IkSAlbSyxY2+7Sf/sGuAR53u3aG5oaj3UVPruNGsaL4WVV7TI65MqvoMRSoOMBRdi7mYOh98etc1uRMuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374535; c=relaxed/simple;
	bh=J/HsxTTCIRAy3TXVt7VJ5+tiLxwGHR2mElOvPJ0HSpA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hDLcrA1qhzp/phVYI1OhaL9casYB/mUBuw3VT7bXfitimaw7Wkbt1vvew2vFwYJgtoIOujuMjCxAhEIMkyRG7z0kbXIA59ielvrjqyOWDJ6qAmp2wYvo1m4HWDGDJyUz/EyW9sXShNlqPMLO6c+VD9BRzoPpmQ+2khaKQJmYdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N38ic3zB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N38ic3zB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3941D1F000E9;
	Thu, 21 May 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374533;
	bh=WYsFDkNJCJZLRNvEDkX91LBJiFLA945zC2SYzDyqE4A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N38ic3zBjZbPswwibccSKMIbhaJY+oCN5CixyxVcQi/3wB5IqY13uIPsbns4syzVg
	 0QyEdT/GPMVgCIV1DRr/sAfdg82dLl0JAQaeubR4t0RgB1ACAor4e1PsF8LGANavbs
	 GMeleMCrEYgoBqQYYr55fgI0VJcfwgxqWMN1TAMYeuBOjM5euRF1pStOl/6evEewCM
	 LQ+jNaGIlKiwYnKJt+MpVSuiaSHJEk82sryBwskrsM5Svz/rRHWP958JXq2XMm/6nU
	 rXwXr/0IIqERjZIB/gXRr/jIHLPq5QnKnCcwblkU0puCG6iQzgIsxQ4FjfWqB6wasQ
	 N87bpl7pSLcOQ==
Date: Thu, 21 May 2026 07:42:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Cc: Allison Henderson <achender@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Shuah Khan
 <shuah@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selftests: rds: config: disable modules
Message-ID: <20260521074212.66205e90@kernel.org>
In-Reply-To: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
References: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 May 2026 11:34:43 +1000 Matthieu Baerts (NGI0) wrote:
> The run.sh script explicitly checks that CONFIG_MODULES is disabled.
> 
> By default, this config option is enabled. Explicitly disable it to be
> able to run the RDS tests.
> 
> Note that writing '# CONFIG_(...) is not set' is usually recommended to
> disable an option in the .config, but it looks like selftests usually
> set 'CONFIG_(...)=n', which looks clearer.
> 
> Fixes: 0f5d68004780 ("selftests: rds: add tools/testing/selftests/net/rds/config")
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> ---
>  tools/testing/selftests/net/rds/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/net/rds/config b/tools/testing/selftests/net/rds/config
> index 97db7ecb892a..3d62d0c750a8 100644
> --- a/tools/testing/selftests/net/rds/config
> +++ b/tools/testing/selftests/net/rds/config
> @@ -1,3 +1,4 @@
> +CONFIG_MODULES=n
>  CONFIG_NET_NS=y
>  CONFIG_NET_SCH_NETEM=y
>  CONFIG_RDS=y

Hm, okay, if it works it works, but IIUC disabling modules turns all =m
from the default config into =n (not =y as one would naively hope?) so
this may come back to bite us. Unless there's a strong reason to not use
modules it may be good to follow up in net-next and life this
requirement.
