Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052250;
	b=shn0CBu51zkcuY5MlHIPVwJceC8BsjMuwynoa7IHtOLw11eJCM2lfKLMMQIvyL6WtLiB
	 jsESwIm6S6maVg6nc5sDfTXjTpXLsA8iyUGHt1k/W9zk8bjC8ywBeFwsaxWD7BJCIANze
	 XqyRHVXfQ1jm7mv+sy9XaFvr/iBdie9NSg7zXdBsKma14KIrxnU7bR/0WvutbUiHcFnM8
	 4/+qbCyVTNTh0nJ9RlRE5zge0GdIva7JUZMHS1GsEWVJGbSTvIEuViXaXIbhQQVGeSCjQ
	 KmQcxjs9mpnBTQgEdsVN4VrKu+NtjrkpXZVslUy0WYjgvyDtSGkph+JQfyu11lr63+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052250;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+ow764gQnWAzHn7aOQ8fKLXgpilrAf3N+ML6fumu2rw=;
	b=gCfzTuDJkzl8dLr577MD/iEN4W42Xg/XhkJ+rBZadBJbIfUtdEMve7S84hbEmrP/n9rp
	 OHJi56jly7zbk8GzdIr3AEJkhSnCKJ/6OIk6OYU+OhL4N46KmLA/6po7kRHIpwFLIlyO3
	 ChIE/40uB6Usu7QYvV9TLZS7gSpYKMD4X4y1eNvOo1Kqem09IYK5yhaO/C6GToiC1gVyT
	 7zuT7MJkUAdcqBO9eTZ4GRu60/75oMb3MP+wtCoymqv+e/FeE0C1ZawkoRLluKpa7MkXB
	 scUyhjDDYlpm8T+vRqYF7tORB6DmeJ9d8Uz6Hd+RmPTpUaR6YWEOBs6GHV1p+G8Dc3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hMED2+bQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AFE606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 22:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hMED2+bQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C305B1F01825;
	Mon, 26 Oct 2026 22:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793052249;
	bh=+ow764gQnWAzHn7aOQ8fKLXgpilrAf3N+ML6fumu2rw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=hMED2+bQo7dTq9kX0I7VuTxOq+Pz7Aj8cVVX3AJnrUT1eVIiH1WVARs2AlIdT+5jA
	 E6ag1IJzbLmJhwvQA3SJxkBOFsrwKcQgvBoLhZuXjBm4D9KFAfYlrWw2KTfmiBuxGh
	 bxh5SRoTF9Sh0rQ46AIeGuRStmKol+tNeps+Mf2L6qL0/A/dQ7O/HfQ45LcbOZ/oVX
	 VEvohH3I/O/XNfopI1A7CnQ0PqqovYMmRgm+6bWQ6/VKDlsVQD+wwnh/YC9j74/rXQ
	 W321clMRIfjQqMrYMo1yHRj76XhUhjiwueor+UKNlqcS2LZXbNBn706gpq3IZzbl3q
	 cXFwjnSz27KBQ==
Message-ID: <sashiko-outbox-185778@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] selftests/rdma: Introduce eBPF kernel and user
 dump utilities for RXE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org
In-Reply-To: <20261026215236.60054-2-yanjun.zhu@linux.dev>
References: <20261026215236.60054-1-yanjun.zhu@linux.dev>
 <20261026215236.60054-2-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 22:04:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/rdma: missing bounds checks on headers in print_bpf_ou=
tput()
- [Medium] selftests/rdma: non-zero exit status on signal termination in ma=
in()
--

commit 4272376de8af3a4ff5f669a42f1584996bddd230
Author: Zhu Yanjun <yanjun.zhu@linux.dev>

selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE

This commit adds eBPF-based kernel and user-space packet dump utilities
to tools/testing/selftests/rdma/ to capture and parse Soft-RoCE (RXE)
traffic over netkit devices.

> diff --git a/tools/testing/selftests/rdma/rxe_pkg_user_dump.c b/tools/tes=
ting/selftests/rdma/rxe_pkg_user_dump.c
> new file mode 100644
> index 0000000000000..5d51e7d1af66a
> --- /dev/null
> +++ b/tools/testing/selftests/rdma/rxe_pkg_user_dump.c
> @@ -0,0 +1,1365 @@

[ ... ]

> +static void print_bpf_output(const void *data, __u32 size)
> +{

[ ... ]

> +	for (int i =3D RXE_BTH + 1; i < NUM_HDR_TYPES; i++) {
> +		int offset =3D rxe_opcode[bth->opcode].offset[i];
> +
> +		if (offset && (size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) =
+ offset)) {
> +			const unsigned char *cur_p =3D (const unsigned char *)bth + offset;
> +			size_t remaining_size =3D size - ((const void *)cur_p - data);
> +
> +			switch (i) {
> +			case	RXE_RETH:
> +				if (remaining_size < sizeof(struct rxe_reth))
> +					break;
> +				printf("RXE_RETH\n");
> +				print_reth((const struct rxe_reth *)cur_p);
> +				break;
> +
> +			case	RXE_AETH:
> +				printf("RXE_AETH\n");
> +				struct rxe_aeth *aeth =3D (struct rxe_aeth *)cur_p;
> +
> +				print_aeth(aeth);
> +				break;
> +
> +			case	RXE_ATMETH:
> +				printf("RXE_ATMETH\n");
> +				struct rxe_atmeth *atmeth =3D (struct rxe_atmeth *)cur_p;
> +
> +				print_atmeth(atmeth);
> +				break;
> +
> +			case	RXE_ATMACK:
> +				printf("RXE_ATMACK\n");
> +				struct rxe_atmack *atmack =3D (struct rxe_atmack *)cur_p;
> +
> +				print_atmack(atmack);
> +				break;
> +
> +			case	RXE_IETH:
> +				printf("RXE_IETH\n");
> +				struct rxe_ieth *ieth =3D (struct rxe_ieth *)cur_p;
> +
> +				print_ieth(ieth);
> +				break;
> +
> +			case	RXE_RDETH:
> +				printf("RXE_RDETH\n");
> +				struct rxe_rdeth *rdeth =3D (struct rxe_rdeth *)cur_p;
> +
> +				print_rdeth(rdeth);
> +				break;
> +
> +			case	RXE_DETH:
> +				printf("RXE_DETH\n");
> +				struct rxe_deth *deth =3D (struct rxe_deth *)cur_p;
> +
> +				print_deth(deth);
> +				break;
> +
> +			case	RXE_IMMDT:
> +				printf("RXE_IMMDT\n");
> +				struct rxe_immdt *immdt =3D (struct rxe_immdt *)cur_p;
> +
> +				print_immdt(immdt);
> +				break;

[Severity: Medium]
Can print_bpf_output() read past the captured packet length in e->data[]
when parsing extended transport headers?

In handle_netkit_ingress() in tools/testing/selftests/rdma/rxe_pkg_kernel_d=
ump.c,
bpf_ringbuf_reserve() allocates an uninitialized struct pkg_event, and
bpf_skb_load_bytes() only populates the first e->len bytes of e->data:

	e =3D bpf_ringbuf_reserve(&rb, sizeof(*e), 0);
	...
	e->len =3D len;
	if (bpf_skb_load_bytes(skb, 0, e->data, len) < 0) {

In print_bpf_output(), the condition:

	if (offset && (size >=3D sizeof(struct iphdr) + sizeof(struct udphdr) + of=
fset))

only ensures that cur_p does not start past data + size (meaning
remaining_size >=3D 0), not that remaining_size is large enough to hold the
header structure at cur_p.

While the RXE_RETH case checks whether remaining_size < sizeof(struct rxe_r=
eth),
the cases for RXE_AETH, RXE_ATMETH, RXE_ATMACK, RXE_IETH, RXE_RDETH, RXE_DE=
TH,
and RXE_IMMDT dereference cur_p without checking remaining_size against the=
ir
respective struct sizes. If a truncated UDP packet arrives on port 4791,
won't these cases read uninitialized ring buffer memory past the end of the
captured packet (or past the end of e->data[MAX_PKT_LEN] if e->len is near
MAX_PKT_LEN)?

[ ... ]

> +int main(void)
> +{

[ ... ]

> +	err =3D 0;
> +
> +	while (!exiting) {
> +		err =3D ring_buffer__poll(ringbuf, 100 /* timeout */);
> +		if (err < 0) {
> +			if (err =3D=3D -EINTR)
> +				break;
> +			fprintf(stderr, "poll error: %d\n", err);
> +			break;
> +		}
> +	}
> +
> +cleanup:
> +	ring_buffer__free(ringbuf);
> +	rxe_pkg_kernel_dump__destroy(skel);
> +	return err;
> +}

[Severity: Medium]
Does main() return a non-zero exit code when terminated normally by SIGINT =
or
SIGTERM?

When a signal interrupts epoll_wait() inside ring_buffer__poll(),
ring_buffer__poll() returns -EINTR. The loop checks for -EINTR and breaks
without resetting err to 0.

Similarly, if the signal arrives while ring_buffer__poll() is processing
events, ring_buffer__poll() returns the positive number of consumed records
and the while (!exiting) loop terminates with err > 0.

In both cases, main() reaches cleanup and returns err directly instead of 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026215236.6005=
4-1-yanjun.zhu@linux.dev?part=3D1
