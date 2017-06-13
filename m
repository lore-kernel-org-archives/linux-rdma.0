From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] IB/usnic: Implement get_netdev hook
Date: Tue, 13 Jun 2017 13:37:19 +0300
Message-ID: <20170613103719.GO2576@mtr-leonro.local>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-2-yuval.shaia@oracle.com>
 <20170613072526.GM2576@mtr-leonro.local>
 <20170613073502.GC28008@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170613073502.GC28008@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 13, 2017 at 10:35:03AM +0300, Yuval Shaia wrote:
> On Tue, Jun 13, 2017 at 10:25:26AM +0300, Leon Romanovsky wrote:
> > On Sun, Jun 11, 2017 at 08:44:49AM +0300, Yuval Shaia wrote:
> > > usnic's get_netdev hook for struct ib_device is missing - add it.
> > >
> > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > Per Moni Shoua's suggestion - create seperate patch for this purpose.
> > > ---
> > >  drivers/infiniband/hw/usnic/usnic_ib_main.c  |  1 +
> > >  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 10 ++++++++++
> > >  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  1 +
> > >  3 files changed, 12 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> > > index c0c1e8b..80577b9 100644
> > > --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> > > +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> > > @@ -409,6 +409,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
> > >  	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
> > >  	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
> > >  	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
> > > +	us_ibdev->ib_dev.get_netdev = usnic_get_netdev;
> > >  	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
> > >  	us_ibdev->ib_dev.alloc_pd = usnic_ib_alloc_pd;
> > >  	us_ibdev->ib_dev.dealloc_pd = usnic_ib_dealloc_pd;
> > > diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> > > index 4996984..f9dc1e80 100644
> > > --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> > > +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> > > @@ -424,6 +424,16 @@ int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
> > >  	return 0;
> > >  }
> > >
> > > +struct net_device *usnic_get_netdev(struct ib_device *device, u8 port_num)
> > > +{
> > > +	struct usnic_ib_dev *us_ibdev = to_usdev(device);
> > > +
> > > +	if (us_ibdev->netdev)
> > > +		dev_hold(us_ibdev->netdev);
> >
> > Who will release this reference?
>
> I followed the instructions in struct ib_device so assuming the one that
> calls get_netdev will do it.
> See ib_cache_gid_add as an example.
>
> Patch #2 aslo take care of it.
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/wF8ACgkQ5GN7iDZy
WKe7yhAAq3BOO1vWw/DOhZqXK5nd7teg5Amta2PtothX1yDykfvwUQ5eQ19XSTIT
mTwcSR29xRYSJKk4qSPgGsfaHXrLjUcMnwJ9jeelxAiWGKK9CO+hX5RAoHCUN0Qs
4fD6QbxSx7WrgO1L4Luz8FLOf0/jfvEHpvpZpAAGMmB1CcPkbFhnNRbL8j24nc2r
RqgudVvNrH+a8oVGdjs6MT2kwoS1ROqQTBeC9GlLaMeb+XFnp9DSo6i22mNwcimM
tzQQmm8ptEsRJAoaj+Rtxfp55s/xqw0XQzVuB7bATyoDWdY3BanFT3VaDy+vukIp
rMvxgHn0ZJNX8/pD7UAua5lZ1E5n+juKGsW/6SygcNyokVcQzBhp44NcVsidRbge
/X3/einYbRrlXepyNUIrDL3RKC4ryqPw2SoJiyVbr3EsxtvhwqgDCJl5yTKpS5J1
c/pYIwSr/svRaBbsVq8deGAE5rOKAHl1yEJrwdezKAXBr93xCmEAc3qqow9CgQbg
DkVkuhR6/C4IPX9wvlNlPDVden8392oOaQB8G19f4z3JmXb5SBrbdtq8Jorssmz+
x3Zz/4pr1Rbc7PQsn7CBT1YGJNErXmJf9mFCaZEb/7+NrFLfAmcAfuF/tCKe/YoY
i2z29YL46jgJE1YlQDt7uNMWzNwqR9Fluw6BYfJ7SbjIlFO2B3U=
=6zFv
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
