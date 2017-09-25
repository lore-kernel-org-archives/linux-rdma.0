From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 04/10] providers: Use the new match_device and
 allocate_device ops
Date: Mon, 25 Sep 2017 13:11:04 +0530
Message-ID: <CANjDDBi6f=zNUg3N4PKSpJ+7CwjhuaJvDwTC3gbwbK-1nSxP1g@mail.gmail.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com> <1505855931-4956-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER (for hf1.ko)" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

bnxt_re related part looks good to me

Acked-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Wed, Sep 20, 2017 at 2:48 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> This is the first step to simplify the provider binding process.
>
> Checking of the ABI version is hoisted into the core code, as are some
> of the common error messages.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/bnxt_re/main.c           | 36 ++++++++++------------
>  providers/cxgb3/iwch.c             | 60 ++++++++++++++++--------------------
>  providers/cxgb4/dev.c              | 60 +++++++++++++++++++-----------------
>  providers/hfi1verbs/hfiverbs.c     | 31 ++++++++++---------
>  providers/hns/hns_roce_u.c         | 63 +++++++++++++++++++-------------------
>  providers/i40iw/i40iw_umain.c      | 39 ++++++++++++++---------
>  providers/ipathverbs/ipathverbs.c  | 32 ++++++++++---------
>  providers/mlx4/mlx4.c              | 42 +++++++++++--------------
>  providers/mlx5/mlx5.c              | 42 ++++++++++---------------
>  providers/mthca/mthca.c            | 43 +++++++++++++-------------
>  providers/nes/nes_umain.c          | 48 ++++++++++++++++-------------
>  providers/ocrdma/ocrdma_main.c     | 46 ++++++++++++----------------
>  providers/qedr/qelr_main.c         | 35 ++++++++++-----------
>  providers/rxe/rxe.c                | 28 +++++++++--------
>  providers/vmw_pvrdma/pvrdma_main.c | 49 ++++++++++-------------------
>  15 files changed, 317 insertions(+), 337 deletions(-)
>
> diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
> index d2c2a6847e3c71..c83baacbb9f749 100644
> --- a/providers/bnxt_re/main.c
> +++ b/providers/bnxt_re/main.c
> @@ -174,43 +174,38 @@ static void bnxt_re_uninit_context(struct verbs_device *vdev,
>         }
>  }
>
> -static struct verbs_device *bnxt_re_driver_init(const char *uverbs_sys_path,
> -                                               int abi_version)
> +static bool bnxt_re_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[10];
> -       struct bnxt_re_dev *dev;
>         unsigned int vendor, device;
>         int i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>         vendor = strtol(value, NULL, 16);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>         device = strtol(value, NULL, 16);
>
>         for (i = 0; i < sizeof(cna_table) / sizeof(cna_table[0]); ++i)
>                 if (vendor == cna_table[i].vendor &&
>                     device == cna_table[i].device)
> -                       goto found;
> -       return NULL;
> -found:
> -       if (abi_version != BNXT_RE_ABI_VERSION) {
> -               fprintf(stderr, DEV "FATAL: Max supported ABI of %s is %d "
> -                       "check for the latest version of kernel driver and"
> -                       "user library\n", uverbs_sys_path, abi_version);
> -               return NULL;
> -       }
> +                       return true;
> +       return false;
> +}
> +
> +static struct verbs_device *
> +bnxt_re_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct bnxt_re_dev *dev;
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, DEV "Failed to allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
>         dev->vdev.sz = sizeof(*dev);
>         dev->vdev.size_of_context =
> @@ -221,7 +216,10 @@ found:
>
>  static const struct verbs_device_ops bnxt_re_dev_ops = {
>         .name = "bnxt_re",
> -       .init_device = bnxt_re_driver_init,
> +       .match_min_abi_version = BNXT_RE_ABI_VERSION,
> +       .match_max_abi_version = BNXT_RE_ABI_VERSION,
> +       .match_device = bnxt_re_device_match,
> +       .alloc_device = bnxt_re_device_alloc,
>         .init_context = bnxt_re_init_context,
>         .uninit_context = bnxt_re_uninit_context,
>  };
> diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
> index c2423a7ee2cc32..7eb283bd9a89e1 100644
> --- a/providers/cxgb3/iwch.c
> +++ b/providers/cxgb3/iwch.c
> @@ -61,7 +61,7 @@
>           .device = PCI_DEVICE_ID_CHELSIO_##d,          \
>           .type = CHELSIO_##t }
>
> -static struct {
> +static struct hca_ent {
>         unsigned vendor;
>         unsigned device;
>         enum iwch_hca_type type;
> @@ -173,30 +173,31 @@ static void iwch_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *cxgb3_driver_init(const char *uverbs_sys_path,
> -                                             int abi_version)
> +static bool iwch_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> -       char devstr[IBV_SYSFS_PATH_MAX], ibdev[16], value[32], *cp;
> -       struct iwch_device *dev;
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
> +       char value[32], *cp;
>         unsigned vendor, device, fw_maj, fw_min;
>         int i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
> -                   device == hca_table[i].device)
> +                   device == hca_table[i].device) {
> +                       sysfs_dev->provider_data = &hca_table[i];
>                         goto found;
> +               }
>
> -       return NULL;
> +       return false;
>
>  found:
>
> @@ -204,15 +205,9 @@ found:
>          * Verify that the firmware major number matches.  Major number
>          * mismatches are fatal.  Minor number mismatches are tolerated.
>          */
> -       if (ibv_read_sysfs_file(uverbs_sys_path, "ibdev",
> -                               ibdev, sizeof ibdev) < 0)
> -               return NULL;
> -
> -       memset(devstr, 0, sizeof devstr);
> -       snprintf(devstr, sizeof devstr, "%s/class/infiniband/%s",
> -                ibv_get_sysfs_path(), ibdev);
> -       if (ibv_read_sysfs_file(devstr, "fw_ver", value, sizeof value) < 0)
> -               return NULL;
> +       if (ibv_read_sysfs_file(sysfs_dev->ibdev_path, "fw_ver", value,
> +                               sizeof(value)) < 0)
> +               return false;
>
>         cp = strtok(value+1, ".");
>         sscanf(cp, "%i", &fw_maj);
> @@ -224,7 +219,7 @@ found:
>                         "Firmware major number is %u and libcxgb3 needs %u.\n",
>                         fw_maj, FW_MAJ);
>                 fflush(stderr);
> -               return NULL;
> +               return false;
>         }
>
>         DBGLOG("libcxgb3");
> @@ -236,25 +231,21 @@ found:
>                 fflush(stderr);
>         }
>
> -       if (abi_version > ABI_VERS) {
> -               PDBG("libcxgb3: ABI version mismatch.  "
> -                       "Kernel driver ABI is %u and libcxgb3 needs <= %u.\n",
> -                       abi_version, ABI_VERS);
> -               fflush(stderr);
> -               return NULL;
> -       }
> +       return true;
> +}
>
> -       PDBG("%s found vendor %d device %d type %d\n",
> -            __FUNCTION__, vendor, device, hca_table[i].type);
> +static struct verbs_device *iwch_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct iwch_device *dev;
> +       struct hca_ent *hca_ent = sysfs_dev->provider_data;
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> +       if (!dev)
>                 return NULL;
> -       }
>
>         pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
> -       dev->hca_type = hca_table[i].type;
> -       dev->abi_version = abi_version;
> +       dev->hca_type = hca_ent->type;
> +       dev->abi_version = sysfs_dev->abi_ver;
>
>         iwch_page_size = sysconf(_SC_PAGESIZE);
>         iwch_page_shift = long_log2(iwch_page_size);
> @@ -285,7 +276,10 @@ err1:
>
>  static const struct verbs_device_ops iwch_dev_ops = {
>         .name = "cxgb3",
> -       .init_device = cxgb3_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = ABI_VERS,
> +       .match_device = iwch_device_match,
> +       .alloc_device = iwch_device_alloc,
>         .uninit_device = iwch_uninit_device,
>         .alloc_context = iwch_alloc_context,
>         .free_context = iwch_free_context,
> diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
> index 492b3978995607..43c5a3c97bc864 100644
> --- a/providers/cxgb4/dev.c
> +++ b/providers/cxgb4/dev.c
> @@ -49,7 +49,7 @@
>   * Macros needed to support the PCI Device ID Table ...
>   */
>  #define CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN \
> -       static struct { \
> +       static struct hca_ent { \
>                 unsigned vendor; \
>                 unsigned device; \
>         } hca_table[] = {
> @@ -399,47 +399,40 @@ void dump_state(void)
>   */
>  int c4iw_abi_version = 1;
>
> -static struct verbs_device *cxgb4_driver_init(const char *uverbs_sys_path,
> -                                             int abi_version)
> +static bool c4iw_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> -       char devstr[IBV_SYSFS_PATH_MAX], ibdev[16], value[32], *cp;
> -       struct c4iw_dev *dev;
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
> +       char value[32], *cp;
>         unsigned vendor, device, fw_maj, fw_min;
>         int i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
> -                   device == hca_table[i].device)
> +                   device == hca_table[i].device) {
> +                       sysfs_dev->provider_data = &hca_table[i];
>                         goto found;
> +               }
>
> -       return NULL;
> +       return false;
>
>  found:
> -       c4iw_abi_version = abi_version;
> -
>         /*
>          * Verify that the firmware major number matches.  Major number
>          * mismatches are fatal.  Minor number mismatches are tolerated.
>          */
> -       if (ibv_read_sysfs_file(uverbs_sys_path, "ibdev",
> -                               ibdev, sizeof ibdev) < 0)
> -               return NULL;
> -
> -       memset(devstr, 0, sizeof devstr);
> -       snprintf(devstr, sizeof devstr, "%s/class/infiniband/%s",
> -                ibv_get_sysfs_path(), ibdev);
> -       if (ibv_read_sysfs_file(devstr, "fw_ver", value, sizeof value) < 0)
> -               return NULL;
> +       if (ibv_read_sysfs_file(sysfs_dev->ibdev_path, "fw_ver", value,
> +                               sizeof(value)) < 0)
> +               return false;
>
>         cp = strtok(value+1, ".");
>         sscanf(cp, "%i", &fw_maj);
> @@ -451,7 +444,7 @@ found:
>                         "Firmware major number is %u and libcxgb4 needs %u.\n",
>                         fw_maj, FW_MAJ);
>                 fflush(stderr);
> -               return NULL;
> +               return false;
>         }
>
>         DBGLOG("libcxgb4");
> @@ -462,22 +455,30 @@ found:
>                         fw_min, FW_MIN);
>                 fflush(stderr);
>         }
> +       return true;
> +}
>
> -       PDBG("%s found vendor %d device %d type %d\n",
> -            __FUNCTION__, vendor, device, CHELSIO_CHIP_VERSION(hca_table[i].device >> 8));
> +static struct verbs_device *c4iw_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct c4iw_dev *dev;
> +       struct hca_ent *hca_ent = sysfs_dev->provider_data;
> +
> +       c4iw_page_size = sysconf(_SC_PAGESIZE);
> +       c4iw_page_shift = long_log2(c4iw_page_size);
> +       c4iw_page_mask = ~(c4iw_page_size - 1);
>
>         c4iw_page_size = sysconf(_SC_PAGESIZE);
>         c4iw_page_shift = long_log2(c4iw_page_size);
>         c4iw_page_mask = ~(c4iw_page_size - 1);
>
>         dev = calloc(1, sizeof *dev);
> -       if (!dev) {
> +       if (!dev)
>                 return NULL;
> -       }
>
>         pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
> -       dev->chip_version = CHELSIO_CHIP_VERSION(hca_table[i].device >> 8);
> -       dev->abi_version = abi_version;
> +       c4iw_abi_version = sysfs_dev->abi_ver;
> +       dev->chip_version = CHELSIO_CHIP_VERSION(hca_ent->device >> 8);
> +       dev->abi_version = sysfs_dev->abi_ver;
>         list_node_init(&dev->list);
>
>         PDBG("%s device claimed\n", __FUNCTION__);
> @@ -514,7 +515,10 @@ found:
>
>  static const struct verbs_device_ops c4iw_dev_ops = {
>         .name = "cxgb4",
> -       .init_device = cxgb4_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = c4iw_device_match,
> +       .alloc_device = c4iw_device_alloc,
>         .uninit_device = c4iw_uninit_device,
>         .alloc_context = c4iw_alloc_context,
>         .free_context = c4iw_free_context,
> diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
> index 247831eb211804..5bb436593517e1 100644
> --- a/providers/hfi1verbs/hfiverbs.c
> +++ b/providers/hfi1verbs/hfiverbs.c
> @@ -180,47 +180,50 @@ static void hf11_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *hfi1_driver_init(const char *uverbs_sys_path,
> -                                            int abi_version)
> +static bool hfi1_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char                    value[8];
> -       struct hfi1_device    *dev;
>         unsigned                vendor, device;
>         int                     i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
>                     device == hca_table[i].device)
> -                       goto found;
> +                       return true;
>
> -       return NULL;
> +       return false;
> +}
> +
> +static struct verbs_device *hfi1_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct hfi1_device    *dev;
>
> -found:
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->abi_version = abi_version;
> +       dev->abi_version = sysfs_dev->abi_ver;
>
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops hfi1_dev_ops = {
>         .name = "hfi1verbs",
> -       .init_device = hfi1_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = hfi1_device_match,
> +       .alloc_device = hfi1_device_alloc,
>         .uninit_device  = hf11_uninit_device,
>         .alloc_context = hfi1_alloc_context,
>         .free_context = hfi1_free_context,
> diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
> index fe2d009ebe3737..88389721811fce 100644
> --- a/providers/hns/hns_roce_u.c
> +++ b/providers/hns/hns_roce_u.c
> @@ -44,20 +44,18 @@
>  #define HID_LEN                        15
>  #define DEV_MATCH_LEN          128
>
> -static const struct {
> -       char     hid[HID_LEN];
> -       void     *data;
> -       int      version;
> -} acpi_table[] = {
> +struct hca_ent {
> +       const char *str;
> +       struct hns_roce_u_hw *data;
> +       int version;
> +};
> +
> +static const struct hca_ent acpi_table[] = {
>          {"acpi:HISI00D1:", &hns_roce_u_hw_v1, HNS_ROCE_HW_VER1},
>          {},
>  };
>
> -static const struct {
> -       char     compatible[DEV_MATCH_LEN];
> -       void     *data;
> -       int      version;
> -} dt_table[] = {
> +static const struct hca_ent dt_table[] = {
>         {"hisilicon,hns-roce-v1", &hns_roce_u_hw_v1, HNS_ROCE_HW_VER1},
>         {},
>  };
> @@ -180,52 +178,53 @@ static void hns_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *hns_roce_driver_init(const char *uverbs_sys_path,
> -                                                int abi_version)
> +static bool hns_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> -       struct hns_roce_device  *dev;
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char                     value[128];
>         int                      i;
> -       void                     *u_hw;
> -       int                      hw_version;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
>                                 value, sizeof(value)) > 0)
>                 for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
> -                       if (!strcmp(value, acpi_table[i].hid)) {
> -                               u_hw = acpi_table[i].data;
> -                               hw_version = acpi_table[i].version;
> -                               goto found;
> +                       if (!strcmp(value, acpi_table[i].str)) {
> +                               sysfs_dev->provider_data =
> +                                   (void *)&acpi_table[i];
> +                               return true;
>                         }
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/of_node/compatible",
>                                 value, sizeof(value)) > 0)
>                 for (i = 0; i < sizeof(dt_table) / sizeof(dt_table[0]); ++i)
> -                       if (!strcmp(value, dt_table[i].compatible)) {
> -                               u_hw = dt_table[i].data;
> -                               hw_version = dt_table[i].version;
> -                               goto found;
> +                       if (!strcmp(value, dt_table[i].str)) {
> +                               sysfs_dev->provider_data = (void *)&dt_table[i];
> +                               return true;
>                         }
>
> -       return NULL;
> +       return false;
> +}
> +
> +static struct verbs_device *hns_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct hns_roce_device  *dev;
> +       const struct hca_ent *hca_ent = sysfs_dev->provider_data;
>
> -found:
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->u_hw = (struct hns_roce_u_hw *)u_hw;
> -       dev->hw_version = hw_version;
> +       dev->u_hw = hca_ent->data;
> +       dev->hw_version = hca_ent->version;
>         dev->page_size   = sysconf(_SC_PAGESIZE);
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops hns_roce_dev_ops = {
>         .name = "hns",
> -       .init_device = hns_roce_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = hns_device_match,
> +       .alloc_device = hns_device_alloc,
>         .uninit_device = hns_uninit_device,
>         .alloc_context = hns_roce_alloc_context,
>         .free_context = hns_roce_free_context,
> diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
> index 90d37651d1f702..bcba6158e60e40 100644
> --- a/providers/i40iw/i40iw_umain.c
> +++ b/providers/i40iw/i40iw_umain.c
> @@ -55,7 +55,7 @@
>           .device = d,          \
>           .type = INTEL_ ## t }
>
> -static struct {
> +static struct hca_ent {
>         unsigned int vendor;
>         unsigned int device;
>         enum i40iw_uhca_type type;
> @@ -220,44 +220,53 @@ static void i40iw_uninit_device(struct verbs_device *verbs_device)
>   * @uverbs_sys_path: sys path
>   * @abi_version: not used
>   */
> -static struct verbs_device *i40iw_driver_init(const char *uverbs_sys_path,
> -                                             int abi_version)
> +static bool i40iw_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[16];
> -       struct i40iw_udevice *dev;
>         unsigned int vendor, device;
>         int i;
>
>         if ((ibv_read_sysfs_file(uverbs_sys_path, "device/vendor", value, sizeof(value)) < 0) ||
>             (sscanf(value, "%i", &vendor) != 1))
> -               return NULL;
> +               return false;
>
>         if ((ibv_read_sysfs_file(uverbs_sys_path, "device/device", value, sizeof(value)) < 0) ||
>             (sscanf(value, "%i", &device) != 1))
> -               return NULL;
> +               return false;
>
>         for (i = 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i) {
>                 if (vendor == hca_table[i].vendor &&
> -                   device == hca_table[i].device)
> -                       goto found;
> +                   device == hca_table[i].device) {
> +                       sysfs_dev->provider_data = &hca_table[i];
> +                       return true;
> +               }
>         }
>
> -       return NULL;
> -found:
> +       return false;
> +}
> +
> +static struct verbs_device *
> +i40iw_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct i40iw_udevice *dev;
> +       struct hca_ent *hca_ent = sysfs_dev->provider_data;
> +
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, PFX "%s: failed to allocate memory for device object\n", __func__);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->hca_type = hca_table[i].type;
> +       dev->hca_type = hca_ent->type;
>         dev->page_size = I40IW_HW_PAGE_SIZE;
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops i40iw_udev_ops = {
>         .name = "i40iw",
> -       .init_device = i40iw_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = i40iw_device_match,
> +       .alloc_device = i40iw_device_alloc,
>         .uninit_device  = i40iw_uninit_device,
>         .alloc_context = i40iw_ualloc_context,
>         .free_context = i40iw_ufree_context,
> diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
> index ebdf5b828e1784..3c141263d8ff86 100644
> --- a/providers/ipathverbs/ipathverbs.c
> +++ b/providers/ipathverbs/ipathverbs.c
> @@ -179,47 +179,51 @@ static void ipath_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *ipath_driver_init(const char *uverbs_sys_path,
> -                                             int abi_version)
> +static bool ipath_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char                    value[8];
> -       struct ipath_device    *dev;
>         unsigned                vendor, device;
>         int                     i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
>                     device == hca_table[i].device)
> -                       goto found;
> +                       return true;
>
> -       return NULL;
> +       return false;
> +}
> +
> +static struct verbs_device *
> +ipath_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct ipath_device    *dev;
>
> -found:
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->abi_version = abi_version;
> +       dev->abi_version = sysfs_dev->abi_ver;
>
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops ipath_dev_ops = {
>         .name = "ipathverbs",
> -       .init_device = ipath_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = ipath_device_match,
> +       .alloc_device = ipath_device_alloc,
>         .uninit_device  = ipath_uninit_device,
>         .alloc_context = ipath_alloc_context,
>         .free_context = ipath_free_context,
> diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
> index 0eefa40af16d83..b52684a563b495 100644
> --- a/providers/mlx4/mlx4.c
> +++ b/providers/mlx4/mlx4.c
> @@ -286,50 +286,41 @@ static void mlx4_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
> +static bool mlx4_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char                    value[8];
> -       struct mlx4_device    *dev;
>         unsigned                vendor, device;
>         int                     i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         vendor = strtol(value, NULL, 16);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         device = strtol(value, NULL, 16);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
>                     device == hca_table[i].device)
> -                       goto found;
> -
> -       return NULL;
> -
> -found:
> -       if (abi_version < MLX4_UVERBS_MIN_ABI_VERSION ||
> -           abi_version > MLX4_UVERBS_MAX_ABI_VERSION) {
> -               fprintf(stderr, PFX "Fatal: ABI version %d of %s is not supported "
> -                       "(min supported %d, max supported %d)\n",
> -                       abi_version, uverbs_sys_path,
> -                       MLX4_UVERBS_MIN_ABI_VERSION,
> -                       MLX4_UVERBS_MAX_ABI_VERSION);
> -               return NULL;
> -       }
> +                       return true;
> +
> +       return false;
> +}
> +
> +static struct verbs_device *mlx4_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct mlx4_device *dev;
>
>         dev = calloc(1, sizeof *dev);
> -       if (!dev) {
> -               fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
>         dev->page_size   = sysconf(_SC_PAGESIZE);
> -       dev->abi_version = abi_version;
> +       dev->abi_version = sysfs_dev->abi_ver;
>
>         dev->verbs_dev.sz = sizeof(*dev);
>         dev->verbs_dev.size_of_context =
> @@ -340,7 +331,10 @@ found:
>
>  static const struct verbs_device_ops mlx4_dev_ops = {
>         .name = "mlx4",
> -       .init_device = mlx4_driver_init,
> +       .match_min_abi_version = MLX4_UVERBS_MIN_ABI_VERSION,
> +       .match_max_abi_version = MLX4_UVERBS_MAX_ABI_VERSION,
> +       .match_device = mlx4_device_match,
> +       .alloc_device = mlx4_device_alloc,
>         .uninit_device = mlx4_uninit_device,
>         .init_context = mlx4_init_context,
>         .uninit_context = mlx4_uninit_context,
> diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
> index 68cca7cde97ef2..44cfd97b73cbbb 100644
> --- a/providers/mlx5/mlx5.c
> +++ b/providers/mlx5/mlx5.c
> @@ -1026,51 +1026,40 @@ static void mlx5_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *mlx5_driver_init(const char *uverbs_sys_path,
> -                                            int abi_version)
> +static bool mlx5_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char                    value[8];
> -       struct mlx5_device     *dev;
>         unsigned                vendor, device;
>         int                     i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
>                     device == hca_table[i].device)
> -                       goto found;
> -
> -       return NULL;
> -
> -found:
> -       if (abi_version < MLX5_UVERBS_MIN_ABI_VERSION ||
> -           abi_version > MLX5_UVERBS_MAX_ABI_VERSION) {
> -               fprintf(stderr, PFX "Fatal: ABI version %d of %s is not supported "
> -                       "(min supported %d, max supported %d)\n",
> -                       abi_version, uverbs_sys_path,
> -                       MLX5_UVERBS_MIN_ABI_VERSION,
> -                       MLX5_UVERBS_MAX_ABI_VERSION);
> -               return NULL;
> -       }
> +                       return true;
> +       return false;
> +}
> +
> +static struct verbs_device *mlx5_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct mlx5_device *dev;
>
>         dev = calloc(1, sizeof *dev);
> -       if (!dev) {
> -               fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
>         dev->page_size   = sysconf(_SC_PAGESIZE);
> -       dev->driver_abi_ver = abi_version;
> +       dev->driver_abi_ver = sysfs_dev->abi_ver;
>
>         dev->verbs_dev.sz = sizeof(*dev);
>         dev->verbs_dev.size_of_context = sizeof(struct mlx5_context) -
> @@ -1081,7 +1070,10 @@ found:
>
>  static const struct verbs_device_ops mlx5_dev_ops = {
>         .name = "mlx5",
> -       .init_device = mlx5_driver_init,
> +       .match_min_abi_version = MLX5_UVERBS_MIN_ABI_VERSION,
> +       .match_max_abi_version = MLX5_UVERBS_MAX_ABI_VERSION,
> +       .match_device = mlx5_device_match,
> +       .alloc_device = mlx5_device_alloc,
>         .uninit_device = mlx5_uninit_device,
>         .init_context = mlx5_init_context,
>         .uninit_context = mlx5_cleanup_context,
> diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
> index 7194539b2d6ab1..521e5b9afe4f2b 100644
> --- a/providers/mthca/mthca.c
> +++ b/providers/mthca/mthca.c
> @@ -77,7 +77,7 @@
>           .device = PCI_DEVICE_ID_MELLANOX_##d,         \
>           .type = MTHCA_##t }
>
> -static struct {
> +static struct hca_ent {
>         unsigned                vendor;
>         unsigned                device;
>         enum mthca_hca_type     type;
> @@ -216,46 +216,44 @@ static void mthca_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *mthca_driver_init(const char *uverbs_sys_path,
> -                                           int abi_version)
> +static bool mthca_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char                    value[8];
> -       struct mthca_device    *dev;
>         unsigned                vendor, device;
>         int                     i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof value) < 0)
> -               return NULL;
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
> -                   device == hca_table[i].device)
> -                       goto found;
> +                   device == hca_table[i].device) {
> +                       sysfs_dev->provider_data = &hca_table[i];
> +                       return true;
> +               }
>
> -       return NULL;
> +       return false;
> +}
>
> -found:
> -       if (abi_version > MTHCA_UVERBS_ABI_VERSION) {
> -               fprintf(stderr, PFX "Fatal: ABI version %d of %s is too new (expected %d)\n",
> -                       abi_version, uverbs_sys_path, MTHCA_UVERBS_ABI_VERSION);
> -               return NULL;
> -       }
> +static struct verbs_device *
> +mthca_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct mthca_device    *dev;
> +       struct hca_ent *hca_ent = sysfs_dev->provider_data;
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->hca_type    = hca_table[i].type;
> +       dev->hca_type    = hca_ent->type;
>         dev->page_size   = sysconf(_SC_PAGESIZE);
>
>         return &dev->ibv_dev;
> @@ -263,7 +261,10 @@ found:
>
>  static const struct verbs_device_ops mthca_dev_ops = {
>         .name = "mthca",
> -       .init_device = mthca_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = MTHCA_UVERBS_ABI_VERSION,
> +       .match_device = mthca_device_match,
> +       .alloc_device = mthca_device_alloc,
>         .uninit_device = mthca_uninit_device,
>         .alloc_context = mthca_alloc_context,
>         .free_context = mthca_free_context,
> diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
> index d02e010d2524a2..fc021a9196b6ad 100644
> --- a/providers/nes/nes_umain.c
> +++ b/providers/nes/nes_umain.c
> @@ -60,7 +60,7 @@ long int page_size;
>           .device = d,    \
>           .type = NETEFFECT_##t }
>
> -static struct {
> +static struct hca_ent {
>         unsigned vendor;
>         unsigned device;
>         enum nes_uhca_type type;
> @@ -191,37 +191,40 @@ static void nes_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -/**
> - * nes_driver_init
> - */
> -static struct verbs_device *nes_driver_init(const char *uverbs_sys_path,
> -                                           int abi_version)
> +static bool nes_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[16];
> -       struct nes_udevice *dev;
>         unsigned vendor, device;
>         int i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
> -                       value, sizeof(value)) < 0) {
> -               return NULL;
> -       }
> +                       value, sizeof(value)) < 0)
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
> -                       value, sizeof(value)) < 0) {
> -               return NULL;
> -       }
> +                       value, sizeof(value)) < 0)
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
>                 if (vendor == hca_table[i].vendor &&
> -                               device == hca_table[i].device)
> -                       goto found;
> +                   device == hca_table[i].device) {
> +                       sysfs_dev->provider_data = &hca_table[i];
> +                       return true;
> +               }
>
> -       return NULL;
> +       return false;
> +}
> +
> +static struct verbs_device *
> +nes_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct nes_udevice *dev;
> +       struct hca_ent *hca_ent = sysfs_dev->provider_data;
> +       char value[16];
>
> -found:
>         if (ibv_read_sysfs_file("/sys/module/iw_nes", "parameters/debug_level",
>                         value, sizeof(value)) > 0) {
>                 sscanf(value, "%u", &nes_debug_level);
> @@ -231,12 +234,10 @@ found:
>         }
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               nes_debug(NES_DBG_INIT, "Fatal: couldn't allocate device for libnes\n");
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->hca_type = hca_table[i].type;
> +       dev->hca_type = hca_ent->type;
>         dev->page_size = sysconf(_SC_PAGESIZE);
>
>         nes_debug(NES_DBG_INIT, "libnes initialized\n");
> @@ -246,7 +247,10 @@ found:
>
>  static const struct verbs_device_ops nes_udev_ops = {
>         .name = "nes",
> -       .init_device = nes_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = nes_device_match,
> +       .alloc_device = nes_device_alloc,
>         .uninit_device = nes_uninit_device,
>         .alloc_context = nes_ualloc_context,
>         .free_context = nes_ufree_context,
> diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
> index 09c00d21ce2af6..f08a49fb73e021 100644
> --- a/providers/ocrdma/ocrdma_main.c
> +++ b/providers/ocrdma/ocrdma_main.c
> @@ -168,50 +168,39 @@ static void ocrdma_free_context(struct ibv_context *ibctx)
>         free(ctx);
>  }
>
> -/**
> - * ocrdma_driver_init
> - */
> -static struct verbs_device *ocrdma_driver_init(const char *uverbs_sys_path,
> -                                              int abi_version)
> +static bool ocrdma_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> -
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[16];
> -       struct ocrdma_device *dev;
>         unsigned vendor, device;
>         int i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
> -                               value, sizeof(value)) < 0) {
> -               return NULL;
> -       }
> +                               value, sizeof(value)) < 0)
> +               return false;
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
> -                               value, sizeof(value)) < 0) {
> -               return NULL;
> -       }
> +                               value, sizeof(value)) < 0)
> +               return false;
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof ucna_table / sizeof ucna_table[0]; ++i) {
>                 if (vendor == ucna_table[i].vendor &&
>                     device == ucna_table[i].device)
> -                       goto found;
> -       }
> -       return NULL;
> -found:
> -       if (abi_version != OCRDMA_ABI_VERSION) {
> -               fprintf(stderr,
> -                 "Fatal: libocrdma ABI version %d of %s is not supported.\n",
> -                 abi_version, uverbs_sys_path);
> -               return NULL;
> +                       return true;
>         }
> +       return false;
> +}
> +
> +static struct verbs_device *
> +ocrdma_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct ocrdma_device *dev;
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               ocrdma_err("%s() Fatal: fail allocate device for libocrdma\n",
> -                          __func__);
> +       if (!dev)
>                 return NULL;
> -       }
>
>         dev->qp_tbl = malloc(OCRDMA_MAX_QP * sizeof(struct ocrdma_qp *));
>         if (!dev->qp_tbl)
> @@ -227,7 +216,10 @@ qp_err:
>
>  static const struct verbs_device_ops ocrdma_dev_ops = {
>         .name = "ocrdma",
> -       .init_device = ocrdma_driver_init,
> +       .match_min_abi_version = OCRDMA_ABI_VERSION,
> +       .match_max_abi_version = OCRDMA_ABI_VERSION,
> +       .match_device = ocrdma_device_match,
> +       .alloc_device = ocrdma_device_alloc,
>         .uninit_device = ocrdma_uninit_device,
>         .alloc_context = ocrdma_alloc_context,
>         .free_context = ocrdma_free_context,
> diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
> index 0be4a8c82a1e05..4d1b92f40a413a 100644
> --- a/providers/qedr/qelr_main.c
> +++ b/providers/qedr/qelr_main.c
> @@ -227,53 +227,50 @@ static void qelr_free_context(struct ibv_context *ibctx)
>         free(ctx);
>  }
>
> -static struct verbs_device *qelr_driver_init(const char *uverbs_sys_path,
> -                                            int abi_version)
> +static bool qedr_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[16];
> -       struct qelr_device *dev;
>         unsigned int vendor, device;
>         int i;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>
>         sscanf(value, "%i", &vendor);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>
>         sscanf(value, "%i", &device);
>
>         for (i = 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i)
>                 if (vendor == hca_table[i].vendor &&
>                     device == hca_table[i].device)
> -                       goto found;
> +                       return true;
>
> -       return NULL;
> -found:
> -       if (abi_version != QELR_ABI_VERSION) {
> -               fprintf(stderr,
> -                       "Fatal: libqedr ABI version %d of %s is not supported.\n",
> -                       abi_version, uverbs_sys_path);
> -               return NULL;
> -       }
> +       return false;
> +}
> +
> +static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct qelr_device *dev;
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               qelr_err("%s() Fatal: fail allocate device for libqedr\n",
> -                        __func__);
> +       if (!dev)
>                 return NULL;
> -       }
>
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops qelr_dev_ops = {
>         .name = "qelr",
> -       .init_device = qelr_driver_init,
> +       .match_min_abi_version = QELR_ABI_VERSION,
> +       .match_max_abi_version = QELR_ABI_VERSION,
> +       .match_device = qedr_device_match,
> +       .alloc_device = qedr_device_alloc,
>         .uninit_device = qelr_uninit_device,
>         .alloc_context = qelr_alloc_context,
>         .free_context = qelr_free_context,
> diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
> index 655800ec3410fd..d9857aac70d745 100644
> --- a/providers/rxe/rxe.c
> +++ b/providers/rxe/rxe.c
> @@ -893,36 +893,40 @@ static void rxe_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
> -                                           int abi_version)
> +static bool rxe_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> -       struct rxe_device *dev;
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[16];
>
>         /* make sure it is a rxe device */
>         if (ibv_read_sysfs_file(uverbs_sys_path, "ibdev",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>
>         if (strncmp(value, "rxe", 3))
> -               return NULL;
> +               return false;
> +
> +       return true;
> +}
>
> +static struct verbs_device *rxe_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct rxe_device *dev;
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr,
> -                       "rxe: Fatal: couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->abi_version = abi_version;
> +       dev->abi_version = sysfs_dev->abi_ver;
>
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops rxe_dev_ops = {
>         .name = "rxe",
> -       .init_device = rxe_driver_init,
> +       .match_min_abi_version = 0,
> +       .match_max_abi_version = INT_MAX,
> +       .match_device = rxe_device_match,
> +       .alloc_device = rxe_device_alloc,
>         .uninit_device = rxe_uninit_device,
>         .alloc_context = rxe_alloc_context,
>         .free_context = rxe_free_context,
> diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
> index 75b9296c6e24e3..9bcf2ddd172afb 100644
> --- a/providers/vmw_pvrdma/pvrdma_main.c
> +++ b/providers/vmw_pvrdma/pvrdma_main.c
> @@ -169,64 +169,49 @@ static void pvrdma_uninit_device(struct verbs_device *verbs_device)
>         free(dev);
>  }
>
> -static struct pvrdma_device *pvrdma_driver_init_shared(
> -                                               const char *uverbs_sys_path,
> -                                               int abi_version)
> +static bool pvrdma_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> -       struct pvrdma_device *dev;
> +       const char *uverbs_sys_path = sysfs_dev->sysfs_path;
>         char value[8];
>         unsigned int vendor_id, device_id;
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>         vendor_id = strtol(value, NULL, 16);
>
>         if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>                                 value, sizeof(value)) < 0)
> -               return NULL;
> +               return false;
>         device_id = strtol(value, NULL, 16);
>
>         if (vendor_id != PCI_VENDOR_ID_VMWARE ||
>             device_id != PCI_DEVICE_ID_VMWARE_PVRDMA)
> -               return NULL;
> +               return false;
> +       return true;
> +}
>
> -       /* We support only a single ABI version for now. */
> -       if (abi_version != PVRDMA_UVERBS_ABI_VERSION) {
> -               fprintf(stderr, PFX "ABI version %d of %s is not "
> -                       "supported (supported %d)\n",
> -                       abi_version, uverbs_sys_path,
> -                       PVRDMA_UVERBS_ABI_VERSION);
> -               return NULL;
> -       }
> +static struct verbs_device *
> +pvrdma_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
> +{
> +       struct pvrdma_device *dev;
>
>         dev = calloc(1, sizeof(*dev));
> -       if (!dev) {
> -               fprintf(stderr, PFX "couldn't allocate device for %s\n",
> -                       uverbs_sys_path);
> +       if (!dev)
>                 return NULL;
> -       }
>
> -       dev->abi_version = abi_version;
> +       dev->abi_version = sysfs_dev->abi_ver;
>         dev->page_size   = sysconf(_SC_PAGESIZE);
>
> -       return dev;
> -}
> -
> -static struct verbs_device *pvrdma_driver_init(const char *uverbs_sys_path,
> -                                              int abi_version)
> -{
> -       struct pvrdma_device *dev = pvrdma_driver_init_shared(uverbs_sys_path,
> -                                                             abi_version);
> -       if (!dev)
> -               return NULL;
> -
>         return &dev->ibv_dev;
>  }
>
>  static const struct verbs_device_ops pvrdma_dev_ops = {
>         .name = "pvrdma",
> -       .init_device = pvrdma_driver_init,
> +       .match_min_abi_version = PVRDMA_UVERBS_ABI_VERSION,
> +       .match_max_abi_version = PVRDMA_UVERBS_ABI_VERSION,
> +       .match_device = pvrdma_device_match,
> +       .alloc_device = pvrdma_device_alloc,
>         .uninit_device = pvrdma_uninit_device,
>         .alloc_context = pvrdma_alloc_context,
>         .free_context  = pvrdma_free_context,
> --
> 2.7.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
