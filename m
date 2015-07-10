From: andrew banman <abanman-sJ/iWh9BUns@public.gmane.org>
Subject: [BUG] mellanox IB driver fails to load on large config
Date: Fri, 10 Jul 2015 14:15:36 -0500
Message-ID: <20150710191506.GA52396@asylum.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm seeing a large number of allocation errors originating from the Mellanox IB
driver when booting the 4.2-rc1 kernel on a 4096cpu 32TB memory system:

8<---
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 64; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 65; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 66; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 67; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 68; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 69; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 70; reverting to legacy
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 71; reverting to legacy
......
<mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 123; reverting to legacy
--->8

Where the failing function is in drivers/infiniband/hw/mlx4/main.c:

8<---
2042 static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
...
2075                         /* Set IRQ for specific name (per ring) */
2076                         if (mlx4_assign_eq(dev, name, NULL,
2077                                            &ibdev->eq_table[eq])) {
2078                                 /* Use legacy (same as mlx4_en driver) */
2079                                 pr_warn("Can't allocate EQ %d; reverting to legacy\n", eq);
2080                                 ibdev->eq_table[eq] =
2081                                         (eq % dev->caps.num_comp_vectors);
2082                         }
--->8

The problem doesn't appear to be fatal. At this point I am unsure if this is
actually expected behavior, so I'm looking for some insight into the issue.

At first we believed the problem to be with request_irq, but after writing in
some debug code that mlx4_assign_eq returned -28, indicating that vec was
never assigned:

8<---
@@ -1401,6 +1402,7 @@ int mlx4_assign_eq(struct mlx4_dev *dev, char *name, struct cpu_rmap *rmap,
        if (vec) {
                *vector = vec;
        } else {
+               pr_crit("!!! debug: mlx4_assign_eq - last err %d\n", err);
                *vector = 0;
                err = (i == dev->caps.comp_pool) ? -ENOSPC : err;
        }
--->8

8<---
 [ 1565.416273] !!! debug: mlx4_assign_eq - last err 0
 [ 1565.416275] <mlx4_ib> mlx4_ib_alloc_eqs: !!! debug: mlx4_assign_eq returned -28
 [ 1565.416277] <mlx4_ib> mlx4_ib_alloc_eqs: Can't allocate EQ 64; reverting to legacy
--->8


Any help would be greatly appreciated!

Andrew Banman

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
