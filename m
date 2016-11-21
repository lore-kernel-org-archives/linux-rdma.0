From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/mad: Fix an array index check
Date: Mon, 21 Nov 2016 15:17:51 -0500
Message-ID: <d5924c69-c052-84d3-06e3-b74ed8eb58d3@dev.mellanox.co.il>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
 <396b3fe2-6a84-efed-07de-3e6381009ad1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <396b3fe2-6a84-efed-07de-3e6381009ad1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/21/2016 1:21 PM, Bart Van Assche wrote:
> The array ib_mad_mgmt_class_table.method_table has MAX_MGMT_CLASS
> (80) elements. Hence compare the array index with that value instead
> of with IB_MGMT_MAX_METHODS (128). This patch avoids that Coverity
> reports the following:
> 
> Overrunning array class->method_table of 80 8-byte elements at element index 127 (byte offset 1016) using index convert_mgmt_class(mad_hdr->mgmt_class) (which evaluates to 127).
> 
> Fixes: commit b7ab0b19a85f ("IB/mad: Verify mgmt class in received MADs")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 40cbd6b..2395fe2 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -1746,7 +1746,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
>  			if (!class)
>  				goto out;
>  			if (convert_mgmt_class(mad_hdr->mgmt_class) >=
> -			    IB_MGMT_MAX_METHODS)
> +			    ARRAY_SIZE(class->method_table))
>  				goto out;
>  			method = class->method_table[convert_mgmt_class(
>  							mad_hdr->mgmt_class)];
> 

I think there is also similar thing in missing check in ib_register_mad_agent where:

        /*
         * Make sure MAD registration (if supplied)
         * is non overlapping with any existing ones
         */
        if (mad_reg_req) {
                mgmt_class = convert_mgmt_class(mad_reg_req->mgmt_class);
                if (!is_vendor_class(mgmt_class)) {
                        class = port_priv->version[mad_reg_req->
                                                   mgmt_class_version].class;
                        if (class) {
                                method = class->method_table[mgmt_class];

so here the class' method_table is also accessed without checking mgmt_class for range violation, right ?

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
