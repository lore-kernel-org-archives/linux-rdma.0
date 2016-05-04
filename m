From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Wed, 4 May 2016 07:41:07 +0300
Message-ID: <20160504044107.GE29160@leon.nu>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503184218.GC29160-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 03, 2016 at 09:42:18PM +0300, Leon Romanovsky wrote:
> On Tue, May 03, 2016 at 12:54:05PM -0400, Dennis Dalessandro wrote:
> > On Tue, May 03, 2016 at 07:24:57PM +0300, Leon Romanovsky wrote:
> > >On Mon, May 02, 2016 at 03:55:02PM -0400, Dennis Dalessandro wrote:
> > >>We also should be able to use any of these schemes to handle our eprom
> > >>reading/writing. Adding eprom to IPoIB as Doug suggested is a fine pl=
an, but
> > >>we technically don't need to do it right now when we could make do wi=
th the
> > >>"UI" functionality and hide the details in user space. In the future =
there
> > >>may well be value in having an eprom capability in the rdma sub-syste=
m, but
> > >>for now we believe we can avoid extending the kernel in this regard.
> > >
> > >Just to understand better your RFC. Are you asking from the community
> > >excuse do not implement core functionality just because you don't need
> > >it? Am I right?
> >=20
> > The purpose of the RFC is to get the community's feedback on our plans =
to
> > solve our UI/EPROM issue. The paragraphs [1] not snipped in your respon=
se
> > focus on that. It comes down to:
> >=20
> > Use resource0 which does not support locking vs use a file in
> > /sys/kernel/debug.
>=20
> I didn't quote the whole email because I didn't see any question in
> these 3 options:
> * First option - doesn't meet the requirements and hard to extend.
> * Second option - doesn't meet the requirements and HW limitations
> * Third option - presented as one possible option and looks like the
>   correct one.
>=20
> And the real question is "where" do you need to implement third option.

And to remove the tension, all what you was supposed to ask can be
summarized in one question: "Do we have other customers for EEPROM in
our RDMA stack?". If the answer is yes, you will need to implement it in
core, and if the answer is no, you will implement it in your driver.

Hope it helps.

>=20
> >=20
> > The point of the particular paragraph you are questioning is that I don=
't
> > think we should add more code and complexity to the kernel for something
> > that is not needed.
> >=20
> > [1] http://marc.info/?l=3Dlinux-rdma&m=3D146221891012428&w=3D2
> >=20
> > -Denny



--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKX1jAAoJEORje4g2clin6vYQALza5C13dZPMM/PB8V7tHEtw
mLCqj3FNDQrcCa/WDmSEjHgbPPyjoikg8vHi3kWI0wfSE0AAGsIGtIG0VOopT2Qt
Rq+RNJMJqpwZghXpnbesUYn2LpVA0M9KTPUL9tuJW2G3tGNt+kmv8Iuimiij2ILe
6weRy0UUuUvvxAGnvZBeURbTzh7owYzntDUG98fZTFzSFiSVRNIzeJNMPjtqOEgq
ZitABpZE4twkSvFk+8w5y5HNj0fjyNIigWk/h49HQzt6IX9eW+HqABwMC+2S5L6g
i0TDKqzOKBxU5OxED5K1sy2UVhqRyDMHmMPfox3ff+8lb3u7W+ZQCTPRoGTx2+eR
uryClebWHLg8/agrx30QsXhQ4Mq44S6BDSZYBi8hNqdaObCEL+9kLkhUFtGwvBtQ
0nPfDXYBT3RlnOK0QDkAm6c7+KsBwZ0/jHVCg4tUoSRA7A8TpjBDrYCb+pfzUrCo
V1+74QHQGZ121KqYhHZ/q2NkZs+oIOGPEOaPQrkOyXN3jFxIpjV+2rgJYmL3+092
zReVF6DzVxoWuL0f50/1O/abIP7gd8TIth48kMtJWN2UgkH+zI1QyLOIOoSHosnD
SrHhQx3ED4Z5qGZLKebMkyUxY888681pubHxydlagoGiC+pdGKb4Th3PssgaQi98
lONwpImXz3x0ISSTH5Os
=aJpa
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
