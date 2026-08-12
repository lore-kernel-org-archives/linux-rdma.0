Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F0935AC05;
	Wed, 12 Aug 2026 07:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786518943; cv=none; b=GNV/QuzHQ/gbkzb+7EZJPNnGQPz5tl/nEJv37C9od6864qG5sixU/y/5gMgwAzRGmmcDlph1haOE9WovDb3RvaA1j6+rztrvlE2hfmq0bvQ2aYKy+nqbaic42/iF0y7YkcGY7gQ8vPHuRY+M6F+iTe0NCK/khNo1ygtkHMLYRGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786518943; c=relaxed/simple;
	bh=nfT96IomZZ4GSS26/IOLwQZi4WjSWb678Oi91uu2RMs=;
	h=From:To:Cc:Subject:Content-Type:MIME-Version; b=f8VBXwTpSqjEgFuHEYoq/hh7oudrZUJLAbAqpdSKZ0EdqoAqQYOJiL7BOb1CKeemSk0c5yF9gqY7SQwvs2vnSX9NEzd7MiGgzX5RRyd8eZ5/+S4FGwmxgO+IMDqXM/jrK67CG+hr5T9qY4HE8tmc1KYbzjMxqJl2VITmCFL4+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iKZ+B3Ch; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iKZ+B3Ch"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786518926; h=From:To:Subject:Content-Type:MIME-Version;
	bh=W+AwKLGAXhRy3dxES5Ug8BEsiVjHWw2YdO+KGajb6bc=;
	b=iKZ+B3ChBuXfZ+ZmZG+szNJrfQIsBjlzENp/mcC32TEaYPI+QYGY16u0rZ2Xm2vadUxGyqDhxYPSIFrH0A9d2FBi+f+DUkJCDHvr5YFye6l0X8lwEZ6YZFHOKLDRF51iAcDpjyXHFLPEt8S9hLGtupf2J1Ra4BJ22v+9DST0OGE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=chuyf26@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X8qjPBn_1786518925;
Received: from x31j07255.sqa.na131(mailfrom:Chuyf26@linux.alibaba.com fp:SMTPD_---0X8qjPBn_1786518925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 15:15:26 +0800
From: Chuyf26 <Chuyf26@linux.alibaba.com>
To: alibuda@linux.alibaba.com
Cc: dust.li@linux.alibaba.com, sidraya@linux.ibm.com, mjambigi@linux.ibm.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH] net/smc: release the internal TCP sock on IPPROTO_SMC socket
 creation failure
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <20260812071538.o7mdtMhZ1eOzDgQnKZduQfWlq0FhL7OCAPLjt9AA11w@z>

IPPROTO_SMC sockets wrap an internal TCP sock ("clcsock"), which is
created by smc_inet_init_sock() via smc_create_clcsk() from the
proto->init hook of inet_create()/inet6_create(). When socket
creation fails after proto->init has succeeded - for example when a
cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE denies the
socket - inet_create() calls sk_common_release(), which only invokes
sk_prot->destroy if it is set. Neither smc_inet_prot nor
smc_inet6_prot defines .destroy, and the sock destructor smc_destruct()
returns early unless sk_state is SMC_CLOSED (it is SMC_INIT here), so
the internal TCP sock is never released.

As a result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC)
call leaks one tcp_sock. Any unprivileged task able to attach a
deny-all BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup (or a
task confined by an LSM policy) can grow kernel memory unboundedly.

Reproduced on v7.2-rc7: with a deny-all BPF_CGROUP_INET_SOCK_CREATE
program attached, a loop of socket(AF_INET, SOCK_STREAM, IPPROTO_SMC)
calls fails with EPERM and kmemleak reports one unreferenced tcp_sock
object per call.

Add a .destroy hook to both IPPROTO_SMC protos that releases the
clcsock via smc_clcsock_release(). That helper is safe here: it takes
the clcsock_release_lock initialized by smc_sk_init() and skips a NULL
clcsock, which is what smc_create_clcsk() leaves behind when creating
the TCP sock fails. Also initialize clcsock to NULL at the start of
smc_inet_init_sock(): the smc_sock slab is SLAB_TYPESAFE_BY_RCU, so
recycled objects are not zeroed and stale memory must not be handed to
sock_release().

The same behaviour is visible without any debugging option: on a
plain kernel the slabinfo "TCP" active_objs count grows by one per
failing socket() call and never shrinks.

With the fix, the same reproducer leaves no unreferenced objects in
kmemleak and the "TCP" slabinfo count stays flat, and regular
IPPROTO_SMC socket create/close cycles are unaffected
(sk_common_release() from inet_release() also routes through the new
.destroy, where the already-NULL clcsock is a no-op).

Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
Reported-by: Abaci <abaci@linux.alibaba.com>
Assisted-by: abaci:qwen3.8-max
Signed-off-by: Chuyf26 <Chuyf26@linux.alibaba.com>
---
 net/smc/smc_inet.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
index a94084b..b94a194 100644
--- a/net/smc/smc_inet.c
+++ b/net/smc/smc_inet.c
@@ -15,13 +15,16 @@
=20
 #include "smc_inet.h"
 #include "smc.h"
+#include "smc_close.h"
=20
 static int smc_inet_init_sock(struct sock *sk);
+static void smc_inet_destroy_sock(struct sock *sk);
=20
 static struct proto smc_inet_prot =3D {
 	.name		=3D "INET_SMC",
 	.owner		=3D THIS_MODULE,
 	.init		=3D smc_inet_init_sock,
+	.destroy	=3D smc_inet_destroy_sock,
 	.hash		=3D smc_hash_sk,
 	.unhash		=3D smc_unhash_sk,
 	.release_cb	=3D smc_release_cb,
@@ -68,6 +71,7 @@ static struct proto smc_inet6_prot =3D {
 	.name		=3D "INET6_SMC",
 	.owner		=3D THIS_MODULE,
 	.init		=3D smc_inet_init_sock,
+	.destroy	=3D smc_inet_destroy_sock,
 	.hash		=3D smc_hash_sk,
 	.unhash		=3D smc_unhash_sk,
 	.release_cb	=3D smc_release_cb,
@@ -109,6 +113,14 @@ static struct inet_protosw smc_inet6_protosw =3D {
 static int smc_inet_init_sock(struct sock *sk)
 {
 	struct net *net =3D sock_net(sk);
+	struct smc_sock *smc =3D smc_sk(sk);
+
+	/*
+	 * The smc_sock slab is SLAB_TYPESAFE_BY_RCU and recycled objects
+	 * are not zeroed. .destroy may run even if .init never completed,
+	 * so make sure smc_clcsock_release() sees a valid clcsock.
+	 */
+	smc->clcsock =3D NULL;
=20
 	/* init common smc sock */
 	smc_sk_init(net, sk, IPPROTO_SMC);
@@ -116,6 +128,17 @@ static int smc_inet_init_sock(struct sock *sk)
 	return smc_create_clcsk(net, sk, sk->sk_family);
 }
=20
+static void smc_inet_destroy_sock(struct sock *sk)
+{
+	/*
+	 * If inet_create()/inet6_create() fail after .init has created the
+	 * internal TCP sock (e.g. rejected by a cgroup BPF program),
+	 * sk_common_release() ends up here. Release the TCP sock, otherwise
+	 * it leaks on every failed IPPROTO_SMC socket() call.
+	 */
+	smc_clcsock_release(smc_sk(sk));
+}
+
 int __init smc_inet_init(void)
 {
 	int rc;
--=20
2.43.5

Reproducer (no clang/bpftool needed, hand-assembled BPF via bpf(2));
run as root on a cgroup-v2 system, needs CAP_BPF and CONFIG_CGROUP_BPF:

  $ gcc -O2 -o smc_leak smc_leak.c
  $ ./smc_leak 20000

It attaches a deny-all BPF_CGROUP_INET_SOCK_CREATE program to a fresh
cgroup, enters it and loops socket(AF_INET, SOCK_STREAM, IPPROTO_SMC).
Before this patch every call fails with EPERM and the slabinfo "TCP"
active_objs count grows by ~1 per call (20004 for 20000 iterations,
never shrinking); with this patch the count stays flat.

/* --- smc_leak.c --- */
/*
 * IPPROTO_SMC socket-creation leak reproducer (no clang/bpftool needed).
 *
 * 1. creates a cgroupv2 subgroup, loads a hand-assembled deny-all
 *    BPF_CGROUP_INET_SOCK_CREATE prog via bpf(2), attaches it;
 * 2. moves itself into that cgroup;
 * 3. loops socket(AF_INET, SOCK_STREAM, IPPROTO_SMC);
 * 4. prints slabinfo "TCP" delta and kmemleak report.
 *
 * Run as root on a cgroup-v2 system:
 *   ./smc_leak 20000
 * Expected on buggy kernel: every socket() fails with EPERM and leaks one
 * TCP sock per call (slabinfo "TCP" active_objs grows by ~1 per iteration;
 * with CONFIG_DEBUG_KMEMLEAK, unreferenced tcp_sock objects are reported).
 * On a fixed kernel: no growth.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <linux/bpf.h>
#include <stdint.h>

#ifndef IPPROTO_SMC
#define IPPROTO_SMC 256
#endif

#define BPF_RAW(CODE, DST, SRC, OFF, IMM) ((struct bpf_insn){CODE, DST, SRC, =
OFF, IMM})

static int sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
{
	return syscall(__NR_bpf, cmd, attr, size);
}

static int load_deny_prog(void)
{
	/* r0 =3D 0 (deny); exit */
	struct bpf_insn insns[] =3D {
		BPF_RAW(BPF_ALU64 | BPF_MOV | BPF_K, BPF_REG_0, 0, 0, 0),
		BPF_RAW(BPF_JMP | BPF_EXIT, 0, 0, 0, 0),
	};
	union bpf_attr attr;
	memset(&attr, 0, sizeof(attr));
	attr.prog_type =3D BPF_PROG_TYPE_CGROUP_SOCK;
	attr.insns =3D (uint64_t)(unsigned long)insns;
	attr.insn_cnt =3D 2;
	attr.license =3D (uint64_t)(unsigned long)"GPL";
	int fd =3D sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
	if (fd < 0)
		perror("BPF_PROG_LOAD");
	return fd;
}

static int attach_prog(int prog_fd, const char *cgpath)
{
	int cg_fd =3D open(cgpath, O_RDONLY | O_DIRECTORY);
	if (cg_fd < 0) {
		perror("open cgroup");
		return -1;
	}
	union bpf_attr attr;
	memset(&attr, 0, sizeof(attr));
	attr.link_create.prog_fd =3D prog_fd;
	attr.link_create.target_fd =3D cg_fd;
	attr.link_create.attach_type =3D BPF_CGROUP_INET_SOCK_CREATE;
	int fd =3D sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
	if (fd < 0) {
		perror("BPF_LINK_CREATE");
		close(cg_fd);
		return -1;
	}
	return fd;
}

static long tcp_active_objs(void)
{
	FILE *f =3D fopen("/proc/slabinfo", "r");
	char line[256];
	long objs =3D -1;

	if (!f)
		return -1;
	while (fgets(line, sizeof(line), f)) {
		char name[64];
		long active;
		if (sscanf(line, "%63s %ld", name, &active) =3D=3D 2 &&
		    !strcmp(name, "TCP")) {
			objs =3D active;
			break;
		}
	}
	fclose(f);
	return objs;
}

static void kmemleak_scan(void)
{
	mkdir("/sys/kernel/debug", 0755);
	mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL);
	FILE *f =3D fopen("/sys/kernel/debug/kmemleak", "w");
	if (f) {
		fputs("scan", f);
		fclose(f);
		sleep(3);
		system("grep -c 'unreferenced object' /sys/kernel/debug/kmemleak 2>/dev/nul=
l | sed 's/^/kmemleak unreferenced objects: /'");
		system("head -60 /sys/kernel/debug/kmemleak 2>/dev/null");
	} else {
		printf("(kmemleak unavailable: %s)\n", strerror(errno));
	}
}

int main(int argc, char **argv)
{
	const char *name =3D argc > 1 ? argv[1] : "smctest";
	long iters =3D argc > 2 ? atol(argv[2]) : 20000;
	char cgpath[256], path[280];
	int prog_fd, link_fd;

	if (access("/sys/fs/cgroup/cgroup.controllers", F_OK)) {
		fprintf(stderr, "cgroup v2 required\n");
		return 1;
	}

	snprintf(cgpath, sizeof(cgpath), "/sys/fs/cgroup/%s", name);
	mkdir(cgpath, 0755);

	prog_fd =3D load_deny_prog();
	if (prog_fd < 0)
		return 1;
	link_fd =3D attach_prog(prog_fd, cgpath);
	if (link_fd =3D=3D -1)
		return 1;

	snprintf(path, sizeof(path), "%s/cgroup.procs", cgpath);
	FILE *f =3D fopen(path, "w");
	if (!f) {
		perror("open cgroup.procs");
		return 1;
	}
	fprintf(f, "%d", getpid());
	fclose(f);

	long before =3D tcp_active_objs();
	printf("TCP slab objs before: %ld\n", before);

	long denied =3D 0, ok =3D 0, other =3D 0;
	for (long i =3D 0; i < iters; i++) {
		int fd =3D socket(AF_INET, SOCK_STREAM, IPPROTO_SMC);
		if (fd >=3D 0) {
			close(fd);
			ok++;
		} else if (errno =3D=3D EPERM) {
			denied++;
		} else {
			if (!other)
				printf("socket error: %s\n", strerror(errno));
			other++;
			break;
		}
	}
	long after =3D tcp_active_objs();
	printf("iterations=3D%ld denied(EPERM)=3D%ld ok=3D%ld other=3D%ld\n",
	       iters, denied, ok, other);
	printf("TCP slab objs after: %ld  (delta %+ld)\n", after, after - before);
	if (denied && after - before > denied / 2)
		printf("=3D> LEAK CONFIRMED: ~%ld TCP socks leaked on error path\n",
		       after - before);

	kmemleak_scan();

	/* leave cgroup so it can be removed */
	f =3D fopen("/sys/fs/cgroup/cgroup.procs", "w");
	if (f) {
		fprintf(f, "%d", getpid());
		fclose(f);
	}
	if (link_fd >=3D 0)
		close(link_fd);
	rmdir(cgpath);
	return 0;
}
/* --- end smc_leak.c --- */
