From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/13] staging/rdma/hfi1: adding per SDMA engine stats to
 hfistats
Date: Wed, 11 Nov 2015 11:22:15 +0300
Message-ID: <20151111082215.GZ18797@mwanda>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
 <1447227213-15122-10-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447227213-15122-10-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 02:33:30AM -0500, Jubin John wrote:
> @@ -8288,6 +8367,21 @@ static int init_cntrs(struct hfi1_devdata *dd)
>  				dd->ndevcntrs++;
>  				index++;
>  			}
> +		} else if (dev_cntrs[i].flags & CNTR_SDMA) {
> +			hfi1_dbg_early(
> +				       "\tProcessing per SDE counters chip enginers %u\n",
> +				       dd->chip_sdma_engines);
> +			dev_cntrs[i].offset = index;
> +			for (j = 0; j < dd->chip_sdma_engines; j++) {
> +				memset(name, '\0', C_MAX_NAME);

This patch is ok, but none of the memsets in this function are needed.
You could remove them in a later patch.

> +				snprintf(name, C_MAX_NAME, "%s%d",
> +					 dev_cntrs[i].name, j);
> +				sz += strlen(name);
> +				sz++;
> +				hfi1_dbg_early("\t\t%s\n", name);

We're basically just trying to calculate a bunch of strlen()s but there
is a lot of extra code to generate debug output.  It would be better to
remove it in a later patch.

> +				dd->ndevcntrs++;
> +				index++;
> +			}

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
