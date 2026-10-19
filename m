Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D4D3C4565
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383808; cv=none; b=GYOSlvo1luZNKMwcUxHhXPMJFVS6nohrRicQRStbpz2pO0wbipNTOiuLXcPAbiQBVkJcNEhQHzAqFGmh0qeqiyj/CAprq+evWBPl3brE4BY5YXpM52DBXzMvw16PX92rMjzEH3KVAl0bvZaQ1trEV3SIvScN9ol1sBGIiOdisjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383808; c=relaxed/simple;
	bh=3sqRFVi5C6qiZlQPtIoHSTPC60STghHsHl13PtUXzRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pTd2D3LCRCIJlTluxpnr+QR7qWBGnHQIddFSbPc+4h3GJ8mzE8c3u+YlKThvKzYgX4VRd/3Yn/sO4j0UYuT/BTVnk7llQbyKjgrTIGINQMWxBYVVNE6xUCv9uuhjSPdnsoUo/k8LxxunRHqlG8y1SLB1GbLWTpYSpfyUKtM4PJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UFMejIWw; arc=none smtp.client-ip=91.218.175.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UFMejIWw"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3sqRFVi5C6qiZlQPtIoHSTPC60STghHsHl13PtUXzRE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383803; v=1; x=1792988603;
 b=UFMejIWwKyZsWTQhMAAiEAVZpGChlWsdeAay0xY7HXEpz5zCkavQ/cMLhF1db3K0vx9s1GNQ
 5pZUu/i9FKibw2jqeEMArMe+Ju7pKLkXMtrV52DRGl4+lpISbgds10ymh4X+zWW1jAfOv5WkCdI
 MOsw5JHxroVJfs30A5++uSDc=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a86580b32d844e3b;
	Mon, 19 Oct 2026 04:23:23 +0000
X-Mizu-Trace-ID: a86580b32d844e3b
X-Migadu-Flow: FLOW_OUT
Message-ID: <64a0b285-1cbe-49b2-8665-8fe0e5535e2c@linux.dev>
Date: Sun, 18 Oct 2026 21:23:15 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] selftests/rdma: Add an eBPF-based testcase using
 netkit for RXE
To: jgg@ziepe.ca, leon@kernel.org, shuah@kernel.org, zyjzyj2000@gmail.com,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20261019041912.29488-1-yanjun.zhu@linux.dev>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261019041912.29488-1-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/18 21:19, Zhu Yanjun 写道:
> Add a new self-test case to verify RXE (Soft-RoCE) traffic using
> netkit virtual interfaces and an eBPF tcx ingress program to dump
> and parse RDMA transport headers (BTH, etc.).

The followings are the test results.

# make -C tools/testing/selftests/ TARGETS=rdma run_tests 
  
  make: Entering directory '/root/linux/tools/testing/selftests'
clang -g -O2 -target bpf -D__TARGET_ARCH_x86 -I../../../../usr/include 
-I../../../../include/uapi -I../bpf -c rxe_pkg_kernel_dump.c -o 
/root/linux/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.o
bpftool gen skeleton 
/root/linux/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.o > 
/root/linux/tools/testing/selftests/rdma/rxe_pkg_kernel.skel.h
gcc -D_GNU_SOURCE= 
-I/root/linux/tools/testing/selftests/../../../tools/testing/selftests 
-g -Wall -I../../../../usr/include -I../../../../include/uapi -I../bpf 
rxe_pkg_user_dump.c  -lbpf -lelf -lz -o 
/root/linux/tools/testing/selftests/rdma/rxe_netkit_dump
# timeout set to 45
# selftests: rdma: rxe_rping_between_netns.sh
ok 1 selftests: rdma: rxe_rping_between_netns.sh
# timeout set to 45
# selftests: rdma: rxe_ipv6.sh
ok 2 selftests: rdma: rxe_ipv6.sh
# timeout set to 45
# selftests: rdma: rxe_socket_with_netns.sh
ok 3 selftests: rdma: rxe_socket_with_netns.sh
# timeout set to 45
# selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
ok 4 selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
# timeout set to 45
# selftests: rdma: rxe_sent_rcvd_bytes.sh
# server DISCONNECT EVENT...
# wait for RDMA_READ_ADV state 10
ok 5 selftests: rdma: rxe_sent_rcvd_bytes.sh
# timeout set to 45
# selftests: rdma: rxe_netns_names.sh
# 1..0 # SKIP rdma netns exclusive mode is not supported
ok 6 selftests: rdma: rxe_netns_names.sh # SKIP
# timeout set to 45
# selftests: rdma: rxe_pkg_netkit.sh
# server DISCONNECT EVENT...
# wait for RDMA_READ_ADV state 10
# client DISCONNECT EVENT...
# ./rxe_pkg_netkit.sh: line 12:  5642 Killed 
"$CUR_WD/rxe_netkit_dump"
ok 7 selftests: rdma: rxe_pkg_netkit.sh
make: Leaving directory '/root/linux/tools/testing/selftests'

Yanjun Zhu

> 
> Zhu Yanjun (2):
>    selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE
>    selftests/rdma: Add netkit-based automated test script for RXE
> 
>   tools/testing/selftests/rdma/Makefile         |   23 +-
>   tools/testing/selftests/rdma/config           |    3 +
>   .../selftests/rdma/rxe_pkg_kernel_dump.c      |   62 +
>   .../testing/selftests/rdma/rxe_pkg_netkit.sh  |   63 +
>   .../selftests/rdma/rxe_pkg_user_dump.c        | 1275 +++++++++++++++++
>   5 files changed, 1425 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
>   create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh
>   create mode 100644 tools/testing/selftests/rdma/rxe_pkg_user_dump.c
> 

