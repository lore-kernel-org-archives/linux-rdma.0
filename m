From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/4] XRC patch set
Date: Sun, 28 Feb 2010 11:02:07 +0200
Message-ID: <201002281102.08286.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, diego-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,
Sorry for the long delay -- I was out for a week with a stomach infection,
and was too weak to work.

Here is the XRC kernel patch set.  This patch set includes:
1. Your replacement/fix for your git's xrc-branch HEAD commit:
    "IB/uverbs: Support for associating XRC domains to inodes"
2. the XRC low-level (mlx4) driver XRC base implementation
3. The XRC_RCV implementation for the IB core and low-level (mlx4) driver.

We have done some testing of XRC and XRC_RCV with your xrc kernel git,
and this patch set applied on top of it (minus your HEAD, which the first patch of
this set replaces -- it is the same patch that you sent to me for review).

For userspace, we used the OFED 1.5.1 libmlx4 and libibverbs, which have XRC implemented 
in a fashion compatible with the kernel implementation in these patches.

Please note that, per Diego Cupernicoff's request, I have added a destroy_xrc_rcv_qp verb
to the kernel for users who do not wish to use the reg/unreg_xrc_rcv_qp() pair. The userspace
libraries I will be submitting (hopefully this week) will include this verb.

Hopefully, this patch set is sufficient for you to continue with RoCEE.

Best Regards,
-Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
