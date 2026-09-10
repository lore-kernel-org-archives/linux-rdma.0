Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2C249B5B6;
	Thu, 10 Sep 2026 21:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077284; cv=none; b=eHYYxBEw6IgRQYs1Ks2VcDQYr4kxvxftOulwqPxmroBkYIvVXm1T+78SQ/vLcLKQvhG2wDFlhQMJztVPWIVQYywaKa0SSXYFAepGtymx2aay6UNTfZYzWNvSZFgerlUh/8JrLWEnT2Ssx3ydTGFOQwzi8SWFsWpg9tTEMXjQWf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077284; c=relaxed/simple;
	bh=dEw80/bVVerQhsMNG0G0v5y17LxkTGc02LZ3iRg0HME=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SU8zU4aFSYklIOx44Ht1IhL3mpgTJLLpec6RmCAQMWv2K87rJWjGFPRMeX5vbilHsJxQqVF3EbEFXCoIugYWNsKJuLLO9QczCdxtaKEyrbyrju7sov/jKi+/oQmLB4NGILhzffsQCKtlsGPt5mNo2Jyjevge2uTfEy/yzxP2R+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbzAsNwD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbzAsNwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CEB1F000FF;
	Thu, 10 Sep 2026 21:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077282;
	bh=c2DuhBr8po4g2CDYugULZYspIL0D4pvk6ekdu105AOc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lbzAsNwDImI6O076ZlZgN51/lSyMpAiP2J79bg5IBKLYcnuYTwoq0Ges50sXjBW8G
	 aJT9PoongOEcpeSYkzhTrzzGlbULEcRDkajyZVF07/WoLzpsJYIaz5m6y9GCkAIX4I
	 phy2oPXgfjGxb0Rdewyjft5w4zN5XY/fO4/FLzeIlX0U3wWvQW2w0msL1qDQUnI99u
	 XCMpaHuGn0QIUCRnZAm6x7ssx+Ir0a2uCe9YarjAknAiPV9h1YvmAqKwlIXH+GDH+E
	 wVzbjDl6T1F+qU6LYSoKM7vV2e1nPe/dT/zPP2BQtU/rAUPw0m/NHVmEAPyqpv2K+k
	 g6337iHG8COpQ==
Subject: Re: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
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
Date: Thu, 10 Sep 2026 21:54:39 +0000
Message-ID: <178907727987.219967.2600993092228146685@kernel.org>
In-Reply-To: <20260908065244.3799142-15-tariqt@nvidia.com>
References: <20260908065244.3799142-15-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 3

- [Medium] test_psp_ver_diff() in
  tools/testing/selftests/drivers/net/hw/psp_gro.py gates on the *count*…
- [Medium] test_psp_after_reconfig()
  (tools/testing/selftests/drivers/net/hw/psp_gro.py:132-141) disables…
- [Low] The new HAVE_OPENSSL probe in
  tools/testing/selftests/drivers/net/hw/Makefile (lines 16-28) decides…
- [Low] test_psp_ver_diff()
  (tools/testing/selftests/drivers/net/hw/psp_gro.py:116-122) claims to…
- [Low] The psp_gro.py module docstring (line 7: "This reuses the gro
  binary in --psp mode:") and the new Makefile comment ("psp_gro.py uses…

--

selftests: drv-net: Add PSP HW GRO conformance tests

This adds psp_gro.py, which drives the existing gro helper binary with PSP
associations obtained from a real PSP device, so the sender encrypts in
software and the receiver relies on the NIC for decrypt, decap and HW GRO.
It also plumbs a common_args parameter through gro_lib.run_test() and adds a
libcrypto probe to the hw Makefile.

No Link: tags in the commit header.

>     Add PSP conformance tests using the same gro helper binary as other gro
>     tests , but in --psp mode. SPIs are procured by psp_gro.py from a real

[Severity: Low]
The commit message, the new Makefile comment ("psp_gro.py uses the gro
binary in PSP mode") and the psp_gro.py docstring all describe a "--psp
mode", but the gro helper has no such option.

In tools/testing/selftests/net/lib/gro.c the only PSP entry in
long_options[] is:

	{ "psp-assoc", required_argument, NULL, OPT_PSP_ASSOC },

and psp_enabled is just a side effect of psp_parse_assoc().  _psp_args()
in psp_gro.py correctly emits --psp-assoc ver,spi,key.  Could the wording
be changed to --psp-assoc so nobody tries to pass --psp and gets an
unknown-option error from getopt_long()?

> diff --git a/tools/testing/selftests/drivers/net/hw/Makefile b/tools/testing/selftests/drivers/net/hw/Makefile
> index 6105be8e590f..daa7e52f236e 100644
> --- a/tools/testing/selftests/drivers/net/hw/Makefile
> +++ b/tools/testing/selftests/drivers/net/hw/Makefile
> @@ -13,6 +13,20 @@ else
>  $(warning excluding iouring tests, liburing not installed or too old)
>  endif
>  
> +# psp_gro.py uses the gro binary in PSP mode, which requires OpenSSL.
> +PKG_CONFIG ?= pkg-config
> +HAVE_OPENSSL := $(shell echo 'int main(void) { return 0; }' | \
> +		  $(CC) -x c - -include openssl/evp.h \
> +		  $(shell $(PKG_CONFIG) --cflags --libs libcrypto 2>/dev/null \
> +			  || echo -lcrypto) \
> +		  -o /dev/null >/dev/null 2>&1 && echo 1)
> +
> +ifeq ($(HAVE_OPENSSL),1)
> +COND_PROGS += psp_gro.py
> +else
> +$(warning excluding PSP GRO tests, libcrypto not installed)
> +endif

[Severity: Low]
Is the build host the right place to test this condition?  The PSP
software encryption runs in the gro binary on the remote endpoint, not on
the build host:

gro_lib.py:_run_gro_bin()
	cfg.bin_local = cfg.net_lib_dir / "gro"
	cfg.bin_remote = cfg.remote.deploy(cfg.bin_local)
	...
	tx_cmd = f"{cfg.bin_remote} {args} --iface {cfg.remote_ifname}"
	...
	cmd(tx_cmd, host=cfg.remote)

gro is dynamically linked against libcrypto:

tools/testing/selftests/net/lib/Makefile
	$(OUTPUT)/gro: LDLIBS += $(LIBCRYPTO_LIBS)

and Remote.deploy() only scp's the executable:

tools/testing/selftests/drivers/net/lib/py/remote_ssh.py
	cmd(f"scp {what} {self.name}:{file_name}")

So on a setup where the build host has libcrypto but the remote endpoint
lacks the runtime library, psp_gro.py is installed and every case fails
with a dynamic linker error on the sender instead of skipping.  Would a
runtime check on the remote be preferable here?

[ ... ]

> diff --git a/tools/testing/selftests/drivers/net/hw/psp_gro.py b/tools/testing/selftests/drivers/net/hw/psp_gro.py
> new file mode 100755
> index 000000000000..3a069c944ae1
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/hw/psp_gro.py
> @@ -0,0 +1,157 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0
> +
> +"""
> +PSP HW GRO conformance tests.
> +
> +This reuses the gro binary in --psp mode:

[Severity: Low]
Same --psp naming question as in the commit message: the implemented
option in gro.c is --psp-assoc.

> +The sender crafts encapsulated & SW-encrypted PSP packets with receiver's PSP
> +rx-assoc, and the receiver's device decrypts and decapsulates the packets
> +before an AF_PACKET tap gets to analyze them.
> +
> +All GRO conformance tests which could run with PSP are included.
> +"""

[ ... ]

> +def _setup(cfg, version):
> +    """Enables PSP on the device under test."""
> +    init_psp_dev(cfg)
> +    require_version(cfg, version)
> +
> +
> +def _psp_args(cfg, versions):
> +    """Produces PSP associations as gro binary --psp-assoc arguments."""
> +    keys = [_psp_assoc(cfg, ver) for ver in versions]
> +    return [f"--psp-assoc {ver},{key['spi']:x},{key['key'].hex()}"
> +            for ver, key in zip(versions, keys)]
> +
> +
> +def _run(cfg, test_name, protocol, versions):
> +    """Sets up, associates and runs one gro test case under PSP + HW GRO."""
> +    _setup(cfg, max(versions))
> +
> +    run_test(cfg, "hw", protocol, test_name,
> +             common_args=_psp_args(cfg, versions))

[ ... ]

> +@ksft_variants(_ip_variants())
> +def test_psp_ver_diff(cfg, protocol):
> +    """Frames from two different PSP versions must not coalesce."""
> +    init_psp_dev(cfg)
> +    if len(cfg.psp_info['psp-versions-cap']) < 2:
> +        raise KsftSkipEx("Device supports a single PSP version")
> +
> +    _run(cfg, "psp_ver_diff", protocol, [0, 1])

[Severity: Medium]
Does the guard here match what the test then asks for?  It counts how
many versions the device advertises, but the following call hardcodes
versions 0 and 1.

psp-versions-cap is an independent flag bitmask in
Documentation/netlink/specs/psp.yaml:

      - name: psp-versions-cap
        doc: Bitmask of PSP versions supported by the device.
        type: u32
        enum: version
        enum-as-flags: true

so the supported set is not required to be a contiguous prefix starting
at 0.  On a device advertising, say, hdr0-aes-gcm-128 (0) and
hdr0-aes-gmac-128 (2), the length check passes and then:

psp_gro.py:_run()
	_setup(cfg, max([0, 1]))     /* == 1 */

psp_lib.py:require_version()
	name = cfg.pspnl.consts["version"].entries_by_val[version].name
	if name in cfg.psp_info['psp-versions-cap']:
		return
	...
	raise KsftSkipEx("PSP version not supported", name)

which skips with a reason unrelated to the guard, and the cross-version
non-coalescing assertion never runs on a device that could run it.

The existing peer test picks the versions from the actual caps instead:

tools/testing/selftests/drivers/net/psp.py:assoc_version_mismatch()
	versions = [cfg.pspnl.consts["version"].entries[v].value for v in versions]

Would deriving the two versions from cfg.psp_info['psp-versions-cap'] be
better here?  Today mlx5 happens to advertise exactly versions 0 and 1
(psp_supported_versions[] = { GCM_128, GCM_256 }), so this only bites the
next driver that advertises a GMAC version.

[Severity: Low]
This isn't a bug, but does psp_ver_diff assert anything that psp_spi_diff
does not?  The two associations passed here differ in version and in SPI,
since each rx_assoc allocates a fresh device SPI
(psp_nl_rx_assoc_doit() -> psd->ops->rx_spi_alloc()).

On the gro.c side both cases share the same sender helper, which only
flips psp_idx:

send_psp_assoc_switch()
	create_packet(buf, PAYLOAD_LEN, 0, PAYLOAD_LEN, 0);
	psp_idx = 1;
	write_packet(fd, buf, pkt_size, daddr);
	psp_idx = 0;

and the receive expectations are byte-for-byte the same as psp_spi_diff
(correct_payload[0] = correct_payload[1] = PAYLOAD_LEN, then
check_recv_pkts(rxfd, correct_payload, 2)); only the printf text differs.
A version-only difference does not look constructible from user space, so
this may be the closest achievable approximation - it is just worth noting
that the case would pass even if the GRO path ignored the version field.

[ ... ]

> +@ksft_variants(_ip_variants())
> +def test_psp_after_reconfig(cfg, protocol):
> +    """Verifies that decap still works after PSP off + on."""
> +    _setup(cfg, 0)
> +
> +    cap = cfg.psp_info['psp-versions-cap']
> +    cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': []})
> +    cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': cap})

[Severity: Medium]
Should the disable here be paired with a defer() for the restore?  As
written, the only thing that re-enables PSP is the very next dev_set()
call, with nothing covering an NlError from it or a kill between the two
calls.

init_psp_dev() only registers a rollback when the cached psp_info says the
enabled set differs from the caps:

tools/testing/selftests/drivers/net/psp_lib.py:init_psp_dev()
	if cap != ena:
		cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': cap})
		defer(cfg.pspnl.dev_set, {'id': cfg.psp_dev_id,
					  'psp-versions-ena': ena})

so on a device discovered with PSP already fully enabled (cap == ena)
there is no defer at all.  If the re-enable does not happen, the NIC is
left with PSP offload off while cfg.psp_info still caches the old enabled
set, and later init_psp_dev() calls compare against that stale snapshot
and conclude nothing needs enabling - subsequent PSP tests then fail on
rx-assoc/decap in a way that looks like a driver problem.

Would registering the re-enable via defer() right after the disable, and
re-reading the device state rather than trusting the cached psp_info,
address that?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
