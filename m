Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC553A8A5;
	Thu, 10 Sep 2026 21:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077281; cv=none; b=lbmvpBJ5UtGYU3PUTuSuKdho1eP8gi0FysQ5YEIwt3ExCp7pCZkSUXW/ovOplKbfDAiKAknR6XW44muLhBPrAXESGEv8tR/dQ0crJkmKo8YWGDFJwD2g/RaRWodTDsVsWO1AisXuAM+7EZsSYzXFmiS8MioAE5rHB0ORjPDK6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077281; c=relaxed/simple;
	bh=aUBhGTqZqeVmV2lUgpSEk2xHi/N2DRiIYBbRBLs+uvY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fijXZMn72AuCdzp2lFV04j8g1lcBINwhyQC0/DyfQd+dlPpC3lIRsu0x9UMZH0YvKMp1KcSQPS/hGw3NmiDnrz70v6fj3xUfsiXri2a71r+SGnunHJWQESnsZjnTVITDtQIUJdB0Bo4J8X581xsIwuJI/ANf7LNx6crNxZ7bxOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjUyG7eM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjUyG7eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020E01F00898;
	Thu, 10 Sep 2026 21:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077279;
	bh=+DVKNr25hqn1FcnQlVP1Q1iJr2zcXSldRHFPTF50VvU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FjUyG7eMqfyAS44FV64wdiYTh5S031v/s25/0bBiZ3Ab47K3CHDuphoP4utYr6UNd
	 11R3ahBDgsJ8pLIXgF0IUvXbyHxY1gX+y2XNWvyBrrNPHMxNxq3l/4l+HzL2/GlDY3
	 iRcjZcrnxgvN9cCXOTugHW0/sHBDBVlTT80jJQNBUX5DnXbs81jGqqD1RVC3bfnoEI
	 UnREzYjUqU3UYiWbCTYmPY6ow2SkX3E3snGOpDE/ap553nyNUONh7wjTzyX1hBgIyZ
	 LnnL2cLXrdqf0rQSs0OYBVB56/kHhOnOVCvkiyFpnbJQ7n197ZOggw6FVNr7Czo++c
	 m3mQOrNhgFvjw==
Subject: Re: [PATCH net-next V4 13/14] selftests: net: gro: Add PSP
 encapsulation and encryption
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, bobbyeshleman@meta.com, borisp@nvidia.com,
 cjubran@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com, doruk@0sec.ai,
 dtatulea@nvidia.com, gal@nvidia.com, jianbol@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, petrm@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 saeedm@nvidia.com, shuah@kernel.org, skhan@linuxfoundation.org,
 horms@kernel.org, willemb@google.com, willemdebruijn.kernel@gmail.com
Date: Thu, 10 Sep 2026 21:54:37 +0000
Message-ID: <178907727756.219967.6178881007641171433@kernel.org>
In-Reply-To: <20260908065244.3799142-14-tariqt@nvidia.com>
References: <20260908065244.3799142-14-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 7

- [Low] `struct psphdr { ... } __packed;` in
  tools/testing/selftests/net/lib/gro.c uses the `__packed` macro, but…
- [Low] The `psp_ver_diff` sub-test claims to verify that 'different PSP
  version doesn't coalesce', but it is implemented by the same…
- [Low] The file-level comment block of
  tools/testing/selftests/net/lib/gro.c enumerates every test case and…
- [Low] Concern (validated as NOT a defect): gro.c gains `--psp-assoc`
  and three psp_* sub-tests with no in-tree caller, making the feature…
- [Low] Concern (validated as NOT a defect): psp_encapsulate() hardcodes
  IPv6 header length and does not walk extension headers or reject…
- [Low] Concern (validated as NOT a defect): psp_encapsulate() recomputes
  the IPv4 header checksum from scratch, repairing the deliberately…
- [Low] Concern (validated as NOT a defect): each parsed PSP association
  allocates an EVP_CIPHER_CTX that is never freed, on error paths and at…

--

selftests: net: gro: Add PSP encapsulation and encryption

This adds an optional PSP transport mode to the gro selftest helper: frames
are encapsulated and encrypted in software with OpenSSL before being sent,
and the receiving NIC is expected to decrypt and decapsulate them. Three
PSP-only sub-tests (psp_spi_diff, psp_ver_diff, psp_mixed) and a new
--psp-assoc option are added, with libcrypto detection scoped to the gro
binary in the Makefile.

A few questions below.

> diff --git a/tools/testing/selftests/net/lib/gro.c b/tools/testing/selftests/net/lib/gro.c
> index 7a333155de1a..fe4a4c0e17ae 100644
> --- a/tools/testing/selftests/net/lib/gro.c
> +++ b/tools/testing/selftests/net/lib/gro.c

[ ... ]

> @@ -110,6 +119,38 @@
>  
>  #define EXIT_OVER_COALESCE	42
>  
> +/* PSP transport mode encapsulation, as built by the sender:
> + *
> + *	[eth][IP][UDP dport=1000][PSP hdr][encrypted L4][ICV]
> + *
> + * Can't use the kernel-only include/net/psp/types.h header, so copy the
> + * encoding here.
> + */
> +struct psphdr {
> +	uint8_t		nexthdr;
> +	uint8_t		hdrlen;
> +	uint8_t		crypt_offset;
> +	uint8_t		verfl;
> +	uint32_t	spi;		/* big endian */
> +	uint64_t	iv;		/* big endian */
> +} __packed;

[Severity: Low]

Where does __packed come from in this translation unit?

The include path for this binary is only:

  CFLAGS += -I../../../../../usr/include/ $(KHDR_INCLUDES)
  CFLAGS += -I../../

scripts/headers_install.sh textually rewrites the macro when exporting uapi
headers:

  s/(^|[^a-zA-Z0-9])__packed([^a-zA-Z0-9_]|$)/\1__attribute__((packed))\2/g

so the installed headers (including linux/psp.h) never define __packed, and
kselftest.h plus net/lib/ksft.h only pull in libc headers. In tools/ the
macro is defined by tools/include/linux/compiler.h and
tools/include/linux/compiler-gcc.h, neither of which is on this include
path.

Doesn't that make the declaration parse as a file-scope tentative definition
of an object named __packed of type struct psphdr, leaving the struct
unpacked?

The layouts happen to agree today (spi at offset 4, iv at offset 8,
sizeof == 16), so PSP_HDR_LEN and the offsetof() used for the nonce are
still right. But the unpacked struct carries 8-byte alignment while psph
lands at ETH_HLEN + 20 + 8 == 42 inside psp_scratch, i.e. 2 mod 8, so:

	psph->spi = htonl(assoc->spi);
	psph->iv = htobe64(psp_next_iv++);

are stores the compiler is entitled to treat as aligned. Would using
__attribute__((packed)) directly, or defining __packed locally as the sgx
and bpf selftests do, be preferable here?

> +
> +#define PSP_UDP_PORT		1000
> +#define PSP_UDP_LEN		sizeof(struct udphdr)
> +#define PSP_HDR_LEN		sizeof(struct psphdr)

[ ... ]

> @@ -1111,6 +1374,39 @@ static void send_changed_pppoe_sid(int fd, struct sockaddr_ll *daddr)
>  	write_packet(fd, buf, pkt_size, daddr);
>  }
>  
> +/* PSP packets don't coalesce across SPIs or versions. */
> +static void send_psp_assoc_switch(int fd, struct sockaddr_ll *daddr)
> +{
> +	static char buf[MAX_HDR_LEN + PAYLOAD_LEN];
> +	int pkt_size = total_hdr_len + PAYLOAD_LEN;
> +
> +	if (psp_num_assoc < 2)
> +		error(1, 0, "%s needs two PSP associations", testname);
> +
> +	create_packet(buf, 0, 0, PAYLOAD_LEN, 0);
> +	write_packet(fd, buf, pkt_size, daddr);
> +
> +	create_packet(buf, PAYLOAD_LEN, 0, PAYLOAD_LEN, 0);
> +	psp_idx = 1;
> +	write_packet(fd, buf, pkt_size, daddr);
> +	psp_idx = 0;
> +}

[Severity: Low]

Does psp_ver_diff actually exercise the version dimension?

Both psp_spi_diff and psp_ver_diff dispatch to send_psp_assoc_switch(),
which only flips psp_idx from association 0 to association 1. Since the two
RX associations always carry distinct device-allocated SPIs, the second
frame differs in SPI as well as version.

The kernel side compares the whole extension:

include/net/psp/functions.h:__psp_skb_coalesce_diff() {
	...
	diffs |= memcmp(a, b, sizeof(*a));
	...
}

over struct psp_skb_ext { __be32 spi; u16 dev_id; u8 generation;
u8 version; }, so the differing SPI alone already forces the flush.

Wouldn't psp_ver_diff then keep passing even if the version field were
dropped from the software or hardware comparison, making it a duplicate of
psp_spi_diff? Since SPIs are allocated by the device and two associations
cannot share one, would it make sense to at least assert
psp_assocs[0].version != psp_assocs[1].version in the sender, or note in a
comment that this case mainly exercises multi-version decap?

>  static void bind_packetsocket(int fd)
>  {
>  	struct sockaddr_ll daddr = {};

[ ... ]

> @@ -1559,6 +1855,16 @@ static void gro_sender(void)
>  		usleep(fin_delay_us);
>  		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
>  
> +	/* PSP sub-tests */
> +	} else if (strcmp(testname, "psp_spi_diff") == 0 ||
> +		   strcmp(testname, "psp_ver_diff") == 0) {
> +		send_psp_assoc_switch(txfd, &daddr);
> +		usleep(fin_delay_us);
> +		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);

[ ... ]

> @@ -1782,6 +2088,22 @@ static void gro_receiver(void)
>  		printf("different PPPoE session ID doesn't coalesce: ");
>  		check_recv_pkts(rxfd, correct_payload, 2);
>  
> +	/* PSP sub-tests */
> +	} else if (strcmp(testname, "psp_spi_diff") == 0) {
> +		correct_payload[0] = PAYLOAD_LEN;
> +		correct_payload[1] = PAYLOAD_LEN;
> +		printf("different PSP SPI doesn't coalesce: ");
> +		check_recv_pkts(rxfd, correct_payload, 2);
> +	} else if (strcmp(testname, "psp_ver_diff") == 0) {
> +		correct_payload[0] = PAYLOAD_LEN;
> +		correct_payload[1] = PAYLOAD_LEN;
> +		printf("different PSP version doesn't coalesce: ");
> +		check_recv_pkts(rxfd, correct_payload, 2);

[ ... ]

> @@ -1802,6 +2124,7 @@ static void parse_args(int argc, char **argv)
>  		{ "ip6ip6", no_argument, NULL, 'E' },
>  		{ "pppoev4", no_argument, NULL, 'p' },
>  		{ "pppoev6", no_argument, NULL, 'P' },
> +		{ "psp-assoc", required_argument, NULL, OPT_PSP_ASSOC },

[Severity: Low]

Should the file-level comment block at the top of gro.c be extended too?

It enumerates every sub-test family (data_*, flags_*, tcp_*, ip_*, large_*,
single, capacity), but psp_spi_diff, psp_ver_diff, psp_mixed and the new
--psp-assoc version,spi,key option are not listed there, and the last patch
of the series does not touch gro.c either.

The requirement that both sides be invoked with the same --psp-assoc
arguments is also undocumented, even though the receiver's expected sizes
depend on it:

static int calc_mss(void)
{
	return ASSUMED_MTU - (total_hdr_len - ETH_HLEN) -
		(psp_enabled ? PSP_ENCAP_LEN : 0);
}

Could that coupling be spelled out next to the other test descriptions?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
