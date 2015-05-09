From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB/core: Fix unaligned accesses
Date: Sat, 09 May 2015 00:18:58 -0400
Message-ID: <1431145138.2407.507.camel@redhat.com>
References: <1430660906-215424-1-git-send-email-david.ahern@oracle.com>
		 <554D0FBC.9090408@oracle.com> <1431141243.2407.481.camel@redhat.com>
	 <554D8856.5050201@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-7qPbg0yjp4p+M9RA69OL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554D8856.5050201-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-7qPbg0yjp4p+M9RA69OL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-08 at 22:08 -0600, David Ahern wrote:
> On 5/8/15 9:14 PM, Doug Ledford wrote:
> > On Fri, 2015-05-08 at 13:34 -0600, David Ahern wrote:
> >> >ping? I have addressed all of the comments; anything else holding up =
a
> >> >commit?
> > Please check Linus' latest kernel, this patch should be present.
> >
> > For that matter, check my pull request, this patch was listed there.
> >
> > Although I admit that there were reviewed by tags not added to it now
> > that I checked.  People reviewed v1/v2/v3 before you put out v4, but
> > that didn't get captured by patchworks and I forgot to add it.  Sorry
> > about that to the reviewers:-(
> >
>=20
> Ok. Every maintainer has a slightly different process; just want to=20
> check this off on my end.

Well, you can check it off because it *is* done.  However, it was
clearly in my git repo, so a simple check of my for-linus tag would have
shown it to be there.

To the people on list reading this:  For the next couple of months, I'm
going to be overworked as I take over this position while also
fulfilling my internal Red Hat responsibilities.  Red Hat has offered to
make this my full time position, but that doesn't mean I got to drop my
internal responsibilities immediately.  Until my replacement is
scheduled to start (July 1st), I'm working two jobs.  Please don't add
to that workload if you don't have to.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-7qPbg0yjp4p+M9RA69OL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVTYqyAAoJELgmozMOVy/dhdQP/0RwGlMyG8AuCgB0MZ8Q8/Tw
T6geysNIBFo+G1tlPVhYtL194dLFc4DKUjNzrtfoOFOvrZWkzUAb8qeeA5J9IPC2
9vDHBC11l4ldzwnnXES80S1MBjZbYfIzEkWR4u1ZT1zT+CEj+jgAXCPlKK7p2kOp
uAgWAgbN/tGa06Lp1pRPYsTH2pEBotX2YIVrYmeDY+0i5uvpZZ3KY2sk4Sfdngl9
PXyxHhE84dWFvOB+idTMPnaa1LH004OmmZCyUK6Cm9HlJ8tUpQ3Ubk7EQG4OiiUn
mvf80CzMvw3OUr5VjUNa4xoP+awnAIuoqQrba5Il5k67lqzknX5ZGrzeK/NND4yQ
iRNbfw6AEhYXls/3NU9d3PJxqkjGUpchFtkZcxA+/HtUh/UKacfxYJ5X7KSgOJim
XqiwBwgra4G7YoS8M+dwbMgfZYtQdlozrkQQcRb87jlwv013mreF0dWjSOuiktxy
FF6i7OmBr93AGjpPqoihyVQ994y+88DBNH0lddbZixfBaSN3+HklZIAnsZIKvg8I
57glnWv9+Pj19ugr3VjWnim74iWiGuYMRnaV1KWkY555/Lw0k4v1AJg9/TXDZeYC
fI0FQrne9tKd99hfNRNhLQSVXAn4+7OHD1qhgxNA4mq+QjGvjETsa5f7Dgs3gMRU
uGvHiwdq48X8GfZxHIEk
=sCq+
-----END PGP SIGNATURE-----

--=-7qPbg0yjp4p+M9RA69OL--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
