From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband/qedr: Potential null ptr dereference of qp
Date: Tue, 25 Dec 2018 06:26:10 +0200
Message-ID: <20181225042610.GC10329@mtr-leonro.mtl.com>
References: <20181224182445.21256-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181224182445.21256-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 24, 2018 at 12:24:45PM -0600, Aditya Pakki wrote:
> idr_find() may fail and return a NULL pointer. The fix checks the
> return value of the function and returns an error in case of NULL.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> index 505fa3648762..93b16237b767 100644
> --- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> +++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> @@ -492,6 +492,8 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>  	int i;
>
>  	qp = idr_find(&dev->qpidr.idr, conn_param->qpn);
> +	if (unlikely(!qp))
> +		return -EINVAL;

As was already pointed, qedr is racy in their accesses to idr_find() and
NULL pointer is less worry about their IDR code.

>
>  	laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
>  	raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
> --
> 2.17.1
>

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcIbFiAAoJEORje4g2clinIpQP/jIB2bXORjzOzylSYEO/qpXb
byJfdtJmObMHWtEc7po5slq+CxFMcQm1sOtLjocJIpEdfDoZle1eSoyxgQGY0+dg
rt67ROoMHdiNxXqB5yPJvDdQHBT9/BBBtat5smuVAUxWGXGkpEz9ELI1J8OfaX1B
1GqkgZ10rIztXOc1xlkS9FyjThOtdScsXXKGz+JR6vKYMIybDlTLzOYnIwPtDw9o
45tyn15vKyah5SRqrSFL/cKpABbOjR8IW3qWR5TvJ46zmPewdO0VPs0NO27Hx+mn
I/kZ4xhR8MPYfYsruOAsOBRrlej25T9BPpc3SufZjfA7U3yqIdPnkJI5MznfDS/x
yiWhd9kmQXBSoeu5Ro/gXxltoVSrby4aVtoRMPSKhBGPixE0MvT7kIhlVa8ig2Of
BbAUsH6uhkmT6pFABS+xsPOt5xLEjEgHpJIjV1ceij165OfnBgRUUSz3nmDlZLaz
QYywBmIl1pAhzDb7KXHMvMYFeaKZ4Y+c5FvAQxPhe2JutdeBrYmf9cr3B0rMaXw8
nasvx0QvzUu4wmVIiAayYfGIk2IsqgnpXjGCIRiY2kBP6mh2t92v+rzl1TbjPe1b
Dg571oyUPSU1TXGQt6Ao+sSb6aEbYO/b+fFNA/akpw5hTSKUFhSQAR8ttX5h8lHr
rmAqYGwNqbHp3IF75vVc
=XC4T
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
