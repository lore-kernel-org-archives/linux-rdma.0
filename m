From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/rxe: Cache dst in QP instead of getting
 it for each send
Date: Thu, 20 Apr 2017 21:43:48 +0300
Message-ID: <20170420184348.GT14088@mtr-leonro.local>
References: <20170420175556.8573-1-leon@kernel.org>
 <20170420175556.8573-2-leon@kernel.org>
 <20170420180114.GA6763@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="de1H0RjRxOSdb4we"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170420180114.GA6763-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--de1H0RjRxOSdb4we
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 20, 2017 at 12:01:14PM -0600, Jason Gunthorpe wrote:
> On Thu, Apr 20, 2017 at 08:55:56PM +0300, Leon Romanovsky wrote:
> > From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > In RC QP there is no need to resolve the outgoing interface
> > for each packet, as this does not change during QP life cycle.
>
> At first blush that seems wonky, shouldn't a QP act like a TCP socket
> and be able to migrate around when things are reconfigured?

I didn't find any support for it in the code. If I don't miss anything,
the RXE will shutdown QP and create it again.

Moni, am I right?

>
> IIRC there is some kind of dst cache scheme you should use instead?

It depends on the answer to the previous question. Let's assume that I'm wrong,
so yes, dst_set_expires will be the way to go. However the code assumes
that RC QP doesn't reconfigure.

Thanks

>
> Jason

--de1H0RjRxOSdb4we
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj5AWQACgkQ5GN7iDZy
WKffJw//YGPxOHaAi7h8zr81oH6O2rIF90xHx7Zcl8DLDrSxSaZN2m/aJZTX3E/A
KGSS9YG+4pA9KKHwj8BxR6MnHNqNsznJLCfVjuXjJb3/wvHLij/XDf/UIqaMA/Dw
OQtuwJhN7lZIma4ivENK0SlT1koCUaimGFpVqD5zP42wqEQmtwU34mcqPVVdEYxI
z7t3TWi4t8pL0ulG/H4Cit1yX1wbSuYn6kwWFi5c88DBkhbgmcB+4SV1Z8rxq8fW
pMd4uofSX+pao/dZdP7irisLl/f5V7ml8tlaWXIrssvvC+TUTKodeFIqmkvXrmJF
0b1NsJ94QlGN9jL3bjxJKEDNOvTMZmx4XFWpPboTxz2ubW+QqSPJ1kYELK6Gn5yv
ILgM0qce5z3ipHOENWUaNvTcSTZEj8n5woW715FnxNIQeyoDSy9EzxIVFYQERUai
4nyyYJWo9w3y9jdSjQIdy31YG+7p3KekxL2wtyqkNqy66a+bdS+FUwF/7EEFmHoM
f+gt9ODpaZVhsHGy5ZTCZ4diwu+hEOpFnXBK8ItrswwbjLjArEB8CL2F5Ap+08XL
1sYBBCcjPfxM5WqVoF6TlavEnePkIErfrJk/9UicIpfKhY1DxJupSYzf4zl1qT7e
1YnJnEZ6X03MK38DBDeIkDH974iSHci56VtCTF1jgpxV+tgBNao=
=8tYl
-----END PGP SIGNATURE-----

--de1H0RjRxOSdb4we--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
