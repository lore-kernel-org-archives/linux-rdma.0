From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 09/10] hns: Use the generic modalias matcher
Date: Wed, 20 Sep 2017 11:28:11 +0800
Message-ID: <4349bfc1-61a0-8432-02f7-083bafee7769@huawei.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-10-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/9/20 5:18, Jason Gunthorpe Ð´µÀ:
> Use the new verbs infrastructure to match providers against modalias
> files. This changes the parse of the compatible string to one
> that is based on modalias instead of directly reading the compatible
> string.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/hns/hns_roce_u.c       | 52 +++++++---------------------------------
>  providers/hns/hns_roce_u.h       |  1 +
>  providers/hns/hns_roce_u_hw_v1.c |  1 +
>  3 files changed, 10 insertions(+), 44 deletions(-)
> 
> diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
> index 88389721811fce..c27212ac7fb603 100644
> --- a/providers/hns/hns_roce_u.c
> +++ b/providers/hns/hns_roce_u.c
> @@ -44,20 +44,11 @@
>  #define HID_LEN			15
>  #define DEV_MATCH_LEN		128
>  
> -struct hca_ent {
> -	const char *str;
> -	struct hns_roce_u_hw *data;
> -	int version;
> -};
> -
> -static const struct hca_ent acpi_table[] = {
> -	 {"acpi:HISI00D1:", &hns_roce_u_hw_v1, HNS_ROCE_HW_VER1},
> -	 {},
> -};
> -
> -static const struct hca_ent dt_table[] = {
> -	{"hisilicon,hns-roce-v1", &hns_roce_u_hw_v1, HNS_ROCE_HW_VER1},
> -	{},
> +static const struct verbs_match_ent hca_table[] = {
> +	VERBS_MODALIAS_MATCH("acpi*:HISI00D1:*", &hns_roce_u_hw_v1),
> +	VERBS_MODALIAS_MATCH("of:N*T*Chisilicon,hns-roce-v1C*", &hns_roce_u_hw_v1),
> +	VERBS_MODALIAS_MATCH("of:N*T*Chisilicon,hns-roce-v1", &hns_roce_u_hw_v1),
> +	{}
>  };
>  
>  static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
> @@ -178,43 +169,16 @@ static void hns_uninit_device(struct verbs_device *verbs_device)
>  	free(dev);
>  }
>  
> -static bool hns_device_match(struct verbs_sysfs_dev *sysfs_dev)
> -{
> -	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
> -	char			 value[128];
> -	int			 i;
> -
> -	if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
> -				value, sizeof(value)) > 0)
> -		for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
> -			if (!strcmp(value, acpi_table[i].str)) {
> -				sysfs_dev->provider_data =
> -				    (void *)&acpi_table[i];
> -				return true;
> -			}
> -
> -	if (ibv_read_sysfs_file(uverbs_sys_path, "device/of_node/compatible",
> -				value, sizeof(value)) > 0)
> -		for (i = 0; i < sizeof(dt_table) / sizeof(dt_table[0]); ++i)
> -			if (!strcmp(value, dt_table[i].str)) {
> -				sysfs_dev->provider_data = (void *)&dt_table[i];
> -				return true;
> -			}
> -
> -	return false;
> -}
> -
>  static struct verbs_device *hns_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
>  {
>  	struct hns_roce_device  *dev;
> -	const struct hca_ent *hca_ent = sysfs_dev->provider_data;
>  
>  	dev = calloc(1, sizeof(*dev));
>  	if (!dev)
>  		return NULL;
>  
> -	dev->u_hw = hca_ent->data;
> -	dev->hw_version = hca_ent->version;
> +	dev->u_hw = sysfs_dev->match->driver_data;
> +	dev->hw_version = dev->u_hw->hw_version;
>  	dev->page_size   = sysconf(_SC_PAGESIZE);
>  	return &dev->ibv_dev;
>  }
> @@ -223,7 +187,7 @@ static const struct verbs_device_ops hns_roce_dev_ops = {
>  	.name = "hns",
>  	.match_min_abi_version = 0,
>  	.match_max_abi_version = INT_MAX,
> -	.match_device = hns_device_match,
> +	.match_table = hca_table,
>  	.alloc_device = hns_device_alloc,
>  	.uninit_device = hns_uninit_device,
>  	.alloc_context = hns_roce_alloc_context,
> diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
> index dc8956af4f8fae..d0e2351fc7fc4c 100644
> --- a/providers/hns/hns_roce_u.h
> +++ b/providers/hns/hns_roce_u.h
> @@ -170,6 +170,7 @@ struct hns_roce_qp {
>  };
>  
>  struct hns_roce_u_hw {
> +	uint32_t hw_version;
>  	int (*poll_cq)(struct ibv_cq *ibvcq, int ne, struct ibv_wc *wc);
>  	int (*arm_cq)(struct ibv_cq *ibvcq, int solicited);
>  	int (*post_send)(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
> diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
> index 0de94e1fabd3d9..482eac90df2183 100644
> --- a/providers/hns/hns_roce_u_hw_v1.c
> +++ b/providers/hns/hns_roce_u_hw_v1.c
> @@ -829,6 +829,7 @@ out:
>  }
>  
>  struct hns_roce_u_hw hns_roce_u_hw_v1 = {
> +	.hw_version = HNS_ROCE_HW_VER1,
>  	.poll_cq = hns_roce_u_v1_poll_cq,
>  	.arm_cq = hns_roce_u_v1_arm_cq,
>  	.post_send = hns_roce_u_v1_post_send,
> 
Acked-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
