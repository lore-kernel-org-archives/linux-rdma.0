From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Mon, 11 Jun 2018 07:34:25 +0300
Message-ID: <20180611043425.GA21382@mtr-leonro.mtl.com>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180610063028.GH12407@mtr-leonro.mtl.com>
 <20180610104305.GA9284@bombadil.infradead.org>
 <20180610122505.GM12407@mtr-leonro.mtl.com>
 <20180610203027.GF5560@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180610203027.GF5560@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <willy@infradead.org>, hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 10, 2018 at 02:30:27PM -0600, Jason Gunthorpe wrote:
> On Sun, Jun 10, 2018 at 03:25:05PM +0300, Leon Romanovsky wrote:
> > On Sun, Jun 10, 2018 at 03:43:05AM -0700, Matthew Wilcox wrote:
> > > On Sun, Jun 10, 2018 at 09:30:28AM +0300, Leon Romanovsky wrote:
> > > > 1. IBTA spec doesn't talk at all about the size of TransactionID, more
> > > > on that in section "13.4.6.4 TRANSACTION ID USAGE", the specification
> > > > says: "The contents of the TransactionID (TID) field are implementation-
> > > > dependent. So let's don't call it mlx4 bug.
> > >
> > > I was loosely paraphrasing the original bug report; suggested rewording
> > > of the comments gratefully accepted.
> >
> > Just replace "mlx4 bug" with something like "to comply with mlx4
> > implementation".
>
> Well, it is a bug. Blindly replacing the upper 8 bits of the TID in a
> driver without accommodation from the core is totally, bonkers wrong.

I provided cite from spec that says that TID can be whatever you want as
long as you success to do it unique.

>
> The original concept was that the 1<<24 limit would come from the
> driver and only mlx4 would have less than 1<<32, because only mlx4
> does this thing..
>
> Thanks Matt,
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbHfvRAAoJEORje4g2clink8EQAMv8h8rJtH/TZ5k8S1PM3SR7
SY1qRYNfEmigAWjwP2PwJu6Um314Azrap93axOdAIVkPFfErfQdbg3vAAVq+RN3n
FgshwxAzoqUAlfDWN0O///rNFg2f4t2ynrzuw4v43JowjwaUq3MPJzt/4EiZx4SN
nGiTUmtAa+aHcxTLo7/j55+ACRF1CfcADGDeDJ7F5LI6FBqqztduqtydpbS5QxgP
eraDcrpm2NP1fNlflnY+Xc05tAUJGKOWc0f9qrM6/evA6o6zmVMN5pnmTgyS8diG
yo8HuKzjDnCGEAAuS8kapS7zJMvshMsgHZWqeh7wvjkot9736RfdnCrbsnp31/aO
E3mSPtMW5AkKrLD+ZOOd0Qk2YE0oO6HirRHwYmdI0108V4pon9V18gIn7NmWa/AB
MfCwz5CjL1K7dE0/FNso/GIMSN3VPc3k654P3IH9ZbZZIPv7yLOhwvMiqu0NPC2Z
/SMzInu+FXdAZy8Kf0p+fc6FTjGStUpBasuPJj8lsLfIW14hA0sMWFT37boS9OCt
ipWvsqtmd7TcXoHb5Mgk68jmZ6tZ+m2+oSNsh2bqum1AxCOFNVOPisQFNRvMJ42I
rPNBiDHH9six4p6X5k7wxP79dTPA9EoAzsmtVIllRV+D2WP1ejdM99QOVVtgIxKu
WMCaFGuhsHjoiQ8CRZUR
=l0ox
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
