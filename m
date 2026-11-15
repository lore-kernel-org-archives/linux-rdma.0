Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769129;
	b=O9CvtQQk6vVSehOT4OQhRBLz1NSskSmhTVNFIR/b33mDx/dxYdht14KfHSxwBssHPlZN
	 604bdoRDWglx7gVJE0Ej/ilIaIZU5td+qdGOHZp6/fPddgRVR0AzLdXqVWsgXvBBhe6oO
	 h9ghHQ27tQk7Mx4r7ttVMYpF++tK8qjL8mYF9XWz+ZyBNQl/OTd/KuhMt33hlvANyUfuZ
	 20MXpuELvsTWPYGeH+ZFlmQcqDgB3XsEztrgBeY5GK8D5ltQU0O7stH1FG2EG9qJF4czR
	 s7OXIOKSrJpqklxXATiUMrHT455BmH+qJCeM/H17aW82Oac+UITSfHQK3w4ClXfWqfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769129;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=IJyxECH75WGYTVW7kxfr5rJiCGU0Zp/BdFTBVu27fCo=;
	b=STobYZk17JoXbiydCeB85cgwFoDVWPJsd99uOmNkBs8U844cYlQ59K0ipa8RMjEwq/Hg
	 TttpEbaKfwNbpEdoLv9+JxsQE9e20/6eOjw0xYEN4Mh0iGvfeYl9MPr2Te2R/7u1uUbBr
	 rJbNzhL7jl+ITeAJFG9ZAFM1TxAhylbfVKVNG+oZXFXsWaeD1lT6ZaQ3kmykh9SEztJ35
	 JrC3yDOXx+MJTFDo1U+9YKv8Joa4NcF0yAm3fl/Eqygznn1ok1T5lH8awg7Td/7St5YMk
	 5AC20jfqHSZamAOt7kLNvP5MXR1uJUdb7uCd2VjzUGlcrsqanRCyzQjihHlxZkniEAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Wy5Zh8z/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D60606A323;
	Sun, 15 Nov 2026 18:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wy5Zh8z/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C368E1F000C4;
	Sun, 15 Nov 2026 18:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769128;
	bh=IJyxECH75WGYTVW7kxfr5rJiCGU0Zp/BdFTBVu27fCo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Wy5Zh8z//iqSC1qTYpNLXRqF1A3NOU66jO+6YvVvKEtVM4P5F5KttjlpfQCttpOHn
	 rzqi6f2iOBz2w0wHA0+Nn4uF0KPGzEhVNNVaLiA5ojYE63jhY7hOJxlFZChM9FrMoC
	 Mh7aGMLEqMDOD9kSLjfjP27iY7UywDUI4/7StXACFqQzdS0nMHKEZVz3V7qoX7D1PT
	 YkcpWIsKIvWOyM7Yi5lx6mbnWC3Tq6nVJScozYbRKLyrPCCxHnrYLum8ZJPSnU1hFH
	 LlvBQmUnSAtyEdw3IirV8gL5DO5me2JnGOEeuGQvz5X09XVGVeOlvQDhhtop0CywRK
	 T5lXwgnWK2N8A==
Subject: Re: [PATCH net v2 2/2] selftests: net: check TCP IP IDs across
 tunnels after GRO and GSO
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch,
 dsahern@kernel.org, idosch@nvidia.com, ncardwell@google.com,
 kuniyu@google.com, richardbgobert@gmail.com, willemb@google.com,
 ecree.xilinx@gmail.com, linux-net-drivers@amd.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, alexei.starovoitov@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, john.fastabend@gmail.com, sdf@fomichev.me,
 martin.lau@linux.dev, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org,
 emil@etsalapatis.com, ihor.solodrai@linux.dev, corbet@lwn.net,
 rdunlap@infradead.org, skhan@linuxfoundation.org, shuah@kernel.org,
 bpf@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 15 Nov 2026 18:58:46 +0000
Message-ID: <179476912638.3136.4994439031364292741@kernel.org>
In-Reply-To: <c4f9c977725ee51341ca84dedf2dddb9fcb4e8ea.1794139176.git.julius@bairaktaris.de>
References: <c4f9c977725ee51341ca84dedf2dddb9fcb4e8ea.1794139176.git.julius@bairaktaris.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The header comment of tcp_fixedid.sh (lines 18-21) and the
  commit message both say that a run in which GRO merged nothing is…
- [Medium] When run_esp() hits an error, it calls nsim_del() (lines 334
  and 360).
- [Low] In do_rx() in tcp_fixedid.c, the check for incrementing IDs is
  `(uint16_t)(id - INCR_ID) >= stop` (line 311).
- [Low] The EXIT trap handler cleanup() in tcp_fixedid.sh (lines 44-47)
  only runs cleanup_all_ns and removes $RESULT.
- [Low] On the success path, run_esp() runs cleanup_all_ns (line 373)
  before nsim_del (line 374), which is the reverse of setup order.
- [Low] selftests: net: tcp_fixedid.sh duplicates lib.sh netdevsim and
  wait helpers

--

selftests: net: check TCP IP IDs across tunnels after GRO and GSO

This adds a packet socket helper and a script. The script sends TCP
segments with fixed or incrementing IPv4 IDs through veth GRO into IPIP,
GRE, VXLAN and netdevsim-offloaded ESP tunnels. It then checks that inner
IDs are preserved and that outer IDs are unique or increment, and it
skips runs in which GRO merged nothing.

> diff --git a/tools/testing/selftests/net/tcp_fixedid.c b/tools/testing/selftests/net/tcp_fixedid.c
> new file mode 100644
> index 0000000000000..25c752beab4ed
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_fixedid.c

[ ... ]

> +static int do_rx(int fd)
> +{

[ ... ]

> +		frames++;
> +		id = ntohs(iph->id);
> +		count_id(inner_map, &inner_ids, id);
> +		if (fixed_id ? id != FIXED_ID : (uint16_t)(id - INCR_ID) >= stop)
> +			inner_bad++;

[Severity: Low]
What happens here when the receiver runs without -c? Only -c sets stop,
so it defaults to 0:

static int segs = 40, bursts = 10, len = 1000, wait_ms = 2000, stop;

With stop == 0 and no -f, (uint16_t)(id - INCR_ID) >= 0 is always true.
Every frame then counts as inner_bad, even when the IDs are correct.

The usage comment lists [-c segs] as optional for rx. capture() in
tcp_fixedid.sh always passes -c "$TOTAL", so this only affects running
the helper by hand as documented.

Should rx without -f require -c, or fall back to some other range?

[ ... ]

> diff --git a/tools/testing/selftests/net/tcp_fixedid.sh b/tools/testing/selftests/net/tcp_fixedid.sh
> new file mode 100755
> index 0000000000000..05ef7ec6b08e7
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_fixedid.sh

[ ... ]

> +cleanup() {
> +	cleanup_all_ns
> +	rm -f "$RESULT"
> +}
> +
> +trap cleanup EXIT

[Severity: Low]
Can this EXIT trap leave behind the netdevsim devices that run_esp()
creates? Only run_esp()'s own return paths call nsim_del(). If the script
is killed during run_esp(), for example by a runner timeout or Ctrl-C,
the trap only deletes the namespaces.

netdevsim ports have no rtnl_link_ops, so default_device_exit_net() moves
them into init_net instead of destroying them:

net/core/dev.c:default_device_exit_net() {
    ...
		/* Leave virtual devices for the generic cleanup */
		if (dev->rtnl_link_ops && !dev->rtnl_link_ops->netns_refund)
			continue;

		/* Push remaining network devices to init_net */
    ...
}

That leaves two netdevsim bus devices and their netdevs in the host
namespace. Could cleanup() also call nsim_del?

[ ... ]

> +# check <name> <result> <want: fixed|incr> <outer: 0|unique|incr> <merged>
> +check() {

[ ... ]

> +	if [ "$outer" = unique ]; then
> +		check_err $((outer_ids != frames)) \
> +			"$outer_ids outer IDs for $frames segments"
> +	elif [ "$outer" = incr ]; then
> +		check_err $((outer_ids < 2)) "fixed outer IDs"
> +	fi
> +	if [ "$RET" -eq 0 ] && [ "$sent" -ge "$TOTAL" ]; then
> +		ret_set_ksft_status "$ksft_skip" "GRO did not merge"
> +	fi
> +	log_test "$name"
> +}

[Severity: Medium]
Does the ESP case report FAIL instead of SKIP when GRO merged nothing?
The commit message says:

  A test where GRO merged nothing is skipped.

The header comment says the same.

Without merging, each forwarded skb carries one segment.
xfrm4_tunnel_encap_add() copies DF from the inner header and calls
ip_select_ident(dev_net(dst->dev), skb, NULL). ip_select_ident_segs()
then does:

	if ((iph->frag_off & htons(IP_DF)) && !skb->ignore_df) {
		iph->id = 0;
		return;
	}

Every ESP outer ID is therefore 0 and outer_ids is 1. The outer=incr
check sets RET=1 before the skip test, so the RET -eq 0 condition never
lets run_esp() skip. The unique and 0 outer modes do skip correctly in
the same situation.

Also, the header comment says the ESP outer IDs must "increment".
outer_ids < 2 only checks that at least two distinct outer IDs were
seen. Is a stricter check intended here?

[ ... ]

> +nsim_del() {
> +	echo "$NSIM_ID" > "$NSIM_BUS/del_device" 2>/dev/null
> +	echo $((NSIM_ID + 1)) > "$NSIM_BUS/del_device" 2>/dev/null
> +}

[ ... ]

> +	if ! rdev=$(nsim_add "$NSIM_ID" "$NRTR") ||
> +	   ! mdev=$(nsim_add $((NSIM_ID + 1)) "$NMID"); then
> +		log_test_skip "esp: netdevsim"
> +		nsim_del
> +		cleanup_all_ns
> +		return
> +	fi

[Severity: Medium]
Can this delete a netdevsim device that another test or the user
created? NSIM_ID is picked at random from 1024..2047.
nsim_bus_dev_new() allocates the ID with ida_alloc_range(id, id), so
new_device fails if that ID is already in use.

In that case nsim_add() returns 1, and nsim_del() writes both NSIM_ID and
NSIM_ID + 1 to del_device, whether or not this run created them.

The same applies to NSIM_ID + 1 if the second nsim_add() collides. It
also applies if the first nsim_add() creates NSIM_ID and then ip link
set netns fails.

Could nsim_del() remove only the IDs that nsim_add() actually created?

[ ... ]

> +	check "esp tunnel offload, fixed inner IDs" "$(tail -n 1 "$RESULT")" \
> +		fixed incr $(($(fwd_packets "$NRTR") - t0))
> +	cleanup_all_ns
> +	nsim_del
> +}

[Severity: Low]
Is this teardown order intended? The success path runs cleanup_all_ns
before nsim_del, but the error paths in run_esp() run nsim_del first.

Because the namespaces are deleted first, default_device_exit_net()
moves the netdevsim ports into init_net. They briefly appear as host
interfaces until nsim_del removes them.

Would calling nsim_del before cleanup_all_ns here match the error paths?

[ ... ]

> @@ -0,0 +1,400 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Check the IPv4 IDs of a TCP stream that GRO merged and software
> +# segmentation split again across a tunnel. A sender in NSRC writes
> +# segments with fixed or incrementing IDs onto a veth with GRO on in
> +# NRTR, which forwards the merged packets:
> +#
> +#  encap:       into an IPIP, GRE or VXLAN tunnel over IPv4 or IPv6,
> +#               segmented on the underlay towards NMID
> +#  decap:       out of VXLAN, received from NSRC with one header fixed and
> +#               the other incrementing, into an IPIP tunnel towards NMID
> +#  encap+decap: into a tunnel that NMID ends without segmenting, and on
> +#               to NDST, segmented there
> +#  esp:         into an ESP tunnel mode SA offloaded to netdevsim, which
> +#               segments the packet in software and does not encrypt it
> +#
> +# The inner IDs must come out as they went in, and the IDs of a new outer
> +# IPv4 header must be unique, or for ESP, whose outer IDs start at 0 for
> +# each packet with DF set, increment. A run in which GRO merged nothing is
> +# skipped.
> +
> +source lib.sh
> +
> +NSRC=""
> +NRTR=""
> +NMID=""
> +NDST=""
> +
> +SEGS=40
> +BURSTS=10
> +TOTAL=$((SEGS * BURSTS))
> +INNER_SRC=10.1.0.1
> +INNER_DST=10.9.0.2
> +VX_MAC=02:00:00:00:00:42
> +TUN_MAC=02:00:00:00:00:99
> +MID_MAC=02:00:00:00:00:98
> +TX=./tcp_fixedid
> +
> +NOSEG="tso gso tx-gre-segmentation tx-gre-csum-segmentation
> +       tx-ipxip4-segmentation tx-ipxip6-segmentation
> +       tx-udp_tnl-segmentation tx-udp_tnl-csum-segmentation"
> +
> +cleanup() {
> +	cleanup_all_ns
> +	rm -f "$RESULT"
> +}
> +
> +trap cleanup EXIT
> +
> +# NSRC s0 - r0 NRTR r1 - m1 NMID m2 - d2 NDST
> +setup() {
> +	setup_ns NSRC NRTR NMID NDST || return "$ksft_skip"
> +
> +	ip link add s0 netns "$NSRC" type veth peer name r0 netns "$NRTR"
> +	ip link add r1 netns "$NRTR" type veth peer name m1 netns "$NMID"
> +	ip link add m2 netns "$NMID" type veth peer name d2 netns "$NDST"
> +
> +	ip -n "$NRTR" addr add 10.1.0.2/24 dev r0
> +	ip -n "$NRTR" addr add 10.2.0.1/24 dev r1
> +	ip -n "$NRTR" addr add fd02::1/64 dev r1 nodad
> +	ip -n "$NMID" addr add 10.2.0.2/24 dev m1
> +	ip -n "$NMID" addr add fd02::2/64 dev m1 nodad
> +	ip -n "$NMID" addr add 10.4.0.1/24 dev m2
> +	ip -n "$NDST" addr add 10.4.0.2/24 dev d2
> +	ip -n "$NSRC" link set s0 up
> +	ip -n "$NRTR" link set r0 up
> +	ip -n "$NRTR" link set r1 up
> +	ip -n "$NMID" link set m1 up
> +	ip -n "$NMID" link set m2 up
> +	ip -n "$NDST" link set d2 up
> +
> +	ip netns exec "$NRTR" sysctl -qw net.ipv4.ip_forward=1
> +	ip netns exec "$NMID" sysctl -qw net.ipv4.ip_forward=1
> +	for ns in "$NRTR" "$NMID"; do
> +		ip netns exec "$ns" sysctl -qw net.ipv4.conf.all.rp_filter=0 \
> +			net.ipv4.conf.default.rp_filter=0
> +	done
> +
> +	# veth passes packets to GRO only if the sender does not do TSO
> +	ip netns exec "$NRTR" ethtool -K r0 gro on >/dev/null ||
> +		return "$ksft_skip"
> +	ip netns exec "$NSRC" ethtool -K s0 tso off >/dev/null ||
> +		return "$ksft_skip"
> +	# release the sender's segments in bursts for GRO to merge
> +	tc -n "$NSRC" qdisc add dev s0 root netem slot 20ms 20ms \
> +		packets "$SEGS" || return "$ksft_skip"
> +}
> +
> +# tunnel <ns> <name> <type> <family> <local> <remote>
> +tunnel() {
> +	local ns=$1 name=$2 type=$3 family=$4 local=$5 remote=$6
> +
> +	case "$type" in
> +	ipip)
> +		if [ "$family" = 4 ]; then
> +			ip -n "$ns" link add "$name" type ipip \
> +				local "$local" remote "$remote"
> +		else
> +			ip -n "$ns" link add "$name" type ip6tnl mode ipip6 \
> +				local "$local" remote "$remote" encaplimit none
> +		fi ;;
> +	gre)
> +		if [ "$family" = 4 ]; then
> +			ip -n "$ns" link add "$name" type gre \
> +				local "$local" remote "$remote"
> +		else
> +			ip -n "$ns" link add "$name" type ip6gre \
> +				local "$local" remote "$remote" encaplimit none
> +		fi ;;
> +	vxlan)
> +		ip -n "$ns" link add "$name" address "$TUN_MAC" type vxlan \
> +			id 7 dstport 4789 local "$local" remote "$remote" \
> +			nolearning ;;
> +	esac || return 1
> +	# no IPv6 link-local traffic in the tx_packets of the tunnel
> +	ip netns exec "$ns" sysctl -qw "net.ipv6.conf.$name.disable_ipv6=1"
> +	ip -n "$ns" link set "$name" up
> +}
> +
> +# route_into <ns> <dev>: send INNER_DST into <dev>
> +route_into() {
> +	ip -n "$1" route add "$INNER_DST/32" dev "$2"
> +	ip -n "$1" neigh add "$INNER_DST" lladdr "$TUN_MAC" dev "$2" \
> +		2>/dev/null
> +	return 0
> +}
> +
> +# noseg <ns> <dev>: segment everything in software before <dev>
> +noseg() {
> +	local f
> +
> +	for f in $NOSEG; do
> +		ip netns exec "$1" ethtool -K "$2" "$f" off >/dev/null 2>&1
> +	done
> +}
> +
> +tx_packets() {
> +	ip netns exec "$1" cat "/sys/class/net/$2/statistics/tx_packets"
> +}
> +
> +# fwd_packets <ns>: packets forwarded, a GSO packet counting once
> +fwd_packets() {
> +	ip netns exec "$1" awk '/^Ip: [0-9]/ { print $7 }' /proc/net/snmp
> +}
> +
> +# check <name> <result> <want: fixed|incr> <outer: 0|unique|incr> <merged>
> +check() {
> +	local name=$1 res=$2 want=$3 outer=$4 sent=$5
> +	local frames outer_ids inner_ids inner_bad
> +
> +	read -r _ frames _ _ _ outer_ids _ inner_ids _ inner_bad <<< "$res"
> +	RET=0
> +	if [ -z "$inner_bad" ]; then
> +		check_err 1 "no result from the receiver"
> +		log_test "$name"
> +		return
> +	fi
> +	check_err $((frames != TOTAL)) "$frames of $TOTAL segments received"
> +	check_err "$inner_bad" "$inner_bad inner IDs not sent"
> +	if [ "$want" = fixed ]; then
> +		check_err $((inner_ids != 1)) "$inner_ids inner IDs, want 1"
> +	else
> +		check_err $((inner_ids != TOTAL)) \
> +			"$inner_ids inner IDs, want $TOTAL"
> +	fi
> +	if [ "$outer" = unique ]; then
> +		check_err $((outer_ids != frames)) \
> +			"$outer_ids outer IDs for $frames segments"
> +	elif [ "$outer" = incr ]; then
> +		check_err $((outer_ids < 2)) "fixed outer IDs"
> +	fi
> +	if [ "$RET" -eq 0 ] && [ "$sent" -ge "$TOTAL" ]; then
> +		ret_set_ksft_status "$ksft_skip" "GRO did not merge"
> +	fi
> +	log_test "$name"
> +}
> +
> +# capture <ns> <dev> <want: fixed|incr>: start the receiver in the
> +# background, pid in CAP_PID, and wait until it is bound
> +capture() {
> +	local f="" i
> +
> +	[ "$3" = fixed ] && f=-f
> +	: > "$RESULT"
> +	ip netns exec "$1" "$TX" -R -i "$2" -c "$TOTAL" -w 3000 $f > "$RESULT" &
> +	CAP_PID=$!
> +	for i in $(seq 100); do
> +		grep -q ready "$RESULT" && return
> +		sleep 0.1
> +	done
> +}
> +
> +run_encap() {
> +	local type=$1 family=$2 want=$3
> +	local r0mac t0 laddr=10.2.0.1 raddr=10.2.0.2
> +	local f=""
> +
> +	setup || { log_test_skip "encap $type IPv$family"; return; }
> +	if [ "$family" = 6 ]; then
> +		laddr=fd02::1
> +		raddr=fd02::2
> +	fi
> +	if ! tunnel "$NRTR" tun0 "$type" "$family" "$laddr" "$raddr"; then
> +		log_test_skip "encap $type IPv$family"
> +		cleanup_all_ns
> +		return
> +	fi
> +	route_into "$NRTR" tun0
> +	noseg "$NRTR" r1
> +
> +	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
> +	capture "$NMID" m1 "$want"
> +	t0=$(tx_packets "$NRTR" tun0)
> +	[ "$want" = fixed ] && f=-f
> +	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s "$INNER_SRC" \
> +		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" $f
> +	wait "$CAP_PID"
> +	check "encap $type IPv$family, $want inner IDs" \
> +		"$(tail -n 1 "$RESULT")" "$want" \
> +		"$([ "$family" = 4 ] && echo unique || echo 0)" \
> +		$(($(tx_packets "$NRTR" tun0) - t0))
> +	cleanup_all_ns
> +}
> +
> +# run_decap <fixed: inner|outer>: VXLAN from NSRC, decapsulated in NRTR
> +run_decap() {
> +	local fixed=$1 want=incr flags=-F
> +	local r0mac t0
> +
> +	setup || { log_test_skip "decap"; return; }
> +	ip -n "$NRTR" link add vx0 address "$VX_MAC" type vxlan id 42 \
> +		dstport 4789 local 10.1.0.2 nolearning ||
> +		{ log_test_skip "decap"; cleanup_all_ns; return; }
> +	ip -n "$NRTR" addr add 10.3.0.2/24 dev vx0
> +	ip -n "$NRTR" link set vx0 up
> +	if ! tunnel "$NRTR" tun0 ipip 4 10.2.0.1 10.2.0.2; then
> +		log_test_skip "decap"
> +		cleanup_all_ns
> +		return
> +	fi
> +	route_into "$NRTR" tun0
> +	noseg "$NRTR" r1
> +
> +	if [ "$fixed" = inner ]; then
> +		want=fixed
> +		flags=-f
> +	fi
> +	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
> +	capture "$NMID" m1 "$want"
> +	t0=$(tx_packets "$NRTR" tun0)
> +	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s 10.3.0.1 \
> +		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" \
> +		-V 10.1.0.1,10.1.0.2 -m "$VX_MAC" $flags
> +	wait "$CAP_PID"
> +	check "decap VXLAN with fixed $fixed IDs, into IPIP" \
> +		"$(tail -n 1 "$RESULT")" "$want" unique \
> +		$(($(tx_packets "$NRTR" tun0) - t0))
> +	cleanup_all_ns
> +}
> +
> +# run_encap_decap <type>: NRTR encapsulates, NMID decapsulates the GSO
> +# packet without segmenting it and forwards it to NDST
> +run_encap_decap() {
> +	local type=$1
> +	local r0mac t0
> +
> +	setup || { log_test_skip "encap+decap $type"; return; }
> +	if ! tunnel "$NRTR" tun0 "$type" 4 10.2.0.1 10.2.0.2 ||
> +	   ! tunnel "$NMID" tun0 "$type" 4 10.2.0.2 10.2.0.1; then
> +		log_test_skip "encap+decap $type"
> +		cleanup_all_ns
> +		return
> +	fi
> +	route_into "$NRTR" tun0
> +	# VXLAN drops frames from its own address as loops
> +	if [ "$type" = vxlan ]; then
> +		ip -n "$NMID" link set tun0 address "$MID_MAC"
> +		ip -n "$NRTR" neigh replace "$INNER_DST" lladdr "$MID_MAC" \
> +			dev tun0
> +	fi
> +	ip -n "$NMID" route add "$INNER_DST/32" via 10.4.0.2
> +	ip -n "$NDST" addr add "$INNER_DST/32" dev d2
> +	noseg "$NMID" m2
> +
> +	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
> +	capture "$NDST" d2 fixed
> +	t0=$(tx_packets "$NRTR" tun0)
> +	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s "$INNER_SRC" \
> +		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" -f
> +	wait "$CAP_PID"
> +	check "encap+decap $type, fixed inner IDs" "$(tail -n 1 "$RESULT")" \
> +		fixed 0 $(($(tx_packets "$NRTR" tun0) - t0))
> +	cleanup_all_ns
> +}
> +
> +NSIM_ID=$((RANDOM % 1024 + 1024))
> +NSIM_BUS=/sys/bus/netdevsim
> +
> +# nsim_add <id> <ns>: create a netdevsim port in <ns>, print its name
> +nsim_add() {
> +	local dev
> +
> +	echo "$1 1" > "$NSIM_BUS/new_device" || return 1
> +	for dev in "$NSIM_BUS/devices/netdevsim$1/net/"*; do
> +		dev=${dev##*/}
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
> +
> +# run_esp: NRTR forwards into an ESP tunnel mode SA offloaded to a
> +# netdevsim port with TSO off, linked to a netdevsim port in NMID
> +run_esp() {
> +	local key=0x3132333435363738393031323334353664636261
> +	local r0mac rdev mdev rfd mfd t0
> +
> +	setup || { log_test_skip "esp"; return; }
> +	if ! modprobe -q netdevsim 2>/dev/null && [ ! -w "$NSIM_BUS/new_device" ]; then
> +		log_test_skip "esp: no netdevsim"
> +		cleanup_all_ns
> +		return
> +	fi
> +	if ! rdev=$(nsim_add "$NSIM_ID" "$NRTR") ||
> +	   ! mdev=$(nsim_add $((NSIM_ID + 1)) "$NMID"); then
> +		log_test_skip "esp: netdevsim"
> +		nsim_del
> +		cleanup_all_ns
> +		return
> +	fi
> +	exec {rfd}<"/run/netns/$NRTR" {mfd}<"/run/netns/$NMID"
> +	echo "$rfd:$(ip netns exec "$NRTR" cat "/sys/class/net/$rdev/ifindex")" \
> +	     "$mfd:$(ip netns exec "$NMID" cat "/sys/class/net/$mdev/ifindex")" \
> +	     > "$NSIM_BUS/link_device"
> +	exec {rfd}<&- {mfd}<&-
> +
> +	ip -n "$NRTR" addr add 10.5.0.1/24 dev "$rdev"
> +	ip -n "$NMID" addr add 10.5.0.2/24 dev "$mdev"
> +	ip -n "$NRTR" link set "$rdev" up
> +	ip -n "$NMID" link set "$mdev" up
> +	ip -n "$NRTR" neigh add 10.5.0.2 dev "$rdev" lladdr \
> +		"$(ip -n "$NMID" -br link show "$mdev" | awk '{ print $3 }')"
> +	ip -n "$NRTR" route add "$INNER_DST/32" via 10.5.0.2 dev "$rdev"
> +	ip netns exec "$NRTR" ethtool -K "$rdev" tso off >/dev/null
> +	if ! ip -n "$NRTR" xfrm state add src 10.5.0.1 dst 10.5.0.2 \
> +		proto esp spi 0x100 reqid 1 mode tunnel \
> +		aead 'rfc4106(gcm(aes))' "$key" 128 \
> +		offload dev "$rdev" dir out ||
> +	   ! ip -n "$NRTR" xfrm policy add dir out \
> +		src "$INNER_SRC/32" dst "$INNER_DST/32" \
> +		tmpl src 10.5.0.1 dst 10.5.0.2 proto esp reqid 1 mode tunnel; then
> +		log_test_skip "esp: no ESP offload"
> +		nsim_del
> +		cleanup_all_ns
> +		return
> +	fi
> +
> +	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
> +	capture "$NMID" "$mdev" fixed
> +	t0=$(fwd_packets "$NRTR")
> +	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s "$INNER_SRC" \
> +		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" -f
> +	wait "$CAP_PID"
> +	check "esp tunnel offload, fixed inner IDs" "$(tail -n 1 "$RESULT")" \
> +		fixed incr $(($(fwd_packets "$NRTR") - t0))
> +	cleanup_all_ns
> +	nsim_del
> +}
> +
> +require_command ethtool
> +require_command tc
> +
> +if [ ! -x "$TX" ]; then
> +	echo "SKIP: $TX not built"
> +	exit "$ksft_skip"
> +fi
> +
> +RESULT=$(mktemp)
> +
> +for type in ipip gre vxlan; do
> +	for family in 4 6; do
> +		run_encap "$type" "$family" fixed
> +		run_encap "$type" "$family" incr
> +	done
> +done
> +run_decap inner
> +run_decap outer
> +for type in ipip gre vxlan; do
> +	run_encap_decap "$type"
> +done
> +run_esp
> +
> +exit "$EXIT_STATUS"

[Severity: Low]
The script already sources lib.sh, and lib.sh has helpers for most
of what is open-coded here:

  - create_netdevsim() and cleanup_netdevsim() cover nsim_add() and
    nsim_del()
  - slowwait() covers the readiness loop in capture()
  - check_gen_prog() covers the [ ! -x "$TX" ] test before the main
    loop

The netdevsim case is not just style. nsim_add() writes new_device in
the initial namespace. It then runs ip link set netns on whatever name
the glob finds under devices/netdevsim$1/net/.

On a host running udevd, the interface can be renamed between the glob
and the ip link call. The move then fails, or nsim_add() prints a
stale name. Either way run_esp() skips, or later commands act on the
wrong name.

create_netdevsim() avoids this. It runs udevadm settle and writes
new_device from inside the target namespace via ip netns exec, so the
port never appears in init_net. cleanup_netdevsim() also checks that
the device exists before writing del_device.

Could nsim_add(), nsim_del(), the capture() wait and the TX check use
the lib.sh helpers instead? create_netdevsim() takes the ID and the
namespace as arguments, so run_esp() should still know both IDs for
the link_device write. Is there a reason the lib.sh versions do not
fit here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794139176.git.julius%40bairaktaris.de
