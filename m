From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 07/10] providers: Use the new common PCI
 matching infrastructure
Date: Sun, 24 Sep 2017 13:29:09 +0000
Message-ID: <BN3PR07MB2578333789DA041401297EC0F8650@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-8-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-8-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER (for hf1.ko)" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For qedr:
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

See the following question though, not directly related to the patch:

>  static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sy=
sfs_dev)
>  {
>  	struct qelr_device *dev;
> @@ -269,7 +238,7 @@ static const struct verbs_device_ops qelr_dev_ops =3D=
 {
>  	.name =3D "qelr",

Should this be the driver name or the library name?
The driver name is qedr and the library name is libqedr. It is usually abbr=
eviated to qelr.
I reckon that this should be the driver name (otherwise auto-load will fail=
?!).

>  	.match_min_abi_version =3D QELR_ABI_VERSION,
>  	.match_max_abi_version =3D QELR_ABI_VERSION,
> -	.match_device =3D qedr_device_match,
> +	.match_table =3D hca_table,
>  	.alloc_device =3D qedr_device_alloc,
>  	.uninit_device =3D qelr_uninit_device,
>  	.alloc_context =3D qelr_alloc_context,

Following the above, and still not directly related to the patch, is usage =
of both names.
I'll fix this after your submission to qelr_...

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
