Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D05F2F1FED
	for <linux-rdma@vger.kernel.org>; Sun,  2 Aug 2026 22:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709717; cv=none; b=nDnO1eJr5T+ggjIb+o+vSCeENtUJb5Jo8urVPwnv+kppQkwCJ6rBKu8fHef1JsLs0YAcvg3EhdoHP5swdN4AgYmi2XSNHTy3ynflHfN4w+2NkyMclY4GT+o7GK20uDF/bh3wKZUYeCBTm/l+N0bDwVIvYDGRBDQy0NNUoA/3Zcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709717; c=relaxed/simple;
	bh=qSEdTGmlz6hnWmBJ5Bf3MOC32YPL+ZC5i8hVD5DueBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aiUjsi9QpD/cmRrpk9O0/jHh5GVIibRZ8pAY1NibL0tx2RqThA9lP5X2P3sFHgxglUb7lf3n/4PbQRTiXbCtmifI0Jd4uD5zrkmlb5ZdVCmasjnH4mPBhS3YgXNN3Ws6e2RthRoxi967lmNZl/SFVX4yoy7fQtCKQU9bOB8v6e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=efA3Yd6q; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="efA3Yd6q"
Message-ID: <36d31c1e-aebe-4a48-ab44-4447c0a75a33@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785709712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lXwAzL20+Uqpz1hlLW2lT9GN/olu3sQDzz3nXWC18Nk=;
	b=efA3Yd6qdyjXxQZH1SsoI8UcpHDgKQo4Nbt2rYwoq8PRpfF9OTfbJaitaRJmYYzgPs5rP/
	WnuaDbL5iUbhMK5bep9/pE8Lg89AzhYUW6iFPynslK9IFoZki+BCQSVtQaaLPeFoaGp/QO
	oUbHKLh9SS6WAko63P+dQfNUYfDoUpk=
Date: Sun, 2 Aug 2026 15:28:25 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net 2/2] DO-NOT-MERGE: selftest: add rxe mr_check_range()
 overflow reproducer
To: Gang Yan <gang.yan@linux.dev>, zyjzyj2000@gmail.com,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, Gang Yan <yangang@kylinos.cn>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <20260728091128.9116-3-gang.yan@linux.dev>
 <c93089b8-bb9f-4aac-a644-36b6cc9b5d59@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <c93089b8-bb9f-4aac-a644-36b6cc9b5d59@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/8/2 15:09, Zhu Yanjun 写道:
> 在 2026/7/28 2:11, Gang Yan 写道:
>> From: Gang Yan <yangang@kylinos.cn>
>>
>> This patch is for reproduce the OOB issue.
>>
>> Requirements:
>> * Kernel built with ``CONFIG_INFINIBAND``, 
>> ``CONFIG_INFINIBAND_USER_ACCESS``
>>    and ``CONFIG_RDMA_RXE`` (=m is fine).
>> * ``rdma_rxe`` module loadable (``modprobe rdma_rxe``).
>> * Userspace headers/libs to build the helper: ``libibverbs-dev``,
>>    ``librdmacm-dev``.
>> * Root (the script builds a network namespace, a veth pair and two rxe
>>    devices).
>>
>> BUILD and RUN:
>>      cd tools/testing/selftests/rdma
>>      make
>>      # as root:
>>      ./rxe_mr_overflow.sh
>>
>> Expected results (Unpatched kernel (bug present) — FAIL):
>> The kernel log shows the index WARNING immediately followed by an OOB 
>> Oops
>> in the responder path::
>>
>>      WARNING: CPU: N PID: ... at rxe_mr_iova_to_index+0x.../0x... 
>> [rdma_rxe]
>>      ...
>>      RIP: 0010:rxe_mr_iova_to_index+0x.../0x... [rdma_rxe]
>>      Call Trace:
>>       <TASK>
>>       rxe_mr_copy+0x.../0x... [rdma_rxe]
>>       rxe_receiver+0x.../0x... [rdma_rxe]
>>       do_work+0x.../0x... [rdma_rxe]
>>       ...
>>      Oops: general protection fault, probably for non-canonical 
>> address 0x...
>>      Workqueue: rxe_wq do_work [rdma_rxe]
>>      RIP: 0010:rxe_mr_copy+0x.../0x... [rdma_rxe]
>>      Call Trace:
>>       <TASK>
>>       rxe_mr_copy+0x.../0x... [rdma_rxe]
>>       rxe_receiver+0x.../0x... [rdma_rxe]
>>       do_work+0x.../0x... [rdma_rxe]
>>
>> Assisted-by: Codex: GLM-5.2
>> Signed-off-by: Gang Yan <yangang@kylinos.cn>
>> ---
>>   tools/testing/selftests/rdma/Makefile         |   8 +-
>>   tools/testing/selftests/rdma/config           |   2 +
>>   .../testing/selftests/rdma/rxe_mr_overflow.c  | 187 ++++++++++++++++++
>>   .../testing/selftests/rdma/rxe_mr_overflow.sh | 132 +++++++++++++
>>   4 files changed, 328 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.c
>>   create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.sh
>>
>> diff --git a/tools/testing/selftests/rdma/Makefile 
>> b/tools/testing/selftests/rdma/Makefile
>> index 07af7f15c1bf..effeb8121d41 100644
>> --- a/tools/testing/selftests/rdma/Makefile
>> +++ b/tools/testing/selftests/rdma/Makefile
>> @@ -1,8 +1,14 @@
>>   # SPDX-License-Identifier: GPL-2.0
>> -TEST_PROGS := rxe_rping_between_netns.sh \
>> +TEST_GEN_FILES := rxe_mr_overflow
>> +TEST_PROGS := rxe_mr_overflow.sh \
>> +        rxe_rping_between_netns.sh \
>>           rxe_ipv6.sh \
>>           rxe_socket_with_netns.sh \
>>           rxe_test_NETDEV_UNREGISTER.sh \
>>           rxe_sent_rcvd_bytes.sh
>>     include ../lib.mk
>> +
>> +# rxe_mr_overflow uses libibverbs / librdmacm
>> +$(OUTPUT)/rxe_mr_overflow: CFLAGS += -O2 -Wall
>> +$(OUTPUT)/rxe_mr_overflow: LDLIBS += -libverbs -lrdmacm
>> diff --git a/tools/testing/selftests/rdma/config 
>> b/tools/testing/selftests/rdma/config
>> index 4ffb814e253b..bc27ce3ec093 100644
>> --- a/tools/testing/selftests/rdma/config
>> +++ b/tools/testing/selftests/rdma/config
>> @@ -1,3 +1,5 @@
>>   CONFIG_TUN
>>   CONFIG_VETH
>>   CONFIG_RDMA_RXE
>> +CONFIG_INFINIBAND
>> +CONFIG_INFINIBAND_USER_ACCESS
>> diff --git a/tools/testing/selftests/rdma/rxe_mr_overflow.c 
>> b/tools/testing/selftests/rdma/rxe_mr_overflow.c
>> new file mode 100644
>> index 000000000000..ccad930533ac
>> --- /dev/null
>> +++ b/tools/testing/selftests/rdma/rxe_mr_overflow.c
>> @@ -0,0 +1,187 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * rxe_mr_overflow.c - trigger mr_check_range() iova overflow (OOB)
>> + *
>> + * Companion to rxe_mr_overflow.sh. The server registers a 
>> USER/MEM_REG MR
>> + * and accepts an RDMA_CM connection, passing its rkey via private 
>> data. The
>> + * client posts a single RDMA-WRITE whose remote_addr is chosen so that
>> + * iova + length wraps to 0 in mr_check_range():
>> + *
>> + *     iova + length = 0xfffffffffffffff8 + 8 = 2^64 = 0
>> + *
>> + * On an *unpatched* kernel this bypasses mr_check_range(), and the 
>> responder
>> + * computes a huge index in rxe_mr_iova_to_index() (WARN_ON(idx >= 
>> nbuf)) and
>> + * dereferences mr->page_info[huge] -> out-of-bounds access / oops.
>> + *
>> + * On a *patched* kernel mr_check_range() rejects the crafted iova 
>> and the
>> + * client completion is IBV_WC_REM_ACCESS_ERR (remote access error).
>> + *
>> + * Build: see Makefile (needs libibverbs-dev / librdmacm-dev).
>> + */
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <stdint.h>
>> +#include <arpa/inet.h>
>> +#include <infiniband/verbs.h>
>> +#include <rdma/rdma_cma.h>
>> +
>> +#define BAD_ADDR    0xfffffffffffffff8ULL    /* iova + WR_LEN wraps 
>> to 0 */
>> +#define WR_LEN        8
>> +#define MR_LEN        4096
>> +
>> +struct mr_info {
>> +    uint32_t rkey;
>> +    uint32_t pad;
>> +    uint64_t iova;
>> +} __attribute__((packed));
>> +
>> +static int wait_ev(struct rdma_event_channel *ec, struct 
>> rdma_cm_event **ev,
>> +           enum rdma_cm_event_type want)
>> +{
>> +    while (rdma_get_cm_event(ec, ev) == 0) {
>> +        if ((*ev)->event != want) {
>> +            fprintf(stderr, "unexpected event %s (want %s)\n",
>> +                rdma_event_str((*ev)->event), rdma_event_str(want));
>> +            rdma_ack_cm_event(*ev);
>> +            return -1;
>> +        }
>> +        return 0;
>> +    }
>> +    perror("rdma_get_cm_event");
>> +    return -1;
>> +}
>> +
>> +static int run_server(const char *ip, int port)
>> +{
>> +    struct rdma_event_channel *ec = rdma_create_event_channel();
>> +    struct rdma_cm_id *lid;
>> +    struct rdma_cm_event *ev;
>> +
>> +    if (!ec) { perror("event_channel"); return 1; }
>> +    if (rdma_create_id(ec, &lid, NULL, RDMA_PS_TCP)) { 
>> perror("create_id"); return 1; }
>> +
>> +    struct sockaddr_in sin = {0};
>> +    sin.sin_family = AF_INET;
>> +    sin.sin_port = htons(port);
>> +    if (!inet_pton(AF_INET, ip, &sin.sin_addr)) { fprintf(stderr, 
>> "bad ip\n"); return 1; }
>> +
>> +    if (rdma_bind_addr(lid, (struct sockaddr *)&sin)) { 
>> perror("bind_addr"); return 1; }
>> +    if (rdma_listen(lid, 1)) { perror("listen"); return 1; }
>> +    printf("[server] listen %s:%d dev=%s\n", ip, port,
>> +        lid->verbs ? ibv_get_device_name(lid->verbs->device) : "?");
>> +    fflush(stdout);
>> +
>> +    if (wait_ev(ec, &ev, RDMA_CM_EVENT_CONNECT_REQUEST)) return 1;
>> +    struct rdma_cm_id *id = ev->id;
>> +
>> +    struct ibv_pd *pd = ibv_alloc_pd(id->verbs);
>> +    struct ibv_cq *cq = ibv_create_cq(id->verbs, 8, NULL, NULL, 0);
>> +    if (!pd || !cq) { perror("alloc_pd/create_cq"); return 1; }
>> +    void *buf = calloc(1, MR_LEN);
>> +    struct ibv_mr *mr = ibv_reg_mr(pd, buf, MR_LEN,
>> +        IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_WRITE);
>> +    if (!mr) { perror("reg_mr"); return 1; }
>> +
>> +    struct ibv_qp_init_attr qa = {0};
>> +    qa.send_cq = cq; qa.recv_cq = cq; qa.qp_type = IBV_QPT_RC;
>> +    qa.cap.max_send_wr = 4; qa.cap.max_recv_wr = 4;
>> +    qa.cap.max_send_sge = 2; qa.cap.max_recv_sge = 2;
>> +    if (rdma_create_qp(id, pd, &qa)) { perror("create_qp"); return 1; }
>> +
>> +    struct mr_info info = { .rkey = mr->rkey, .iova = 
>> (uint64_t)(uintptr_t)buf };
>> +    struct rdma_conn_param p = {0};
>> +    p.private_data = &info;
>> +    p.private_data_len = sizeof(info);
>> +    p.initiator_depth = 1;
>> +    p.responder_resources = 1;
>> +    if (rdma_accept(id, &p)) { perror("accept"); return 1; }
>> +    rdma_ack_cm_event(ev);
>> +    printf("[server] accepted rkey=%#x iova=%#llx; waiting for 
>> client write\n",
>> +        mr->rkey, (unsigned long long)info.iova);
>> +    fflush(stdout);
>> +
>> +    /* The OOB (if unpatched) fires here in the responder path. */
>> +    sleep(5);
>> +    return 0;
>> +}
>> +
>> +static int run_client(const char *ip, int port)
>> +{
>> +    struct rdma_event_channel *ec = rdma_create_event_channel();
>> +    struct rdma_cm_id *id;
>> +    struct rdma_cm_event *ev;
>> +
>> +    if (!ec) { perror("event_channel"); return 1; }
>> +    if (rdma_create_id(ec, &id, NULL, RDMA_PS_TCP)) { 
>> perror("create_id"); return 1; }
>> +
>> +    struct sockaddr_in sin = {0};
>> +    sin.sin_family = AF_INET; sin.sin_port = htons(port);
>> +    if (!inet_pton(AF_INET, ip, &sin.sin_addr)) { fprintf(stderr, 
>> "bad ip\n"); return 1; }
>> +
>> +    if (rdma_resolve_addr(id, NULL, (struct sockaddr *)&sin, 5000)) 
>> { perror("resolve_addr"); return 1; }
>> +    if (wait_ev(ec, &ev, RDMA_CM_EVENT_ADDR_RESOLVED)) return 1;
>> +    rdma_ack_cm_event(ev);
>> +    if (rdma_resolve_route(id, 5000)) { perror("resolve_route"); 
>> return 1; }
>> +    if (wait_ev(ec, &ev, RDMA_CM_EVENT_ROUTE_RESOLVED)) return 1;
>> +    rdma_ack_cm_event(ev);
>> +
>> +    struct ibv_pd *pd = ibv_alloc_pd(id->verbs);
>> +    struct ibv_cq *cq = ibv_create_cq(id->verbs, 8, NULL, NULL, 0);
>> +    void *buf = calloc(1, MR_LEN);
>> +    struct ibv_mr *mr = ibv_reg_mr(pd, buf, MR_LEN, 
>> IBV_ACCESS_LOCAL_WRITE);
>> +    struct ibv_qp_init_attr qa = {0};
>> +    qa.send_cq = cq; qa.recv_cq = cq; qa.qp_type = IBV_QPT_RC;
>> +    qa.cap.max_send_wr = 4; qa.cap.max_recv_wr = 4;
>> +    qa.cap.max_send_sge = 2; qa.cap.max_recv_sge = 2;
>> +    if (rdma_create_qp(id, pd, &qa)) { perror("create_qp"); return 1; }
>> +
>> +    struct rdma_conn_param p = {0};
>> +    p.initiator_depth = 1; p.responder_resources = 1; p.retry_count 
>> = 3;
>> +    if (rdma_connect(id, &p)) { perror("connect"); return 1; }
>> +    if (wait_ev(ec, &ev, RDMA_CM_EVENT_ESTABLISHED)) return 1;
>> +
>> +    struct mr_info info = {0};
>> +    if (ev->param.conn.private_data_len >= (int)sizeof(info))
>> +        memcpy(&info, ev->param.conn.private_data, sizeof(info));
>> +    rdma_ack_cm_event(ev);
>> +
>> +    /* The malicious RDMA-WRITE: remote_addr makes iova+length wrap. */
>> +    struct ibv_sge sge = { .addr = (uintptr_t)buf, .length = WR_LEN, 
>> .lkey = mr->lkey };
>> +    struct ibv_send_wr wr = {0}, *bad;
>> +    wr.wr_id = 0xdead;
>> +    wr.opcode = IBV_WR_RDMA_WRITE;
>> +    wr.send_flags = IBV_SEND_SIGNALED;
>> +    wr.sg_list = &sge;
>> +    wr.num_sge = 1;
>> +    wr.wr.rdma.remote_addr = BAD_ADDR;
>> +    wr.wr.rdma.rkey = info.rkey;
>> +    printf("[client] post RDMA-WRITE remote_addr=%#llx len=%d 
>> rkey=%#x\n",
>> +        (unsigned long long)BAD_ADDR, WR_LEN, info.rkey);
>> +    fflush(stdout);
>> +    ibv_post_send(id->qp, &wr, &bad);
>> +
>> +    struct ibv_wc wc;
>> +    int n, tries = 5000;
>> +    while (tries-- > 0 && (n = ibv_poll_cq(cq, 1, &wc)) == 0)
>> +        usleep(1000);
>> +    if (n > 0)
>> +        printf("[client] completion status=%d (%s)\n",
>> +            wc.status, ibv_wc_status_str(wc.status));
>> +    else
>> +        printf("[client] no completion (responder likely crashed)\n");
>> +    sleep(2);
>> +    return 0;
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +    if (argc == 3)            /* server <ip> <port> */
>> +        return run_server(argv[1], atoi(argv[2]));
>> +    if (argc == 4 && !strcmp(argv[1], "-c"))    /* -c <ip> <port> */
>> +        return run_client(argv[2], atoi(argv[3]));
>> +    fprintf(stderr, "Usage:\n  server: %s <ip> <port>\n  client: %s 
>> -c <ip> <port>\n",
>> +        argv[0], argv[0]);
>> +    return 1;
>> +}
>> diff --git a/tools/testing/selftests/rdma/rxe_mr_overflow.sh 
>> b/tools/testing/selftests/rdma/rxe_mr_overflow.sh
>> new file mode 100644
>> index 000000000000..2590e41be99b
>> --- /dev/null
>> +++ b/tools/testing/selftests/rdma/rxe_mr_overflow.sh
>> @@ -0,0 +1,132 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Regression test for the mr_check_range() iova overflow in SoftRoCE 
>> (rxe).
>> +#
>> +# A remote peer can craft an RDMA-WRITE whose RETH makes iova + 
>> length wrap
>> +# to 0, bypassing the old
>> +#
>> +#    if (iova + length > mr->ibmr.iova + mr->ibmr.length)
>> +#
>> +# range check in mr_check_range(). The responder then derives a huge 
>> page
>> +# index in rxe_mr_iova_to_index() (only WARN_ON-guarded) and 
>> dereferences
>> +# mr->page_info[huge] -> out-of-bounds read/write / kernel oops, 
>> triggerable
>> +# by an unauthenticated remote peer.
>> +#
>> +# Fixed by rewriting the check in overflow-safe form:
>> +#
>> +#    if (iova < mr->ibmr.iova ||
>> +#        length > mr->ibmr.length ||
>> +#        iova - mr->ibmr.iova > mr->ibmr.length - length)
>> +#
>> +# Topology: a veth pair across a network namespace, one rxe device 
>> on each
>> +# end. The server (ns) registers a USER MR and accepts an RDMA_CM
>> +# connection, passing its rkey/iova in the private data. The client 
>> (host)
>> +# posts one RDMA-WRITE with remote_addr = 0xfffffffffffffff8, len = 8.
>> +#
>> +#   - Patched kernel:   PASS  (mr_check_range() rejects the crafted 
>> iova;
>> +#                              the client completion is 
>> IBV_WC_REM_ACCESS_ERR;
>> +#                              no kernel warning/oops in dmesg)
>> +#   - Unpatched kernel: FAIL  (WARN_ON in rxe_mr_iova_to_index 
>> followed by
>> +#                              an OOB page fault / oops in rxe_mr_copy)
>> +
> Thanks a lot. When I run rdma selftests. I got the following:
> "
> # Warning: file rxe_mr_overflow.sh is not executable
> "
> You need to make rxe_mr_overflow.sh executable.

After this testcase is run, please remove this bin file rxe_mr_overflow 
in tools/testing/selftests/rdma.

Thanks a lot.

Zhu Yanjun

>
> And please also check and try to fix some warnings from sashiko.
>
> Thanks a lot.
> Zhu Yanjun
>
>> +NS="rxe_mrovf"
>> +VETH_NS="vmo-a"
>> +VETH_HOST="vmo-b"
>> +IP_NS="1.1.1.1"
>> +IP_HOST="1.1.1.2"
>> +PORT=4792
>> +BIN="$(dirname "$(readlink -f "$0")")/rxe_mr_overflow"
>> +
>> +source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
>> +
>> +SRV=
>> +
>> +# Remove the topology this script creates. Idempotent: safe to call 
>> even when
>> +# some of the resources no longer exist (e.g. partial setup, prior 
>> abort).
>> +rxe_teardown() {
>> +    rdma link del rxe1 2>/dev/null
>> +    ip netns exec "$NS" rdma link del rxe0 2>/dev/null
>> +    ip link delete "$VETH_HOST" 2>/dev/null
>> +    ip netns del "$NS" 2>/dev/null
>> +}
>> +
>> +cleanup() {
>> +    trap '' INT TERM EXIT        # guard against re-entry
>> +    # Kill the server first so the client does not block on a dead 
>> peer.
>> +    [ -n "$SRV" ] && kill "$SRV" 2>/dev/null
>> +    wait "$SRV" 2>/dev/null
>> +    rxe_teardown
>> +    modprobe -r rdma_rxe 2>/dev/null
>> +}
>> +# Cover normal exit, Ctrl+C (SIGINT) and kill (SIGTERM) alike.
>> +trap cleanup INT TERM EXIT
>> +
>> +# Tear down any leftover topology from a previous aborted run 
>> (SIGINT, kill
>> +# -9, guest crash, ...) so this script is always re-runnable instead of
>> +# failing on "RTNETLINK answers: File exists".
>> +rxe_teardown
>> +
>> +# --- Prerequisites ---
>> +if [ "$EUID" -ne 0 ]; then
>> +    ktap_print_header
>> +    ktap_skip_all "needs root"
>> +    exit "$KSFT_SKIP"
>> +fi
>> +if ! modinfo rdma_rxe >/dev/null 2>&1; then
>> +    ktap_print_header
>> +    ktap_skip_all "rdma_rxe module not found"
>> +    exit "$KSFT_SKIP"
>> +fi
>> +if [ ! -x "$BIN" ]; then
>> +    ktap_print_header
>> +    ktap_skip_all "$BIN not built (needs libibverbs-dev / 
>> librdmacm-dev)"
>> +    exit "$KSFT_SKIP"
>> +fi
>> +
>> +modprobe rdma_rxe >/dev/null 2>&1
>> +
>> +# --- Topology: veth pair across a netns, one rxe device on each end 
>> ---
>> +ip netns add "$NS"
>> +ip link add "$VETH_NS" type veth peer name "$VETH_HOST"
>> +ip link set "$VETH_NS" netns "$NS"
>> +
>> +ip netns exec "$NS" ip addr add "$IP_NS/24" dev "$VETH_NS"
>> +ip netns exec "$NS" ip link set "$VETH_NS" up
>> +ip netns exec "$NS" ip link set lo up
>> +ip addr add "$IP_HOST/24" dev "$VETH_HOST"
>> +ip link set "$VETH_HOST" up
>> +
>> +ip netns exec "$NS" rdma link add rxe0 type rxe netdev "$VETH_NS"
>> +rdma link add rxe1 type rxe netdev "$VETH_HOST"
>> +
>> +if ! ping -c 2 -W 1 "$IP_NS" >/dev/null 2>&1; then
>> +    ktap_print_header
>> +    ktap_skip_all "no connectivity between host and netns"
>> +    exit "$KSFT_SKIP"
>> +fi
>> +
>> +# Only look at warnings produced by this run.
>> +dmesg -C >/dev/null 2>&1
>> +
>> +# --- Run: server in the netns, client on the host ---
>> +# On an unpatched kernel the crafted WRITE can wedge the responder; 
>> wrap both
>> +# sides in timeout() so the script always reaches a verdict and runs 
>> cleanup
>> +# instead of hanging on a stuck peer.
>> +ktap_print_header
>> +ktap_set_plan 1
>> +
>> +ip netns exec "$NS" timeout 30 "$BIN" "$IP_NS" "$PORT" >/dev/null 
>> 2>&1 &
>> +SRV=$!
>> +sleep 2
>> +timeout 30 "$BIN" -c "$IP_NS" "$PORT" >/dev/null 2>&1
>> +wait "$SRV" 2>/dev/null
>> +
>> +# --- Verdict: any rxe MR-range warning / OOB means the kernel is 
>> unpatched ---
>> +if dmesg 2>/dev/null | grep -qE 
>> "rxe_mr_iova_to_index|mr_check_range|BUG:.*rxe_mr_copy|KASAN:.*rxe_mr"; 
>> then
>> +    ktap_test_fail "mr_check_range() iova overflow (UNPATCHED): 
>> OOB/WARN in dmesg"
>> +else
>> +    ktap_test_pass "mr_check_range() rejected crafted iova (patched)"
>> +fi
>> +
>> +ktap_finished
>
-- 
Best Regards,
Yanjun.Zhu

