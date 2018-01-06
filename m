From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 1/8] infiniband: fix ulp/opa_vnic/opa_vnic_encap.h
 kernel-doc for Sphinx
Date: Fri, 5 Jan 2018 16:38:03 -0800
Message-ID: <c7e46f04-ac60-448f-3e5d-e23fe7221c9a@wdc.com>
References: <5a50168d.4a9b620a.2c596.4dfd@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5a50168d.4a9b620a.2c596.4dfd-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/05/18 16:21, Randy Dunlap wrote:
> Use '\' escape characters in kernel-doc notation to eliminate a warning
> from Sphinx.
> 
> ../drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:243: WARNING: Inline strong start-string without end-string.
> 
> Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20171222.orig/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
> +++ linux-next-20171222/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
> @@ -239,7 +239,7 @@ struct opa_veswport_mactable_entry {
>    * @offset: mac table starting offset
>    * @num_entries: Number of entries to get or set
>    * @mac_tbl_digest: mac table digest
> - * @tbl_entries[]: Array of table entries
> + * @tbl_entries\[\]: Array of table entries
>    *
>    * The EM sends down this structure in a MAD indicating
>    * the starting offset in the forwarding table that this

Wouldn't it be better to fix the toolchain such that it escapes Sphinx 
metacharacters in kernel-doc headers instead of modifying the source 
code with patches like the above one?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
