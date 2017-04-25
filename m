From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Tue, 25 Apr 2017 20:56:50 +0300
Message-ID: <20170425175650.GR14088@mtr-leonro.local>
References: <20170424114733.GI14088@mtr-leonro.local>
 <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local>
 <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
 <20170424181351.GM14088@mtr-leonro.local>
 <CACaajQvf4fioVGoYqJexhOAbNFJPK0aYGbFW+52z3NFU9RKQcA@mail.gmail.com>
 <20170424183137.GA27506@obsidianresearch.com>
 <CACaajQt8WZrCWXN5-JGovCcknwV9TKiy5gntzNmTjpmdxf6PJg@mail.gmail.com>
 <20170424201033.GA28656@obsidianresearch.com>
 <CACaajQsMdNt++M=DStZ+27km04xNRRxpbcrSGS9av_qtUgPJHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8QM4kKE+nfbBA4vJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQsMdNt++M=DStZ+27km04xNRRxpbcrSGS9av_qtUgPJHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8QM4kKE+nfbBA4vJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 25, 2017 at 02:29:58PM +0300, Vasiliy Tolstov wrote:
> 2017-04-24 23:10 GMT+03:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:
> > Sorry, I ment the kernel API to userspace. The internal kernal API is
> > internally complete of course.
>
>
> =(. SO as i understand i need to know how mellanox userspace library
> interract with kernel and hardware ?

Despite the fact that this guide [1] lacks RDMA part, the concepts and
software interfaces can help you understand (reverse engineering)
Mellanox HW.

[1] http://www.mellanox.com/related-docs/user_manuals/Ethernet_Adapters_Programming_Manual.pdf

Thanks

>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org

--8QM4kKE+nfbBA4vJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj/jeIACgkQ5GN7iDZy
WKd8bA/+O4GpAO60iivNDm6yO8qY4LN6wkAmImU4msPpTx117ADx66YTA4dtv4RD
uQkkKlb0Xm04oAUIqmatwau129uyDptzG9K3ItRow/MsK71Ua05NcMD8xAb9nSUN
cdfT7z72ExOAcRDU/vkdJTO1ItuQ2Cdnk8xXyxYcLKhqhbTQQMfFzbRfEDC/gUn8
/EKiqESn3Kqezcksyf45gx3pdwFceEa5abuZDObWCWkoDt3mzFnP7DvsEo7MBgUJ
OUSstS0o1MQ0RsGcJ8rYScsjWxJ6ffMRY+vT5Yc40bRF/pheQbayfShMZN5GjgNi
rorWbbdU8InrJBDUj+MsTpefcnlYHo/hu+asGCHgY0p/XHiNPaUDeDqR3eSZmILM
F77gclRyuwn6sVIImxmwULEq0Yt8CyqhO2U4cHWbYS/u3XgNDEV0SCT85PLjMAD7
q8hc91Au0Kqdc4lpUkOeND6t4we+SewWZDJ8w319wtK15me7f2ZCKerFJxuImhB/
Cksj/w+x9ihky+lvzUNOylLPxlg3GFz04E6oqEjJUrcWR92Xkai5jWLCrWOTU9dg
I/tk8mGkY+49O7Uq288GepVqZV9F4hs6k55wl8PHHiTvcmalcR0+G7xa7AEh0uZj
Tw28C23YXtXPT3IxLv+HAUouwkTkqCuguX56mrw/wBoqiPYgKSI=
=uI4Z
-----END PGP SIGNATURE-----

--8QM4kKE+nfbBA4vJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
