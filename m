Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E72FFDD6
	for <linux-rdma@vger.kernel.org>; Fri,  8 May 2026 04:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778214079; cv=none; b=WURQJobeqYS7nkg8g9df7GlZUcyTUGwJqVkWkwBFg9HjEpr3BZd8jD3ac5WM+E3kA7NAKJ9rXciZyo7ulGM1KIR/C6b5TGaE842FZ4c/Cdf2n5oB0kEmuwwB1VREYiZK/JSAtxo09x3JtCwErKDuikY1oZ0FdeshUCeEpSfGSrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778214079; c=relaxed/simple;
	bh=hZFFo2SGrx6LmiIKgUIUS7/uYs2bLO16WIcddipNSnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DcRv6I1mD6G5rKdIfjoE+ir4ik/YUW41x0/fESuxu2H3mHMcfMMuiq9k6PlCiNZM8zgDCNGzruAVJ2ibMPqlp/o4cFKdUSar00SUr5nBbiSuJNtBmoCjn3Lyvn0z+VeGbvpR5zwDcLVKZhUw+qq3LsunsW2mIpMFzGqF/kyG5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M1fB2Jan; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M1fB2Jan"
Message-ID: <63aa67fb-5c8b-42be-a38f-cd5a92ac528a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778214074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zpa4juc56fuOlDJ+f1Z6X2ImYQ7FBgx9urtCPnddnzE=;
	b=M1fB2JannvLy6rdk7+faFulHOKCcMDSFbVqkZuduk7l9uJHeaO63dsszSYDzAO8e+00+vV
	kfzTphFGpYIzouZoAvuiY2sIOG2zp6n3eYsXdDMbHjy4yG3nqR3IfRH9067gMRRar8fgHP
	mi72rpwXbjh72yUkW8Ay9CHsytBRC9g=
Date: Thu, 7 May 2026 21:21:09 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] selftests/rdma: explicitly skip tests when required
 modules are missing
To: Yi Lai <yi1.lai@intel.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Shuah Khan <shuah@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi1.lai@linux.intel.com, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260507125106.3114167-1-yi1.lai@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260507125106.3114167-1-yi1.lai@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/5/7 5:51, Yi Lai 写道:
> Currently, the rdma rxe selftests fail with an exit code of 1 when
> required kernel modules are not present. This causes spurious failures
> in environments where these modules might not be compiled or available.
>
> Include the standard kselftest 'ktap_helpers.sh' and replace the
> hardcoded error exits with '$KSFT_SKIP'. This ensures the tests are
> properly marked as skipped rather than failed.
tools/testing/selftests/rdma/rxe_rping_between_netns.sh:30:modprobe 
rdma_rxe || { echo "Failed to load rdma_rxe"; exit 1; }
tools/testing/selftests/rdma/rxe_socket_with_netns.sh:29: modprobe "$m" 
|| { echo "Error: Failed to load $m"; exit 1; }

In the above script files, if modprobe fails, exit 1;

I am wondering if we need to replace error code 1 with $KSFT_SKIP.

Except the above, I am fine with this commit.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

>
> Signed-off-by: Yi Lai <yi1.lai@intel.com>
> ---
>   tools/testing/selftests/rdma/rxe_ipv6.sh                   | 6 ++++--
>   tools/testing/selftests/rdma/rxe_rping_between_netns.sh    | 7 +++++++
>   tools/testing/selftests/rdma/rxe_socket_with_netns.sh      | 6 ++++++
>   tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh | 6 ++++--
>   4 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/rdma/rxe_ipv6.sh b/tools/testing/selftests/rdma/rxe_ipv6.sh
> index b7059bfd6d7c..32dad687a044 100755
> --- a/tools/testing/selftests/rdma/rxe_ipv6.sh
> +++ b/tools/testing/selftests/rdma/rxe_ipv6.sh
> @@ -8,6 +8,8 @@ RXE_NAME="rxe6"
>   PORT=4791
>   IP6_ADDR="2001:db8::1/64"
>   
> +source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
> +
>   exec > /dev/null
>   
>   # Cleanup function to run on exit (even on failure)
> @@ -21,8 +23,8 @@ trap cleanup EXIT
>   # 1. Prerequisites check
>   for mod in tun veth rdma_rxe; do
>       if ! modinfo "$mod" >/dev/null 2>&1; then
> -        echo "Error: Kernel module '$mod' not found."
> -        exit 1
> +        echo "SKIP: Kernel module '$mod' not found." >&2
> +        exit $KSFT_SKIP
>       fi
>   done
>   
> diff --git a/tools/testing/selftests/rdma/rxe_rping_between_netns.sh b/tools/testing/selftests/rdma/rxe_rping_between_netns.sh
> index e5b876f58c6e..e7554fbb8951 100755
> --- a/tools/testing/selftests/rdma/rxe_rping_between_netns.sh
> +++ b/tools/testing/selftests/rdma/rxe_rping_between_netns.sh
> @@ -8,6 +8,8 @@ IP_A="1.1.1.1"
>   IP_B="1.1.1.2"
>   PORT=4791
>   
> +source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
> +
>   exec > /dev/null
>   
>   # --- Cleanup Routine ---
> @@ -27,6 +29,11 @@ if [[ $EUID -ne 0 ]]; then
>      exit 1
>   fi
>   
> +if ! modinfo rdma_rxe >/dev/null 2>&1; then
> +    echo "SKIP: Kernel module 'rdma_rxe' not found." >&2
> +    exit $KSFT_SKIP
> +fi
> +
>   modprobe rdma_rxe || { echo "Failed to load rdma_rxe"; exit 1; }
>   
>   # --- Setup Network Topology ---
> diff --git a/tools/testing/selftests/rdma/rxe_socket_with_netns.sh b/tools/testing/selftests/rdma/rxe_socket_with_netns.sh
> index 002e5098f751..9478657c02c1 100755
> --- a/tools/testing/selftests/rdma/rxe_socket_with_netns.sh
> +++ b/tools/testing/selftests/rdma/rxe_socket_with_netns.sh
> @@ -4,6 +4,8 @@
>   PORT=4791
>   MODS=("tun" "rdma_rxe")
>   
> +source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
> +
>   exec > /dev/null
>   
>   # --- Helper: Cleanup Routine ---
> @@ -26,6 +28,10 @@ if [[ $EUID -ne 0 ]]; then
>   fi
>   
>   for m in "${MODS[@]}"; do
> +    if ! modinfo "$m" >/dev/null 2>&1; then
> +        echo "SKIP: Kernel module '$m' not found." >&2
> +        exit $KSFT_SKIP
> +    fi
>       modprobe "$m" || { echo "Error: Failed to load $m"; exit 1; }
>   done
>   
> diff --git a/tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh b/tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh
> index 021ca451499d..8c18cea7535c 100755
> --- a/tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh
> +++ b/tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh
> @@ -5,6 +5,8 @@ DEV_NAME="tun0"
>   RXE_NAME="rxe0"
>   RDMA_PORT=4791
>   
> +source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
> +
>   exec > /dev/null
>   
>   # --- Cleanup Routine ---
> @@ -19,8 +21,8 @@ trap cleanup EXIT
>   
>   # 1. Dependency Check
>   if ! modinfo rdma_rxe >/dev/null 2>&1; then
> -    echo "Error: rdma_rxe module not found."
> -    exit 1
> +    echo "SKIP: rdma_rxe module not found." >&2
> +    exit $KSFT_SKIP
>   fi
>   
>   modprobe rdma_rxe

-- 
Best Regards,
Yanjun.Zhu

