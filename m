From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 04/10] providers: Use the new match_device and allocate_device ops
Date: Tue, 19 Sep 2017 16:29:17 -0500
Message-ID: <017a01d3318e$5947c870$0bd75950$@opengridcomputing.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com> <1505855931-4956-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ariel Elior' <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Adit Ranadive' <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "'moderated list:HF1 USERSPACE PROVIDER (for hf1.ko)'" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "'open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)'" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> 
> This is the first step to simplify the provider binding process.
> 
> Checking of the ABI version is hoisted into the core code, as are some
> of the common error messages.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---

<snip>

> diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
> index 492b3978995607..43c5a3c97bc864 100644
> --- a/providers/cxgb4/dev.c
> +++ b/providers/cxgb4/dev.c


<snip>

> @@ -462,22 +455,30 @@ found:
>  			fw_min, FW_MIN);
>  		fflush(stderr);
>  	}
> +	return true;
> +}
> 
> -	PDBG("%s found vendor %d device %d type %d\n",
> -	     __FUNCTION__, vendor, device,
> CHELSIO_CHIP_VERSION(hca_table[i].device >> 8));
> +static struct verbs_device *c4iw_device_alloc(struct verbs_sysfs_dev
> *sysfs_dev)
> +{
> +	struct c4iw_dev *dev;
> +	struct hca_ent *hca_ent = sysfs_dev->provider_data;
> +
> +	c4iw_page_size = sysconf(_SC_PAGESIZE);
> +	c4iw_page_shift = long_log2(c4iw_page_size);
> +	c4iw_page_mask = ~(c4iw_page_size - 1);
> 
>  	c4iw_page_size = sysconf(_SC_PAGESIZE);
>  	c4iw_page_shift = long_log2(c4iw_page_size);
>  	c4iw_page_mask = ~(c4iw_page_size - 1);


The above doesn't look right.

Other than this, the cxgb bits look ok.  Did you test it? 😊

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
