From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 01/21] drm/i915: Move u64-to-ptr helpers to
 general header
Date: Tue, 15 May 2018 12:04:00 +0300
Message-ID: <20180515090400.GU10381@mtr-leonro.mtl.com>
References: <20180503133715.15276-1-leon@kernel.org>
 <20180503133715.15276-2-leon@kernel.org>
 <20180514201054.GF21531@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1009381345=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180514201054.GF21531@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Matan Barak <matanb@mellanox.com>, David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>, dri-devel@lists.freedesktop.org, Rodrigo Vivi <rodrigo.vivi@intel.com>, intel-gfx@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org


--===============1009381345==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEfPc/DjvCj+JzNg"
Content-Disposition: inline


--PEfPc/DjvCj+JzNg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2018 at 02:10:54PM -0600, Jason Gunthorpe wrote:
> On Thu, May 03, 2018 at 04:36:55PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > The macro u64_to_ptr() and function ptr_to_u64() are useful enough
> > to be part of general header, so move them there and allow RDMA
> > subsystem reuse them.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/gpu/drm/i915/i915_utils.h | 12 ++----------
> >  include/linux/kernel.h            | 12 ++++++++++++
> >  2 files changed, 14 insertions(+), 10 deletions(-)
>
> This patch and the next one to kernel.h will need to be Ack'd be
> someone.. But I am not sure who.. AndrewM perhaps?

Why is that?

The kernel.h doesn't have explicit maintainer and is managed by
community effort.

Thanks

>
> Jason

--PEfPc/DjvCj+JzNg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJa+qKAAAoJEORje4g2clinrKMQAIWPr1AcsnSgJjYZQvaVsON5
svikX7KLOaRQ13JauTDV7k7wfo75U98MPPyGyjOTMmqR/GSZVOkkMLkwev4w/vud
uCGO5UPk/B2lvW4dfooSodwk+80ItyQFDKH8iLMMjWj0TihVtXqsUN3/YNyCXAHn
W7QIJhYw3mkni2xdO4MohodZdeg9QpXz4HopW1Hx2XUKoLKh2uael0suEBOGLmJ8
TOdHaos/s4Bn0aqbbIDvCPBvXiqmdKwmtUeArKKi+xbaCkMfQITE2P3qF0c0ceSW
bMm6TzAkplV0d8a3ATe7dw8Ny7tdqcqWNLfqL2ocq5pykdUcg4GHdQ1pd4R0SS2H
mbuWyprmhqkmCf58LU3f5BAZh6ipPJyRHASf3cy7KN25xVu9PrrwtZ9AarmaK6f+
djjc98iQdiotObmZ36z9WZAQ+Ae1LUZXRza+sPyJywoZK532RXgx/qbuOGOyipo/
SD9oTkShPuu7OHmiENJoOGOTcAM7IF9RaL53K+gQnMMqPO2/3eZHNIlMG/zlIx4k
JbENkOkv++nrifNi6DSHqfABMyZg/XET3LnjEIFWijXnMpweG8zICDz5uK/NquM5
BoTMC5O9tFGXeFkQYmqsO9kuMHXY6RAJZVVWCP1WIiKtrxT2ZyMilp0z7ecMzuc5
T9nEV4q8ErrnFcf3n55O
=IVMt
-----END PGP SIGNATURE-----

--PEfPc/DjvCj+JzNg--

--===============1009381345==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1009381345==--
