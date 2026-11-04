Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785879;
	b=2QWFBzyVq8H+QqcTbaVnR9lMxWI87EVKwqnoJw/Qo5l+JsVInZAsKqwkjd81L+sn/jAc
	 LpJ7Hxvr2Dd3K1hE4+l+BK9El9akLj+rZGD8f4JRO5o3u29sY2iLIautSAW/vm1TRHx6G
	 DbAB707RKWt0DZ+KAd78aMXfHZBJqS8Hr2lZ+Nq0t8g1tu1UxRTf011uNoM+6aqkyYMhd
	 gdOYuF/TB13MdgPtV6kKMxKJbluXZu8NNcLtaHCQ7fJ9iMzVXCHKsidfzDd61/tnbg1hz
	 W35lf7US9L7onE6OckpgEo6UvFwFht4NbVwP6Vm7V5WR6aiQB+5EL/ln5DCFPaa8idQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785879;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=dIJPIwpES90xQ7z49M+pmvTQt1ecupVvISf5T2Czb5Y=;
	b=sMtX64GqZrF0zBMLESmqNKHBURCFUzZWn8QsP42dF3gHHnjvVxRdXSEpLho7HIIP9zF6
	 7+e7ctfgQk0omW4iw3x75pEtJBo0Qj+hr+MuEuUtlJGd+Tuwq22kYwAOCngXwRQ8KaZIm
	 KxRaUmDThfJQSKwB3hxjIecrG68AZdbC+vMQ4ru5zQ5wRvnRgTHxXSRNonjsk2a2zW93R
	 q9WQ2ruqBYb7qGCV53FZJUHNOMasbGfSjDiVkkZLI4axfQ/VhYgt5jeoA7381Yqfpdzm4
	 v/84yhs+fySdaVQaYJf+YqF+GcevZJCMTGUUzRMmC6X5enFnY+xMKNidfuA+Zmz3DRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OV74+N7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3713A606A329;
	Wed,  4 Nov 2026 09:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OV74+N7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030221F000C1;
	Wed,  4 Nov 2026 09:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785878;
	bh=dIJPIwpES90xQ7z49M+pmvTQt1ecupVvISf5T2Czb5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OV74+N7H0RV2l2wsoUAH0hCrWXUHCfKreWP48tvbQPx5krnWLkNRFmGq6HeXtLrZz
	 yR3BzbghqIX4566t5bCxLuRxIg/uq7vMAD5cNyWjQmzOZS2yZhAiua7INoEo7oZloa
	 tSBWnwa8z+ICXq1T2Nbe3RrgGOhZGd+Hq5syEZfmNhW3pmLe1iXXYJ6UJ9vW3XeHuo
	 6+5gCVlnDltXroozfOIoT+jGmW1Hbc5jENTOn/yvEqmyG8bWPh5IOtVUnZndHKjNwS
	 xwdRj39CtRts1OXiS4soxkVPvGAdHE7xMQiw5/ah03tn526gU92MunaLWKNRul3c3V
	 +uzQGb96nABGQ==
Date: Wed, 4 Nov 2026 11:51:14 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yuqiang Sun <izaiahsun@gmail.com>
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
	guoqing.jiang@linux.dev, lgs201920130244@gmail.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] RDMA/rtrs-srv: Do not free the path on path file
 creation failure
Message-ID: <20261104095114.GB478286@unreal>
References: <20261103122024.GG264423@unreal>
 <20261103134939.55513-1-izaiahsun@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103134939.55513-1-izaiahsun@gmail.com>

On Tue, Nov 03, 2026 at 09:49:39PM +0800, Yuqiang Sun wrote:
> On Tue, Nov 03, 2026 at 02:20:24PM +0200, Leon Romanovsky wrote:
> > Interesting claim. How did you trigger the KASAN warning in the RDMA ULP?
> 
> With soft-RoCE in a KVM guest, with both ends of rtrs in the same guest,
> and failslab standing in for an allocation failure:
> 
> - Kernel: rdma for-next c3e8e9451e6f, x86_64, with KASAN, RDMA_RXE,
>   INFINIBAND_RTRS_CLIENT/SERVER, BLK_DEV_RNBD_CLIENT/SERVER, BLK_DEV_RAM,
>   FAILSLAB and FAULT_INJECTION_STACKTRACE_FILTER, all built in.
> - In the guest: "rdma link add rxe0 type rxe netdev eth0", then failslab
>   is limited to call stacks through rtrs_srv_create_path_files()
>   (require-start/require-end set to its range from /proc/kallsyms,
>   stacktrace-depth 32, probability 100, times 1, interval N), and /dev/ram0
>   is mapped through the rnbd client:
>   echo "sessname=s1 path=ip:10.0.2.15 device_path=/dev/ram0" \
>        > /sys/class/rnbd-client/ctl/map_device
> - The server handles the client's info request in its completion worker,
>   in rtrs_srv_info_req_done(). With N chosen so that the failing
>   allocation is the one in kobject_init_and_add() of srv_path->kobj,
>   rtrs_srv_create_path_files() fails, its kobject_put() frees srv_path
>   through rtrs_srv_release(), and process_info_req() and
>   rtrs_srv_info_req_done() go on using it: that is the KASAN report in
>   the changelog, followed by more in rtrs_srv_close_work() and a general
>   protection fault. Failing the stats kobject instead gives reports of
>   the same kind.
> 
> The steps in the guest, after boot:
> 
>   ip link set eth0 up
>   ip addr add 10.0.2.15/24 dev eth0
>   rdma link add rxe0 type rxe netdev eth0
>   f=rtrs_srv_create_path_files
>   start=$(awk -v f=$f '$3 == f {print $1; exit}' /proc/kallsyms)
>   end=$(sort /proc/kallsyms |
>         awk -v s=$start 'found && $1 != s {print $1; exit} $1 == s {found=1}')
>   F=/sys/kernel/debug/failslab
>   echo 0x$start > $F/require-start
>   echo 0x$end > $F/require-end
>   echo 32 > $F/stacktrace-depth
>   echo N > $F/task-filter
>   echo N > $F/ignore-gfp-wait
>   echo $N > $F/interval
>   echo 1 > $F/times
>   echo 2 > $F/verbose
>   echo 100 > $F/probability
>   echo "sessname=s1 path=ip:10.0.2.15 device_path=/dev/ram0" \
>        > /sys/class/rnbd-client/ctl/map_device
> 
> With verbose=2 failslab prints the stack of the allocation it fails, so
> N is found by trying N=1, 2, ... until it is the one in
> kobject_init_and_add() for srv_path->kobj (21 in our build).
> 
> So it needs an allocation failure while a client connects; nothing else
> is unusual. I can send the full KASAN log, the init script and the
> kernel config if that helps. The client that triggers patch 2's
> use-after-free from the network by sending an empty pathname (fixed by
> patch 3) is not public; I can send it to you privately if you want it.

No, I don't need it. I was just curious what “no RDMA hardware” means.

Thanks

> 
> Thanks,
> Yuqiang
