From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH for-next v2 06/10] IB/cache: Add ib_find_gid_by_filter
 cache API
Date: Sun, 18 Oct 2015 22:27:44 +0530
Message-ID: <CANjDDBh7J7VK6YMwZvtdSqk=B1WsLYj5SSY8Nf6GJMStdA2OTg@mail.gmail.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com> <1444923534-10882-7-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-7-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks Good
Reviewed-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

On Thu, Oct 15, 2015 at 9:08 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> GID cache API users might want to search for GIDs with specific
> attributes rather than just specifying GID, net device and port.
> This is used in a later patch, where we find the sgid index by
> L2 Ethernet attributes.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c | 93 +++++++++++++++++++++++++++++++++++++++++
>  include/rdma/ib_cache.h         |  8 ++++
>  2 files changed, 101 insertions(+)
>
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
> index 639a726..89bebea 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -440,6 +440,81 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev,
>  }
>  EXPORT_SYMBOL(ib_find_cached_gid_by_port);
>
> +/**
> + * ib_find_gid_by_filter - Returns the GID table index where a specified
> + * GID value occurs
> + * @device: The device to query.
> + * @gid: The GID value to search for.
> + * @port_num: The port number of the device where the GID value could be
> + *   searched.
> + * @filter: The filter function is executed on any matching GID in the table.
> + *   If the filter function returns true, the corresponding index is returned,
> + *   otherwise, we continue searching the GID table. It's guaranteed that
> + *   while filter is executed, ndev field is valid and the structure won't
> + *   change. filter is executed in an atomic context. filter must not be NULL.
> + * @index: The index into the cached GID table where the GID was found.  This
> + *   parameter may be NULL.
> + *
> + * ib_cache_gid_find_by_filter() searches for the specified GID value
> + * of which the filter function returns true in the port's GID table.
> + * This function is only supported on RoCE ports.
> + *
> + */
> +static int ib_cache_gid_find_by_filter(struct ib_device *ib_dev,
> +                                      const union ib_gid *gid,
> +                                      u8 port,
> +                                      bool (*filter)(const union ib_gid *,
> +                                                     const struct ib_gid_attr *,
> +                                                     void *),
> +                                      void *context,
> +                                      u16 *index)
> +{
> +       struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
> +       struct ib_gid_table *table;
> +       unsigned int i;
> +       bool found = false;
> +
> +       if (!ports_table)
> +               return -EOPNOTSUPP;
> +
> +       if (port < rdma_start_port(ib_dev) ||
> +           port > rdma_end_port(ib_dev) ||
> +           !rdma_protocol_roce(ib_dev, port))
> +               return -EPROTONOSUPPORT;
> +
> +       table = ports_table[port - rdma_start_port(ib_dev)];
> +
> +       for (i = 0; i < table->sz; i++) {
> +               struct ib_gid_attr attr;
> +               unsigned long flags;
> +
> +               read_lock_irqsave(&table->data_vec[i].lock, flags);
> +               if (table->data_vec[i].props & GID_TABLE_ENTRY_INVALID)
> +                       goto next;
> +
> +               if (memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
> +                       goto next;
> +
> +               memcpy(&attr, &table->data_vec[i].attr, sizeof(attr));
> +
> +               if (filter(gid, &attr, context))
> +                       found = true;
> +
> +next:
> +               read_unlock_irqrestore(&table->data_vec[i].lock, flags);
> +
> +               if (found)
> +                       break;
> +       }
> +
> +       if (!found)
> +               return -ENOENT;
> +
> +       if (index)
> +               *index = i;
> +       return 0;
> +}
> +
>  static struct ib_gid_table *alloc_gid_table(int sz)
>  {
>         unsigned int i;
> @@ -670,6 +745,24 @@ int ib_find_cached_gid(struct ib_device *device,
>  }
>  EXPORT_SYMBOL(ib_find_cached_gid);
>
> +int ib_find_gid_by_filter(struct ib_device *device,
> +                         const union ib_gid *gid,
> +                         u8 port_num,
> +                         bool (*filter)(const union ib_gid *gid,
> +                                        const struct ib_gid_attr *,
> +                                        void *),
> +                         void *context, u16 *index)
> +{
> +       /* Only RoCE GID table supports filter function */
> +       if (!rdma_cap_roce_gid_table(device, port_num) && filter)
> +               return -EPROTONOSUPPORT;
> +
> +       return ib_cache_gid_find_by_filter(device, gid,
> +                                          port_num, filter,
> +                                          context, index);
> +}
> +EXPORT_SYMBOL(ib_find_gid_by_filter);
> +
>  int ib_get_cached_pkey(struct ib_device *device,
>                        u8                port_num,
>                        int               index,
> diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
> index 679d7ca..269a27cf 100644
> --- a/include/rdma/ib_cache.h
> +++ b/include/rdma/ib_cache.h
> @@ -93,6 +93,14 @@ int ib_find_cached_gid_by_port(struct ib_device *device,
>                                u8               port_num,
>                                struct net_device *ndev,
>                                u16              *index);
> +
> +int ib_find_gid_by_filter(struct ib_device *device,
> +                         const union ib_gid *gid,
> +                         u8 port_num,
> +                         bool (*filter)(const union ib_gid *gid,
> +                                        const struct ib_gid_attr *,
> +                                        void *),
> +                         void *context, u16 *index);
>  /**
>   * ib_get_cached_pkey - Returns a cached PKey table entry
>   * @device: The device to query.
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
