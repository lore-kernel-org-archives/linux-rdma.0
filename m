From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: NULL required to terminate attr array
Date: Wed, 10 May 2017 17:11:30 +0300
Message-ID: <20170510141130.GB1839@mtr-leonro.local>
References: <20170509210907.GA29717@oc1783850105.ibm.com>
 <20170510053543.GA1839@mtr-leonro.local>
 <20170510134030.GA28309@oc1783850105.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170510134030.GA28309-i3Uw2LK+iw9rGVE3K263K1aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 08:40:30AM -0500, Steven Roberts wrote:
>
> This patch fixes a kernel panic when loading the hfi driver as a dynamic module.Addressing this patch will make performance tweaking the driver as a loadable module possible.
>
> git diff | scripts/checkpatch.pl
> total: 0 errors, 0 warnings, 9 lines checked
>
> Your patch has no obvious style problems and is ready for submission.
>
> Signed-off-by: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>  drivers/infiniband/hw/hfi1/sysfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Did you use git format-patch to create this patch? There is no --- after
your Singed-off-by and it says me that the answer will be no.

Please use git send-email to send patches and not as a reply, and please
limit your commit message to 80 symbols per-line.

You also should check the patch with checkpatch.pl and not the output of
git diff.

I recommend you to read SubmittingPatches doc.

Thanks

>
> diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sys
> index 50d140d..2f3bbca 100644
> --- a/drivers/infiniband/hw/hfi1/sysfs.c
> +++ b/drivers/infiniband/hw/hfi1/sysfs.c
> @@ -196,7 +196,8 @@ static ssize_t cc_attr_store(struct kobject *kobj, struct at
>  };
>
>  static struct attribute *port_cc_default_attributes[] = {
> -       &cc_prescan_attr.attr
> +       &cc_prescan_attr.attr,
> +       NULL
>  };
>
>  static struct kobj_type port_cc_ktype = {
>

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkTH5IACgkQ5GN7iDZy
WKd4xA//ScCZ5lCTefcGIVavoV64U4j/5Y+//Y8uVKNVElfE/vUBp2XQhtwP/MdF
18P6AwUekNNU/UfLVo7QcsLHK/29R8kg/LMkGvo2mnfN9KNpQoML/5iY8kQn//BY
wjV4Qwh3q/G+2tWZhu8v0z5fHKY3RE2pJ7pNRDctoRc0Gc8LmhSRPSOH+KVfHYrN
/VPFK9wrSytOzP+fRjzN0ju9vyAgh5NHwrDliytDDcDOMNt11pkOCxTT4YFYfFyX
Wf0+tRicgfk1S/MZDruraBOyBPZQsp3tGC0ahPLFPwcbYLQUhFkMq1BaV+t+fF7r
wbij1qNWQHzBwKnUJXZE4s5wydOKGOnGCVR8N4gkO2uc4lt7ng07PspzguSdnCa6
EJzwjpULztbMguFssyJetkOZ61fhmeK1zdalGcuTr2zewN2dBHQj1FwdnoldUr0o
aqZkf+zp/lTDfJAZ1w49I5+9kK0yiErO3LXdp/nCdm5aPqZP7as4efVRj9RGfMN/
hg4bqj/E3X6IXMeyfLm+YbYVNDiTgT0qYAdhzB9mHdcClDa7dl0/N7jOEYjXE9MK
Bw+iS2PsFS6pktCcs9zTK4/UxVts9LHQG6Jn7BOt2mqGuGsZf4XHaHTkjJZH6qNF
4Pzq9ueWIqY0BXU1HLrkGfrPH+Iq0MxwPI8lYB/wva2Cumhn7hY=
=SMXs
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
