From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 14/15] IB/mlx5: Don't advertise RAW QP support
 in dual port mode
Date: Thu, 4 Jan 2018 07:21:11 +0200
Message-ID: <20180104052111.GY10145@mtr-leonro.local>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-15-leon@kernel.org>
 <CAJ3xEMgAtd1PKN2h1NFj=Mt72msuU5bpFy0jO4KFXxXxGRf7hA@mail.gmail.com>
 <20171225071613.GW2942@mtr-leonro.local>
 <CAJ3xEMhtssDWuu8JAB_jhyofKbkeo4vYTLixLeta6vPzKQOp+A@mail.gmail.com>
 <ab3fb697-7b2c-685c-2151-5f48d5d7270a@mellanox.com>
 <CAJ3xEMimYj8=USqjHEF_uiwJCNoeT5qpbNMYTWUX7EgTVSeuuw@mail.gmail.com>
 <6f114e3c-2e16-f7ce-2e60-d06113afc9b8@mellanox.com>
 <CAJ3xEMjZfTJP1fi=VosXL_v=AUueWZc54iOsXz1ynikYm-jcjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jesV4P1FjH8FXPjZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjZfTJP1fi=VosXL_v=AUueWZc54iOsXz1ynikYm-jcjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jesV4P1FjH8FXPjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 10:47:14PM +0200, Or Gerlitz wrote:
> On Wed, Jan 3, 2018 at 10:43 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On 1/3/2018 2:39 PM, Or Gerlitz wrote:
> >> On Wed, Jan 3, 2018 at 10:35 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >>> On 12/25/2017 3:17 AM, Or Gerlitz wrote:
> >>>> On Mon, Dec 25, 2017 at 9:16 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >>>>> On Mon, Dec 25, 2017 at 12:16:15AM +0200, Or Gerlitz wrote:
> >>>>>> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>>>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>>>>
> >>>>>>> When operating in dual port RoCE mode RAW QPs are not supposed
> >>>>>>> to work on the slave port.
> >>>>>> why?
> >>>>> HW create flow table restriction.
> >>>> cryptic to me, either put a proper explanation on the V2 change log
> >>>> for this patch
> >>>> so we can review it then or explain it here if you want a review on V1
> >>> We don't report RAW QP support on a per port basis.  It's per device.
> >>> The user doesn't know which port is the master/slave, so we shouldn't
> >>> support RAW QP at all in this mode. I'll update the commit message to state that.
> >> in mlx4 we do have IB device with two ports and RAW QP is supported,
> >> what is different there?
> >
> > mlx4 has a completely different HW architecture.  It's 2 ports on 1 PCI function.  This feature doesn't do that for mlx5, there are still 2 PCI functions.  It uses steering rules to route RDMA traffic arriving at the 2nd port to resources in the domain of the 1st port. RDMA traffic is easy to identify and steer accordingly, generic traffic over a Raw QP is not.
>
> ok, so this is basically uneasy but not undoable. Aren't we creating
> possible regressions for people that used RAW QP on mlx5 devices?
> these
> are open-systems and the code is out there for people to use it. Now
> the systems that move to the new mode has inferior functionality.

No, we are not creating regression mainly because of two reasons:
1. This dual-port functionality is enabled by special FW and not
available by default.
2. Programmers were supposed to query device capabilities and ensure
that RAW QP is supported prior to use it, like any other feature
advertised by those capabilities. This is the whole idea of device
capabilities.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jesV4P1FjH8FXPjZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpNuccACgkQ5GN7iDZy
WKet8Q/8DzqbZ76+orLGeYWyZ2ZwRcA1e/z6oHbTn4+PYEZUEr/cfPKwJGTmRzls
QQZU+ZGLV3xqNSbFDqRp8y/d/2LedNqvloRXlpw2tAk8PYSG6t2LZI0xyOslQ9jy
6+Xg9q9pQUJoGOyUEure7Yh0ce2vDLf9chA3xbAsPO2ncTFE3wBdO7H4LZDviRGC
iiFtFSdscIf+cch0mMbajXRif+n1bCQcQ3a8tHMIrGbu7ZjKGj9ybcsWHu/V08rr
G6k3SaHuXjjiOSCgfIb9x9vu47gTIQwacIftu+BpTxkHersUYyHC8f6nyqOtNsef
SN4vEmpRJ0u/zNJJUfNQmDJmMoFoFrltWSOTtgpJrtH1Z5FUTKQML5KCKaSgIUZS
kgrc1fURiZ5WfA7btd3kH61ZD+keZRQzmASqKYDSA3/c9GOVnwmEyQ6I1MJbt5yi
iZawq4+c4H9ISgteYLDmRKHdlY+UjHg/rK6iNIPuQAv4CU3nBZF55E7HqloFSu+3
R2X4Yy3LzK7HX6FtCCN5fFhg0kDrAhLfPYUNb+uW/xq5HeMM3wMOI1yiMJumqNcS
7GBFCJOFRhyoIxqsQYn14AU99oGgIVQnzCq2ljAC7Zp57HROWlkaujAYLwTclcep
ff8rWOumo/8SkUThY53QekMr1YtBEQRKoWOhgXdpB8BSxT1HxRU=
=UF5w
-----END PGP SIGNATURE-----

--jesV4P1FjH8FXPjZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
