From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Fri, 28 Jul 2017 15:42:52 -0400
Message-ID: <347f8b97-6b81-94a7-d71b-7023d2ed3dac@redhat.com>
References: <20170726053749.GV3259@mtr-leonro.local>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
 <20170726130350.GW3259@mtr-leonro.local>
 <a1abee42-58d2-aba6-bc56-9bf1830a4539@redhat.com>
 <20170728043233.GE13672@mtr-leonro.local>
 <1501260896.2593.18.camel@redhat.com>
 <20170728192930.GH13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bAS7hTH3L9EqqCVEtm8m0fUPCXTwsgGkk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728192930.GH13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bAS7hTH3L9EqqCVEtm8m0fUPCXTwsgGkk
Content-Type: multipart/mixed; boundary="kUaQ3wslItLwnXGC5jCLUcul4lgpuNWex";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Message-ID: <347f8b97-6b81-94a7-d71b-7023d2ed3dac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
References: <20170726053749.GV3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <a1abee42-58d2-aba6-bc56-9bf1830a4539-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170728043233.GE13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <1501260896.2593.18.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170728192930.GH13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170728192930.GH13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--kUaQ3wslItLwnXGC5jCLUcul4lgpuNWex
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/28/2017 3:29 PM, Leon Romanovsky wrote:
> On Fri, Jul 28, 2017 at 12:54:56PM -0400, Doug Ledford wrote:
>> On Fri, 2017-07-28 at 07:32 +0300, Leon Romanovsky wrote:

>> officially landed in their repo (unless there are review issues or
>> build failures that kick it back out), so I don't know why you would
>> expect different from me, but it's not gonna happen.
>=20
> I didn't expect anything different from you. What I expected from you i=
s
> to take a look on one patchset, decide go/no go, add to your branch, pu=
sh
> to github and 0-build (it very good in queuing jobs),

Right now 0day is taking 10-13hours to give me results.  If people are
queueing up test runs for every single patch (or small patch series),
then no wonder it's taking so long.  That's horribly inefficient.  There
is enough stuff for me to look at that I'm batching it up, applying
multiple series to a specific branch, and then doing the build testing
at the end for the whole group.  If I know I'm looking at 10 small patch
series in a given day, then I doubt you will ever get me to send them
all separately to 0day as that sort of behavior is likely precisely why
it's taking 10+ hours to get results right now.  If people *didn't* do
that, then the results might get in much sooner.

> announce and so on
> till all patches are tested and it can be forwarded to k.o.
>=20
> Sorry, if I expected too much.
>=20
>>
>>> As I said more than once, I'm fine with sequential work, I'm fine
>>> with
>>> the fact that not all my code is accepted, I'm fine with scheduled
>>> delays, but I'm not fine with silence.
>>
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>     GPG KeyID: B826A3330E572FDD
>>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 =
2FDD
>>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--kUaQ3wslItLwnXGC5jCLUcul4lgpuNWex--

--bAS7hTH3L9EqqCVEtm8m0fUPCXTwsgGkk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZe5PDAAoJELgmozMOVy/dOkwP/3aofh9x2z475k75NA9KFlWs
0qGmI6QGbds4IiBm3hGZUHy9JuU8gd/PDFYb5OLCIplWUUd12R3RcrsTInK0Kp8a
ozZPtg/oQCaAMA2yNqL/ncsbVp92FVTKt+eIioHYSFrBNGnHTAbD8AUpwmUOeM9D
hAwAwu1/M5SyG73lcQcqzuyusliP7uWnBCXlijGm4UzqVaSZuQE/d+m71F3uHFc8
SOA7vuBEEvfHlm3W19HfLNeLf2Ka9bFwf9g8Uim+Y3d4vzTGBPDzviSkSu/Wyt6n
bSM6lbzV0Ccs1UDtuDsqdyBsD+yn4fXM4LCFVZN1IF5tLnsL84aZP2+/fa8kP4G7
qP9ZMYyKJxMarAHq8G1vUlTLdnm41X0InwpDh8rXMSsZKQNz7egKl6k9bXssn14Y
alZ/XRcg8rIjLMIl/YNa1pNuoFVX7Axzvx/MLh3vQ7s4ggLQlcsmxixtKSmqbyrL
9et9LFxTI7U4ca7CjOBeWxPZBef2AZEYMWdo+mV6FTVYJo8QEXM7ObGvW+PDa+EV
zpt3ZxZX+niqcrrDRgCVpXiSHglqrJXviyVTOpB6/tGhDNVEru2fGrFSzj1498uq
Jj9/t6u3lFFEJW5E5vxzqskgyc72uloYKxqAqWZtI2l2gT9nHfUybYQ1HKXIVg6S
13srTTf+PsY97Dsb/cvv
=VADS
-----END PGP SIGNATURE-----

--bAS7hTH3L9EqqCVEtm8m0fUPCXTwsgGkk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
