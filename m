From: "Kershner, David A" <David.Kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 10/22] staging: unisys: visorbus: Make use of the new
 sg_map helper function
Date: Fri, 14 Apr 2017 16:07:14 +0000
Message-ID: <CY4PR07MB317691139A5B2F902CDA9B0EF0050__2770.85354687205$1492186067$gmane$org@CY4PR07MB3176.namprd07.prod.outlook.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-11-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492121135-4437-11-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <linaro-mm-sig-cunTk1MwBs8@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Logan Gunthorpe [mailto:logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org]
...
> Subject: [PATCH 10/22] staging: unisys: visorbus: Make use of the new
> sg_map helper function
>=20
> Straightforward conversion to the new function.
>=20
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>

Can you add Acked-by for this patch?=20

Acked-by: David Kershner <david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>

Tested on s-Par and no problems.=20

Thanks,
David Kershner

> ---
>  drivers/staging/unisys/visorhba/visorhba_main.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c
> b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 0ce92c8..2d8c8bc 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -842,7 +842,6 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct
> scsi_cmnd *scsicmd)
>  	struct scatterlist *sg;
>  	unsigned int i;
>  	char *this_page;
> -	char *this_page_orig;
>  	int bufind =3D 0;
>  	struct visordisk_info *vdisk;
>  	struct visorhba_devdata *devdata;
> @@ -869,11 +868,14 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp,
> struct scsi_cmnd *scsicmd)
>=20
>  		sg =3D scsi_sglist(scsicmd);
>  		for (i =3D 0; i < scsi_sg_count(scsicmd); i++) {
> -			this_page_orig =3D kmap_atomic(sg_page(sg + i));
> -			this_page =3D (void *)((unsigned long)this_page_orig |
> -					     sg[i].offset);
> +			this_page =3D sg_map(sg + i, SG_KMAP_ATOMIC);
> +			if (IS_ERR(this_page)) {
> +				scsicmd->result =3D DID_ERROR << 16;
> +				return;
> +			}
> +
>  			memcpy(this_page, buf + bufind, sg[i].length);
> -			kunmap_atomic(this_page_orig);
> +			sg_unmap(sg + i, this_page, SG_KMAP_ATOMIC);
>  		}
>  	} else {
>  		devdata =3D (struct visorhba_devdata *)scsidev->host-
> >hostdata;
> --
> 2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
