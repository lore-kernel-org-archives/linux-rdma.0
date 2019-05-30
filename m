From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH][next] IB/hfi1: Use struct_size() helper
Date: Thu, 30 May 2019 14:30:01 -0400
Message-ID: <1f382255-fdce-1f3d-d336-c36b09116c7e@intel.com>
References: <20190529151528.GA24148@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529151528.GA24148@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/29/2019 11:15 AM, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace the following form:
> 
> sizeof(struct opa_port_status_rsp) + num_vls * sizeof(struct _vls_pctrs)
> 
> with:
> 
> struct_size(rsp, vls, num_vls)
> 
> and so on...
> 
> Also, notice that variable size is unnecessary, hence it is removed.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/infiniband/hw/hfi1/mad.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index 4228393e6c4c..184dba3c2828 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -2744,8 +2744,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
>   	u16 link_width;
>   	u16 link_speed;
>   
> -	response_data_size = sizeof(struct opa_port_status_rsp) +
> -				num_vls * sizeof(struct _vls_pctrs);
> +	response_data_size = struct_size(rsp, vls, num_vls);
>   	if (response_data_size > sizeof(pmp->data)) {
>   		pmp->mad_hdr.status |= OPA_PM_STATUS_REQUEST_TOO_LARGE;
>   		return reply((struct ib_mad_hdr *)pmp);
> @@ -3014,8 +3013,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
>   	}
>   
>   	/* Sanity check */
> -	response_data_size = sizeof(struct opa_port_data_counters_msg) +
> -				num_vls * sizeof(struct _vls_dctrs);
> +	response_data_size = struct_size(req, port[0].vls, num_vls);
>   
>   	if (response_data_size > sizeof(pmp->data)) {
>   		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
> @@ -3232,8 +3230,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
>   		return reply((struct ib_mad_hdr *)pmp);
>   	}
>   
> -	response_data_size = sizeof(struct opa_port_error_counters64_msg) +
> -				num_vls * sizeof(struct _vls_ectrs);
> +	response_data_size = struct_size(req, port[0].vls, num_vls);
>   
>   	if (response_data_size > sizeof(pmp->data)) {
>   		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
> 

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
