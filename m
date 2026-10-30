Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336039;
	b=a3LgTLbZb3GeIRjBEAeNMUqnCy26VF/DFvwmHlb+PC/lmDAe/8oQqbxpwhHwFBhZ/Okn
	 NSB/xSX1HZrkZbTvmB+xM5YKKFe1kCzh0KQoydcnyrGRHYJz4Adpc/3AAO5Ph/zR02O1r
	 fzbzkZB+WWWhdc1puFbdr+arfMxfGJPZABRTV9v7yobq+5uTumX4bYs91gyc5qVPfgdFn
	 k1Ac/ZcEYoYZq42EJ3LkIt3SjS3bMrN0L0EbQpe4uXUJqp3u5rV3Hguubp/dMVOmz6eB5
	 je9S0A7oEpWUlUMTCPQZm65drpn95PS0fh2KXqOuBlmv7Tu6DPaMVwxZPB/izechBng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336039;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VIUfn/NrF8EDgjqOAEyF2z5otVH2OlaeAPEo4Ck2bfc=;
	b=U4VOPdv18GbCJyZ63pNCckazxVgGMLSwLkm7CNxRxRVErgh6gCj1SO7wvgDOtbIc8pue
	 SYm9qgtWiEyTMCI6M3KHtbklftcM08BtZXM2R7YLSUcIrFLLtAdoj0OMfA4+Bqyj+3WDg
	 tDGL1QmlDOBSv/SrYSIfgMSAWYhYMvUchLEGATMvMKFAyr6HPvpYQUNwOdu7a5S5t1vOP
	 cxCueIFTOANQU9iu/ud6/sDnX6lL1rFr3WnJdcEPhPmPXQlRBw6CSN7su23OzfATjUWIl
	 epAnMunnb97TWcL7FhcD4NOR5S8Ev7x2JZEAO+9RggBYyehQcv6jvTVNU0cEy36j3vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duw1onrG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3282606A31F;
	Fri, 30 Oct 2026 04:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duw1onrG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523011F00A1C;
	Fri, 30 Oct 2026 04:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336039;
	bh=VIUfn/NrF8EDgjqOAEyF2z5otVH2OlaeAPEo4Ck2bfc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=duw1onrGDMp9RRzaoisMTr9vPasYm35dKzRBLGV07UDD2jQQ1QRtK9Zu1M/mvkzmh
	 9m1ZkYPa/Uv8dJD35+RoFnOgdP3k8g8dj+J7J7E0RPy8clUQpmuZen56XSD4WimER9
	 qaN+zbBunhiWe+9q1WhGMnfyRA3XmWa5xH2XD6+qqJHTy61+ykPUy4Y8GTckMam3RG
	 RTwmpKGUjb/AOnz6Yy3UopQzlRtvSnsKyKvR/OXp7QzKRxze8Q7oL7yTjbVJHQUKJu
	 3aYJy8eZt8kiROX8+th7HCMoM+JPZnxyg2ZdTkzgiLEMXASOSW43PuC0wG7aiCzKkA
	 xRUa3B1Lg+GyA==
Message-ID: <sashiko-outbox-190388@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 8/8] selftests: drv-net: add netkit devmem
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-8-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-8-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:58 +0000
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
- [High] If configure_nic(cfg) fails halfway, the script exits without exec=
uting cleanup_nic(cfg), permanently leaving the physical NIC in a disrupted=
 state.
- [High] The script performs highly disruptive physical NIC configuration c=
hanges unconditionally, bypassing the framework's DISRUPTIVE=3DFalse skip m=
echanism.
--

commit 605c5904b1c331eeb3043ea246464b1479d4bb3f
Author: Bobby Eshleman <bobbyeshleman@meta.com>

selftests: drv-net: add netkit devmem tests

This commit adds nk_devmem.py with four tests for TCP devmem through a netk=
it
device. The script configures the NIC once before running the test cases and
cleans it up in a finally block to avoid toggling settings around every tes=
t.

> diff --git a/tools/testing/selftests/drivers/net/hw/nk_devmem.py b/tools/=
testing/selftests/drivers/net/hw/nk_devmem.py
> new file mode 100755
> index 0000000000000..0e36a0fa96888
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/hw/nk_devmem.py

[ ... ]

> +def main() -> None:
> +    """Configure the NIC once, then run the netkit devmem test cases."""
> +    with NetDrvContEnv(__file__, rxqueues=3D2, primary_rx_redirect=3DTru=
e) as cfg:
> +        setup_test(cfg,
> +                   os.path.join(os.path.dirname(os.path.abspath(__file__=
)),
> +                                "ncdevmem"))
> +
> +        require_devmem(cfg)
> +        configure_nic(cfg)

Because configure_nic(cfg) is called here in main() outside of ksft_run(),
does this bypass the DISRUPTIVE=3DFalse skip mechanism?

Since the test functions themselves are marked with @ksft_disruptive, runni=
ng
with DISRUPTIVE=3DFalse will skip the tests, but it appears the disruptive =
NIC
configuration will still unconditionally execute.

> +        try:

If configure_nic(cfg) fails halfway through, will this permanently leave the
physical NIC in a disrupted state?

If an exception is raised before the try block is entered (for example, if
the driver doesn't support queue leases during configuration),
cleanup_nic(cfg) would be entirely bypassed.

Could configure_nic() be moved inside the try block to ensure cleanup
always runs?

> +            ksft_run([check_nk_rx, check_nk_tx, check_nk_tx_chunks,
> +                      check_nk_rx_hds], args=3D(cfg,))
> +        finally:
> +            cleanup_nic(cfg)
> +
> +    ksft_exit()

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D8
