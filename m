From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] IB/hfi1: Clean up char devs and destage driver
Date: Fri, 13 May 2016 16:55:26 -0400
Message-ID: <e31e561d-8ad7-0e9f-a70c-b6c138de945a@redhat.com>
References: <20160512172500.11667.11333.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TaDk02MtUFJrOJax6HRPeEQsMdOCqUeOX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172500.11667.11333.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TaDk02MtUFJrOJax6HRPeEQsMdOCqUeOX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/12/2016 01:27 PM, Dennis Dalessandro wrote:
> Based on feedback we have received during review of recent hfi1 driver =
patches
> [1] we have decided to go ahead and remove the driver specific characte=
r devices
> for the UI and snoop/diag. Furthermore we remove the EPROM specific cod=
e since=20
> we have discovered a way to do this sort of stuff from user space.
>=20
> This series also removes the multi-purpose hfi1 cdev. We still maintain=
 a per
> hfi cdev (/dev/hfi1_x) but the /dev/hfi1 cdev has been removed.
>=20
> The write()/writev() problem [2] has been addressed in a patch series p=
reviously
> posted and resubmitted just prior to this.
>=20
> Since the hfi1 TODO file is complete and we have removed the parts of t=
he code
> which have drawn the most ire from the community list we believe it is =
now fair
> to let the driver move out of staging and into the mainline. We will wo=
rk with
> the community to get back the features that have been removed as separa=
te
> patches that can be more easily reviewed and commented on.
>=20
> We realize there is still an on-going effort to redo the verbs uAPI and=

> understand that may have an impact on our use of the /dev/hfi1_x cdevs =
and are
> looking forward to working with the community on that front. However we=
 do not
> believe that alone should hold the hfi1 driver in staging.
>=20
> There is one other aspect that has been called out, which is the
> driver's use of twsi code. We are currently working on a patch set to a=
ddress
> that which will hopefully be out soon, but want to get this on the mail=
ing list
> for comments rather than wait.
>=20
> [1] https://www.spinics.net/lists/linux-rdma/msg35319.html
> [2] https://www.spinics.net/lists/linux-rdma/msg34451.html
>=20
> This patch series applies on Doug's k.o/for-4.7 branch.
>=20
> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Dennis Dalessandro (6):
>       IB/hfi1: Remove multiple device cdev
>       IB/hfi1: Remove UI char device
>       IB/hfi1: Remove EPROM functionality from data device
>       IB/hfi1: Remove snoop/diag interface
>       IB/hfi1: Remove anti-pattern in cdev init
>       IB/hfi1: Move driver out of staging

I've delayed this until after the respin of this and the ioctl switch
series.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TaDk02MtUFJrOJax6HRPeEQsMdOCqUeOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNj8+AAoJELgmozMOVy/dWGIP/A2NoJvi2kf2wZwJWpjtC+nh
KouwECz8Ey1BDtGPK0Du9WszR2DLM95iACgDEsc4v8SlhLpdsN+5wfL3OZBdUj1F
UQxgHGfDoBuoblHjGIyg+Vb14W5JvLObkRLoJNYbgRQotux3lyK2pgJRDsKaQ0ou
cguhLlLNSObs4vAbzMn6H0JGYlRrenYxSOJu9WDFdcrsQHVYSkPhvaG7SzIS0Q6W
hGalt4jXhJPgwDKKEEEVfBIRlN6w1+VCf5yis7TqU55Rbf+Yw0Wl5zzqLl2j0idW
R7qOnY0hJtK0vo23VFUngYJ0d1fjcoOiUqAeQD5GCleINjrNkDhwnN4N6uDZSHmO
YcW9gNayUui2B1RrIxtR8bQFYjvp8M+o3QRHNplNK27UTxCWPjvrgeX8BihKeUq9
dO2JyU/jv4fcpV+k8h24qXkpKHTSS9e5z+bcTJFl7aqJK73a8FJhkGEjgQHvebwB
EFclhnrdSnXah/lc3Ud7oqR+sxagPTNNGwAE4fUDnRXLdegAF6RoJs2GIWTrLc+y
glHqMB13ViQyFSgEyN+BYCPqewKRS4SOmTB8TH//rKyxzh8BnmqriMvmoRAav1Iz
LrPipHVZ/Sj1yqg5QLeVyZPwXy37Wx6uAX0ZDxzb0yV46jtjIZM+phc/KaAguuIo
yZhtI7opou+7wOw53hpy
=paPW
-----END PGP SIGNATURE-----

--TaDk02MtUFJrOJax6HRPeEQsMdOCqUeOX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
