From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/9] IB: Use dma_virt_ops instead of duplicating it
Date: Thu, 12 Jan 2017 15:17:51 +0200
Message-ID: <20170112131751.GK20392@mtr-leonro.local>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
 <20170111005648.14988-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zOcTNEe3AzgCmdo9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170111005648.14988-7-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zOcTNEe3AzgCmdo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 04:56:45PM -0800, Bart Van Assche wrote:
> Additionally, switch from struct ib_dma_mapping_ops to struct
> dma_mapping_ops. Update the comments that referred to the source
> files removed by this patch.
>
> This patch eliminates one branch from every ib_dma_map_*() call.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/Makefile |   2 +-
>  drivers/infiniband/sw/rdmavt/dma.c    | 198 ----------------------------------
>  drivers/infiniband/sw/rdmavt/dma.h    |  53 ---------
>  drivers/infiniband/sw/rdmavt/mr.c     |   8 +-
>  drivers/infiniband/sw/rdmavt/vt.c     |   5 +-
>  drivers/infiniband/sw/rdmavt/vt.h     |   1 -
>  drivers/infiniband/sw/rxe/Makefile    |   1 -
>  drivers/infiniband/sw/rxe/rxe_dma.c   | 183 -------------------------------
>  drivers/infiniband/sw/rxe/rxe_loc.h   |   2 -
>  drivers/infiniband/sw/rxe/rxe_verbs.c |   3 +-
>  include/rdma/ib_verbs.h               | 117 +++-----------------
>  11 files changed, 25 insertions(+), 548 deletions(-)
>  delete mode 100644 drivers/infiniband/sw/rdmavt/dma.c
>  delete mode 100644 drivers/infiniband/sw/rdmavt/dma.h
>  delete mode 100644 drivers/infiniband/sw/rxe/rxe_dma.c
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--zOcTNEe3AzgCmdo9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh3gf8ACgkQ5GN7iDZy
WKcD+BAAzeXnhrppWnFGA8ZaCGAIbNYYbfIerZmKyxZDS8UWYex0IU9EJ4IJnAgj
i6kukVYZXHmjcMccL01zGqCIg/KjdeC+MJHppe1q/OYCzABNPQfyq8pSCV1Tp11T
ebbXScIMznqd01z+S7cAlYEoaAPdSKC5M3n/osJWveqR+W9Mxnr4tXCcqJnXshGp
l+hUFlekGGbSq8W0ibOgSNS4jcDhMr3ZYa8CZ8J30eXBdMrOfCyyuLBeUXaSatfI
Bh4MTuDze4hKnXUmx0TM20Q+3KTs2JIlJwPFE5A8RicKzCCzlirCR7cwWsYhUXh0
0obxS2kbFGytVir9iSklN/kLarUDd2bw0Lib3B217fy/dOIHW1mnp9odqNDAQXDl
xdQKwS0s1jOC4i20vIsRN8niRddAL9bz8CDRf0lPDYveRJwfuBRky3U+BjuL/NNp
dVCAZTWCGYj2Nayn2A8H0pDZME5UDurJzYFcYwnXw+Ny1kwLN5IiT+vjOeSKctRS
vEk2nM/fMRKz1UwvT/Q401anXERrquZWlXxiH7WAVtCzpAmXb8SJ0nuBBD1yEhtK
vQ0QcDhU3w5gktfmIXJdbnq9FRyzqONbZciC9yozYfiyIHfOmTH+ZFgkFmBDHsz8
AKxkohDBNa01ZEsr60dP6CLOodWcUPBUn7NWACmUwvJCcr34n68=
=Zg6l
-----END PGP SIGNATURE-----

--zOcTNEe3AzgCmdo9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
