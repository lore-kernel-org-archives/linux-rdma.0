From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/8] IB/mlx5/hmm: add mlx5 HMM device initialization and
 callback v3.
Date: Tue, 21 Jul 2015 11:14:59 -0400 (EDT)
Message-ID: <1450090324.1616771.1437491699456.JavaMail.zimbra@redhat.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com> <1437159665-6612-7-git-send-email-jglisse@redhat.com> <55AE2431.20105@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AE2431.20105-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 17/07/2015 22:01, J=C3=A9r=C3=B4me Glisse wrote:
> > @@ -151,10 +151,11 @@ int ib_umem_odp_get(struct ib_ucontext *conte=
xt,
> > struct ib_umem *umem)
> >  		context->ib_mirror =3D ib_mirror_ref(ib_mirror);
> >  	}
> >  	mutex_unlock(&ib_device->hmm_mutex);
> > -	umem->odp_data.ib_mirror =3D ib_mirror;
> > +	umem->odp_data->ib_mirror =3D ib_mirror;
> > =20
> >  	down_write(&ib_mirror->umem_rwsem);
> > -	rbt_ib_umem_insert(&umem->odp_data->interval_tree, &mirror->umem_=
tree);
> > +	rbt_ib_umem_insert(&umem->odp_data->interval_tree,
> > +			   &ib_mirror->umem_tree);
> >  	up_write(&ib_mirror->umem_rwsem);
> > =20
> >  	mmput(mm);
> > @@ -163,7 +164,7 @@ int ib_umem_odp_get(struct ib_ucontext *context=
, struct
> > ib_umem *umem)
> > =20
> >  void ib_umem_odp_release(struct ib_umem *umem)
> >  {
> > -	struct ib_mirror *ib_mirror =3D umem->odp_data;
> > +	struct ib_mirror *ib_mirror =3D umem->odp_data->ib_mirror;
> > =20
> >  	/*
> >  	 * Ensure that no more pages are mapped in the umem.
>=20
> It doesn't look like this code would have compiled before this patch,
> and as far as I can see the previous patch removed the #error line.
> Could you make sure all of the patches build correctly? You could use
> tools/testing/ktest for instance.
>=20

This is a rebase error. But the #error is there for a purpose the HMM
would not work mid way so if anyone if bisecting up through that i woul=
d
rather error out at compilation.

J=C3=A9r=C3=B4me
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
