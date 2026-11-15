Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794747099;
	b=JBbAihyVriMHUCISSd+VKBjvkrU2VdHx3l0PRpm1pWf2mLTZ8P+e7B+3GJP90HprViM1
	 lbdq3Wy8f9TxFlaxas0sOigTXRrEGztHMi3iv613BIuHklCMFi7YZCMSA79tGDLzb4Eiv
	 dwl/405w2JthdyWkuZtIi5aPFnii1Bu6ZUIfCMv2h8xO+XiqIH0xPVGs/xJ2W7bSqsxyj
	 /2ptYjteRFq7TPqPNS6s+qRb1/0HsCJMswE+Wdv1S3vfJrIlDyh4zfIa23THKvBXvvr9V
	 aFQuNq9EjuJMS+Rzhot+31m+5VOa128BaKHwNZulvn0V/6zzD3YzN0BNuyi2PQ4HJSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794747099;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qPBjkdBDzlUtD5nQuCT9K+06zNKQ+/uPG+/Vo8m+ws8=;
	b=CtVSwofLDTguxiW9Kry1Zq9gXBvRFalU620kDJQ0grt9qXuqpi/07iM6yurSpyGGyRFI
	 2vAipGZlebiCqgilDEQr9me3uZI240a9ddPwpYP1DoeaWMjjfPUAM+YjjYLkFwFrADFlJ
	 70EgVgS1iWV78X2jEk8ujoOZz9cYbn/hXAtxPxCb/riZDO9f7DizfBEGPHzLVjhVx0+tm
	 FAEi42OnVU8UkBAcl8P7GotVoQKNGyvDSLLittQS79GaazfyFmoT9RCzhViAwzHoWwEuT
	 xzqQVmpLs3APn9YfeBwQM3sCbji+c7yo+2eYD0VGvnFLdDej0J4go9pUZsMaboU+rGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeSNLrVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8197606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeSNLrVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FCF1F000C8;
	Sun, 15 Nov 2026 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794747099;
	bh=qPBjkdBDzlUtD5nQuCT9K+06zNKQ+/uPG+/Vo8m+ws8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MeSNLrVZUye2l8S+k3lWdEMk+p7Rd0hbw3y2mpdd7XT9dzB+Zw8k+giE3vtKLacvx
	 7jDPf2OOc7I4GUH53NAw0QWPkezhNqaYMFqnZxMqzO7c2yb34J4xna6SDs8H//HiBm
	 /z+tc10WvEpqF6FIbCy/wcxAK2NFGC0rPXq8yn4GHrSTxFipOsxB3mngJZX1n4HTPo
	 ddmGfw4DUcfIvVuFJsqkCuKpvF/LGPUYRhwabqzYbe45+pX3EU+FbwRxa49ygxRGQg
	 XrvHS21mIOxymxge+lLPYQ8+SAopQj4MhF9+nAP97quD/fsFD73BCuAANZSuIFb3FP
	 l7JSpLcYvMWPw==
Date: Sun, 15 Nov 2026 14:51:33 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Stephen Bates <sbates@raithlin.com>
Cc: linux-rdma@vger.kernel.org, sshaul@nvidia.com, stephen.bates@amd.com,
	abhijit.gangurde@amd.com, nikhil.agarwal@amd.com,
	Claude <noreply@anthropic.com>
Subject: Re: [PATCH v3] perftest: add a ROCm build to CI
Message-ID: <20261115125133.GA42525@unreal>
References: <20261106224821.126399-1-sbates@raithlin.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106224821.126399-1-sbates@raithlin.com>

On Fri, Nov 06, 2026 at 04:48:21PM -0600, Stephen Bates wrote:
> CI builds only the CUDA configuration. The two existing workflows pass no
> --enable-rocm, so src/rocm_memory.c and everything behind HAVE_ROCM and
> HAVE_ROCM_DMABUF is never compiled on a pull request, and a change that
> breaks the ROCm backend goes green.
> 
> Add an Ubuntu 24.04 job building --enable-rocm --enable-rocm-dmabuf,
> alongside the two CUDA jobs and triggered the same way. It runs in AMD's
> slim ROCm image rather than installing ROCm on the runner. The -full and
> -complete tags, and an apt install of the amdrocm-core metapackages, all
> pull the whole ML stack: Composable Kernel alone is over 2 GB, before
> rocSHMEM, MIOpen and the BLAS and FFT libraries. A compile check touches
> none of it. rocm/dev-ubuntu-24.04:7.2.4 is about 1.1 GB against 8.3 GB
> for the smallest 10.1 image, and still ships hipcc and the HIP and HSA
> headers needed to compile the ROCm backend.
> 
> 7.2.4 rather than 10.1 because AMD publishes slim tags only through 7.2.x;
> every 10.x tag is -full. What this job needs is a toolchain that compiles
> the sources, which that image provides. Moving to a newer ROCm is a
> one-line change to the container tag if a slim 10.x image appears, or if
> something here starts depending on a newer HIP API.
> 
> This is a single host-only build; there are no HIP kernel sources in the
> project yet, so there is nothing to compile for a specific device target.
> When device code and --with-rocm-arch support are introduced this job can
> gain an architecture matrix at that point.
> 
> Like the CUDA jobs this builds and installs only. There is no RDMA device
> in a runner, and the project has no test suite.
> 
> Verified by running this workflow in a fork of the repository. The job
> passed: configure accepts every option, and make and make install succeed
> warning-free.
> 
> Link: https://github.com/linux-rdma/perftest/pull/418
> 
> Co-Authored-By: Claude <noreply@anthropic.com>
> Signed-off-by: Stephen Bates <sbates@raithlin.com>

Stephen,

Thanks for bringing this to the mailing list. It brought to my attention that
the perftest repository had been neglected.

Please open a PR against the perftest repository, and I'll start cleaning
things up there.

Thanks

> ---
> 
> Changes since v2:
>   Drop the architecture matrix; collapse to a single host-only build job.
>   Update the commit message to match what the workflow actually does.
>   An architecture matrix will be added when HIP kernel sources and
>   --with-rocm-arch support are introduced.
>  .github/workflows/ubuntu24_04_rocm7_2.yaml | 72 ++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
>  create mode 100644 .github/workflows/ubuntu24_04_rocm7_2.yaml
> 
> diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflows/ubuntu24_04_rocm7_2.yaml
> new file mode 100644
> index 0000000..e8f3ea5
> --- /dev/null
> +++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
> @@ -0,0 +1,72 @@
> +name: Build and Test perftest on Ubuntu 24.04 with ROCm
> +
> +on:
> +  push:
> +    branches:
> +      - master
> +  pull_request:
> +    branches:
> +      - master
> +  workflow_dispatch:
> +
> +jobs:
> +  build:
> +    runs-on: ubuntu-24.04
> +
> +    # AMD's slim ROCm image. The -full and -complete tags carry the whole ML
> +    # stack -- Composable Kernel alone is over 2 GB -- which a compile check
> +    # never touches. This one is about 1.1 GB and still ships hipcc and the
> +    # HIP and HSA headers needed to compile the ROCm backend.
> +    container: rocm/dev-ubuntu-24.04:7.2.4
> +
> +    name: ROCm
> +
> +    steps:
> +      - name: Checkout repository
> +        uses: actions/checkout@v4
> +
> +      # The job runs as root inside the container, so no sudo here.
> +      - name: Install build dependencies
> +        run: |
> +          export DEBIAN_FRONTEND=noninteractive
> +          apt-get update
> +          apt-get install -y \
> +            build-essential \
> +            autoconf \
> +            automake \
> +            libtool \
> +            pkg-config \
> +            libibverbs-dev \
> +            librdmacm-dev \
> +            libibumad-dev \
> +            libpci-dev
> +
> +      - name: Locate ROCm
> +        run: |
> +          # The image ships /opt/rocm as a symlink to a versioned prefix.
> +          # configure needs the include path, so resolve it rather than
> +          # assuming either spelling.
> +          ROCM_PATH=$(ls -d /opt/rocm* 2>/dev/null | sort -V | tail -1)
> +          if [ -z "$ROCM_PATH" ]; then
> +            echo "No ROCm installation found under /opt" >&2
> +            ls -la /opt || true
> +            exit 1
> +          fi
> +          echo "Using ROCm at $ROCM_PATH"
> +          "$ROCM_PATH/bin/hipcc" --version | head -2 || hipcc --version | head -2
> +          echo "ROCM_PATH=$ROCM_PATH" >> $GITHUB_ENV
> +          echo "$ROCM_PATH/bin" >> $GITHUB_PATH
> +
> +      - name: Run autogen.sh
> +        run: ./autogen.sh
> +
> +      - name: Configure the build
> +        run: |
> +          ./configure --enable-rocm --enable-rocm-dmabuf \
> +                      --with-rocm="$ROCM_PATH"
> +
> +      - name: Build perftest
> +        run: make
> +
> +      - name: Install perftest
> +        run: make install
> -- 
> 2.53.0
> 
> 
> 
