From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 20:27:07 +0300
Message-ID: <20180326172707.GQ1877@mtr-leonro.local>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <8d788e10-c170-9b94-09f0-98515fdd5bac@gmail.com>
 <783e600a-9296-8ea0-003e-59e48fd5234b@opengridcomputing.com>
 <20180326150826.GH1877@mtr-leonro.local>
 <09f5080f-04d2-3b5e-74fd-7aba85516097@opengridcomputing.com>
 <20180326170647.GL1877@mtr-leonro.local>
 <6c376ad8-7b42-8b13-1eba-328fecd0e3bd@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gw4vLALk08fVJy3V"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c376ad8-7b42-8b13-1eba-328fecd0e3bd@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--gw4vLALk08fVJy3V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2018 at 12:13:53PM -0500, Steve Wise wrote:
>
>
> On 3/26/2018 12:06 PM, Leon Romanovsky wrote:
> > On Mon, Mar 26, 2018 at 10:24:25AM -0500, Steve Wise wrote:
> >>
> >> On 3/26/2018 10:08 AM, Leon Romanovsky wrote:
> >>> On Mon, Mar 26, 2018 at 09:55:46AM -0500, Steve Wise wrote:
> >>>> On 3/26/2018 9:44 AM, David Ahern wrote:
> >>>>> On 3/26/18 8:30 AM, Steve Wise wrote:
> >>>>>> On 3/26/2018 9:17 AM, David Ahern wrote:
> >>>>>>> On 2/27/18 9:07 AM, Steve Wise wrote:
> >>>>>>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
> >>>>>>>> index 5809f70..e55205b 100644
> >>>>>>>> --- a/rdma/rdma.h
> >>>>>>>> +++ b/rdma/rdma.h
> >>>>>>>> @@ -18,10 +18,12 @@
> >>>>>>>>  #include <libmnl/libmnl.h>
> >>>>>>>>  #include <rdma/rdma_netlink.h>
> >>>>>>>>  #include <time.h>
> >>>>>>>> +#include <net/if_arp.h>
> >>>>>>>>
> >>>>>>>>  #include "list.h"
> >>>>>>>>  #include "utils.h"
> >>>>>>>>  #include "json_writer.h"
> >>>>>>>> +#include <rdma/rdma_cma.h>
> >>>>>>>>
> >>>>>>> did you forget to add rdma_cma.h? I don't see that file in my rep=
o.
> >>>>>> It is provided by the rdma-core package, upon which rdma tool now
> >>>>>> depends for the rdma_port_space enum.
> >>>>>>
> >>>>> You need to add a check for the package, and only build rdma if that
> >>>>> package is installed. See check_mnl in configure for an example.
> >>>> Ok, that makes sense.
> >>> IMHO, better solution will be to copy those files to iproute2.
> >> Hey Leon,
> >>
> >> Why is it better in your opinion?=A0 My gut tells me adding rdma_cma.h=
 to
> >> iproute2 means more uabi type syncing.
> > Making rdmatool be dependant on rdma-core will require that distributio=
ns
> > will update their specs to install rdma-core as a dependency for every
> > iprotue2 install.
> >
> > The rdma-core dependency makes sense for RDMA users, but doesn't for mo=
st of
> > the iproute2 users.
>
> I'm fuzzy on the details of distro packaging, but David's suggestion is
> that rdmatool wouldn't get built if rdma-core isn't present. But
> everything else would.=A0 Just like it does not get built if libmnl is not
> installed.=A0 For pre-built rpms, the rdma-core would have to be present.=
=A0
>
> I'm ok pulling it in, I'm just trying to understand. :)
>

Distros supply pre-built packages, for example Fedora's RPM:
https://rpmfind.net/linux/RPM/fedora/27/x86_64/i/iproute-4.12.0-3.fc27.x86_=
64.html
It requires that libmnl will be installed. Once rdmatool will need
rdma-core, it will pulled in too.

BTW, don't forget to change header's guards (ifdef/defne ..), see
rdma_netlink.h as an example.


> Steve.
>
>
>
>

--gw4vLALk08fVJy3V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq5LWsACgkQ5GN7iDZy
WKd0NxAArA8jdm/y9V7WNxpDoCLmPzeq3j2XPf1beSNzC8TCLuhnhDa9Z+1S/c+0
oX//i1b7JY5VO5s2FqjU7ncKh1H7x9KTBzJs8P0qCCc74t/jpDvBJ5cQW2g+9Qjr
exB5iqrLqzR8SiXf6Qr0rbTyUU9Mun86NSksCV2/WIdr7T5af/qzbZMBifMqrSXS
saBwJ0mMAP46dZ3IcbtGnCoJlete3K2RzCBpe9j3cB7M9n2NvmgzTlpoqFKTbZ2I
1BRCvIjYzsgAROVyyyqSsxRcwTJlWuhxdbpBZNnEgkuwKyQ29qJX01xWxqrK9B6u
WJIkrMxoqhSl7q5bzympqeulGQSCkLX6dH3xS7C4d1pomoV+X+hSJtvnOCQ/kMiD
T9YRZDZTnfQATHAa+qQtMlG1e0B+CuS8ok46F3XiEKlWHpvbkK7lVih3BhqMhGf+
9Hlvmnd3yaHCn+gjOhQSKBKZ9lfizwdnpX5ZSTUo77WyZZRmmAojiJOycuxDAbWD
CR09Smp7Rd43I3HXrV88qdiJgdQVGxe+zbqOVSCVyIg0f28n/p7gExbk/F7L9L+f
V41fgTHzdEEhAeAun/OFu1U2gsjjgZCcH4OlkKf9nbwBb5oV4Mw7D7WVVdQngXmx
q4Dwz6sBW9HvY0fWD/NO7GanfO0YwFAxuSOOEWdJqEehL61XOoI=
=9Sks
-----END PGP SIGNATURE-----

--gw4vLALk08fVJy3V--
