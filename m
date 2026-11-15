Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794767281;
	b=uQyg5m1drxTMqFhqE+aK2oEUlIX+eDeji9rqtb0badjfUTf9aWMH5rZb2WnXxwIj9ne9
	 ZPEb66VjW5OAYgJXni373o4+nInj8KD34/bwcTK1tj9fwCv7yadFc94lVSl+gMQWF0Kmv
	 z0p+AjrTOXa16UAG0VS6/Y3TFrC6IN/14nP01ghbmZ6yqaT6PxHWEjZh2ocxiLwwuqQ29
	 81Lf2VTqrqG01Qc98jy5nK1jQfpTqIblMX/QBbYB7uLPZQeTQoJt7qJR3/sB2Kh3AE4ML
	 6jq3V/0JXpv6Y4apJsRw9mgh5rGJ5S/GQ4Lb7mye7Ebx4Cz22fD26jXOhxM7rgLhGUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767281;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fad+5qFUW61Uri7Mze4W7A6gLGHfxkCgg1EVDqGqoGU=;
	b=hHS6Csw955TROom4ijTfsUGSXFhORhKtork054q1A8fYvIwEU0N0vZpEVxltZR4Gcy5B
	 fsjY+bh4eo/VAFzD9xEvRiZX8URLvIcMdYN3z+qrszxdHWRGilT8/1CDe4X33A6Lr9SfL
	 lO5KtybwAU7qmSeT4Hh9Jfn+9k17NdEtRyO+TlmoqlOr0QH/BKvyMDVXogg179xuD2eV3
	 X3qq3zofc+iLK7yXHPY0kjoHbiINQA8BXdfm6mzGcnnw7fsa6RpJlK00q+hG5UN7ohEmK
	 Kd1w8bjsOXgivPCF8wmrrbgmPWEo8jI0ympWgFf5jcxzykgIRu3jg4FcMaCHF2qhzFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XoN2lJHS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4DA606A31A;
	Sun, 15 Nov 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XoN2lJHS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5A91F000C5;
	Sun, 15 Nov 2026 18:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794767281;
	bh=fad+5qFUW61Uri7Mze4W7A6gLGHfxkCgg1EVDqGqoGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XoN2lJHSNPQaB/3IXt5HDhpWnLDJJG66CSBu6LhWv+Csah+soK9XkB3mAWi5bB2E5
	 rnNiuOslCJsO297w0OhdsyhYnFGjKNhEJgMzc4xMaWDLvSzdpgPabOHhB0nGQoqPNB
	 BptCDvGCVCvZeWIPx99I7j5FzZ+KVrXCNI00uDpw9Kde6wGkSxfYdjuC2L/k9/jnO4
	 x/30SeYqER1vC5nqKaK4ZOk1p+A9qOK5tEVK8XjVT3MtOOMkBb8QMy8iJ9O0NkMw8Y
	 f1wzx1vI9VOl6Hj4PD6kkKMevoprScPUOSinLtrkU75vFLqTihcKzaqsc4wnJulSSo
	 1G3GRVgKairSA==
Message-ID: <sashiko-outbox-215718@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 2/2] selftests: net: check TCP IP IDs across
 tunnels after GRO and GSO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julius Bairaktaris" <julius@bairaktaris.de>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <c4f9c977725ee51341ca84dedf2dddb9fcb4e8ea.1794139176.git.julius@bairaktaris.de>
References: <cover.1794139176.git.julius@bairaktaris.de>
 <c4f9c977725ee51341ca84dedf2dddb9fcb4e8ea.1794139176.git.julius@bairaktaris.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 18:28:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Low] selftests: net: check() fails instead of skipping on outer=3Dincr
  without GRO
- [Low] selftests: net: missing nsim_del() in cleanup() trap and
  teardown order
- [Low] selftests: net: tcp_fixedid.sh duplicates lib.sh netdevsim and
  wait helpers
- [Low] selftests: net: do_rx() rejects all inner IDs when optional -c
  is omitted
--

commit 6de9851dc8b11c95f79b39bbfd7e7c1ba08870cd
Author: Julius Bairaktaris <julius@bairaktaris.de>

selftests: net: check TCP IP IDs across tunnels after GRO and GSO

This commit adds a selftest that sends TCP segments with fixed or
incrementing IPv4 IDs across veth GRO and tunnel software segmentation,
verifying that inner IP IDs are preserved and new outer IPv4 IDs are
unique or incrementing.

> diff --git a/tools/testing/selftests/net/tcp_fixedid.c b/tools/testing/se=
lftests/net/tcp_fixedid.c
> new file mode 100644
> index 0000000000000..25c752beab4ed
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_fixedid.c
> @@ -0,0 +1,411 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Send TCP segments with fixed or incrementing IPv4 IDs, optionally in
> + * VXLAN, and report the IP IDs of TCP segments received on a device,
> + * also inside IPIP, GRE, VXLAN or ESP.
> + *
> + * tx: tcp_fixedid -T -i dev -M dmac -s saddr -d daddr [-f] [-n segs]
> + *                 [-b bursts] [-l len] [-V osaddr,odaddr -m inner_dmac =
[-F]]
> + * rx: tcp_fixedid -R -i dev [-f] [-c segs] [-w ms]

[ ... ]

> +static int do_rx(int fd)
> +{
> +	static uint8_t outer_map[8192], inner_map[8192];
> +	unsigned int frames =3D 0, outer4 =3D 0, outer_ids =3D 0, inner_ids =3D=
 0;
> +	unsigned int inner_bad =3D 0;
> +	unsigned char buf[65536];
> +	struct pollfd pfd =3D { .fd =3D fd, .events =3D POLLIN };
> +
> +	printf("ready\n");
> +	fflush(stdout);
> +
> +	/* wait longer for the first segment than between segments */
> +	while (poll(&pfd, 1, frames ? wait_ms : 10 * wait_ms) > 0) {
> +		const struct iphdr *iph, *oiph;
> +		struct sockaddr_ll from;
> +		socklen_t fl =3D sizeof(from);
> +		uint16_t id;
> +		int n;
> +
> +		n =3D recvfrom(fd, buf, sizeof(buf), 0, (struct sockaddr *)&from,
> +			     &fl);
> +		if (n < 0)
> +			error(1, errno, "recvfrom");
> +		if (from.sll_pkttype =3D=3D PACKET_OUTGOING)
> +			continue;
> +		iph =3D find_inner(buf, n, &oiph);
> +		if (!iph)
> +			continue;
> +		frames++;
> +		id =3D ntohs(iph->id);
> +		count_id(inner_map, &inner_ids, id);
> +		if (fixed_id ? id !=3D FIXED_ID : (uint16_t)(id - INCR_ID) >=3D stop)
> +			inner_bad++;
> +		if (oiph) {
> +			outer4++;
> +			count_id(outer_map, &outer_ids, ntohs(oiph->id));
> +		}
> +		if (stop && frames =3D=3D (unsigned int)stop)
> +			break;
> +	}

[Severity: Low]
Does do_rx() count every segment as inner_bad when the optional -c flag is
omitted in incrementing-ID mode?  With stop left at 0 and fixed_id false,
(uint16_t)(id - INCR_ID) >=3D stop is always true.

[ ... ]

> diff --git a/tools/testing/selftests/net/tcp_fixedid.sh b/tools/testing/s=
elftests/net/tcp_fixedid.sh
> new file mode 100755
> index 0000000000000..05ef7ec6b08e7
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_fixedid.sh
> @@ -0,0 +1,400 @@

[ ... ]

> +cleanup() {
> +	cleanup_all_ns
> +	rm -f "$RESULT"
> +}
> +
> +trap cleanup EXIT

[Severity: Low]
Should cleanup() also call nsim_del() before cleanup_all_ns()?  If the
script exits via the trap during run_esp() (for example on SIGINT or
PAUSE_ON_FAIL=3Dyes), netdevsim$NSIM_ID and netdevsim$((NSIM_ID + 1)) are
left behind in /sys/bus/netdevsim and their interfaces move back into the
initial network namespace when the namespaces are removed.  At the end of
run_esp(), cleanup_all_ns is also called before nsim_del.

[ ... ]

> +# check <name> <result> <want: fixed|incr> <outer: 0|unique|incr> <merge=
d>
> +check() {
> +	local name=3D$1 res=3D$2 want=3D$3 outer=3D$4 sent=3D$5
> +	local frames outer_ids inner_ids inner_bad
> +
> +	read -r _ frames _ _ _ outer_ids _ inner_ids _ inner_bad <<< "$res"
> +	RET=3D0
> +	if [ -z "$inner_bad" ]; then
> +		check_err 1 "no result from the receiver"
> +		log_test "$name"
> +		return
> +	fi
> +	check_err $((frames !=3D TOTAL)) "$frames of $TOTAL segments received"
> +	check_err "$inner_bad" "$inner_bad inner IDs not sent"
> +	if [ "$want" =3D fixed ]; then
> +		check_err $((inner_ids !=3D 1)) "$inner_ids inner IDs, want 1"
> +	else
> +		check_err $((inner_ids !=3D TOTAL)) \
> +			"$inner_ids inner IDs, want $TOTAL"
> +	fi
> +	if [ "$outer" =3D unique ]; then
> +		check_err $((outer_ids !=3D frames)) \
> +			"$outer_ids outer IDs for $frames segments"
> +	elif [ "$outer" =3D incr ]; then
> +		check_err $((outer_ids < 2)) "fixed outer IDs"
> +	fi
> +	if [ "$RET" -eq 0 ] && [ \"$sent\" -ge \"$TOTAL\" ]; then
> +		ret_set_ksft_status \"$ksft_skip\" \"GRO did not merge\"
> +	fi
> +	log_test "$name"
> +}

[Severity: Low]
When GRO does not merge in run_esp() (sent >=3D TOTAL), does check() fail
with "fixed outer IDs" instead of skipping?  Each unmerged packet has DF
set, so ESP tunnel encapsulation gives every packet outer ID 0
(outer_ids =3D=3D 1); check_err $((outer_ids < 2)) then sets RET=3D1 before=
 the
sent >=3D TOTAL check can mark the test as skipped.

> +
> +# capture <ns> <dev> <want: fixed|incr>: start the receiver in the
> +# background, pid in CAP_PID, and wait until it is bound
> +capture() {
> +	local f=3D"" i
> +
> +	[ "$3" =3D fixed ] && f=3D-f
> +	: > "$RESULT"
> +	ip netns exec "$1" "$TX" -R -i "$2" -c "$TOTAL" -w 3000 $f > "$RESULT" &
> +	CAP_PID=3D$!
> +	for i in $(seq 100); do
> +		grep -q ready "$RESULT" && return
> +		sleep 0.1
> +	done
> +}

[ ... ]

> +NSIM_ID=3D$((RANDOM % 1024 + 1024))
> +NSIM_BUS=3D/sys/bus/netdevsim
> +
> +# nsim_add <id> <ns>: create a netdevsim port in <ns>, print its name
> +nsim_add() {
> +	local dev
> +
> +	echo "$1 1" > "$NSIM_BUS/new_device" || return 1
> +	for dev in "$NSIM_BUS/devices/netdevsim$1/net/"*; do
> +		dev=3D${dev##*/}
> +		ip link set "$dev" netns "$2" || return 1
> +		echo "$dev"
> +		return 0
> +	done
> +	return 1
> +}
> +
> +nsim_del() {
> +	echo "$NSIM_ID" > "$NSIM_BUS/del_device" 2>/dev/null
> +	echo $((NSIM_ID + 1)) > "$NSIM_BUS/del_device" 2>/dev/null
> +}

[Severity: Low]
Could this script reuse create_netdevsim(), cleanup_netdevsim(),
slowwait() and check_gen_prog() from lib.sh instead of open-coding
nsim_add(), nsim_del(), the readiness loop in capture() and the [ ! -x
"$TX" ] check?  In particular, create_netdevsim() creates the device
inside the target netns after udevadm settle, avoiding a race with host
udevd renaming the interface before ip link set moves it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794139176.gi=
t.julius@bairaktaris.de?part=3D2
