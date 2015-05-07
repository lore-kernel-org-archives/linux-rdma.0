From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: Scatter-Gather support in connected mode
Date: Thu, 07 May 2015 10:45:05 -0400
Message-ID: <1431009905.2407.371.camel@redhat.com>
References: <1422357682-8934-1-git-send-email-yuval.shaia@oracle.com>
	 <1422444987.3133.81.camel@opteya.com> <20150201070941.GA4778@yuval-lab>
	 <20150315151616.GA3546@yuval-lab> <20150322092149.GA5229@yuval-lab>
	 <20150323171749.GA3580@obsidianresearch.com>
	 <20150401203314.GF8024@yuval-lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-qGkw3+loE/KdxqoYbt9m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150401203314.GF8024@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-qGkw3+loE/KdxqoYbt9m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-01 at 23:33 +0300, Yuval Shaia wrote:
> On Mon, Mar 23, 2015 at 11:17:49AM -0600, Jason Gunthorpe wrote:
> > On Sun, Mar 22, 2015 at 11:21:50AM +0200, Yuval Shaia wrote:
> > > On Sun, Mar 15, 2015 at 05:16:16PM +0200, Yuval Shaia wrote:
> > > > Hi,
> > > > I didn't got any further comments on this one.
> > > > Any idea why SG in CM is un-welcome?
> > > By mistake I sent a private mail only.
> > > Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >=20
> > > Your advice would be very appreciated.
> >=20
> > I haven't looked in detail at the patch, but in principle, using S/G
> > when ever possible should be the default, even if this creates a
> > performance regression.
> Per my testings - no impact on performance.
> >=20
> > It is well known that high order allocations are problematic in Linux
> > and should be avoided, and I also have seen systems blow up because of
> > high order IPoIB allocations.
> Yes, snapshot from oops:
> Call Trace:
>  [<ffffffff810ddf74>] __alloc_pages_nodemask+0x524/0x595
>  [<ffffffff8110da3f>] kmem_getpages+0x4f/0xf4
>  [<ffffffff8110dc12>] fallback_alloc+0x12e/0x1ce
>  [<ffffffff8110ddd3>] ____cache_alloc_node+0x121/0x134
>  [<ffffffff8110e3f3>] kmem_cache_alloc_node_notrace+0x84/0xb9
>  [<ffffffff8110e46e>] __kmalloc_node+0x46/0x73
>  [<ffffffff813b9aa8>] ? __alloc_skb+0x72/0x13d
> >=20
> > That said, there may be cases where S/G is not possible, you should
> > try and get Mellanox to comment if all their offloads work on all
> > their cards when S/G is used. Work may be required to resolve any of
> > these constraints. I'd like to belive there is some reason why we've
> > been doing high order allocations for so many years.
> Old kernels (2.6.39) restrict the usage of S/G only to H/W which supports=
 CSUM offload.
> Mellanox HCA supports CSUM offload only for UD and this is why we can fin=
d S/G support for UD but not for CM.
> With the introduction of commit ec5f061 this limitation is no longer ther=
e so no reason not to add this support.

Can you repost the patch with a cleaned up commit message that includes
a reference to this prior restriction and the fact that it no longer
exists please?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-qGkw3+loE/KdxqoYbt9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVS3pxAAoJELgmozMOVy/dOKQQAIvGaOZrqhAnNzjRN6my9ETM
4s2qFZJX4k8ezalg/oGostwWOTMPDffQ0OBa6hyn/wHChgfLJw7c3v5rOz4M37gO
JtXaniWv4cFeQpdfIm1pEP7UuazCx7ROmFfLBmDlZzN18oWUn1z5Z523gN8y1qqN
vrglllsfo9Fhybiu8kAD6zJGEDxv3dJoAcVM8yefXLlqDmfcM9tl/O+OhSfG3qu8
6wcTwjYSwd2fmV4sUedSIo8+8aiPNQTOcro+l9QQ1PStlj8yvQ9IzPVao0CD+SPO
nGLCAGdHxjZmF9nEqMmYHGbJrQG0otXQclY/Albmdh8BM0NQdtVLBTCHueCER7cj
rB6yLAcxMX6bWWJuAFYZlH2KWnv7MFkc6UGyUQzh/8NI+jSRSZCUdkcC3ivGzDMN
nJpSMQS1Qra7FAZwinh2LgKbTQSu0gQaYBs4ORcv+NTP3aG/wmcV9csAqTLfT9SM
9yvbv+xN1+3pzQ3Cikvlv3UB9XSm4qhs4Asukk2zcfqPNPEBSfAaNQcVyJUtsVq8
o7Y4cMhce4vyTBwhpKY80Of5QLBxIxmYMH89agvs/x+d6AX7XiKjzNLUiONxzLFo
gRSoWmq6wwyjPmlupNwKnJ44alL/TLlgxsDkmDOurPLeMVvCsu95yg1UwTbaoghK
EH3YflD08IM/nJ8uhHPW
=2ewg
-----END PGP SIGNATURE-----

--=-qGkw3+loE/KdxqoYbt9m--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
