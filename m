From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next V2 11/22] IB/mlx4: Add CM paravirtualization
Date: Mon, 24 Sep 2012 12:33:51 -0700
Message-ID: <CAL1RGDUVmWNEth2mxmYuCsuLoZ_xyH6TDgpn1tFEgZ8CRojjjw@mail.gmail.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-12-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-12-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 3, 2012 at 1:40 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> +static struct id_map_entry *
> +id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
> +{
> +       int ret, id;
> +       static int next_id;
> +       struct id_map_entry *ent;
> +       struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
> +
> +       ent = kmalloc(sizeof(struct id_map_entry), GFP_KERNEL);
> +       if (!ent) {
> +               mlx4_ib_warn(ibdev, "Couldn't allocate id cache entry - out of memory\n");
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       ent->sl_cm_id = sl_cm_id;
> +       ent->slave_id = slave_id;
> +       ent->scheduled_delete = 0;
> +       ent->dev = to_mdev(ibdev);
> +       INIT_DELAYED_WORK(&ent->timeout, id_map_ent_timeout);
> +
> +       do {
> +               spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
> +               ret = idr_get_new_above(&sriov->pv_id_table, ent,
> +                                       next_id, &id);
> +               if (!ret) {
> +                       next_id = ((unsigned) id + 1) & MAX_ID_MASK;
> +                       ent->pv_cm_id = (u32)id;
> +                       sl_id_map_add(ibdev, ent);
> +               }
> +
> +               spin_unlock(&sriov->id_map_lock);
> +       } while (ret == -EAGAIN && idr_pre_get(&sriov->pv_id_table, GFP_KERNEL));
> +       /*the function idr_get_new_above can return -ENOSPC, so don't insert in that case.*/
> +       if (!ret) {
> +               spin_lock(&sriov->id_map_lock);
> +               list_add_tail(&ent->list, &sriov->cm_list);
> +               spin_unlock(&sriov->id_map_lock);
> +               return ent;
> +       }
> +       /*error flow*/
> +       kfree(ent);
> +       mlx4_ib_warn(ibdev, "No more space in the idr (err:0x%x)\n", ret);
> +       return ERR_PTR(-ENOMEM);
> +}

This looks strange.  We have one spin lock and IDR per device, but next_id
is just a static variable in the function.  So it seems we'll get unexpected
results if we have multiple physical HCAs running this code in parallel
(since they can both do read-modify-write of next_id and step on each other).

Should next_id be moved into the per-device structure?  Is there any need
for idr_get_new_above() at all, or could this be replaced by idr_get_new()?
(I guess we want to avoid CM ID reuse for as long as possible)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
