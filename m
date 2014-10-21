From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] IB/mlx5: Implement Fast Indirect Memory
 Registration Feature
Date: Tue, 21 Oct 2014 16:12:20 +0300
Message-ID: <20141021123531.GA23683@mtldesk30>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com>
 <1412693281-6161-3-git-send-email-sagig@mellanox.com>
 <543AD8DE.5060404@mellanox.com>
 <543B8E09.6090606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <543B8E09.6090606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 13, 2014 at 11:32:09AM +0300, Sagi Grimberg wrote:
> >
> >>+static void set_indir_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
> >>+                  struct ib_send_wr *wr)
> >>+{
> >>+    u64 mask;
> >>+    u32 list_len = wr->wr.indir_reg.indir_list_len;
> >>+
> >>+    memset(umr, 0, sizeof(*umr));
> >>+
> >>+    umr->klm_octowords = get_klm_octo(list_len * 2);
> >>+    mask = MLX5_MKEY_MASK_LEN        |
> >>+        MLX5_MKEY_MASK_PAGE_SIZE    |
> >>+        MLX5_MKEY_MASK_START_ADDR    |
> >>+        MLX5_MKEY_MASK_EN_RINVAL    |
> >>+        MLX5_MKEY_MASK_KEY        |
> >>+        MLX5_MKEY_MASK_LR        |
> >>+        MLX5_MKEY_MASK_LW        |
> >>+        MLX5_MKEY_MASK_RR        |
> >>+        MLX5_MKEY_MASK_RW        |
> >>+        MLX5_MKEY_MASK_A        |
> >>+        MLX5_MKEY_MASK_FREE;
> >>+
> >>+    umr->mkey_mask = cpu_to_be64(mask);
> >>+}
> >
> >here you basically replicate the majority of the code from
> >set_reg_umr_segment - share the common part...
> 
> I've thought about it, but I know Eli prefers not to centralize the
> umr control segment (and mkey context) setting routines at this point.
> I am not against doing it at all, but let's let Eli comment here.
> 

We have some versions of this mask building but they are not
identical. Note that we build the mask at compile time so it does not
affect code size and it will make future changes easier.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
