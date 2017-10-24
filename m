From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V3 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Tue, 24 Oct 2017 18:28:36 +0300
Message-ID: <20171024152836.GJ16127@mtr-leonro.local>
References: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508851309-183263-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2017 at 09:21:44PM +0800, Lijun Ou wrote:
> This patch series add userspace library for hip08 RoCE driver. It will
> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>
> Change from V2:
> - Fix the spelling with referred
> - Eliminate the warning by travis-CI
>
> Change from V1:
> - Fix build warning due to the strange placement of fprintf
>

I created pull request, but Travis CI doesn't seem like working.
https://github.com/linux-rdma/rdma-core/pull/230

I'll try to restart it a little bit later.

Thanks

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnvXCQACgkQ5GN7iDZy
WKeYihAAyQ8B3H+sHjK+rmA4tQkiap4vCfRImaYKCNnVbj7SXiWSUon5g2Q6AExi
1kZ3jB4feCRJjYmfX/6w6HKcA8hstm3CCr7DUS8ln7VlItUu2EmdA3HPLKFA/Ung
sZfVZhmionhHf0aZdytNlbyGtLgcKHItqBo1z6qPf5FpKUrRE4RwSyW6KAqkgX5w
/0jLVYo0JkFlqg3kgmGLRvDbQuPZzhTLR7BEhiFQK790Eblj8joUr0q4yHcYX6ey
GavkQFmPd2aUbHE/VYrsgix0l1N1rlY0wpDuO2wGWUYjmO75nSt99mrjzUkp7Fy9
ujrsvowqMppS9ZpE/tHfwPQ/HWEBPqXGLhS7oLnekrzyufeGCCasjwW7JX0AzJ+J
OVG33KEGk6pG0FlVArq+6qifF86zlTZU4PwneUdzgVJa2Zc2vccxEHehhw5nG2jS
pjA5E6p5APl02QFoap8o8a3p0MoroEf7Q6mF+ZzA5WFkaJHr73M664Zr54dvpsHB
TgzcuNQkn7yBAnzIFVivtY5s1edBBYGyMaf8mwubITqIRerqdHnGhNZb5/NjUmad
ZcNnoPY63nuzgGK1wdJUabrh6bfKN6GdJD0Jo5FLEUqOWLfx/m4E53qOwoQJkOre
x/F5BMlBbkHmgojx5TTTXkfWXdwXSKSKD1BiTqaoFC0qgvB2wkk=
=zf4S
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
