From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 18/20] IB/hfi1: Fix unbalanced braces around else
Date: Thu, 13 Apr 2017 09:03:43 +0300
Message-ID: <20170413060343.GC1343@mtr-leonro.local>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171717.10579.36147.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170409171717.10579.36147.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 09, 2017 at 10:17:18AM -0700, Dennis Dalessandro wrote:
> Add missing braces around else blocks in a few places to make checkpatch
> happy.
>
> Fixes: 7724105686e7 ("IB/hfi1: add driver files")
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/chip.c |    4 ++--
>  drivers/infiniband/hw/hfi1/init.c |    6 ++++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
> index c0cfcd1..19fab90 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -8147,10 +8147,10 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
>
>  		/* handle the interrupt(s) */
>  		sdma_engine_interrupt(sde, status);
> -	} else
> +	} else {
>  		dd_dev_err(dd, "SDMA engine %u interrupt, but no status bits set\n",
>  			   sde->this_idx);

Not relevant to this patch, but interesting to hear. Does such error
print produce dmesg storm in case of error or this is one time failure?

Thanks

> -
> +	}
>  	return IRQ_HANDLED;
>  }
>
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> index 838d3a8..e9b33c8 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -245,9 +245,10 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
>  			if (ctxt < kctxt_ngroups) {
>  				base = ctxt * (dd->rcv_entries.ngroups + 1);
>  				rcd->rcv_array_groups++;
> -			} else
> +			} else {
>  				base = kctxt_ngroups +
>  					(ctxt * dd->rcv_entries.ngroups);
> +			}
>  		} else {
>  			u16 ct = ctxt - dd->first_user_ctxt;
>
> @@ -256,9 +257,10 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
>  			if (ct < dd->rcv_entries.nctxt_extra) {
>  				base += ct * (dd->rcv_entries.ngroups + 1);
>  				rcd->rcv_array_groups++;
> -			} else
> +			} else {
>  				base += dd->rcv_entries.nctxt_extra +
>  					(ct * dd->rcv_entries.ngroups);
> +			}
>  		}
>  		rcd->eager_base = base * dd->rcv_entries.group_size;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljvFL8ACgkQ5GN7iDZy
WKfayw//cTnIz5j3UNU2YCQP509wyTvLArXHJYpJYNBRjo1I9DI9fMJuNw5jt0lG
8oXG40XpkMVBPzN90hPh5Mf3WGmHn4nwE4M8pqqt59jRWhyThNidv3IFzy35muHZ
sribIAaf2khk6D1yDCgFkFnzdkkLRMfQBZGmvUApZ1XT/du6151F0Omfz7FSvlHT
UqJ4WWlCfSV+KKybcZaOw/0MRunESc1uHDpKRGY2n2zFOL6cg+foO4OWlU1IfxnQ
m+7JFfK9gfFmUxeTNzgduL71AaQX7pB7ymVW9Fjm87S2RnH0CLtZRfJ8gAlEbrVE
AZsjnN9YvBgKM8m9R2Gl9AAoSTUOUT8aIRLK5k9DBIjp9yvaMlaZutGh/yzoSzqV
lThAlD+TPc6S1Evq5KdODD7L+7xLZuVSCYVKsGMyJvGkMAdduSsJayA5SeQyBtH1
F0WW900miebrErfiFTwwMEr7WXWfRtgVMUVEQSJqWjroLHRG2gGRrG+0afS5n1Al
n19S64ZHW5AflJvsYFAZZ1CTCVa5bnVb8mRoc6rAm+6ddZ5uxCZF5P5XKeuZcIXJ
eSvVX1LyhegPqiVqpWz0nGHPyWXkcU0NNHnp31mu6NhU4hmDfbgdNuYyQNMGmHww
WEpxG4L+VBK7AwMq4yGDJW/Sc0UZWBERVbwhWrFMtaCaUYJdnfo=
=DtVk
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
