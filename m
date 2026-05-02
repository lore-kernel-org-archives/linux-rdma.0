Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181F62264AA;
	Sat,  2 May 2026 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777683252; cv=none; b=TNaxSRXlQ3HnKtIn4hIVqKHLELhmCg4xQ1qBk08WKo8S/bCKMOwLHXp26yuqlkg0FFNIIohK36i9Fw754r56j+3OqznLg3nc+S5gn8kw6UX8uZZBRPaOmbgCfNqpnhiHblFuEMHGsdioRp9fWCevcORasvtbTdsGLO6+7i3bumI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777683252; c=relaxed/simple;
	bh=d+U4X3IdiJSuGJALmhGHNsbRRrVXdXhpKDCAipKDJ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU8sJJJ4jpl3qWLacO1ZVYc4OutrihwyffzxAlO/lEOtozm62+pmzNW7TPYZO1OTLjgoJKNRSNm45YYoV9cTgQqSPLcdilUVQlJ29Q78NxIq6IElrIxMVrXGA1tfB9eYV1m1nCSsfcf6YAEwiyXpGDw0U3U27zx0moFoCMY9HHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWqSsWFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWqSsWFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7F3C2BCB4;
	Sat,  2 May 2026 00:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777683251;
	bh=d+U4X3IdiJSuGJALmhGHNsbRRrVXdXhpKDCAipKDJ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWqSsWFfijHXbKAm9tanA0Jzbl7L8ljmKNORBzcYvIbgUPLWlJI0gxWM3/636KeT5
	 SQSpUCO77HMFTuttIsc0L/bXlZBovbk37LAqBHkmIGXXzREg/CddlVxzlk5BFGAYmF
	 x9IjzBy6kzQccDRRs8npZrmQOpayvlfkwiJfeXOx+vXDolVFmiuerKY7ycwVNhloMi
	 BzcJxEQENUPkJ5pobOTsPLKiQaJcI0tIPUvwKsql3/XFi+G7y4bdwV2LKjMBUsZoOA
	 Aers+PtoKkT8RIzNF216Q6aOw/RReGCZ4YkxiHg41G7Icto2NZLGoJMH/ZbdPPFa5A
	 vwPkHiCkP1ZBA==
From: Jakub Kicinski <kuba@kernel.org>
To: ernis@linux.microsoft.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	dipayanroy@linux.microsoft.com,
	yury.norov@gmail.com,
	shirazsaleem@microsoft.com,
	kees@kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v7] net: mana: Expose hardware diagnostic info via debugfs
Date: Fri,  1 May 2026 17:54:09 -0700
Message-ID: <20260502005409.3645108-1-kuba@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430075342.1871554-1-ernis@linux.microsoft.com>
References: <20260430075342.1871554-1-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: Expose hardware diagnostic info via debugfs

This patch adds debugfs entries under /sys/kernel/debug/mana/<BDF>/ to
expose device-level and per-vPort hardware configuration and diagnostic
information. Debugfs creation and removal are moved into mana_gd_setup()
and a renamed mana_gd_cleanup_device() so probe, remove, suspend, resume
and shutdown share a single path.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index a654b3699c4c..077d3a1ff6bf 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3659,6 +3684,11 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
>  
>  	ac->bm_hostmode = bm_hostmode;
>  
> +	debugfs_create_u16("num_vports", 0400, gc->mana_pci_debugfs,
> +			   &ac->num_ports);
> +	debugfs_create_u8("bm_hostmode", 0400, gc->mana_pci_debugfs,
> +			  &ac->bm_hostmode);
> +
>  	if (!resuming) {
>  		ac->num_ports = num_ports;
>  	} else {

Is the num_vports debugfs file pointed at ac->num_ports before that
field has been assigned from the queried num_ports value?

On a fresh probe (!resuming), the sequence in mana_probe() is:

    err = mana_query_device_cfg(ac, ..., &num_ports, &bm_hostmode);
    ...
    ac->bm_hostmode = bm_hostmode;

    debugfs_create_u16("num_vports", 0400, gc->mana_pci_debugfs,
                       &ac->num_ports);
    ...

    if (!resuming) {
            ac->num_ports = num_ports;
    } else {
            ...
    }
    ...
    if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
            ac->num_ports = MAX_PORTS_IN_MANA_DEV;

During the window between debugfs_create_u16() and the assignment (and
subsequent clamp to MAX_PORTS_IN_MANA_DEV), would a reader of the
num_vports debugfs file observe 0 rather than the hardware-reported
value?

Would it be clearer to create this file after ac->num_ports has been
assigned and clamped, so the exposed value matches what the commit
message describes as "Device configuration"?
-- 
pw-bot: cr
