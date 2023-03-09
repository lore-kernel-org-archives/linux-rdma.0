Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED96C6FD1F
	for <linux-rdma@archiver.kernel.org>; Thu,  9 Mar 2023 11:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjCIL7C (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 9 Mar 2023 06:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCIL7B (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 9 Mar 2023 06:59:01 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9837F011;
        Thu,  9 Mar 2023 03:58:58 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VdTbXRD_1678363135;
Received: from 30.221.149.231(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VdTbXRD_1678363135)
          by smtp.aliyun-inc.com;
          Thu, 09 Mar 2023 19:58:56 +0800
Message-ID: <b8480883-eceb-f488-fdaa-2eb6647844a8@linux.alibaba.com>
Date:   Thu, 9 Mar 2023 19:58:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v2 2/2] bpf/selftests: add selftest for SMC bpf
 capability
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <1676981919-64884-1-git-send-email-alibuda@linux.alibaba.com>
 <1676981919-64884-3-git-send-email-alibuda@linux.alibaba.com>
 <60991e56-dad5-c310-86bb-102ebf756b6b@linux.dev>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <60991e56-dad5-c310-86bb-102ebf756b6b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On 2/23/23 6:35 AM, Martin KaFai Lau wrote:
> On 2/21/23 4:18 AM, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This PATCH adds a tiny selftest for SMC bpf capability,
>> making decisions on whether to use SMC by collecting
>> certain information from kernel smc sock.
>>
>> Follow the steps below to run this test.
>>
>> make -C tools/testing/selftests/bpf
>> cd tools/testing/selftests/bpf
>> sudo ./test_progs -t bpf_smc
>>
>> Results shows:
>> 18      bpf_smc:OK
>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>
>> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>> ---
>>   tools/testing/selftests/bpf/prog_tests/bpf_smc.c |  39 +++
>>   tools/testing/selftests/bpf/progs/bpf_smc.c      | 315 
>> +++++++++++++++++++++++
>>   2 files changed, 354 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_smc.c 
>> b/tools/testing/selftests/bpf/prog_tests/bpf_smc.c
>> new file mode 100644
>> index 0000000..b143932
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_smc.c
>> @@ -0,0 +1,39 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2019 Facebook */
>
> copy-and-paste left-over...

Sorry for that, but it might be more appropriate to delete it here... 😂

>
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_smc.c 
>> b/tools/testing/selftests/bpf/progs/bpf_smc.c
>> new file mode 100644
>> index 0000000..78c7976
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_smc.c
>> @@ -0,0 +1,315 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +
>> +#include <linux/bpf.h>
>> +#include <linux/stddef.h>
>> +#include <linux/smc.h>
>> +#include <stdbool.h>
>> +#include <linux/types.h>
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_core_read.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +#define BPF_STRUCT_OPS(name, args...) \
>> +    SEC("struct_ops/"#name) \
>> +    BPF_PROG(name, args)
>> +
>> +#define SMC_LISTEN        (10)
>> +#define SMC_SOCK_CLOSED_TIMING    (0)
>> +extern unsigned long CONFIG_HZ __kconfig;
>> +#define HZ CONFIG_HZ
>> +
>> +char _license[] SEC("license") = "GPL";
>> +#define max(a, b) ((a) > (b) ? (a) : (b))
>> +
>> +struct sock_common {
>> +    unsigned char    skc_state;
>> +    __u16    skc_num;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct sock {
>> +    struct sock_common    __sk_common;
>> +    int    sk_sndbuf;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct inet_sock {
>> +    struct sock    sk;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct inet_connection_sock {
>> +    struct inet_sock    icsk_inet;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct tcp_sock {
>> +    struct inet_connection_sock    inet_conn;
>> +    __u32    rcv_nxt;
>> +    __u32    snd_nxt;
>> +    __u32    snd_una;
>> +    __u32    delivered;
>> +    __u8    syn_data:1,    /* SYN includes data */
>> +        syn_fastopen:1,    /* SYN includes Fast Open option */
>> +        syn_fastopen_exp:1,/* SYN includes Fast Open exp. option */
>> +        syn_fastopen_ch:1, /* Active TFO re-enabling probe */
>> +        syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
>> +        save_syn:1,    /* Save headers of SYN packet */
>> +        is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
>> +        syn_smc:1;    /* SYN includes SMC */
>> +} __attribute__((preserve_access_index));
>> +
>> +struct socket {
>> +    struct sock *sk;
>> +} __attribute__((preserve_access_index));
>
> All these tcp_sock, socket, inet_sock definitions can go away if it 
> includes "vmlinux.h". tcp_ca_write_sk_pacing.c is a better example to 
> follow. Try to define the "common" (eg. tcp, tc...etc) missing macros 
> in bpf_tracing_net.h. The smc specific macros can stay in this file.

Got it, i'll fix this.

>> +static inline struct smc_prediction *smc_prediction_get(const struct 
>> smc_sock *smc,
>> +                            const struct tcp_sock *tp, __u64 tstamp)
>> +{
>> +    struct smc_prediction zero = {}, *smc_predictor;
>> +    __u16 key;
>> +    __u32 gap;
>> +    int err;
>> +
>> +    err = bpf_core_read(&key, sizeof(__u16), 
>> &tp->inet_conn.icsk_inet.sk.__sk_common.skc_num);
>> +    if (err)
>> +        return NULL;
>> +
>> +    /* BAD key */
>> +    if (key == 0)
>> +        return NULL;
>> +
>> +    smc_predictor = bpf_map_lookup_elem(&negotiator_map, &key);
>> +    if (!smc_predictor) {
>> +        zero.start_tstamp = bpf_jiffies64();
>> +        zero.pacing_delta = SMC_PREDICTION_MIN_PACING_DELTA;
>> +        bpf_map_update_elem(&negotiator_map, &key, &zero, 0);
>> +        smc_predictor = bpf_map_lookup_elem(&negotiator_map, &key);
>> +        if (!smc_predictor)
>> +            return NULL;
>> +    }
>> +
>> +    if (tstamp) {
>> +        bpf_spin_lock(&smc_predictor->lock);
>> +        gap = (tstamp - smc_predictor->start_tstamp) / 
>> smc_predictor->pacing_delta;
>> +        /* new splice */
>> +        if (gap > 0) {
>> +            smc_predictor->start_tstamp = tstamp;
>> +            smc_predictor->last_rate_of_lcc =
>> +                (smc_prediction_calt_rate(smc_predictor) * 7) >> (2 
>> + gap);
>> +            smc_predictor->closed_long_cc = 0;
>> +            smc_predictor->closed_total_cc = 0;
>> +            smc_predictor->incoming_long_cc = 0;
>> +        }
>> +        bpf_spin_unlock(&smc_predictor->lock);
>> +    }
>> +    return smc_predictor;
>> +}
>> +
>> +/* BPF struct ops for smc protocol negotiator */
>> +struct smc_sock_negotiator_ops {
>> +    /* ret for negotiate */
>> +    int (*negotiate)(struct smc_sock *smc);
>> +
>> +    /* info gathering timing */
>> +    void (*collect_info)(struct smc_sock *smc, int timing);
>> +};
>> +
>> +int BPF_STRUCT_OPS(bpf_smc_negotiate, struct smc_sock *smc)
>> +{
>> +    struct smc_prediction *smc_predictor;
>> +    struct tcp_sock *tp;
>> +    struct sock *clcsk;
>> +    int ret = SK_DROP;
>> +    __u32 rate = 0;
>> +
>> +    /* Only make decison during listen */
>> +    if (smc->sk.__sk_common.skc_state != SMC_LISTEN)
>> +        return SK_PASS;
>> +
>> +    clcsk = BPF_CORE_READ(smc, clcsock, sk);
>
> Instead of using bpf_core_read here, why not directly gets the clcsk 
> like the 'smc->sk.__sk_common.skc_state' above.
>
>> +    if (!clcsk)
>> +        goto error;
>> +
>> +    tp = tcp_sk(clcsk);
>
> There is a bpf_skc_to_tcp_sock(). Give it a try after changing the 
> above BPF_CORE_READ.

Copy that!  thanks.

>
>> +    if (!tp)
>> +        goto error;
>> +
>> +    smc_predictor = smc_prediction_get(smc, tp, bpf_jiffies64());
>> +    if (!smc_predictor)
>> +        return SK_PASS;
>> +
>> +    bpf_spin_lock(&smc_predictor->lock);
>> +
>> +    if (smc_predictor->incoming_long_cc == 0)
>> +        goto out_locked_pass;
>> +
>> +    if (smc_predictor->incoming_long_cc > 
>> SMC_PREDICTION_MAX_LONGCC_PER_SPLICE) {
>> +        ret = 100;
>> +        goto out_locked_drop;
>> +    }
>> +
>> +    rate = smc_prediction_calt_rate(smc_predictor);
>> +    if (rate < SMC_PREDICTION_LONGCC_RATE_THRESHOLD) {
>> +        ret = 200;
>> +        goto out_locked_drop;
>> +    }
>> +out_locked_pass:
>> +    smc_predictor->incoming_long_cc++;
>> +    bpf_spin_unlock(&smc_predictor->lock);
>> +    return SK_PASS;
>> +out_locked_drop:
>> +    bpf_spin_unlock(&smc_predictor->lock);
>> +error:
>> +    return SK_DROP;
>> +}
>> +
>> +void BPF_STRUCT_OPS(bpf_smc_collect_info, struct smc_sock *smc, int 
>> timing)
>
> Try to stay with SEC("struct_ops/...") void BPF_PROG(....)

Got it.  I have finished this modification in v4.


