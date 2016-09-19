From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Mon, 19 Sep 2016 12:03:34 -0400
Message-ID: <02761057-02de-d3d1-13d9-ca64e4ee9556@redhat.com>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
 <20160919061558.GG3273@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mnds0thGEtNEh440sVxhqUNHeHv9efd0m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919061558.GG3273-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mnds0thGEtNEh440sVxhqUNHeHv9efd0m
Content-Type: multipart/mixed; boundary="mHN21BPgVwX4SF4RVIbu3uesrWpkcIxPB";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <02761057-02de-d3d1-13d9-ca64e4ee9556-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: VERBOSE flags
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160919061558.GG3273-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160919061558.GG3273-2ukJVAZIZ/Y@public.gmane.org>

--mHN21BPgVwX4SF4RVIbu3uesrWpkcIxPB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/19/2016 2:15 AM, Leon Romanovsky wrote:
> On Sun, Sep 18, 2016 at 04:35:37PM -0400, Doug Ledford wrote:

> Doug,
> The function pointers will cause us to create two similar functions
> (debug/regular) for every important function. It will leave to code
> duplication and/or introducing of new code to fill additional fields
> in returns to debug functions, so they will be able to print it.

That's situationally specific.  The original patch you posted that I
said no to is an example of where this wouldn't have been true.
Basically it all boils down to whether or not your debug code can be a
wrapper of your existing function or if it needs to be embedded in the
middle of it.  If the latter, then you are more likely to have code
duplication as you point out.  But, then refactoring code can help with
that problem too.

> I wanted to propose to use tracepoints to provide debug information in
> data paths. The tracepoints infrastructure uses hooks in the code with
> minimal impact on performance.

Yes, but one of the things you said before was "zero impact on normal
operations", but with tracepoints you just said "minimal impact".  So it
sounds like tracepoints don't meet your own initial requirements.  I'm
not against them, but utilizing the entry points allows for achievment
of the "zero impact" requirement.  And as Denny pointed out, some things
can't be done with tracepoints.  So, the final solution might be a mix
of different things including different entry points, tracepoints, and
some core infrastructure.

>=20
>> Then we can drop the CONFIG_*_DEBUG options out of all of the
>> drivers.  That would be my preference.  I don't want any compile time
>> options because you never will be running a debug kernel when you need=

>> it.  Per device, run time selectable so that you get 0 overhead in the=

>> normal case is what I would like to see.
>=20
> Great,
> We are aligned on this point, so do I. I see no reason in special compi=
led
> kernel or global module parameter to print debug prints for whole drive=
r.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--mHN21BPgVwX4SF4RVIbu3uesrWpkcIxPB--

--mnds0thGEtNEh440sVxhqUNHeHv9efd0m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX4AxWAAoJELgmozMOVy/dEs8P/RYsEQT/IqEZvIAao9Rk/ApG
ZQbWlRUXuGybxrSJooIpsriSP9thNC1DdTi79+6f0Pu0v8siFc53J0JkZ0V0Ntd6
3eHwpukLSSapz8Q0hbmSkHLfICnM/PPxlza8HSrPhgPcYZA6lVpLO8iNfqKVbBld
DGepI8Io56EBeZ8amQ9uvmZ0VyHfxKyu3FNQvsSpnYzSGls/H8zrzVcLEwFiUErd
VgA0Uvhq/t1SjH/2iFsAh/eiDToBvvS1kin0/QI0f9xqNjFoY8WEK80Jzyrn8qjN
N3ScXj/14b4w4HFKpcPPsu4piBBoAgewYhOzHGNY7MUa8C36upE9nsbpFUx1GrcE
imp5iaC3cgmNnwOnAIWWF2jciqe/Xo9pWAQuBN5sjVhrBj0lhVcArxpyvcAyml8B
2sLmHQoQToA68D3lnM2Jl0QxFen+d29KCC1LM9gppFXQIh7puSNowoOjqYMR0wA5
SJK1lUtFbmtZLyszwsW3o6VxoPpMQB4mxJUCUrJXhPxZICST9rOPY4MU3ZQhXdMj
wBQwEFFyIEOltAb+99bM0q9q7ElwkwypxP+6ZZHylrPl6lkByhkQ+e/8ohCpUIpt
69Z5/NJGAdqD578mgKwOafTRu0rEgL33ReF+1H9ZYPKmbxzduiFSz6MMUeA585WD
3P/w05jaggAcL46MPO+H
=Po+K
-----END PGP SIGNATURE-----

--mnds0thGEtNEh440sVxhqUNHeHv9efd0m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
