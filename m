From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 04/25] IB/verb: Add ipoib_options
 struct and API
Date: Wed, 15 Mar 2017 08:27:28 +0200
Message-ID: <20170315062728.GB2079@mtr-leonro.local>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-5-git-send-email-erezsh@mellanox.com>
 <20170313200136.GA2738@obsidianresearch.com>
 <CAAk-MO8dZJKYgpWT8p1fz0O6y2wTx4jxoJhYf21ikMOef_xUMg@mail.gmail.com>
 <20170314190300.GA80705@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sf3MmCJcUNNLokcm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170314190300.GA80705-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--Sf3MmCJcUNNLokcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 14, 2017 at 12:03:01PM -0700, Vishwanathapura, Niranjana wrote:
> On Tue, Mar 14, 2017 at 03:25:01PM +0200, Erez Shitrit wrote:
> > On Mon, Mar 13, 2017 at 10:01 PM, Jason Gunthorpe
> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > > On Mon, Mar 13, 2017 at 08:31:15PM +0200, Erez Shitrit wrote:
> > >
> > > > diff --git a/include/rdma/ib_ipoib_accel_ops.h b/include/rdma/ib_ipoib_accel_ops.h
> > > > new file mode 100644
> > > > index 000000000000..148a5529a559
> > > > +++ b/include/rdma/ib_ipoib_accel_ops.h
> > >
> > > Both patches need a better naming scheme for this file..
> > >
> > > rn_opa_vnic.h
> > > rn_ipoib.h
> > >
> > > Maybe?
> >
> > Can work for me.
> >
> > vnic?
> >
>
> I do see why it is an issue for ipoib (we don't want two ipoib.h files). We
> can add rn_ prefix for vnic, but probably opa_vnic.h is good enough.

Just for the consistency, I would like to see the same "rn_" prefix
for both files (ipoib and opa_vnic).

Thanks

--Sf3MmCJcUNNLokcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljI3s8ACgkQ5GN7iDZy
WKcW7RAAj0L4rOTpuRM2mcdiqmR7RuNIPhWjQIbUR8762KmvvFj24VZ6fSf+z7Ri
ZOPHJ1HDuKhlNQ1acypT9erHPP/1Pm7h8KpTz8oaNmq6jL1InVz2wkwWqDnFZ0oN
uykNlpYP/TfiY9BC71NfyLSgCVHphaP53cpzdKJ2l+A4py5aK380aRLAHLz747O9
F3YaXcUAnn5QtyOteeM68Qb4seM3MGk/YpiYaPYUefifgeYgGV4bvecpfZim9ef0
a/3dYiGAwoZI1Lnb8G1ECXUYEYHotE06c9PUjqNgmf+Ylli5MjnzaOtzYAUANvei
oYuIUhHwZJJADHxrTJ6tgdSq9gx3QPX5SXWn4Y7/vUwN9nuI+s/FDDhe1D8HlYDB
NGb5o2zE+5q35bbcDwceWNWzUxzI41ndXv4UUI+DoH25PQKrQtJMtUmisXLxS0pH
4qeHqikJWKFCPYrykg0YgDdBx7aiVuDVAOHW84SOyU8JFRkjoI2JMB69ZQZMSx2J
1+uoyq0dc32hcaG6ARYb6CnTQ/sOa1h+RbDhVV4unyG6bN2/DfWMZFkEQpr5vpAK
tKbJWq+/Qr9qvPymDVtn4Xgcg3DJQU7nvdn2CQeeS1fibGO6AfpfQX7akuACDPht
0lISwJy6GL3Z0CfD8yY9jl0c7H68FmbGpLPcUvYkam6giNgN5n4=
=WMii
-----END PGP SIGNATURE-----

--Sf3MmCJcUNNLokcm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
