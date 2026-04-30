Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BC92F361E;
	Thu, 30 Apr 2026 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777516928; cv=none; b=jMlKwWET7tBgEGEixYih+mvI5ynKTYl6lkQHBBGz08bAmv5BVcEMcYSOkB2Obkbo7S38FQlYS582yKEMr6zEh7tjrGza3lPLRbVQ20hp/f2n8X+rXZcrlZlLqzuvmVg1avb1xxsm7jE+46F3stkBwvLtHCqIi2DzkBF206ryo6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777516928; c=relaxed/simple;
	bh=hCKPMhlDk5ib397JtkQYKg8iIdJBJanlckgHAuazbGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRHLP1K1rxATS8Q26+3OCRm27EsgpZusshoO6r/dzw727xl6R7bJ41RlA4DRYqoeFlROZhSOXSXqzUY+XK7srYJBKJxTLQaIUBHCRmCDOxN9O+SnfexdFiMtzCM03KRyhfI0GZf7EkReSsAEEdECv+TylUp42yMAPVyK1Xqel4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gw70+f8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gw70+f8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4420FC19425;
	Thu, 30 Apr 2026 02:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777516927;
	bh=hCKPMhlDk5ib397JtkQYKg8iIdJBJanlckgHAuazbGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gw70+f8M8Pv/BOEKzcE5BlqNT/lnCEdKAYyIbDdALz8U0Y+08Opvwx9np3V1eOEQP
	 DIzvZlUw0yJ7mYbEKnMUz+JZD8JmaB5ZjgMKF/3LBH1YSwpOf2S+4NptajbtEBDy5W
	 i7IPC4xacR2sCTV2hwgiuicoke3/OJE5BR59noPs/4yUV6w7Yjv9gMXjBOQ/6umGdu
	 UD57/3ckSjdMC3JzP0bqGguZ6buLycevyTYNlJOn5LBtc8qg/nornwH+B0LT46ATSZ
	 pWnZnyIYwBbmEanTQI/RHXJ9kdXTQ/B1odC3iWsPBg84CfFHcMYPnibCWn3jd2mols
	 H3udaHXPATGfA==
From: Jakub Kicinski <kuba@kernel.org>
To: achender@kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH net-next v2 5/7] selftests: rds: Fix gcov and pcap collection
Date: Wed, 29 Apr 2026 19:42:06 -0700
Message-ID: <20260430024206.2452353-1-kuba@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428222716.2960871-6-achender@kernel.org>
References: <20260428222716.2960871-6-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
selftests: rds: Fix gcov and pcap collection

This commit addresses dependencies on host systemd configurations in the vng
guest. It adds mounts for tmpfs on /tmp and debugfs to ensure pcap and gcov
data collection work, and updates the gcovr root path.

> diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/run.sh
> index bc2e53126aab..3fc116d23410 100755
> --- a/tools/testing/selftests/net/rds/run.sh
> +++ b/tools/testing/selftests/net/rds/run.sh
> @@ -197,6 +197,13 @@ COVR_DIR="${LOG_DIR}/coverage/"
>  mkdir -p  "$LOG_DIR"
>  mkdir -p "$COVR_DIR"
>  
> +# tcpdump saves pcaps to /tmp because it requires chown to save the
> +# pcap but chown is not supported by 9p.  Mount tmpfs on /tmp if it is
> +# not already a separate filesystem
> +if ! mountpoint -q /tmp 2>/dev/null; then
> +	mount -t tmpfs tmpfs /tmp
> +fi
> +

Could this introduce a regression when the test is run directly on a host
workstation rather than inside an isolated VM?

If /tmp is a regular directory on the root filesystem, mounting tmpfs over it
will instantly hide all existing files and UNIX domain sockets in /tmp.

Since there is no cleanup trap to unmount it on exit or failure, does this
leave the host system in a degraded state?

[ ... ]

>  if [ "$GENERATE_GCOV_REPORT" -eq 1 ]; then
>         echo saving coverage data...
> +
> +       # Ensure debugfs is mounted
> +       if ! test -d /sys/kernel/debug/gcov; then
> +               mount -t debugfs debugfs /sys/kernel/debug 2>/dev/null || true
> +       fi
> +

If the test is run against a kernel that does not have CONFIG_GCOV_KERNEL
enabled, the gcov directory will not exist even when debugfs is correctly
mounted.

Will this condition cause a regression where the script repeatedly mounts
debugfs on every run, stacking redundant shadow mounts over
/sys/kernel/debug since they are never unmounted?
-- 
pw-bot: cr
