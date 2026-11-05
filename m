Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907485;
	b=ZhnaSjHmtWsr5PPKxTRgZaruqGeP3KycAhfGFl3IjTh5AhR/NWBcFeVL0xI8o8rPRTb1
	 IYWJzXYy06hspLAJ8i+Y1BgBETOOPIp2GUURIsfxtMiAd+1dU2HroZ34vZepq7W+VThGf
	 8yTwpAUneHFvVXIO/SZyp1eOWfC09H0Cl8djT8iiYVRbDqxWFDpxE8Z77F2SRDoMHDx9w
	 5MD8rC1oUKLIjm3L8Sq/nxK91dDcCK1oU9kX3gKgLUNR/R6ynZ/kFf3abxbYwfCICMicg
	 jIoYNHvjnVHdeXOyMUtEij2kZ6/vQoxCs8Ayy5Fz8CNL8wSqbltOgvg3H24SxmWi9BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907485;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5gtDsALbs7XRusV4UDxH8IZuJVkw8oLPyfccKt3BFWc=;
	b=j9COQGN+dh2kOJfPDNIVJKRNe7ym6h3+/83SPHZ+G+7AUuGJJOlV+QS2zqUHuwCCCmvn
	 5KhxFiFgcITpAo4qYA5EFPl6w5iYCpeaxBsPXLj65Olf8++sjarBVmCjEuGfYFjrvhUjF
	 nFgMyOgui8xPcGb8wdL2qdsUqWsPxPyTufLMaPrY4se+qXcdeyij5yYraBR09JNraKC8A
	 GWPstvTfjPDOglBdTEyzlO0Ha8vZ+uF67EIfuwcBqQgewK+ajXUw3+PRQrjyiFu6L8Yy3
	 1xhHJvXulcAZSlDo5JRojaizDEtHBNnkYGskoA6sBPlU/QD9hPQQ/c3ByN6frlwKjtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqdY7yqN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BA607D010;
	Thu,  5 Nov 2026 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqdY7yqN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCDF1F0089F;
	Thu,  5 Nov 2026 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907484;
	bh=5gtDsALbs7XRusV4UDxH8IZuJVkw8oLPyfccKt3BFWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CqdY7yqNv/aoO7y8upwLtyC6XH28aiuYbZ6OsFDFPVo5Uv7M6SEwt0HGtZ9PvNbfe
	 dUnEHTjnZeF4AOxpiYNDB+t15zIXbJ9dVQDZDPzLabQnGCxz1hUlma2Tts/KJtSVt4
	 2v5rO1INZaqnIRY818PxRaXLDPEj6QbYGEbaPLFHCPklRlUbS1sKlaBDoQrXbsQrp0
	 txbK0Xwy4YwCNLc0ieAt+lP5vEBuEEuA8+UPtqFjybZs3cBMswIc5qG2tRfCYdgISW
	 uqMezNJqHLEVxrjXv5gHzFdtGj/zb0MKsNOedLAifG2XKiz89N+HM+RJezKiL5aQSA
	 +3gP86DfWi8tQ==
Date: Thu, 5 Nov 2026 21:38:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Chengyu Liu <lui2012qwq@gmail.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] RDMA/ipoib: cancel the AH reaper synchronously on
 teardown
Message-ID: <20261105193800.GJ8298@unreal>
References: <20261105042922.14733-1-lui2012qwq@gmail.com>
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
In-Reply-To: <20261105042922.14733-1-lui2012qwq@gmail.com>

On Thu, Nov 05, 2026 at 12:29:22PM +0800, Chengyu Liu wrote:
> ipoib_stop_ah_reaper() uses cancel_delayed_work(), which cannot stop a
> callback that is already running.  ipoib_reap_ah() re-arms itself after
> an unlocked test_bit(IPOIB_STOP_REAPER) check, so a callback that has
> passed the check but has not re-armed yet still queues the delayed work
> after the "stop":
> 
>   CPU0 (reaper)                     CPU1 (stop/teardown)
>   test_bit(STOP_REAPER) == 0
>                                     set_bit(STOP_REAPER)
>                                     cancel_delayed_work()  (no-op)
>                                     ... destroy_workqueue(priv->wq)
>   queue_delayed_work(priv->wq, ...)  <- delayed work sits on the timer
> 
> destroy_workqueue() cannot see a delayed work that is pending on the
> timer wheel, so the re-armed work fires after the workqueue is
> destroyed and priv is freed: both the queueing onto the dead queue and
> the callback's container_of() on freed memory are use-after-free.
> 
> Use cancel_delayed_work_sync(), which waits for a running callback and
> swallows its re-arm while the stop is in flight.  Note that
> ipoib_stop_ah_reaper() also runs on ndo_stop and on the stop/open cycle
> of a heavy flush, so the work must be left enabled for
> ipoib_start_ah_reaper() to re-arm it on the next open;
> cancel_delayed_work_sync() re-enables on the way out, unlike
> disable_delayed_work_sync() which would kill the reaper for good.
> 
> The comment above claims ipoib_reap_dead_ahs() "ensures the work is
> really stopped", but it never touches the work item - it only walks
> the dead_ahs list under priv->lock.  The stop guarantee comes from the
> cancel; fix the comment along with it.
> 
> Found by static analysis.  Reproduced on a KASAN build running stock
> ib_ipoib on a Soft-RoCE transport (rxe): when a running reaper callback
> escapes the stop and re-arms, the timer fires one second later in
> __run_timer_base() on the destroyed workqueue (slab-use-after-free).

Please add full dmesg kernel stack here.

Thanks

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>
> ---
> v3:
>   - back to cancel_delayed_work_sync(): ipoib_stop_ah_reaper() also runs
>     on ndo_stop and on the heavy-flush stop/open cycle, so the work must
>     be left enabled (sashiko review); disable_delayed_work_sync() would
>     kill the reaper on the next open
> 
> v2: https://lore.kernel.org/r/20261104181753.1245369-1-lui2012qwq@gmail.com
>   - add reproducer on stock ib_ipoib over rxe
>   - switch to disable_delayed_work_sync() (superseded by v3)
> 
> v1: https://lore.kernel.org/r/20261103170703.1600310-1-lui2012qwq@gmail.com
> 
> 
> Reproducer (harness summary; full driver scripts and the timing trigger
> below):
> 
>     QEMU has no IB hardware, so the stock ib_ipoib driver runs over a
>     Soft-RoCE (rxe) transport presented as an IB port.  Harness shims,
>     all below ib_ipoib (the driver itself is unmodified):
> 
>       * rxe_verbs.c: report link layer INFINIBAND and cap flags
>         PROT_IB|IB_MAD|AF_IB from rxe_get_link_layer() /
>         rxe_port_immutable(); skip ib_get_eth_speed() for the flipped
>         port in rxe_query_port(); set dev.parent before
>         ib_register_device().
>       * sa_query.c: answer ib_sa_path_rec_get() locally (async via
>         system_wq) when the device has no SA.
>       * multicast.c: complete ib_sa_join_multicast() locally (async);
>         tag the synthetic object (comp_mask bit 63) so
>         ib_sa_free_multicast() frees it.
>       * ipoib_ib.c (witness only, no behavior change): trace_printk()
>         timing in ipoib_reap_ah(), and an ESCAPED-ARM line when the
>         callback re-arms after IPOIB_STOP_REAPER was set.
> 
>     With ~500 AH entries churned into dead_ahs, the reaper's walk
>     measures 20-160us once a second; the teardown (RDMA netlink
>     DELLINK of the rxe device) reaches ipoib_stop_ah_reaper() ~3.9ms
>     after the syscall enters.  The stock test->queue window is the
>     handful of instructions between the lockless test_bit() and the
>     queue_delayed_work(); to hit it deterministically the PoC kernel
>     widens it to 200us with a module parameter.  On a hit the witness
>     logs
> 
>         ipoib_stop_ah_reaper: reap_ah: ib0 STOP at=531116547240
>         ipoib_reap_ah: reap_ah: ib0 ESCAPED-ARM after stop
> 
>     and one second later the escaped timer fires on the destroyed
>     workqueue (trimmed):
> 
>         BUG: KASAN: use-after-free in __run_timer_base.part.0+0x80c/0x900
>         Write of size 8 at addr ffff888021088628 by task swapper/0/0
>         Call Trace:
>          <IRQ>
>          kasan_report+0x96/0xd0
>          __run_timer_base.part.0+0x80c/0x900
>          tmigr_handle_remote_up+0x38b/0x830
>          ...
>          handle_softirqs+0x184/0x5c0
>          irq_exit_rcu+0x6e/0x150
>          sysvec_apic_timer_interrupt+0x70/0x80
>          </IRQ>
> 
>     with the workqueue core reporting, right before the splat:
> 
>         workqueue: cannot queue ipoib_reap_ah on wq ipoib_wq
> 
> 
> ------------------------- reproducer: trigger.c -------------------------
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * trigger.c - F-026 teardown timing trigger.
>  *
>  * Watches the PoC kernel's ipoib_reap_ah() witness lines on trace_pipe
>  * ("reap_ah: ib0 start=<ns> walk_ns=<ns>"), predicts the next reaper run
>  * (~1s period, jiffy-aligned) and deletes the rxe device via RDMA netlink
>  * (RDMA_NLDEV_CMD_DELLINK, the real teardown path: ib unregister -> ipoib
>  * remove -> stop_ah_reaper -> destroy_workqueue -> free) at
>  *
>  *      next_start + walk_ns + offset
>  *
>  * which is the callback's test_bit->queue_delayed_work gap.
>  *
>  * usage: trigger <rxe_dev> <ib_dev> <offset_ns>
>  */
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <time.h>
> #include <errno.h>
> #include <linux/netlink.h>
> #include <sys/socket.h>
> 
> #ifndef NETLINK_RDMA
> #define NETLINK_RDMA 20
> #endif
> 
> #define RDMA_NL_NLDEV		5
> #define RDMA_NL_GET_TYPE(c, o)	(((c) << 10) + (o))
> #define RDMA_NLDEV_CMD_GET	1
> #define RDMA_NLDEV_CMD_DELLINK	4
> #define RDMA_NLDEV_ATTR_DEV_INDEX	1
> #define RDMA_NLDEV_ATTR_DEV_NAME	2
> 
> static const char *TRACE_PIPE = "/sys/kernel/tracing/trace_pipe";
> 
> static unsigned long long now_ns(void)
> {
> 	struct timespec ts;
> 	clock_gettime(CLOCK_MONOTONIC, &ts);
> 	return (unsigned long long)ts.tv_sec * 1000000000ull + ts.tv_nsec;
> }
> 
> static void wait_until(unsigned long long deadline_ns)
> {
> 	while (now_ns() < deadline_ns)
> 		;
> }
> 
> static int nla_put(char *buf, int *off, int type, const void *data, int len)
> {
> 	struct nlattr *na = (struct nlattr *)(buf + *off);
> 	na->nla_type = type;
> 	na->nla_len = NLA_HDRLEN + len;
> 	memcpy(buf + *off + NLA_HDRLEN, data, len);
> 	*off += NLA_ALIGN(na->nla_len);
> 	return 0;
> }
> 
> /* dump all rdma links, return the index of `name` (0 if not found) */
> static int rdma_dev_index(int fd, const char *name)
> {
> 	char buf[4096];
> 	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
> 	int found = -1;
> 	struct timeval tv = { .tv_sec = 2, .tv_usec = 0 };
> 
> 	setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
> 	memset(buf, 0, sizeof(buf));
> 	nlh->nlmsg_len = NLMSG_LENGTH(0);
> 	nlh->nlmsg_type = RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET);
> 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
> 	nlh->nlmsg_seq = 1;
> 	if (send(fd, buf, nlh->nlmsg_len, 0) < 0)
> 		return 0;
> 
> 	for (;;) {
> 		ssize_t len = recv(fd, buf, sizeof(buf), 0);
> 		struct nlmsghdr *m;
> 		if (len <= 0)
> 			break;
> 		for (m = (struct nlmsghdr *)buf; NLMSG_OK(m, len);
> 		     m = NLMSG_NEXT(m, len)) {
> 			struct nlattr *a;
> 			int rem, idx = -1;
> 			char nm[64] = "";
> 
> 			if (m->nlmsg_type == NLMSG_DONE)
> 				goto out;
> 			if (m->nlmsg_type == NLMSG_ERROR) {
> 				struct nlmsgerr *e = NLMSG_DATA(m);
> 				fprintf(stderr, "[dbg] dump err=%d\n", e->error);
> 				goto out;
> 			}
> 			a = (struct nlattr *)NLMSG_DATA(m);
> 			rem = m->nlmsg_len - NLMSG_HDRLEN;
> 			for (; rem > 0 && (int)a->nla_len <= rem;
> 			       rem -= NLA_ALIGN(a->nla_len),
> 			       a = (struct nlattr *)((char *)a + NLA_ALIGN(a->nla_len))) {
> 				if (a->nla_type == RDMA_NLDEV_ATTR_DEV_INDEX)
> 					idx = *(unsigned int *)((char *)a + NLA_HDRLEN);
> 				else if (a->nla_type == RDMA_NLDEV_ATTR_DEV_NAME)
> 					snprintf(nm, sizeof(nm), "%s",
> 						 (char *)a + NLA_HDRLEN);
> 			}
> 			if (idx >= 0 && !strcmp(nm, name))
> 				found = idx;
> 			else if (idx == 0 && !strcmp(nm, name))
> 				found = 0;
> 		}
> 	}
> out:
> 	return found;
> }
> 
> static int rdma_dellink(int fd, int index)
> {
> 	char buf[256];
> 	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
> 	int off = NLMSG_LENGTH(0);
> 
> 	memset(buf, 0, sizeof(buf));
> 	nlh->nlmsg_len = 0;
> 	nlh->nlmsg_type = RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_DELLINK);
> 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
> 	nlh->nlmsg_seq = 2;
> 	nla_put(buf, &off, RDMA_NLDEV_ATTR_DEV_INDEX, &index, sizeof(index));
> 	nlh->nlmsg_len = off;
> 
> 	if (send(fd, buf, off, 0) < 0)
> 		return -1;
> 	/* read the ACK */
> 	if (recv(fd, buf, sizeof(buf), 0) > 0) {
> 		struct nlmsghdr *m = (struct nlmsghdr *)buf;
> 		if (m->nlmsg_type == NLMSG_ERROR) {
> 			struct nlmsgerr *e = NLMSG_DATA(m);
> 			return e->error ? -1 : 0;
> 		}
> 	}
> 	return 0;
> }
> 
> int main(int argc, char **argv)
> {
> 	const char *ifname = argv[1];	/* rxe device, e.g. rxe0 */
> 	const char *ibname = argv[2];	/* ipoib iface, e.g. ib0 */
> 	char tname[80];
> 	long long offset_ns = atoll(argv[3]);
> 	FILE *f;
> 	char line[512];
> 	unsigned long long start = 0, walk = 0, period = 0, prev_start = 0;
> 	int nlfd;
> 
> 	snprintf(tname, sizeof(tname), "reap_ah: %s ", ibname);
> 
> 	nlfd = socket(AF_NETLINK, SOCK_RAW, NETLINK_RDMA);
> 	if (nlfd < 0) {
> 		perror("socket NETLINK_RDMA");
> 		return 1;
> 	}
> 
> 	f = fopen(TRACE_PIPE, "r");
> 	if (!f) {
> 		perror("open trace_pipe");
> 		return 1;
> 	}
> 
> 	fprintf(stderr, "[*] trigger: dev=%s offset=%lldns\n", ifname, offset_ns);
> 
> 	while (fgets(line, sizeof(line), f)) {
> 		char *s, *w;
> 		if (!strstr(line, tname))
> 			continue;
> 		s = strstr(line, "start=");
> 		w = strstr(line, "walk_ns=");
> 		if (!s || !w)
> 			continue;
> 		start = strtoull(s + 6, NULL, 10);
> 		walk = strtoull(w + 8, NULL, 10);
> 		if (!start || !walk)
> 			continue;
> 		if (prev_start)
> 			period = start - prev_start;
> 		prev_start = start;
> 		if (!period || !walk)
> 			continue;
> 
> 		unsigned long long fire = start + period + walk + offset_ns;
> 		unsigned long long t0 = now_ns();
> 		if (fire <= t0)
> 			continue;
> 		fprintf(stderr, "[*] next gap in %llu ns (period %llu, walk %llu)\n",
> 			fire - t0, period, walk);
> 		wait_until(fire);
> 		unsigned long long fired = now_ns();
> 		int idx = rdma_dev_index(nlfd, ifname);
> 		int rc = idx >= 0 ? rdma_dellink(nlfd, idx) : -1;
> 		fprintf(stderr, "[+] fired DELLINK idx=%d rc=%d at=%llu drift=%lldns\n",
> 			idx, rc, fired, (long long)(fired - fire));
> 		fflush(stderr);
> 
> 		/* closed-loop: read the trace buffer, find the gap_enter and
> 		 * STOP the del produced, report how far off we landed */
> 		usleep(1500000);
> 		FILE *tf = fopen("/sys/kernel/tracing/trace", "r");
> 		if (tf) {
> 			char l2[512];
> 			unsigned long long ge = 0, stop = 0;
> 			while (fgets(l2, sizeof(l2), tf)) {
> 				char *p;
> 				if (strstr(l2, tname) && (p = strstr(l2, "gap_enter=")))
> 					ge = strtoull(p + 10, NULL, 10);
> 				if (strstr(l2, tname) && (p = strstr(l2, "STOP at=")))
> 					stop = strtoull(p + 8, NULL, 10);
> 			}
> 			fclose(tf);
> 			if (ge && stop) {
> 				long long miss = (long long)(stop - ge);
> 				fprintf(stderr, "[=] MISS-BY=%lld (stop-gap_enter, want 0..200000)\n", miss);
> 				printf("%lld\n", miss);	/* stdout for the driver */
> 			}
> 		}
> 		return rc != 0;
> 	}
> 	return 1;
> }
> 
> ------------------------- guest scripts -------------------------
> 
> ----- setup.sh -----
> #!/bin/bash
> # setup.sh - F-026 guest setup: two rxe endpoints presenting as IB, ipoib up.
> # NICs: enp0s3 = slirp (ssh/internet); enp0s4+enp0s5 = same L2 hub (ipoib pair).
> set -x
> mount -t configfs none /sys/kernel/config 2>/dev/null
> mount -t tracefs none /sys/kernel/tracing 2>/dev/null
> 
> ip link set enp0s4 up
> ip link set enp0s5 up
> 
> rdma link add rxe0 type rxe netdev enp0s4
> rdma link add rxe1 type rxe netdev enp0s5
> sleep 1
> 
> ip addr add 10.99.0.1/24 dev ib0
> ip link set ib0 up
> ip addr add 10.99.0.2/24 dev ib1
> ip link set ib1 up
> sleep 1
> ip -brief addr show ib0
> ip -brief addr show ib1
> 
> ping -c2 -W2 10.99.0.2 -I ib0 && echo PING-OK
> ip neigh show dev ib0
> echo SETUP-DONE
> 
> ----- churn3.sh -----
> #!/bin/bash
> # churn3.sh - fast AH churn on ib0 (static PERMANENT neighs + one UDP each,
> # then explicit neigh del -> AHs to dead_ahs).  ib0 must have a /16 alias.
> N=${1:-500}
> LOOPS=${2:-9999}
> 
> ip addr add 10.99.0.1/16 dev ib0 2>/dev/null	# widen the on-link subnet
> 
> mklladdr() {
> 	local i=$1
> 	printf '80:00:00:10:52:54:00:12:%02x:%02x:00:00:00:00:00:00:00:%02x:%02x:01' \
> 		$(( (i >> 8) & 255 )) $(( i & 255 )) $(( (i >> 8) & 255 )) $(( i & 255 ))
> }
> 
> for l in $(seq 1 $LOOPS); do
> 	for i in $(seq 1 $N); do
> 		a=10.99.$(( i >> 8 )).$(( i & 255 ))
> 		ip neigh replace $a lladdr $(mklladdr $i) dev ib0 2>/dev/null
> 	done
> 	/root/churn_send16 $N 2>/dev/null || /root/churn_send16 $N
> 	for i in $(seq 1 $N); do
> 		ip neigh del 10.99.$(( i >> 8 )).$(( i & 255 )) dev ib0 2>/dev/null
> 	done
> 	echo "loop $l done ($(date +%T))"
> done
> 
> ----- churn_send16.c -----
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * churn_send16.c - one UDP datagram at each 10.99.Hi.Lo neighbor on ib0
>  * so ipoib creates a real AH per neighbor (path lookup -> SA shim -> rxe AH).
>  *
>  * usage: churn_send16 <count>
>  */
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <arpa/inet.h>
> #include <sys/socket.h>
> 
> int main(int argc, char **argv)
> {
> 	int n = argc > 1 ? atoi(argv[1]) : 500;
> 	int fd = socket(AF_INET, SOCK_DGRAM, 0);
> 	char buf[64] = "f026";
> 	struct sockaddr_in sa;
> 	int i, sent = 0;
> 
> 	if (fd < 0) {
> 		perror("socket");
> 		return 1;
> 	}
> 
> 	memset(&sa, 0, sizeof(sa));
> 	sa.sin_family = AF_INET;
> 	sa.sin_port = htons(9999);
> 
> 	for (i = 1; i <= n; i++) {
> 		char ip[32];
> 		snprintf(ip, sizeof(ip), "10.99.%d.%d", (i >> 8) & 255, i & 255);
> 		inet_pton(AF_INET, ip, &sa.sin_addr);
> 		if (sendto(fd, buf, sizeof(buf), 0,
> 			   (struct sockaddr *)&sa, sizeof(sa)) >= 0)
> 			sent++;
> 	}
> 	close(fd);
> 	printf("churn_send16: fired %d datagrams\n", sent);
> 	return 0;
> }
> 
> ----- race.sh -----
> #!/bin/bash
> # race.sh - F-026 closed-loop sweep: trigger prints MISS-BY (where the
> # teardown's stop landed vs the reaper gap), we steer the next offset to
> # land 100us into the 200us widened gap.
> IF=ib0
> off=-4000000	# first guess: syscall latency is ~3.9ms
> MAX=${1:-300}
> 
> for i in $(seq 1 $MAX); do
> 	rdma link del rxe0 2>/dev/null; sleep 0.5
> 	rdma link add rxe0 type rxe netdev enp0s4; sleep 1
> 	ip addr add 10.99.0.1/16 dev $IF 2>/dev/null; ip link set $IF up; sleep 1
> 	echo > /sys/kernel/tracing/trace
> 	/root/churn3.sh 300 1 >/dev/null 2>&1
> 
> 	miss=$(/root/trigger rxe0 $IF $off 2>/dev/null | tail -1)
> 	case "$miss" in ''|*[!0-9-]*)
> 		echo "shot $i: off=$off no-measurement"
> 		continue ;;
> 	esac
> 	echo "shot $i: off=$off miss=$miss"
> 	off=$(( off - miss + 100000 ))
> 
> 	if grep -q 'ESCAPED-ARM' /sys/kernel/tracing/trace || dmesg | grep -qE 'BUG: KASAN|Oops'; then
> 		echo "=== HIT at off=$off (shot $i) ==="
> 		grep -E 'reap_ah|ESCAPED' /sys/kernel/tracing/trace | tail -20
> 		dmesg | grep -E 'KASAN|Oops|Call Trace|RIP' | tail -30
> 		echo "HIT-OFFSET=$off shot=$i" > /root/HIT
> 		poweroff -f
> 	fi
> done
> echo "done $MAX shots, no hit"
> 
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 81bbb3f7c113..5ed4f709cb40 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -736,11 +736,11 @@ static void ipoib_start_ah_reaper(struct ipoib_dev_priv *priv)
>  static void ipoib_stop_ah_reaper(struct ipoib_dev_priv *priv)
>  {
>  	set_bit(IPOIB_STOP_REAPER, &priv->flags);
> -	cancel_delayed_work(&priv->ah_reap_task);
> +	cancel_delayed_work_sync(&priv->ah_reap_task);
>  	/*
>  	 * After ipoib_stop_ah_reaper() we always go through
> -	 * ipoib_reap_dead_ahs() which ensures the work is really stopped and
> -	 * does a final flush out of the dead_ah's list
> +	 * ipoib_reap_dead_ahs() which does a final flush out of the
> +	 * dead_ah's list
>  	 */
>  }
>  
> -- 
> 2.25.1
> 
> 
