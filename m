From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 12/23] staging/rdma/hfi1: Macro code clean up
Date: Tue, 27 Oct 2015 17:19:10 +0900
Message-ID: <20151027081910.GA25171@kroah.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
 <1445869729-7507-13-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445869729-7507-13-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 26, 2015 at 10:28:38AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Clean up the context and sdma macros and move them to a more logical place in
> hfi.h
> 
> Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/hfi.h | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
> index a35213e9b500..41ad9a30149b 100644
> --- a/drivers/staging/rdma/hfi1/hfi.h
> +++ b/drivers/staging/rdma/hfi1/hfi.h
> @@ -1104,6 +1104,16 @@ struct hfi1_filedata {
>  	int rec_cpu_num;
>  };
>  
> +/* for use in system calls, where we want to know device type, etc. */
> +#define fp_to_fd(fp) ((struct hfi1_filedata *)(fp)->private_data)
> +#define ctxt_fp(fp) (fp_to_fd((fp))->uctxt)
> +#define subctxt_fp(fp) (fp_to_fd((fp))->subctxt)
> +#define tidcursor_fp(fp) (fp_to_fd((fp))->tidcursor)
> +#define user_sdma_pkt_fp(fp) (fp_to_fd((fp))->pq)
> +#define user_sdma_comp_fp(fp) (fp_to_fd((fp))->cq)
> +#define notifier_fp(fp) (fp_to_fd((fp))->mn)
> +#define rb_fp(fp) (fp_to_fd((fp))->tid_rb_root)

Ick, no, don't do this, just spell it all out (odds are you will see tht
you can make the code simpler...)  If you don't know what "cq" or "pq"
are, then name them properly.

These need to be all removed.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
