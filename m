From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error
 handling paths
Date: Mon, 4 Mar 2019 08:44:19 +0200
Message-ID: <20190304064419.GB15253@mtr-leonro.mtl.com>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
 <332021c5-ab72-d54f-85c8-b2b12b76daed@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Zd8I2GZVcdxtyaG/"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <332021c5-ab72-d54f-85c8-b2b12b76daed@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Zd8I2GZVcdxtyaG/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 03, 2019 at 02:37:33PM -0800, John Hubbard wrote:
> On 3/3/19 1:52 AM, Artemy Kovalyov wrote:
> >
> >
> > On 02/03/2019 21:44, Ira Weiny wrote:
> > >
> > > On Sat, Mar 02, 2019 at 12:24:35PM -0800, john.hubbard@gmail.com wrot=
e:
> > > > From: John Hubbard <jhubbard@nvidia.com>
> > > >
> > > > ...
> > > > 3. Dead code removal: the check for (user_virt & ~page_mask)
> > > > is checking for a condition that can never happen,
> > > > because earlier:
> > > >
> > > > =A0=A0=A0=A0 user_virt =3D user_virt & page_mask;
> > > >
> > > > ...so, remove that entire phrase.
> > > >
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 bcnt -=3D min_t(size_t, npages << PAGE_=
SHIFT, bcnt);
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&umem_odp->umem_mutex);
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 for (j =3D 0; j < npages; j++, user_vir=
t +=3D PAGE_SIZE) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (user_virt & ~page_mask) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p +=3D PAGE_SIZE;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (page_to_phys(loc=
al_page_list[j]) !=3D p) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D =
-EFAULT;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 put_page(local_page_=
list[j]);
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> > > > -
> > >
> > > I think this is trying to account for compound pages. (ie page_mask c=
ould
> > > represent more than PAGE_SIZE which is what user_virt is being incrim=
ented by.)
> > > But putting the page in that case seems to be the wrong thing to do?
> > >
> > > Yes this was added by Artemy[1] now cc'ed.
> >
> > Right, this is for huge pages, please keep it.
> > put_page() needed to decrement refcount of the head page.
> >
>
> OK, thanks for explaining! Artemy, while you're here, any thoughts about =
the
> release_pages, and the change of the starting point, from the other part
> of the patch:

Your release pages code is right fix, it will be great if you prepare
proper and standalone patch.

Thanks

>
> @@ -684,9 +677,11 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp
> *umem_odp, u64 user_virt,
> 	mutex_unlock(&umem_odp->umem_mutex);
>
>  		if (ret < 0) {
> -			/* Release left over pages when handling errors. */
> -			for (++j; j < npages; ++j)
> -				put_page(local_page_list[j]);
> +			/*
> +			 * Release pages, starting at the the first page
> +			 * that experienced an error.
> +			 */
> +			release_pages(&local_page_list[j], npages - j);
>  			break;
>  		}
>  	}
>
> ?
>
> thanks,
> --
> John Hubbard
> NVIDIA
>

--Zd8I2GZVcdxtyaG/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcfMlDAAoJEORje4g2clin72MP/ibsjGMdgjy0b+1RJm1NeF5f
OtglTfABByBidkhy1S+YICCsf0inIiBAnm3bHGzHT7DycmnHLBLVmHvARo3HeHNS
NCCWvE5dNImmalxiu7CrMoeVhzLowBxXfLINxITC1TZr9+3nrJxRakh6p6tVVdYd
u2403inffoLuBuTT2f5f8sk/U9ogLOmkSF4S4z2VQxjz1S58BpclLlDDanIak+R+
ne4Lz6tFlnPBMbtXhzEucqbsEoielmh1I7bVtg05qtWqaVFFISiImq1qKTfrIvjR
S8VEoYF06uV+O7XCRMP5yvHLDijnTOCwwFHImGo3/JYLwWVFs8rkYK/y2XjKuqpZ
uo1UMyKJgpT1XTdRp19+iM9Bc9Sxk7fb+5WsCgyHTTKf+8E3u4sylASetKCCdZWy
GO10Wf6ZgveMk1z/BNiVjiHCQtkzS2weNNkFqKnfxUnrnNXH1oXVQxpqJg2Td9hA
9Y7miv0Q8mgsZbfNuYOzsry25cihN+RPQgzdnKOweNKuBNy83tQTuxRv6N3yszJo
xWunaSZOX9GU4IHmTRZi0LC8FNDY0M3PM3ISmRI1Q69SAfBFN2ACaF0hYTxE74iw
H6K46M2YF8DhHOV8TV/NjIh+x7PHBK9IXw3rQuPrE3FDeIrwwuif5uszJSEdS4jp
jHFOkAAWZh2EAc5wwMjc
=+eOE
-----END PGP SIGNATURE-----

--Zd8I2GZVcdxtyaG/--
