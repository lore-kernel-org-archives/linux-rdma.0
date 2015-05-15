From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 06/11] RDMA/ocrdma: Prevent allocation of DPP
 PDs if FW doesnt support it
Date: Fri, 15 May 2015 11:43:02 -0400
Message-ID: <1431704582.29187.2.camel@redhat.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
	 <1431762709-20740-7-git-send-email-selvin.xavier@avagotech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hWMe8hQXlTn2iQjSwOSV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-7-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-hWMe8hQXlTn2iQjSwOSV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2015-05-16 at 13:21 +0530, Selvin Xavier wrote:

> @@ -1468,10 +1471,8 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma=
_dev *dev)
> =20
>  	cmd->pd_count =3D dev->attr.max_pd - dev->attr.max_dpp_pds;
>  	status =3D ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> -	if (status)
> -		goto mbx_err;
>  	rsp =3D (struct ocrdma_alloc_pd_range_rsp *)cmd;
> -	if (rsp->pd_count) {
> +	if (!status && rsp->pd_count) {
>  		dev->pd_mgr->pd_norm_start =3D rsp->dpp_page_pdid &
>  					OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
>  		dev->pd_mgr->max_normal_pd =3D rsp->pd_count;
> @@ -1486,7 +1487,6 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_=
dev *dev)
>  	} else {
>  		return -ENOMEM;
>  	}
> -mbx_err:
>  	kfree(cmd);
>  	return status;
>  }

I didn't go into the file to make sure, but this looks like a memory
leak (in fact, it looks like a leak that always existed, specifically if
rsp->pd_count =3D=3D 0 then the else causes you to leave before the
kfree(cmd) and therefore you leak).  It's now been made worse because it
would now happen both when status !=3D 0 and when pd_count =3D=3D 0.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-hWMe8hQXlTn2iQjSwOSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVVhQGAAoJELgmozMOVy/dVfYP/R+pd8XFJxnwfQ+t42Ri8lZp
W8wC+uPy/3/TB+cswFh9XiDHYr2k9AYHfeKsqrbBKEGUbtHNqWN+jUtkmj/2uSEm
FDgp204nCxTDzEXI8DyyqRfYgD3nNy/HEpnmlUrwoRcU33/MMKEdF06bBqqqKnzt
p+VG7CstSBpMfwDLb+FeLWbYocNrh9WRUNMiuVNVgqs4hGH7CmzxnFhULe0kS5PI
jlOo93rHegNhaY7vfUy+0H7xdQRaf0isxXU6G/QCRZx/t0jstCFSid2PMQUJzCUW
EyuDl8EiSURn5YTcjbZLJK0+pyVb74eNL9BIXQ+fLBxHd3WjwKa5X7JoAvFrRFaU
emsvq3MvXfKeSlFr+xPkat7Io6XsdVnmb5hOQ/TEK9XFIXydMsWMNttRmo/86TEk
TS31VaAuph8T0XVyhXFYapLe+2brnM5b3L9gE81Bqkt1Mir/2ZW4IbFyLTYnF6Ip
sy1O8CYRbBG6Y0a5iTRH0ED1TekAFQopMkJPX0GmlLDcbB9vV8FMWBZFx9F8Tnsw
DIT49ihbWTP4FZ4+HaxS4mEKyCQ6iPHSPfCI9gS1epimVIx82jZM4zvdqXYd8WVY
9lwXo4OWWYnGDVYXLDnwV/riI2w/g5BmNg7xRzxqCg2BN4VFeym2XdO2M7i2Tq95
6XjL78MVOUUTpXWQbnIg
=FTf8
-----END PGP SIGNATURE-----

--=-hWMe8hQXlTn2iQjSwOSV--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
