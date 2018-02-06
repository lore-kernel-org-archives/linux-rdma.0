From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/3] RDMA/hns: Fix a bug with modifying mac
 address
Date: Tue, 6 Feb 2018 08:53:38 -0700
Message-ID: <20180206155338.GG1288@mellanox.com>
References: <1517920459-93900-1-git-send-email-oulijun@huawei.com>
 <1517920459-93900-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517920459-93900-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 06, 2018 at 08:34:17PM +0800, Lijun Ou wrote:
> When modifying mac address, it will trigger hns_roce_del_gid
> function and can't delete the default gid matched the index
> because the attribute of gid is null.
> 
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>  drivers/infiniband/hw/hns/hns_roce_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index eb9a69f..6f39afb 100644
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -100,6 +100,7 @@ static int hns_roce_del_gid(struct ib_device *device, u8 port_num,
>  			    unsigned int index, void **context)
>  {
>  	struct hns_roce_dev *hr_dev = to_hr_dev(device);
> +	const struct ib_gid_attr zattr;

That is uninited stack memory, need a = {}

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
