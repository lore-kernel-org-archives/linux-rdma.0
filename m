Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D7631618C;
	Tue,  9 Jun 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781020840; cv=none; b=Y4Uec/NjZEx6M4UE3zKUNPOYPNohdYZUFO/oM1HKzYLoptLMJHLkeYCgtt7ac6qOI54FeR+Z9cifQt0UTKGvhFMTInx5gnW9D7sd3sftYAmTbMBab2psAR0Iyfe5cMMNiD+eIlk73RABugVBNlErDdJ2K4el5c8K2iHrLrtOrIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781020840; c=relaxed/simple;
	bh=DueyKx9WuH4OVbms+/f6grEwTUeCkiuZb1ybxt0zrBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/K5ZYsLAyj0Kns7tuBSUKQl3Xf5So10vSVX/gQolJs4mrNpOAGD5FcKd2oplQ3iLPxYa4b/+ywyPD9B7Uxgps0QqKnpdtJtGFkOMj4yNdZy2qx8VWxsH0nZE7SOoVdZvD2jLVEkklgeKaUJ5XlquL293nCehGC7tXh1d8+guLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKubknSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKubknSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A761F00893;
	Tue,  9 Jun 2026 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781020838;
	bh=GOkmt/JjHJGW5u4kUSvcbFQkbFk2ijvX6bSDmM6GXaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dKubknSt3f7U90uMvxvQ9f4Ehw5udC0anBv8UuMJ+I4ddtRBfbhBJXQB+88Py/Amt
	 yCnLW2vU2gLr5O6spPcXlfnoOt/zNnqfbz15gl4VIGBNCtV2+ZDeak8HI11wEnzIHM
	 mIAqe3/9fRtlDB7LChXiHMyIf3FAh4ZHL2xPovnivPdJqPG8WP3MnDJe+rLbJSHX5z
	 Sj4m+YNK56T+y1y+fjYsgnHb9AfCp7v7y6s6snGBDAqCyEXSw3jHJs+1kotj0VvI9t
	 kmKp/dfJ7L/oGkPwO1cEGs34gq36d4BwfDUNevPNica8em78Ckw4NQowTgIVP1gtSw
	 phYo88ZOA+Eqw==
Date: Tue, 9 Jun 2026 19:00:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chenguang Zhao <zhaochenguang@kylinos.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Shuah Khan <shuah@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3] RDMA/CM: add RDMA CM observability regression scripts
Message-ID: <20260609160033.GD327369@unreal>
References: <20260506060305.891564-1-zhaochenguang@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260506060305.891564-1-zhaochenguang@kylinos.cn>

On Wed, May 06, 2026 at 02:03:05PM +0800, Chenguang Zhao wrote:
> This adds a minimal RDMA CM selftest suite that captures observability
> baselines and runs trace, counter-delta, and fault-injection-oriented
> checks, plus a review-loop helper for repeated validation rounds.
> 
> Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
> ---
> v3:
>  TARGET += rdma is already present, remove it 
>  as suggested by Yanjun.
> 
> v2:
>  https://lore.kernel.org/all/20260428071216.1212775-1-zhaochenguang@kylinos.cn/
> 
> v1:
>  https://lore.kernel.org/all/20260416062224.1546388-1-zhaochenguang@kylinos.cn/
> ---
>  tools/testing/selftests/rdma/Makefile         |  10 ++
>  tools/testing/selftests/rdma/config           |   6 +
>  .../selftests/rdma/rdma_cm_baseline.sh        |  58 ++++++++
>  .../selftests/rdma/rdma_cm_counter_delta.sh   |  72 ++++++++++
>  .../selftests/rdma/rdma_cm_fault_injection.sh |  95 +++++++++++++
>  .../selftests/rdma/rdma_cm_review_loop.sh     |  35 +++++
>  .../selftests/rdma/rdma_cm_trace_sequence.sh  |  83 ++++++++++++
>  tools/testing/selftests/rdma/rdma_common.sh   | 126 ++++++++++++++++++
>  8 files changed, 485 insertions(+)
>  create mode 100755 tools/testing/selftests/rdma/rdma_cm_baseline.sh
>  create mode 100755 tools/testing/selftests/rdma/rdma_cm_counter_delta.sh
>  create mode 100755 tools/testing/selftests/rdma/rdma_cm_fault_injection.sh
>  create mode 100755 tools/testing/selftests/rdma/rdma_cm_review_loop.sh
>  create mode 100755 tools/testing/selftests/rdma/rdma_cm_trace_sequence.sh
>  create mode 100755 tools/testing/selftests/rdma/rdma_common.sh
> 
> diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selftests/rdma/Makefile
> index 7dd7cba7a73c..04c52db4b9d9 100644
> --- a/tools/testing/selftests/rdma/Makefile
> +++ b/tools/testing/selftests/rdma/Makefile
> @@ -4,4 +4,14 @@ TEST_PROGS := rxe_rping_between_netns.sh \
>  		rxe_socket_with_netns.sh \
>  		rxe_test_NETDEV_UNREGISTER.sh
>  
> +TEST_PROGS += \
> +	rdma_cm_baseline.sh \
> +	rdma_cm_trace_sequence.sh \
> +	rdma_cm_counter_delta.sh \
> +	rdma_cm_fault_injection.sh
> +
> +TEST_FILES += \
> +	rdma_common.sh \
> +	rdma_cm_review_loop.sh
> +
>  include ../lib.mk
> diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
> index 4ffb814e253b..e22141838c19 100644
> --- a/tools/testing/selftests/rdma/config
> +++ b/tools/testing/selftests/rdma/config
> @@ -1,3 +1,9 @@
>  CONFIG_TUN
>  CONFIG_VETH
>  CONFIG_RDMA_RXE
> +CONFIG_DEBUG_KERNEL
> +CONFIG_FAULT_INJECTION
> +CONFIG_SYSFS
> +CONFIG_DEBUG_FS
> +CONFIG_FAULT_INJECTION_DEBUG_FS
> +CONFIG_FAILSLAB
> diff --git a/tools/testing/selftests/rdma/rdma_cm_baseline.sh b/tools/testing/selftests/rdma/rdma_cm_baseline.sh
> new file mode 100755
> index 000000000000..b0d8b3e46470
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rdma_cm_baseline.sh
> @@ -0,0 +1,58 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +set -euo pipefail
> +
> +SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
> +source "${SCRIPT_DIR}/rdma_common.sh"
> +
> +require_root
> +require_cmd date
> +require_cmd uname
> +
> +trace_dir="$(tracefs_dir || true)"
> +counter_root="$(find_cm_counter_root || true)"
> +out_dir="/tmp/rdma_cm_baseline.$(date +%s)"
> +dmesg_lines=400
> +dmesg_pattern="ib_cm|infiniband|rdma|roce|mlx|hns_roce|irdma|siw|rxe"

Sorry that it took so long to review this.

Please address Sashiko’s comments regarding 'fault injection most likely
not enabled here' and 'statistics check in wrong port':
https://sashiko.dev/#/patchset/20260506060305.891564-1-zhaochenguang@kylinos.cn

Also, 'dmesg_pattern' is not a scalable option. You should not rely on
the dmesg print format.

Thanks
