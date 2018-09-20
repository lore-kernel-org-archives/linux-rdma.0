From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 00/24] Extend DEVX functionality
Date: Thu, 20 Sep 2018 08:01:15 +0300
Message-ID: <20180920050115.GD3519@mtr-leonro.mtl.com>
References: <20180917110418.18937-1-leon@kernel.org>
 <20180919181701.GP11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180919181701.GP11367@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 19, 2018 at 12:17:01PM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 17, 2018 at 02:03:53PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > From Yishai,
> >
> > This series comes to enable the DEVX functionality in some wider scope,
> > specifically,
> > - It enables using kernel objects that were created by the verbs
> >   API in the DEVX flow.
> > - It enables white list commands without DEVX user context.
> > - It enables the IB link layer under CAP_NET_RAW capabilities.
> > - It exposes the PRM handles for RAW QP (i.e. TIRN, TISN, RQN, SQN)
> >   to be used later on directly by the DEVX interface.
> >
> > In General,
> > Each object that is created/destroyed/modified via verbs will be stamped
> > with a UID based on its user context. This is already done for DEVX objects
> > commands.
> >
> > This will enable the firmware to enforce the usage of kernel objects
> > from the DEVX flow by validating that the same UID is used and the resources are
> > really related to the same user.
> >
> > For example in case a CQ was created with verbs it will be stamped with
> > UID and once will be pointed by a DEVX create QP command the firmware will
> > validate that the input CQN really belongs to the UID which issues the create QP
> > command.
> >
> > As of the above, all the PRM objects (except of the public ones which
> > are managed by the kernel e.g. FLOW, etc.) will have a UID upon their
> > create/modify/destroy commands. The detection of UMEM / physical
> > addressed in the relevant commands will be done by firmware according to a 'umem
> > valid bit' as the UID may be used in both cases.
> >
> > The series also enables white list commands which don't require a
> > specific DEVX context, instead of this a device UID is used so that
> > the firmware will mask un-privileged functionality. The IB link layer
> > is also enabled once CAP_NET_RAW permission exists.
> >
> > To enable using the RAW QP underlay objects (e.g. TIRN, RQN, etc.) later
> > on by DEVX commands the UHW output for this case was extended to return this
> > data when a DEVX context is used.
> >
> > Thanks
> >
> > Leon Romanovsky (1):
> >   net/mlx5: Update mlx5_ifc with DEVX UID bits
> >
> > Yishai Hadas (24):
> >   net/mlx5: Set uid as part of CQ commands
> >   net/mlx5: Set uid as part of QP commands
> >   net/mlx5: Set uid as part of RQ commands
> >   net/mlx5: Set uid as part of SQ commands
> >   net/mlx5: Set uid as part of SRQ commands
> >   net/mlx5: Set uid as part of DCT commands
> >   IB/mlx5: Set uid as part of CQ creation
> >   IB/mlx5: Set uid as part of QP creation
> >   IB/mlx5: Set uid as part of RQ commands
> >   IB/mlx5: Set uid as part of SQ commands
> >   IB/mlx5: Set uid as part of TIR commands
> >   IB/mlx5: Set uid as part of TIS commands
> >   IB/mlx5: Set uid as part of RQT commands
> >   IB/mlx5: Set uid as part of PD commands
> >   IB/mlx5: Set uid as part of TD commands
> >   IB/mlx5: Set uid as part of SRQ commands
> >   IB/mlx5: Set uid as part of DCT commands
> >   IB/mlx5: Set uid as part of XRCD commands
> >   IB/mlx5: Set uid as part of MCG commands
>
> This is really too many patches.. They are small and not too hard to
> review, but it is well beyond the guideline.
>
> And I'm not totally happy with the extensive use of ucontext in the IB
> portions, it is problematic looking into the future, and uboject is
> really not supposed to be used in the drivers.
>
> The driver needs to store the uid in the PD (copied from the ucontext
> that created it) and use that in all the dependent places, not use
> pd->uobject->ucontext->devx_uid or some other convoluted way to get
> to it.
>
> The ucontext variable should only be used when creating the PD, CQ and
> devx objects.
>
> This detail becomes quite important, for instance, if we get to the
> 'shared pd' that has been talked about at conference. In this case
> when the 'receiver' of the 'shared pd' creates a child object, like a
> MR, the MR must be stamped with the devx_uid of the PD (ie the
> originating context's devx_uid), not the dev_uid of its local ufile!
>
> If we do that, then the series can be split, so long as pd->devx_uid ==
> 0 until the entire series is applied. uid tagging is an all-or-nothing
> thing, as partial tagging will break verbs. So breaking it up also
> makes it more bi-section safe.

There is very simple reason why this series was sent as one piece. The
basic requirement that the code posted will be as one feature, from the
beginning till the end, easy to follow, cherry-pick, proper ordering
and less errors.

However if you want to see three series posted immediately one after
another and have two of them with dead code, I'll do it.

Thanks

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJboymbAAoJEORje4g2clinrskQAM7PCOxPRfL0ez9f3n53WFU/
ubH9ix2H84+DH4eXkv8KwOAkUs2hyxQCrXF2n4oo/e2JBQH0mMGI3q5BDrU1x94N
ROureq3KXDnR2Kox376m5FPOqtlizPRAKSJ2eDp4VLfRkBRX04yHklBOwAMfLVJm
WFCntaGe8ApU+Hv3hkEdU9OGKEZsPetPy07r2L45Np5kPBtZG0NcvhTSXEhi2ptt
J9BFHFaQkHvrD13jET0x4t1bygx55cHvXJZlJa8CBnxVH7R6eXZkcwCkX9UlxhK6
JJP1X6qIjkYKc/PuJQKUfvxP9dOKJ0bPe0MeP/nfq4uY603OEf0mA1/q67aoojY3
zWchJlyl0NcVGljC29hZEvlKqjst2WBEKlEZO2js8tKtylNvlq69w/SfRTzTq4Y0
Tx0tAQe76AV442KyW+hz8ORA6zELR8CSQwinggbbtmryAUTwRfdt7hCH1sqwsfik
QU/XINFyJFtAi2S5ldwVuSe4pTJIGY3vUPPDlB9Jmviu0GB9o04Lw/4ZIy3giG0Z
YFq70G5jYqeSns/tSIoyE3/bTd2EzXa8C1LtuRsY21/66FdcCaU6t4EBly6Dp6dl
1e0FUvjlnSIAG1+WotU4AI2EExnbIlOjp9I7FNyemEXM912BcbFmITqqHz8gSU0T
ecRyPrAo6FGKYt3JGwTb
=AgvX
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
