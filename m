From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 04/10] providers: Use the new match_device and
 allocate_device ops
Date: Mon, 25 Sep 2017 12:52:18 +0000
Message-ID: <BN3PR07MB25780CB209E98E5DD0CB22DEF87A0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <BN3PR07MB257813BD7D36694EBF97BA91F8650@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170924201053.GA31652@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924201053.GA31652-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER (for hf1.ko)" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq5hl2p70BpVqQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I changed the series like so:
>=20
> diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
> index 1297e8e16acee5..fa2be455edc93e 100644
> --- a/providers/qedr/qelr_main.c
> +++ b/providers/qedr/qelr_main.c
> @@ -223,7 +223,7 @@ static void qelr_free_context(struct ibv_context *ibc=
tx)
>         free(ctx);
>  }
>=20
> -static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sy=
sfs_dev)
> +static struct verbs_device *qelr_device_alloc(struct verbs_sysfs_dev *sy=
sfs_dev)
>  {
>         struct qelr_device *dev;
>=20
> @@ -235,11 +235,11 @@ static struct verbs_device *qedr_device_alloc(struc=
t verbs_sysfs_dev *sysfs_dev)
>  }
>=20
>  static const struct verbs_device_ops qelr_dev_ops =3D {
> -       .name =3D "qelr",
> +       .name =3D "qedr",
>         .match_min_abi_version =3D QELR_ABI_VERSION,
>         .match_max_abi_version =3D QELR_ABI_VERSION,
>         .match_table =3D hca_table,
> -       .alloc_device =3D qedr_device_alloc,
> +       .alloc_device =3D qelr_device_alloc,
>         .uninit_device =3D qelr_uninit_device,
>         .alloc_context =3D qelr_alloc_context,
>         .free_context =3D qelr_free_context,
>=20
> Jason

OK, thanks.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
