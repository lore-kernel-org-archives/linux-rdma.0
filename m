Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712703;
	b=y/FNl5QfvCbjynuORsghG2u9q73ccKHrQfRmrS98kIpvzpwcchEtuvOCoM+wIUvDJXp3
	 uwb1WoOo7vZZBQf8Cx/V8yVa+XUual+Ddsrm2qLJtK6ZykkiHP4YJ1++20AbXAvWc/wtO
	 9ZTB6Bk9ZEO1YQFILRtadQm8X0JZhjvnNdUfikhqrHEcZDJTbjlDUaF+33xdoMtZtxtwZ
	 l35u6mKRA+xrWisyn9xh/tUfsf03xAwkjeobzYrnwjObUXv60KjiwFCTc2ANGWzKkNYOM
	 +FNUs+IwH8ansxFQx7iK2ac2DkK1UNcIK9P93Z0opXs+srWs4cfvGe33RszX+pi7V2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712703;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ERJ1IoTOJVoO0BUVAAL35jSmT72i5VI3cMJqWRwEe3o=;
	b=b4ETre91R/tWqCnBPROOnVn9W0l8nhg82KNpw0LRKXdV7/s5bXu0o7UOyHBFhPRKFn5l
	 F9ku5TireEU6q3q4mGH5KIW8HWOQdOpTcMZRCsinJ9/RgLPp1/MsC6e7+ITZMHMDQAVSI
	 Yk2V6f8SQQC7psX6PFXb1NtdYOujq9AKJ+nFcGbmWF6x/TtuhPdDRbImOpAi8AjueZO+b
	 ZlZME//P6v1JyltXI63SgCVNV9JXrXCTAVcNeQ4FdErIuqs6BD2WTPeOeRmFrkyF31SxB
	 4/+Nv407D4vb1IAkVRQE99K5jApPZ+SdQLJf7ixkNlhG2hqmPV/gzVAgvBkDzS0PxDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IouvtsYX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6C606A889;
	Sun, 15 Nov 2026 03:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IouvtsYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546AB1F000D3;
	Sun, 15 Nov 2026 03:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712702;
	bh=ERJ1IoTOJVoO0BUVAAL35jSmT72i5VI3cMJqWRwEe3o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IouvtsYXSVwqKZuDWjKGOnZoPCAscCsdr3Tk/EIuMn8ERkAIt0Nx1kwNd4hWFj4tD
	 zHb3wvmv59cmoAtYHRXqMT3PYrcCFs5vOeBxlg/lqiINmMDUi8bXSyVzuJtolpQWoe
	 E1Pr2VG5CDPnTFm6XwVOIPYGL4uYovLMiFqWEs06+L4StbeOcmsoRZf38o0x0WKAnL
	 Ju8r9quKA7T7jH/ZhCIsmObyU6ejNUZLuy0cox7SU2Ic2DyIkwAwoYDtiLcrYVpymK
	 0qX2Ac56pLkzcvmFCsQvO1Xvi3BlhwePJhLb72gaHW2EUZ9qis9t3Q4UFhJq1O4yEP
	 FVR438SOIb/Pg==
Subject: Re: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs from
 egress to ingress
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
 kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 martin.lau@linux.dev, pabeni@redhat.com, saeedm@nvidia.com, horms@kernel.org,
 tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 03:18:20 +0000
Message-ID: <179471270091.2199510.4320994626979041884@kernel.org>
In-Reply-To: <20261111005533.6436-8-toddfreed@meta.com>
References: <20261111005533.6436-8-toddfreed@meta.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new check in __bpf_redirect()
  (net/core/filter.c:2232-2233) decides that the skb is on egress, and…
- [Low] The new drop in __bpf_redirect() (net/core/filter.c:2234) uses
  kfree_skb(skb), which records SKB_DROP_REASON_NOT_SPECIFIED.
- [Low] bpf: non-standard multi-line comment style in __bpf_redirect()

--

bpf: don't redirect decrypted skbs from egress to ingress

With this patch, __bpf_redirect() drops skbs that have skb->decrypted set
when they are redirected with BPF_F_INGRESS from outside tc ingress. On
transmit the bit asks the device to encrypt. In a receive path the same
bit would make the packet look like the device decrypted it. This matches
the mirred change from the previous patch.

> diff --git a/net/core/filter.c b/net/core/filter.c
> index aca8160b26a1a..a178a9dd30070 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2226,6 +2226,15 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
>  static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>  			  u32 flags)
>  {
> +	/* On transmit, decrypted asks the device to encrypt the packet. Sent
> +	 * to ingress, the packet would read as decrypted by the device.
> +	 */
> +	if (unlikely((flags & BPF_F_INGRESS) && !skb_at_tc_ingress(skb) &&
> +		     skb_is_decrypted(skb))) {

[Severity: Low]
This isn't a bug, but could the new comment in __bpf_redirect() use
the multi-line comment style that BPF code prefers?

net/core/filter.c is covered by the BPF comment style. There the
opening /* goes on its own line and the text starts on the next line,
even where the surrounding code still uses the older networking style.
The added comment puts "On transmit, decrypted asks the device ..." on
the same line as the opening delimiter. Moving that text down one line
would match the preferred form:

	/*
	 * On transmit, decrypted asks the device to encrypt the packet.
	 * Sent to ingress, the packet would read as decrypted by the
	 * device.
	 */

[Severity: Medium]
Is skb_at_tc_ingress() a reliable direction signal for every caller of
__bpf_redirect()?

tcf_mirred_act() only checks this inside a tc hook, where tc_at_ingress
is always current. But __bpf_redirect() is also reached from LWT xmit
programs. lwt_xmit_func_proto() gives those programs bpf_redirect() and
bpf_clone_redirect(), and BPF_F_INGRESS is an accepted flag:

ip_finish_output2()
  lwtunnel_xmit()
    run_lwt_bpf()
      skb_do_redirect()
        __bpf_redirect(skb, dev, flags)

This runs before __dev_queue_xmit(), the only place on transmit that
clears the bit:

net/core/dev.c:__dev_queue_xmit() {
    ...
	tcx_set_ingress(skb, false);
    ...
}

The only place that sets the bit is sch_handle_ingress(), and only when
the input device has a tcx/clsact ingress entry. skb_scrub_packet() does
not touch it. For a forwarded skb, tc_at_ingress at the LWT xmit hook is
whatever the input device left behind.

Here is one way to get a forwarded skb whose decrypted bit means "please
encrypt". psp_validate_xmit() accepts any device whose psp_dev matches
the association, including dev-assoc veth/netkit devices. A PSP socket in
a container can then cross the veth with decrypted=1, and the host-side
peer forwards it.

Say the host-side veth has a tc ingress hook. Then tc_at_ingress=1
reaches the LWT xmit hook, and bpf_redirect(X, BPF_F_INGRESS) passes this
check. The packet enters X's receive path through __bpf_rx_skb() with
decrypted=1.

Without a tc ingress hook on the host-side veth, the same packet and the
same program get -EINVAL, and the packet is dropped.

Doesn't that make the result depend on unrelated tc configuration on the
input device, rather than on the direction of the hook calling the
helper? Neither the comment ("On transmit, ...") nor the commit message
("drop decrypted skbs which bpf redirects from egress to ingress")
describes this case.

The socket-less PSP case through act_psp encap on tc egress looks fine,
since tc_at_ingress is 0 there. Could the caller pass the direction
instead (LWT xmit is always egress), or could the LWT path be handled
explicitly?

> +		kfree_skb(skb);
> +		return -EINVAL;

[Severity: Low]
This isn't a bug, but could this use kfree_skb_reason() with a specific
drop reason?

kfree_skb() records SKB_DROP_REASON_NOT_SPECIFIED. For bpf_redirect(),
the program has already returned TC_ACT_REDIRECT, and the callers of
skb_do_redirect() ignore its return value:

net/core/dev.c:sch_handle_egress() {
    ...
		skb_do_redirect(skb);
		*ret = NET_XMIT_SUCCESS;
    ...
}

run_lwt_bpf() and netkit ignore it too. Neither the program nor the
sender learns about this new policy drop. In drop_monitor or the
kfree_skb tracepoint it looks like any other generic drop.

The matching mirred drop in the previous patch returns TC_ACT_SHOT and is
recorded as SKB_DROP_REASON_TC_EGRESS. The series also already defines
SKB_DROP_REASON_PSP_OUTPUT for related PSP policy drops.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
