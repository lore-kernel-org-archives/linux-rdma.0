From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH 6/8] IB/mlx5/hmm: add mlx5 HMM device initialization and
 callback v3.
Date: Tue, 21 Jul 2015 13:51:29 +0300
Message-ID: <55AE2431.20105@mellanox.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
 <1437159665-6612-7-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437159665-6612-7-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christophe Harle <charle@nvidia.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Shachar Raindel <raindel@mellanox.com>, Liran Liss <liranl@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 17/07/2015 22:01, J=C3=A9r=C3=B4me Glisse wrote:
> @@ -151,10 +151,11 @@ int ib_umem_odp_get(struct ib_ucontext *context=
, struct ib_umem *umem)
>  		context->ib_mirror =3D ib_mirror_ref(ib_mirror);
>  	}
>  	mutex_unlock(&ib_device->hmm_mutex);
> -	umem->odp_data.ib_mirror =3D ib_mirror;
> +	umem->odp_data->ib_mirror =3D ib_mirror;
> =20
>  	down_write(&ib_mirror->umem_rwsem);
> -	rbt_ib_umem_insert(&umem->odp_data->interval_tree, &mirror->umem_tr=
ee);
> +	rbt_ib_umem_insert(&umem->odp_data->interval_tree,
> +			   &ib_mirror->umem_tree);
>  	up_write(&ib_mirror->umem_rwsem);
> =20
>  	mmput(mm);
> @@ -163,7 +164,7 @@ int ib_umem_odp_get(struct ib_ucontext *context, =
struct ib_umem *umem)
> =20
>  void ib_umem_odp_release(struct ib_umem *umem)
>  {
> -	struct ib_mirror *ib_mirror =3D umem->odp_data;
> +	struct ib_mirror *ib_mirror =3D umem->odp_data->ib_mirror;
> =20
>  	/*
>  	 * Ensure that no more pages are mapped in the umem.

It doesn't look like this code would have compiled before this patch,
and as far as I can see the previous patch removed the #error line.
Could you make sure all of the patches build correctly? You could use
tools/testing/ktest for instance.
