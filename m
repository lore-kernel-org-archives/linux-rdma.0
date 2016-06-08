From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 8 Jun 2016 16:10:28 +0300
Message-ID: <20160608131028.GK3663@leon.nu>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <20160603052539.GB31196@infradead.org>
 <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw@mail.gmail.com>
 <1465379530.5365.91.camel@haakon3.risingtidesystems.com>
 <20160608104123.GJ3663@leon.nu>
 <5e1bd9ce-f802-9237-14a0-7cdc2be5089b@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EMQjp+MvU6EBGjHc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5e1bd9ce-f802-9237-14a0-7cdc2be5089b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linrdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--EMQjp+MvU6EBGjHc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 08, 2016 at 08:20:55AM -0400, Doug Ledford wrote:
> On 6/8/2016 6:41 AM, Leon Romanovsky wrote:
> > On Wed, Jun 08, 2016 at 02:52:10AM -0700, Nicholas A. Bellinger wrote:
> >> Hey Moni & HCH, Co.
> >>
> >> (Adding Sagi CC')
> >>
> >> On Wed, 2016-06-08 at 11:49 +0300, Moni Shoua wrote:
> >>> On Fri, Jun 3, 2016 at 8:25 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>=
 wrote:
> >>>> Do you have a changelog compred to the last version?
> >>>>
> >>>
> >>> - Moved from drivers/staging/rdma/rxe to drivers/infiniband/hw/rxe
> >>> - Rebase to newer kernel (was 4.4-rc6)
> >>> - Removed support in phys. MR
> >>> - Removed memory window codes (buggy)
> >>> - Mind  IS_ENABLED(CONFIG_IPV6)
> >>> - Dispatch IB event on port UP/DOWN
> >>> - Validate ICRC in receive
> >>> - Validate dgid in receive
> >>> - Scatter IPv4 header to right place for UD QP
> >>> - Other bug fixes
> >>> - Copyright dates were updated in file headers
> >>>
> >>>
> >>>> How well do FRWRs work, does this include Sagi's work in that area?
> >>> FRWR is not supported yet
> >>>> How well does posting of fenced WRs work?
> >>> We ran successfully some simple tests with IBV_SEND_FENCE
> >>>
> >>
> >> Great.
> >>
> >> A Soft-RoCE environment against v4.7-rc2 for iser and early nvme-fabri=
cs
> >> code would be extremely useful.  :-)
> >>
> >> Can we get this code into 0-day build ASAP..?
> >=20
> > Hi Nicholas,
> >=20
> > Per your request, I added Soft-RoCE code to my tree for testing (kbuild
> > and linux-next tests). Please be aware that official RDMA tree is Doug's
> > tree and only appearance in his tree will be sign for acceptance.
> >=20
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/rxe
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtesting/rdma-next
>=20
> I have a branch in my tree with this code in it already.  This isn't a
> statement of inclusion, as I still have to finish the review, but it's
> on the rxe branch and I haven't seen any 0-day failure so far (it won't
> undergo linux-next until it officially hits my next branch).

Great,
We will see linux-next failures if any in my testing/rdma-next topic
(v4.7-rc2 + RXE).

>=20
>=20




--EMQjp+MvU6EBGjHc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXWBlEAAoJEORje4g2clinBPsQAK1n/WneVPc9ep1GyOyOA22D
vXG3bdxll/j53k3Lz8hsUE5vtqYZJyg1z06b7ZbTj/y5qP452s6JwSTdNPj0WQhO
ZIA4c4tm9zwNAcRbCAA+47PQYQVLPKTVMMO52uB1cFrlTZr6MQ0bQTkaBRm7ogYu
qnUosdRMXJRwdeznGYFjFZFnb+CxKVwNcDq2rZlWMNnUbb4hkcKee5H9X8xBc/oN
tblL8b998FhzNR5jIb7J9VHojPN31eIdKOfB1f2JoxGskJUb73h6Vrh69XnAyJSy
iNnZ+2ISXIKAztHldzB1lTOnZGDFW9dQ6/PknOnpSoudSM5lWUT5iaOaReYeG819
4UhYTRPVrAXFsIhAEmmGRuuaHSb7/kyzvY5Ic3srU1/BGwb8nlLOsc+yagQ40ehK
dq+mkxbLeAW1X7RXkXk0ycFG+d1qezmm0qpJ/xvvVcZZFH/3xqs4iV9m1i/R26XT
nR45riGc8ng+7JFUwwHAIBnHRojeIIwIvTXrwj9g8tE5l+cat1Gtmr/dHsp8XPr+
QUR5IkMab3gcLM7kDcDFhwvcvY7iplhOrL2QRXb/+BFcMbuorOKQ5KH5WPChe8J1
mBNDudaYD4sNAiKbLioWqPpTKAXICMmpZBFMAFA+B0CNsOlew//e+A97oAWAesX7
kShQszLINz5PlroNNsAB
=cpkP
-----END PGP SIGNATURE-----

--EMQjp+MvU6EBGjHc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
