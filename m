From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 04/10] providers: Use the new match_device and
 allocate_device ops
Date: Sun, 24 Sep 2017 13:44:58 +0000
Message-ID: <BN3PR07MB257813BD7D36694EBF97BA91F8650@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER (for hf1.ko)" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
> index 0be4a8c82a1e05..4d1b92f40a413a 100644
> --- a/providers/qedr/qelr_main.c
> +++ b/providers/qedr/qelr_main.c
> @@ -227,53 +227,50 @@ static void qelr_free_context(struct ibv_context *i=
bctx)
>  	free(ctx);
>  }
>=20
> -static struct verbs_device *qelr_driver_init(const char *uverbs_sys_path=
,
> -					     int abi_version)
> +static bool qedr_device_match(struct verbs_sysfs_dev *sysfs_dev)
>  {
> +	const char *uverbs_sys_path =3D sysfs_dev->sysfs_path;
>  	char value[16];
> -	struct qelr_device *dev;
>  	unsigned int vendor, device;
>  	int i;
>=20
>  	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
>  				value, sizeof(value)) < 0)
> -		return NULL;
> +		return false;
>=20
>  	sscanf(value, "%i", &vendor);
>=20
>  	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
>  				value, sizeof(value)) < 0)
> -		return NULL;
> +		return false;
>=20
>  	sscanf(value, "%i", &device);
>=20
>  	for (i =3D 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i)
>  		if (vendor =3D=3D hca_table[i].vendor &&
>  		    device =3D=3D hca_table[i].device)
> -			goto found;
> +			return true;
>=20
> -	return NULL;
> -found:
> -	if (abi_version !=3D QELR_ABI_VERSION) {
> -		fprintf(stderr,
> -			"Fatal: libqedr ABI version %d of %s is not supported.\n",
> -			abi_version, uverbs_sys_path);
> -		return NULL;
> -	}
> +	return false;
> +}
> +
> +static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sy=
sfs_dev)
> +{
> +	struct qelr_device *dev;
>=20
>  	dev =3D calloc(1, sizeof(*dev));
> -	if (!dev) {
> -		qelr_err("%s() Fatal: fail allocate device for libqedr\n",
> -			 __func__);
> +	if (!dev)
>  		return NULL;
> -	}
>=20
>  	return &dev->ibv_dev;
>  }
>=20
>  static const struct verbs_device_ops qelr_dev_ops =3D {
>  	.name =3D "qelr",
> -	.init_device =3D qelr_driver_init,
> +	.match_min_abi_version =3D QELR_ABI_VERSION,
> +	.match_max_abi_version =3D QELR_ABI_VERSION,
> +	.match_device =3D qedr_device_match,
> +	.alloc_device =3D qedr_device_alloc,
>  	.uninit_device =3D qelr_uninit_device,
>  	.alloc_context =3D qelr_alloc_context,
>  	.free_context =3D qelr_free_context,

Please use qelr_ prefix for the functions.
There shouldn't be any qedr in this file except for a comment, maybe.

Other than that:
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
