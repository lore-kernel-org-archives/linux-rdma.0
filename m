From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next] iser-target: fix error return code in
 isert_connect_request()
Date: Tue, 23 Apr 2013 14:16:39 -0700
Message-ID: <1366751799.13769.27.camel@haakon3.risingtidesystems.com>
References: <CAPgLHd8xrcHNEYOYZ6y6in=oEmkDegKtf_yZa_sF93sHTwp-rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd8xrcHNEYOYZ6y6in=oEmkDegKtf_yZa_sF93sHTwp-rQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, yongjun_wei@trendmicro.com.cn, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-04-19 at 13:13 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Merged into the initial iser-target commit in for-next-merge.

Thanks Wei!

--nab

>  drivers/infiniband/ulp/isert/ib_isert.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index f6f4f58..803b949 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -329,6 +329,7 @@ static struct isert_device *
>  isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
>  {
>  	struct isert_device *device;
> +	int ret;
>  
>  	mutex_lock(&device_list_mutex);
>  	list_for_each_entry(device, &device_list, dev_node) {
> @@ -342,16 +343,17 @@ isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
>  	device = kzalloc(sizeof(struct isert_device), GFP_KERNEL);
>  	if (!device) {
>  		mutex_unlock(&device_list_mutex);
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	INIT_LIST_HEAD(&device->dev_node);
>  
>  	device->ib_device = cma_id->device;
> -	if (isert_create_device_ib_res(device)) {
> +	ret = isert_create_device_ib_res(device);
> +	if (ret) {
>  		kfree(device);
>  		mutex_unlock(&device_list_mutex);
> -		return NULL;
> +		return ERR_PTR(ret);
>  	}
>  
>  	device->refcount++;
> @@ -434,8 +436,10 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>  	}
>  
>  	device = isert_device_find_by_ib_dev(cma_id);
> -	if (!device)
> +	if (IS_ERR(device)) {
> +		ret = PTR_ERR(device);
>  		goto out_rsp_dma_map;
> +	}
>  
>  	isert_conn->conn_device = device;
>  	isert_conn->conn_pd = device->dev_pd;
> 
