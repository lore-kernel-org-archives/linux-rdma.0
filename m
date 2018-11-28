From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 22:13:03 +0200
Message-ID: <20181128201303.GR4559@mtr-leonro.mtl.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
 <20181128200412.GP4559@mtr-leonro.mtl.com>
 <ddbbc8b5-3a32-4eea-cc02-b3211d3d47bb@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lbQeYSs6J2ITmUo7"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ddbbc8b5-3a32-4eea-cc02-b3211d3d47bb@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org


--lbQeYSs6J2ITmUo7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 02:07:29PM -0600, Steve Wise wrote:
>
>
> On 11/28/2018 2:04 PM, Leon Romanovsky wrote:
> > On Wed, Nov 28, 2018 at 01:08:05PM -0600, Steve Wise wrote:
> >>
> >> On 11/28/2018 12:26 PM, Leon Romanovsky wrote:
> >>> On Thu, Sep 13, 2018 at 10:19:21AM -0700, Steve Wise wrote:
> >>>> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft=
-rdma
> >>>> device to a netdev interface.
> >>>>
> >>>> EG:
> >>>>
> >>>> rdma link add rxe_eth0 type rxe dev eth0
> >>>> rdma link delete rxe_eth0
> >>>>
> >>>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> >>>> ---
> >>>>  rdma/link.c  | 106 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++
> >>>>  rdma/rdma.h  |   1 +
> >>>>  rdma/utils.c |   2 +-
> >>>>  3 files changed, 108 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/rdma/link.c b/rdma/link.c
> >>>> index 7a6d4b7e356d..d4f76b0ce11f 100644
> >>>> --- a/rdma/link.c
> >>>> +++ b/rdma/link.c
> >>>> @@ -14,6 +14,8 @@
> >>>>  static int link_help(struct rd *rd)
> >>>>  {
> >>>>  	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
> >>>> +	pr_out("Usage: %s link add NAME type TYPE dev DEV\n", rd->filename=
);
> >>> I suggest to rename "dev" to be "netdev", because we are using "dev" =
for
> >>> ib devices.
> >> Yea ok.
> >>
> >>>> +	pr_out("Usage: %s link delete NAME type TYPE\n", rd->filename);
> >>> Why do you need "type" for "delete" command?
> >> Because the type is used in the kernel to find the appropriate link
> >> ops.=A0 I could change the kernel side to search all types for the dev=
ice
> >> name to delete?=A0
> > I would say, yes.
> > It makes "delete" operation more natural.
> >
> > Thanks
>
> Perhaps.
>
> Note: 'ip link delete' takes a type as well...

According to man section, yes.
According to various guides, no.
https://docs.fedoraproject.org/en-US/Fedora/20/html/Networking_Guide/sec-Co=
nfigure_802_1Q_VLAN_Tagging_ip_Commands.html

Thanks

>
>

--lbQeYSs6J2ITmUo7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb/vbPAAoJEORje4g2clinnZkQAMMGc3WQrX9GINmbe1cvLIPg
XEv4SYjSWOeuR7qHqaapJsqK2un1CC05+aRNy0H/WzkUFOl5qryW0v8Nq+UVaRz5
kSUiZxwUC9UvWpw5w1AdH/KIPYKLiKfuT+wiP3lGye3YvgRM+1NeY45RDQ5m9PpE
RhHAzOJJx6QPU2hAbaA5nu1nZJ1gsUbTIHXgIcE/IILQfJ77DxqKs9BvIHjOH7Vs
zwLbx+mey+3KAk9A9mDEyaIslKLUga+P02z8iQxghGIDTvcFZDT9S3bEhrJbTBqF
KwJT23Hg4zo0VPLbLAno2j2PfGlNQrPB1FD7RAahYJ3EAs96QC0XibPjsWiVoHEs
G8jEsOL6SJAJUmqlqdhiAud2AiBjastbHbPf+j3RfxnGStLnixwpNKzM9eWnYZ8J
KQESAU7I401aFqWQqdtfxpIkrKbgyzxNbh8Cx6mWzAUNk5PxSEuGjSW3CjjitG5m
CMwTfcvYDT6//2ixU4Illtfqt3/oUNYgoEeYPcEYY2LrY75nNFXnFs3eQz1VkUtA
ebucEQBEiyRTu17p3eWbKCmWSutQGlSFTYbR/VU1lJq6wdb2vygbX3hOT88RgtWe
zZdppqDw/iogPxKXAlipQzgPfnndsQyQ6eLb0eEgSTAZ3nyn9m2Edid2kdnLL5X4
nVChUkHUcqXm5Uz+xoYX
=h4W5
-----END PGP SIGNATURE-----

--lbQeYSs6J2ITmUo7--
