From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH for-next V2 6/9] IB/core: Pass hardware specific data in query_device
Date: Mon, 1 Jun 2015 14:54:09 +0530
Message-ID: <CANjDDBg2pSonSws0j6cGnYOMSrAr3W+CdPYDyVXzLOjjzA4kSA@mail.gmail.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	<1433074457-26437-7-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433074457-26437-7-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ocrdma part Looks good.

Reviewed-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

On Sun, May 31, 2015 at 5:44 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Vendors should be able to pass vendor specific data to/from
> user-space via query_device uverb. In order to do this,
> we need to pass the vendors' specific udata.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c             |    4 +++-
>  drivers/infiniband/core/uverbs_cmd.c         |    2 +-
>  drivers/infiniband/hw/amso1100/c2_provider.c |    7 +++++--
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    8 ++++++--
>  drivers/infiniband/hw/cxgb4/provider.c       |    8 ++++++--
>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6 +++++-
>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3 ++-
>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7 +++++--
>  drivers/infiniband/hw/mlx4/main.c            |    6 +++++-
>  drivers/infiniband/hw/mlx5/main.c            |    9 +++++++--
>  drivers/infiniband/hw/mthca/mthca_provider.c |    7 +++++--
>  drivers/infiniband/hw/nes/nes_verbs.c        |    6 +++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6 +++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3 ++-
>  drivers/infiniband/hw/qib/qib_verbs.c        |    6 ++++--
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6 +++++-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    3 ++-
>  include/rdma/ib_verbs.h                      |    3 ++-
>  18 files changed, 75 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 568cb41..694bd66 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -539,9 +539,11 @@ EXPORT_SYMBOL(ib_dispatch_event);
>  int ib_query_device(struct ib_device *device,
>                     struct ib_device_attr *device_attr)
>  {
> +       struct ib_udata uhw = {.outlen = 0, .inlen = 0};
> +
>         memset(device_attr, 0, sizeof(*device_attr));
>
> -       return device->query_device(device, device_attr);
> +       return device->query_device(device, device_attr, &uhw);
>  }
>  EXPORT_SYMBOL(ib_query_device);
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 11ee298..bbb02ff 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3428,7 +3428,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>
>         memset(&attr, 0, sizeof(attr));
>
> -       err = device->query_device(device, &attr);
> +       err = device->query_device(device, &attr, uhw);
>         if (err)
>                 return err;
>
> diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
> index a43e022..382f109 100644
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -63,13 +63,16 @@
>  #include "c2_provider.h"
>  #include "c2_user.h"
>
> -static int c2_query_device(struct ib_device *ibdev,
> -                          struct ib_device_attr *props)
> +static int c2_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                          struct ib_udata *uhw)
>  {
>         struct c2_dev *c2dev = to_c2dev(ibdev);
>
>         pr_debug("%s:%u\n", __func__, __LINE__);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         *props = c2dev->props;
>         return 0;
>  }
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> index 2eaf7e8..c4b5936 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1150,13 +1150,17 @@ static u64 fw_vers_string_to_u64(struct iwch_dev *iwch_dev)
>                (fw_mic & 0xffff);
>  }
>
> -static int iwch_query_device(struct ib_device *ibdev,
> -                            struct ib_device_attr *props)
> +static int iwch_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                            struct ib_udata *uhw)
>  {
>
>         struct iwch_dev *dev;
> +
>         PDBG("%s ibdev %p\n", __func__, ibdev);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         dev = to_iwch_dev(ibdev);
>         memset(props, 0, sizeof *props);
>         memcpy(&props->sys_image_guid, dev->rdev.t3cdev_p->lldev->dev_addr, 6);
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
> index ef08a9f..05a96a5 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -301,13 +301,17 @@ static int c4iw_query_gid(struct ib_device *ibdev, u8 port, int index,
>         return 0;
>  }
>
> -static int c4iw_query_device(struct ib_device *ibdev,
> -                            struct ib_device_attr *props)
> +static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                            struct ib_udata *uhw)
>  {
>
>         struct c4iw_dev *dev;
> +
>         PDBG("%s ibdev %p\n", __func__, ibdev);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         dev = to_c4iw_dev(ibdev);
>         memset(props, 0, sizeof *props);
>         memcpy(&props->sys_image_guid, dev->rdev.lldi.ports[0]->dev_addr, 6);
> diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
> index 9ed4d25..e8b1bb6 100644
> --- a/drivers/infiniband/hw/ehca/ehca_hca.c
> +++ b/drivers/infiniband/hw/ehca/ehca_hca.c
> @@ -50,7 +50,8 @@ static unsigned int limit_uint(unsigned int value)
>         return min_t(unsigned int, value, INT_MAX);
>  }
>
> -int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
> +int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                     struct ib_udata *uhw)
>  {
>         int i, ret = 0;
>         struct ehca_shca *shca = container_of(ibdev, struct ehca_shca,
> @@ -71,6 +72,9 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
>                 IB_DEVICE_PORT_ACTIVE_EVENT,  HCA_CAP_PORT_ACTIVE_EVENT,
>         };
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
>         if (!rblock) {
>                 ehca_err(&shca->ib_device, "Can't allocate rblock memory.");
> diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
> index 952f2fb..192eef1 100644
> --- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
> +++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
> @@ -44,7 +44,8 @@
>
>  #include "ehca_classes.h"
>
> -int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props);
> +int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                     struct ib_udata *uhw);
>
>  int ehca_query_port(struct ib_device *ibdev, u8 port,
>                     struct ib_port_attr *props);
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
> index 764081d..78af73c 100644
> --- a/drivers/infiniband/hw/ipath/ipath_verbs.c
> +++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
> @@ -1495,11 +1495,14 @@ bail:
>         return 0;
>  }
>
> -static int ipath_query_device(struct ib_device *ibdev,
> -                             struct ib_device_attr *props)
> +static int ipath_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                             struct ib_udata *uhw)
>  {
>         struct ipath_ibdev *dev = to_idev(ibdev);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         memset(props, 0, sizeof(*props));
>
>         props->device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 3b90df0..914beae 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -132,7 +132,8 @@ static int num_ib_ports(struct mlx4_dev *dev)
>  }
>
>  static int mlx4_ib_query_device(struct ib_device *ibdev,
> -                               struct ib_device_attr *props)
> +                               struct ib_device_attr *props,
> +                               struct ib_udata *uhw)
>  {
>         struct mlx4_ib_dev *dev = to_mdev(ibdev);
>         struct ib_smp *in_mad  = NULL;
> @@ -140,6 +141,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>         int err = -ENOMEM;
>         int have_ib_ports;
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
>         out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
>         if (!in_mad || !out_mad)
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index b9976a0..5a8486c 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -63,7 +63,8 @@ static char mlx5_version[] =
>         DRIVER_VERSION " (" DRIVER_RELDATE ")\n";
>
>  static int mlx5_ib_query_device(struct ib_device *ibdev,
> -                               struct ib_device_attr *props)
> +                               struct ib_device_attr *props,
> +                               struct ib_udata *uhw)
>  {
>         struct mlx5_ib_dev *dev = to_mdev(ibdev);
>         struct ib_smp *in_mad  = NULL;
> @@ -74,6 +75,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>         int max_sq_sg;
>         u64 flags;
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         gen = &dev->mdev->caps.gen;
>         in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
>         out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
> @@ -910,6 +914,7 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
>         struct mlx5_general_caps *gen;
>         int err = -ENOMEM;
>         int port;
> +       struct ib_udata uhw = {.inlen = 0, .outlen = 0};
>
>         gen = &dev->mdev->caps.gen;
>         pprops = kmalloc(sizeof(*pprops), GFP_KERNEL);
> @@ -920,7 +925,7 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
>         if (!dprops)
>                 goto out;
>
> -       err = mlx5_ib_query_device(&dev->ib_dev, dprops);
> +       err = mlx5_ib_query_device(&dev->ib_dev, dprops, &uhw);
>         if (err) {
>                 mlx5_ib_warn(dev, "query_device failed %d\n", err);
>                 goto out;
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
> index f1b04bd..d6d7c16 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -57,14 +57,17 @@ static void init_query_mad(struct ib_smp *mad)
>         mad->method        = IB_MGMT_METHOD_GET;
>  }
>
> -static int mthca_query_device(struct ib_device *ibdev,
> -                             struct ib_device_attr *props)
> +static int mthca_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                             struct ib_udata *uhw)
>  {
>         struct ib_smp *in_mad  = NULL;
>         struct ib_smp *out_mad = NULL;
>         int err = -ENOMEM;
>         struct mthca_dev *mdev = to_mdev(ibdev);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
>         out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
>         if (!in_mad || !out_mad)
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index a9d62c5..0c2fb7a 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -512,12 +512,16 @@ static void nes_free_fast_reg_page_list(struct ib_fast_reg_page_list *pifrpl)
>  /**
>   * nes_query_device
>   */
> -static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
> +static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                           struct ib_udata *uhw)
>  {
>         struct nes_vnic *nesvnic = to_nesvnic(ibdev);
>         struct nes_device *nesdev = nesvnic->nesdev;
>         struct nes_ib_device *nesibdev = nesvnic->nesibdev;
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         memset(props, 0, sizeof(*props));
>         memcpy(&props->sys_image_guid, nesvnic->netdev->dev_addr, 6);
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index f441df6..fce11ec 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -61,10 +61,14 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
>         return 0;
>  }
>
> -int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
> +int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
> +                       struct ib_udata *uhw)
>  {
>         struct ocrdma_dev *dev = get_ocrdma_dev(ibdev);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         memset(attr, 0, sizeof *attr);
>         memcpy(&attr->fw_ver, &dev->attr.fw_ver[0],
>                min(sizeof(dev->attr.fw_ver), sizeof(attr->fw_ver)));
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> index e853195..b15c608 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> @@ -36,7 +36,8 @@ int ocrdma_post_recv(struct ib_qp *, struct ib_recv_wr *,
>  int ocrdma_poll_cq(struct ib_cq *, int num_entries, struct ib_wc *wc);
>  int ocrdma_arm_cq(struct ib_cq *, enum ib_cq_notify_flags flags);
>
> -int ocrdma_query_device(struct ib_device *, struct ib_device_attr *props);
> +int ocrdma_query_device(struct ib_device *, struct ib_device_attr *props,
> +                       struct ib_udata *uhw);
>  int ocrdma_query_port(struct ib_device *, u8 port, struct ib_port_attr *props);
>  int ocrdma_modify_port(struct ib_device *, u8 port, int mask,
>                        struct ib_port_modify *props);
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
> index dba1c92..e1dad45 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -1550,12 +1550,14 @@ full:
>         }
>  }
>
> -static int qib_query_device(struct ib_device *ibdev,
> -                           struct ib_device_attr *props)
> +static int qib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
> +                           struct ib_udata *uhw)
>  {
>         struct qib_devdata *dd = dd_from_ibdev(ibdev);
>         struct qib_ibdev *dev = to_idev(ibdev);
>
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
>         memset(props, 0, sizeof(*props));
>
>         props->device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index 2b3f7e3..7df4382 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -248,7 +248,8 @@ enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *device,
>  }
>
>  int usnic_ib_query_device(struct ib_device *ibdev,
> -                               struct ib_device_attr *props)
> +                         struct ib_device_attr *props,
> +                         struct ib_udata *uhw)
>  {
>         struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
>         union ib_gid gid;
> @@ -257,6 +258,9 @@ int usnic_ib_query_device(struct ib_device *ibdev,
>         int qp_per_vf;
>
>         usnic_dbg("\n");
> +       if (uhw->inlen || uhw->outlen)
> +               return -EINVAL;
> +
>         mutex_lock(&us_ibdev->usdev_lock);
>         us_ibdev->netdev->ethtool_ops->get_drvinfo(us_ibdev->netdev, &info);
>         us_ibdev->netdev->ethtool_ops->get_settings(us_ibdev->netdev, &cmd);
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> index 2ab8427..0bd04ef 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> @@ -24,7 +24,8 @@
>  enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *device,
>                                                 u8 port_num);
>  int usnic_ib_query_device(struct ib_device *ibdev,
> -                               struct ib_device_attr *props);
> +                               struct ib_device_attr *props,
> +                         struct ib_udata *uhw);
>  int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>                                 struct ib_port_attr *props);
>  enum rdma_protocol_type
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index a45f674..045b5b2 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1562,7 +1562,8 @@ struct ib_device {
>         int                        (*get_protocol_stats)(struct ib_device *device,
>                                                          union rdma_protocol_stats *stats);
>         int                        (*query_device)(struct ib_device *device,
> -                                                  struct ib_device_attr *device_attr);
> +                                                  struct ib_device_attr *device_attr,
> +                                                  struct ib_udata *udata);
>         int                        (*query_port)(struct ib_device *device,
>                                                  u8 port_num,
>                                                  struct ib_port_attr *port_attr);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
