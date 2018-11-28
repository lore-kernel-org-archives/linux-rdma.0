From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 22:04:12 +0200
Message-ID: <20181128200412.GP4559@mtr-leonro.mtl.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Jtds+vpI57xq70EV"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org


--Jtds+vpI57xq70EV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 01:08:05PM -0600, Steve Wise wrote:
>
>
> On 11/28/2018 12:26 PM, Leon Romanovsky wrote:
> > On Thu, Sep 13, 2018 at 10:19:21AM -0700, Steve Wise wrote:
> >> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-r=
dma
> >> device to a netdev interface.
> >>
> >> EG:
> >>
> >> rdma link add rxe_eth0 type rxe dev eth0
> >> rdma link delete rxe_eth0
> >>
> >> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> >> ---
> >>  rdma/link.c  | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  rdma/rdma.h  |   1 +
> >>  rdma/utils.c |   2 +-
> >>  3 files changed, 108 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/rdma/link.c b/rdma/link.c
> >> index 7a6d4b7e356d..d4f76b0ce11f 100644
> >> --- a/rdma/link.c
> >> +++ b/rdma/link.c
> >> @@ -14,6 +14,8 @@
> >>  static int link_help(struct rd *rd)
> >>  {
> >>  	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
> >> +	pr_out("Usage: %s link add NAME type TYPE dev DEV\n", rd->filename);
> > I suggest to rename "dev" to be "netdev", because we are using "dev" for
> > ib devices.
>
> Yea ok.
>
> >> +	pr_out("Usage: %s link delete NAME type TYPE\n", rd->filename);
> > Why do you need "type" for "delete" command?
>
> Because the type is used in the kernel to find the appropriate link
> ops.=A0 I could change the kernel side to search all types for the device
> name to delete?=A0

I would say, yes.
It makes "delete" operation more natural.

Thanks

--Jtds+vpI57xq70EV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb/vS8AAoJEORje4g2clinqpAQAIA8D5Ka2YlP2XXyaXhlENyB
DSNguCxkmoZiXGPc59ylKDlAUXFAYsX74Pip8VuqJb4ZPVLbtgdgFyxKk5WeZfZs
zRlD6iy3iOuhq8mQ15mpmvZg4Q6kizxsoEcxCsTMTsjEQX8JFoq2uoWOfKTVnxAK
5AQUP0M96hMmMi5NRtpIE6JwNwRO25rH+xpjEaOnOqwsS/R26MSaTNgG+Cf3W8L7
VHWZw2/hAKQE+1qrZ6l0dEVdzagOhaTIPZ1rVUT1dPPMg5tSTc3URm/tt0EZyxxk
gS+2ripDAlu1LKHwwcBeDMixhZbJFG1lq2yDJrZveAugtaaeYHjyT20clU0Pf2sT
jDlHTab4SSSGs3fWYdV8mb8ps/p9T6PVs3xpB9VgzQY7tmRc0zARSEIC0q73oiOG
dtQAgimsYltmvJsKwJdwxUs+Ix+abvgTRcFV7b9xeWNFE40kYN4vBfXjfyWuCcqZ
5PNqob2iZ6syu7f5mY7XAVkCcYZQ02vj6FTI6AG0gKokfZFY15264cfbYOm7uXbD
eOqoYMk1+L0ao8beqSJ0GEd6MOQuqsNOpg2j7ANEUc7V4MlOMUiM62y0Y5kxZpT+
TmbCR19JWleHGk/UEKpJ7YlVFkH6yAHW/h1IR0HThh0KLozG7hYs6fdxZZUWk816
bcLoQ0XnOGmU8PjIcMO/
=HVJ7
-----END PGP SIGNATURE-----

--Jtds+vpI57xq70EV--
