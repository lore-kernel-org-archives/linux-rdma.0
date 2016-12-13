From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/rxe: Fix handling of erroneous WR
Date: Tue, 13 Dec 2016 14:20:35 +0200
Message-ID: <20161213122035.GA29435@mtr-leonro.local>
References: <1479285558-19627-1-git-send-email-leon@kernel.org>
 <1479285558-19627-3-git-send-email-leon@kernel.org>
 <5bd83de1-64d3-e5a9-1c58-cca52d89d64a@sandisk.com>
 <20161213074441.GE8204@mtr-leonro.local>
 <ba254635-c8f9-7b3b-eb73-60075d079542@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ba254635-c8f9-7b3b-eb73-60075d079542-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2016 at 09:04:44AM +0100, Bart Van Assche wrote:
> On 12/13/2016 08:44 AM, Leon Romanovsky wrote:
> > On Tue, Dec 13, 2016 at 08:03:03AM +0100, Bart Van Assche wrote:
> > > On 11/16/2016 09:39 AM, Leon Romanovsky wrote:
> > > > @@ -745,13 +746,17 @@ int rxe_requester(void *arg)
> > > >  	wqe->status =3D IB_WC_LOC_PROT_ERR;
> > > >  	wqe->state =3D wqe_state_error;
> > > >
> > > > -complete:
> > > > -	if (qp_type(qp) !=3D IB_QPT_RC) {
> > > > -		while (rxe_completer(qp) =3D=3D 0)
> > > > -			;
> > > > -	}
> > > > -
> > > > -	return 0;
> > > > +	/*
> > > > +	 * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
> > > > +	 * ---------8<---------8<-------------
> > > > +	 * ...Note that if a completion error occurs, a Work Completion
> > > > +	 * will always be generated, even if the signaling
> > > > +	 * indicator requests an Unsignaled Completion.
> > > > +	 * ---------8<---------8<-------------
> > > > +	 */
> > > > +	wqe->wr.send_flags |=3D IB_SEND_SIGNALED;
> > > > +	__rxe_do_task(&qp->comp.task);
> > > > +	return -EAGAIN;
> > >
> > > Hello Leon and Yonatan,
> > >
> > > Sorry for the late reply but I think setting IB_SEND_SIGNALED for WQE=
's
> > > reporting a completion error is wrong.
> >
> > I'm not clear about it. I didn't find in spec what to do with IB_SEND_S=
IGNALED
> > flag in case of error.
> >
> > According to spec:
> > 	"C10-91: The CI shall generate a CQE when a Work Request
> > 	completed under any of the following conditions:
> > 	=E2=80=A2 The Work Request completed in error"
>
> Hello Leon,
>
> To me that paragraph from the spec means that do_complete() is wrong. And
> once do_complete() is fixed, callers that set the WQE status to "error" no
> longer have to set IB_SEND_SIGNALED.

Thanks,
It looks like a right thing to do. Yonatan is handling it.

>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhP55IACgkQ5GN7iDZy
WKeLoRAAghlbzjyFrJdW+KraNpqgoxmUZVXkGvuapRThHf8+E/2vNsmpXSw6U2a+
nKomVJS+T4yUFsjZ5cjZW+2PAvijU8Q3z23HHbvu+k/KM2t/ZEdMG7ZTowk6LKdo
casLNW0I3PyV4JZrO7ExI1sCS1dcEYf0Q7qdZSGloFGnQ7YAHERlPYQtW4PNvlxj
6NoPy1M7fKC7II34AfYE8YXY/97fX8zPeeoZlWxLEv42Mq8XkHeqWOeat+bbK1lr
6TNHaZOTscAuRA5AbLy3CpGmxXcCFv6juv4eAKjJjXWe5sCj4MVM6mK6gmiCuDbi
FJFOuR6Bw6TKleZzh1PqjrHcpca1fLrIKhTm40J2sbyEgKhHILjhmPJy9aM5wVWh
zo6Y+k6qiK91MGX8ppt2dsWjodMzkrHmudL4pDIyK7UPUqMTh/RMh2wF5yBF4CM0
U5BKGNfolPUN0hkIzjCyEVF7gOdLIfltbu5dBoJJqNaGfFjsTHNpvt33E+UTlUwH
7Bsvg/TW10cAiFiP/UeEkMJKAnPgQZ2BFHEYNPSCIXeBRibClnq2x0cG0sy1iRxg
BidivUvhRjbsUh8GUQhHpUmqBHxhkwZgSzugRFIyr7QY/U5ryx6Eh3YWu5BknHyP
9ZdYFAX6LfNiXnogCk8Fe8uhh31wlddaqneIA/HxtYkWUIdB/xc=
=4/t+
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
