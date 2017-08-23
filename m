From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: small patches to librdmacm
Date: Wed, 23 Aug 2017 07:29:27 +0300
Message-ID: <20170823042927.GH1724@mtr-leonro.local>
References: <C50D9A8A-457A-4DA6-B727-43B77117ED15@lanl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y77xulteysKOarq0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C50D9A8A-457A-4DA6-B727-43B77117ED15-YOWKrPYUwWM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--y77xulteysKOarq0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 22, 2017 at 01:47:18PM -0600, Jeff Inman wrote:
> Hi folks,
>
> I=E2=80=99m new to this.  Please let me know, if you need a different for=
mat, etc.

Yes,

1. Please send them with git send-email command, so they will be
threaded together.

2. The commit messages should include description and you already have it
here, just copy/paste to the commit message itself.

3. Fixes lines should be in the kernel format and not hand-made as it is no=
w.
The following git alias in your .gitconfig can create the proper Fixes line=
 for the
specific hash.

[alias]
	fixes =3D log --abbrev=3D12 -1 --format=3D'Fixes: %h (\"%s\")'

For example: git fixes ac3a949fb2f in the kernel will produce:
Fixes: ac3a949fb2ff ("IB/CM: Set appropriate slid and dlid when handling CM=
 request")

4. No extra space between Fixes and your Signed-off-by signature.

5. Don't forget to add Sean's acked-by.

Hope to see it merged.

Thanks

>
> Of the two of these, 0001 is the one I care about.
>
>
> 0001:  The patch comment explains the details of the fix, but here=E2=80=
=99s some context:
>
> Access to entries in the rsocket index 'idm' is effectively serialized by=
 creation/destruction of file-descriptors for /dev/infiniband/rdma_cm.  New=
 fds are created in rsocket -> rdma_create_id, and released in rclose -> rs=
_free -> rdma_destroy_id.  rs_free() was releasing the index with rs_remove=
() *after* calling rdma_destroy_id().  But closing the file-descriptor in r=
dma_destroy_id() yields to the scheduler, making it easy for another thread=
 to get into rsocket() during the break.  This thread can get its own fd (b=
ecause the first thread=E2=80=99s close has succeed) and store its own rs i=
nto the index, before the first thread has gotten around to calling rs_remo=
ve().  After the first thread does call rs_remove(), the second thread will=
 segfault in most rsocket-related functions.
>
> Note that I=E2=80=99m not assuming an rsocket can be simultaneously opera=
ted by different threads.  I just have separate threads that open/operate/c=
lose their own rsockets.  This seems to be working fine, except for this pa=
tched problem.  Am I mistaken that this is reasonable?
>
>
> 0002:  Removing the potential for segfaults when a legitimate rs is not f=
ound in the index.  This should never happen unless there is a bug like the=
 one fixed in 0001 (or someone stupidly makes a call with a closed rsocket =
=E2=80=A6), so the tests should almost always be wasted.  Made this a separ=
ate patch, so you could ignore it, if you want.
>
>
> Thanks,
> Jeff
>
> --
> Jeff Inman
> High-Performance Computing (HPC-ENV)
> MS-B295, Los Alamos National Laboratory
> Los Alamos, NM 87545
>
>
>
>
>
>
>
> Jeff Inman (2):
>   rsocket: fix a race-condition in rs_free()
>   rsocket: fix segfaults when rs is not found in the index
>
>  librdmacm/rsocket.c |   22 +++++++++++++++++++---
>  1 files changed, 19 insertions(+), 3 deletions(-)
>
>



>


--y77xulteysKOarq0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdBKYACgkQ5GN7iDZy
WKew0hAAzbIXIYLDCbphb9NK0x2++QvGU0H2W/FV9I3GGPPAPiYk93HZBb1MrHvH
fFL68ixRsC3UwZX7x7uLPft4DxhWePckRfbD9xQ06VptmtO+vJbUOH+ldMHnhp3w
g7YAoTrQou3fhdvsNCcHhZV4Z9nzbNs/jvnx0v1TyErzOR87hOrlJQLK1LRUQylr
vuN1IZDCxH6c/jQNYVJge4RBtIVvIjsRzMbeY66+k1gBGTuFNz97YnWuq9ectXKL
zPfIAWfGQWiy2ql1wXbV6coMbjcO5R29/ObuOSBdSpupT3DwJMlkaZKe9gXNkhh9
LnXGldRU//ctqd4OF9DFhfQ0phx/xjylYtP8fS5V7azDx7XW/MCR8QtcUhmzhOLp
mU79MXBTn4Eks+SpYSmwAp0nFP1Dc5xzwuBiIpstURlWHwPlt4Cr17nEgejDWGvU
I+f3xhJXEe2afytwaLolvs1OF3mVrpD4XByPMk/b1YOaVBrJpUY0T13oXFphu14I
qtQEuNTu8w5EHP+EkdxhrKmWo46o6i0N2BkQ6lxre13BjDWEpCU1M1+LG4+2B/8U
4b0zYFUFXOQSUp2bf4M6mtMG/Sqj5gt/IdKwEVNsWFdYyZXO/Np6KORfLBbQ+7W1
oujC+WJBwAlvQKNY229wa3HONHn9qU/p7CHEULuFzkKsWeISOHk=
=K7jP
-----END PGP SIGNATURE-----

--y77xulteysKOarq0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
