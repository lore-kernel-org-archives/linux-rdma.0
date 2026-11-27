Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795074;
	b=hsgfUXHonR1Xbi5kegr+9JQiwS9ZDI+T0O9jlCpyr7rRu9C1ShWwR4kyQXOGLRQUwASO
	 NBwAflAn3dq+/CkMmBvVh/JOj6hkz/5yX28bxsYJBbpCIwuIDv8TrG3v9LnLzSWj8U16M
	 uppfJYlNPHKV40aXE213f5o9scICrv3FH9OxDvsV7xiBFz8r4q+g2P2TDtAXLbzKrPjps
	 RGIL5sFG5bgWLrKFAzeSWGkqchzslwGBX3vG0lAqaqQYy56EievGChd/Z2lZR0S/juT/E
	 39Jnvi83TmCIiHlWqhjGYiCSKOW9hwPmVqMXN55fetCrOx0kYaw5S2ezKdpLFV1UTWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795074;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=1Uf6rEZNwkBmln35150GQlXwSl97Nl4pLzD4EjTrQQw=;
	b=R7wqtMErCFbhtDhXLgUk0IAf0dZxMkp0gRYA7CUE3WO67VDVRL+gh5ZkkqRkYR0WR+0h
	 Y9iLt0cPcKUfAxDm/FoA2Rydfds0/UKtYpt39aeCFbb1z8E8s3CJLMVL6pcPHFGuYG4nM
	 aG5Yu0GRxVYSC7h8eVk40HVP9tphH60278TFMkb0Uhw27P+AnxBfN+bU0wJm1o+PQ1Nc+
	 8Jx1qkTST5mcBlwYRRUdhnSamYvw5S1U2E7oXL55bOJFMh6qWlclKsdx7Z0Kvt3t9YUKb
	 uym6o6lo9yGZvac0SFA+uKFbSJGeKr+7zjWsZMi9HJpcpLg+ZGkxWlXC1qQgfHHzLiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNVVYJbJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB76606A33D;
	Fri, 27 Nov 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNVVYJbJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8761F000C1;
	Fri, 27 Nov 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795074;
	bh=1Uf6rEZNwkBmln35150GQlXwSl97Nl4pLzD4EjTrQQw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DNVVYJbJd8Wr/iau/0IOpFDh3/sejQiBg6bjbhCzYfdnCZvyy1ERG9rnR1swZpE/2
	 06Sn00UjAOMC/ZyBtvBEJ9VFEOkxeOcjnoi3h+HAbQn8IFOQGIoExxl31ICHjpF3Rm
	 X8EggNOb+FGL5mi3TYLaSEKQOt/M5iO9L2k7uzmkKohxWXt3cjLhQNHyUrlN+3ypZG
	 GRp4F+Fs/WxJFR9USH2GxuGrspaM+u9D2dM9PMAgoqforoZ48uNglZGuHnJKbPIRzh
	 u2JtS+SkKPxT8qw/Qe7VtV9YCbrMhQ2F9arFVk2HqJS5tAZn08xlBEbS6fBJoLyW56
	 XQxYljvXcwSuA==
Subject:
 Re: [PATCH v2 04/11] net/xsc: query HCA capabilities and reset function
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:53 +0000
Message-ID: <179579507336.3135.5729346813922191216@kernel.org>
In-Reply-To: <20261126145721.70868-5-tianx@yunsilicon.com>
References: <20261126145721.70868-5-tianx@yunsilicon.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In xsc_pci_init()
  (drivers/net/ethernet/yunsilicon/xsc/pci/main.c), the new…
- [Medium] net/xsc: missing in.hdr.ver initialization in
  xsc_cmd_query_hca_cap()
- [Low] xsc_cmd_query_hca_cap() in
  drivers/net/ethernet/yunsilicon/xsc/pci/main.c computes…
- [Low] The subject line is split across two lines.
- [Low] xsc_cmd_query_hca_cap()
  (drivers/net/ethernet/yunsilicon/xsc/pci/main.c) takes an unneeded…

--

net/xsc: query HCA capabilities and reset function

During probe, this commit queries the firmware HCA capabilities (CQ size,
segment counts, MSI-X range, port and PF identifiers). It stores them in
struct xsc_caps and struct xsc_core_device, then sends the firmware
FUNCTION_RESET command to reset the function's resources.

> net/xsc: query HCA capabilities and reset function
>
> resources

[Severity: Low]
This isn't a bug, but the subject line looks like it was wrapped onto two
lines. Git will use "net/xsc: query HCA capabilities and reset function"
as the subject, and "resources" will become the first paragraph of the
body.

The cut-off shortlog also reads like a PCI function-level reset. The patch
actually sends the firmware XSC_CMD_OP_FUNCTION_RESET command.

Could the subject be joined back into a single line?

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
> index 9b08580f52f38..42c5a1baed23b 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
> @@ -29,6 +29,63 @@ static int xsc_set_dma_caps(struct pci_dev *pdev)
>  	return err;
>  }
>  
> +static int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
> +				 struct xsc_caps *caps)
> +{

[ ... ]

> +	xdev->glb_func_id = be32_to_cpu(out->hca_cap.glb_func_id);
> +
> +	caps->max_cqes = 1 << out->hca_cap.log_max_cq_sz;

[Severity: Low]
log_max_cq_sz is a u8 that comes straight from firmware, and nothing
checks its range. The 1 here is a signed int, so a value of 31 shifts into
the sign bit, and a value of 32 or more is undefined behaviour.

Later in the series, xsc_eth_build_queue_param() does:

    min_t(int, XSC_RQCQ_ELE_NUM, xdev->caps.max_cqes)

A max_cqes of 0x80000000 would become INT_MIN there and give a negative
queue size. log_max_qp_depth is also stored unchecked, and the same
function uses it in BIT(xdev->caps.log_max_qp_depth) for rq_size with no
upper clamp.

Would it make sense to use 1U << n (or BIT()) here, and reject or clamp
out-of-range exponents?

> +	caps->send_ds_num = out->hca_cap.send_seg_num;
> +	caps->recv_ds_num = out->hca_cap.recv_seg_num;
> +
> +	caps->nic_caps = (caps->nic_caps & ~XSC_CAP_MAC_PORT_MASK) |
> +			 FIELD_PREP(XSC_CAP_MAC_PORT_MASK,
> +				    out->hca_cap.mac_port & 0xff);
> +	xdev->mac_port = FIELD_GET(XSC_CAP_MAC_PORT_MASK, caps->nic_caps);

[Severity: Low]
This isn't a bug, but is the round trip through caps->nic_caps needed?
Packing mac_port with FIELD_PREP() and then unpacking it with FIELD_GET()
gives the same result as:

    xdev->mac_port = out->hca_cap.mac_port;

As far as I can tell, nothing else in the series reads caps->nic_caps. That
leaves the nic_caps field and XSC_CAP_MAC_PORT_MASK otherwise unused. The
other capability fields are read by later patches, so this applies only to
nic_caps.

The & 0xff masks on the u8 fields mac_port and log_max_qp_depth also have
no effect.

[ ... ]

> @@ -90,6 +147,19 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
>  		goto err_cmd_cleanup;
>  	}
>  
> +	err = xsc_cmd_query_hca_cap(xdev, &xdev->caps);
> +	if (err) {
> +		pci_err(pdev, "failed to query hca caps: err=%d\n", err);
> +		goto err_cmd_cleanup;
> +	}
> +
> +	err = xsc_reset_function_resource(xdev);
> +	if (err) {
> +		pci_err(pdev, "failed to reset function resource: err=%d\n",
> +			err);
> +		goto err_cmd_cleanup;
> +	}

[Severity: High]
What happens to the device's DMA if one of these commands times out and
probe takes the err_cmd_cleanup path?

On a timeout, xsc_cmd_invoke() leaves the entry registered, and
_xsc_cmd_exec() leaves both mailboxes owned by the device:

drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c:xsc_cmd_invoke() {
    ...
	if (!wait_for_completion_timeout(&ent->done, timeout)) {
		cmd->cmd_status = XSC_CMD_STATUS_TIMEDOUT;
		...
		/* the entry stays registered for the completion handler */
		return -ETIMEDOUT;
	}
    ...
}

drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c:_xsc_cmd_exec() {
    ...
	err = xsc_cmd_invoke(xdev, inb, outb, &status);
	if (err == -ETIMEDOUT)
		/* the command owns both mailboxes now */
		return err;
    ...
}

The device still holds out->next->dma through lay->out_ptr. It also still
has cq_buf and cmd_buf programmed as DMA targets.

xsc_cmd_cleanup() then stops only the polling kthread. It frees all of
that memory while bus mastering is still enabled:

drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c:xsc_cmd_cleanup() {
    ...
		xsc_free_msg(xdev, cmd->ent_arr[i]->in);
		xsc_free_msg(xdev, cmd->ent_arr[i]->out);
    ...
	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf, cmd->cq_dma);
	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf, cmd->dma);
	dma_pool_destroy(cmd->pool);
    ...
}

pci_clear_master() only runs later, at err_clr_master, after
pci_iounmap(). If the firmware finishes the timed-out command late, can it
DMA the response and completion entry into memory that has already gone
back to the page allocator or the dma_pool?

The comment in xsc_cmd_cleanup() describes a response that "may never
come", which suggests the driver expects a late response is possible.

This ordering comes from the earlier "net/xsc: add the command queue"
patch in this series. The xsc_cmd_version_check() error path can already
reach it, and xsc_pci_fini() also calls xsc_cmd_cleanup() before
pci_clear_master(). This patch adds two more probe paths into it.
FUNCTION_RESET is a firmware resource teardown, so it seems likely to run
long and time out.

Should the device's cmdq be quiesced, or bus mastering cleared, before
the mailboxes and rings are freed?

[ ... ]

> @@ -29,6 +29,63 @@ static int xsc_set_dma_caps(struct pci_dev *pdev)
>  	return err;
>  }
>  
> +static int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
> +				 struct xsc_caps *caps)
> +{
> +	struct xsc_cmd_query_hca_cap_mbox_out *out;
> +	struct xsc_cmd_query_hca_cap_mbox_in in;
> +	int err;
> +
> +	out = kzalloc_obj(*out, GFP_KERNEL);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	memset(&in, 0, sizeof(in));
> +	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HCA_CAP);
> +	in.cpu_num = cpu_to_be16(num_online_cpus());
> +
> +	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
> +	if (err)
> +		goto err_free;
> +
> +	xdev->glb_func_id = be32_to_cpu(out->hca_cap.glb_func_id);
> +
> +	caps->max_cqes = 1 << out->hca_cap.log_max_cq_sz;
> +	caps->send_ds_num = out->hca_cap.send_seg_num;
> +	caps->recv_ds_num = out->hca_cap.recv_seg_num;
> +
> +	caps->nic_caps = (caps->nic_caps & ~XSC_CAP_MAC_PORT_MASK) |
> +			 FIELD_PREP(XSC_CAP_MAC_PORT_MASK,
> +				    out->hca_cap.mac_port & 0xff);
> +	xdev->mac_port = FIELD_GET(XSC_CAP_MAC_PORT_MASK, caps->nic_caps);
> +
> +	caps->msix_base = be16_to_cpu(out->hca_cap.msix_base);
> +	caps->msix_num = be16_to_cpu(out->hca_cap.msix_num);
> +
> +	caps->log_max_qp_depth = out->hca_cap.log_max_qp_depth & 0xff;
> +
> +	xdev->pcie_no = out->hca_cap.pcie_no;
> +	xdev->pf_id = out->hca_cap.pf_id;
> +
> +	kfree(out);
> +	return 0;
> +err_free:
> +	kfree(out);
> +	return err;
> +}
> +
> +static int xsc_reset_function_resource(struct xsc_core_device *xdev)
> +{
> +	struct xsc_function_reset_mbox_out out;
> +	struct xsc_function_reset_mbox_in in;
> +
> +	memset(&in, 0, sizeof(in));
> +	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_FUNCTION_RESET);
> +	in.glb_func_id = cpu_to_be16(xdev->glb_func_id);
> +
> +	return xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +}
> +
>  static int xsc_pci_init(struct xsc_core_device *xdev,
>  			const struct pci_device_id *id)
>  {

[Severity: Medium]
The input mailbox is zeroed by memset(), and only in.hdr.opcode and
in.cpu_num are filled in, so in.hdr.ver goes to the firmware as 0.
xsc_cmd.h defines XSC_CMD_QUERY_HCA_CAP_V1 as the hca_cap mbox
version, but nothing in the driver uses it.

This matters because the function then reads out->hca_cap.pcie_no and
out->hca_cap.pf_id without any check. Those fields are part of the
versioned extension of struct xsc_hca_cap, and later in the series
xsc_core_eth_modify_raw_qp() uses them to set up raw QP port routing.

The firmware might validate hdr.ver, or fill in the extended fields
only for a V1 request. In that case a version 0 request could fail
the query and abort probe. It could also leave pcie_no and pf_id at
zero from the kzalloc. In that second case probe succeeds and the raw
QPs are set up with the wrong port routing, and nothing is logged.

Should this set in.hdr.ver = cpu_to_be16(XSC_CMD_QUERY_HCA_CAP_V1)?
If the firmware is meant to return the full structure for version 0,
could the commit message say so, and the unused define be dropped?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
