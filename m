From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Tue, 28 Mar 2017 20:05:06 +0300
Message-ID: <20170328170506.GI20443@mtr-leonro.local>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170327195500.GH20443@mtr-leonro.local>
 <20170327201714.GB29831@srabinov-linux.uk.oracle.com>
 <20170328091940.GA14058@srabinov-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0Ed1hDcWxc3B7cn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170328091940.GA14058-t9juWtktDCT52KUv/Ok+f8QLKKaP9WJ9VpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--y0Ed1hDcWxc3B7cn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2017 at 12:19:41PM +0300, Shamir Rabinovitch wrote:
> On Mon, Mar 27, 2017 at 11:17:14PM +0300, Shamir Rabinovitch wrote:
> >
> > > >
> > > > +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> > > > +static int ipoib_netdev_event(struct notifier_block *this,
> > > > +			      unsigned long event, void *ptr)
> > > > +{
> > > > +	struct netdev_notifier_info *ni = ptr;
> > > > +	struct net_device *dev = ni->dev;
> > > > +
> > > > +	if (dev->netdev_ops->ndo_open != ipoib_open)
> > > > +		return NOTIFY_DONE;
> > > > +
> > > > +	switch (event) {
> > > > +	case NETDEV_REGISTER:
> > > > +		ipoib_create_debug_files(dev);
> > > > +		break;
> > > > +	case NETDEV_CHANGENAME:
> > > > +		ipoib_debugfs_rename(dev);
> > >
> > > Why do we need explicit ipoib_debugfs_rename function?
> > > Will it work by simply calling ipoib_delete_debug_files
> > > and immediately after that ipoib_create_debug_files?
> > >
> > >
> > > > +		break;
> > > > +	case NETDEV_UNREGISTER:
> > > > +		ipoib_delete_debug_files(dev);
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	return NOTIFY_DONE;
> > > > +}
> > > > +#endif
> > > > +
> >
> > Hi Leon,
> >
> > Good point.
> > I will have look on this idea and get back to you.
> >
> > BR, Shamir
>
> Hi Leon,
>
> It seems that the difference between using debugfs_rename and a
> combination of debugfs_create_file and debugfs_remove is mainly the
> atomicy of the rename operation with regard to the file system.
> debugfs_rename is atomic operation while the above combination is not.
> As result I see kernel panic when the rename operation interleave with
> the delete due to module unload. So after carefully considering what you
> suggest I think it might introduce unexpected issues.

Thank you for checking it.

There is one more thing which I noticed, you should check the return
values of debugfs_remove and destroy debugfs in case of failures.

>
> BR, Shamir

--y0Ed1hDcWxc3B7cn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljal8EACgkQ5GN7iDZy
WKdtwA//ak0ETC7REHzLVeug5PAmprfh6b5bN3YYokZ/F33ooPbMicTyDCGpb2ac
ssu5ryMCK1RKvDWQ0EWkAP+wasUaHUz5CiLl004JOO1eLV2mVrBXWzRTDo/EE6xB
WU7K7r6nYg9MnHuDzvW5mwn/k1nPtWoH+AXunQbcLBxoUpgzHyhIiVQaMdko8FOs
4LYms35aLQdkVeOCjLVb/Zi7zZ8ykRC2E8Yy1d10c15rT9Cy8hYbMghIPAMcBKKS
nwNrw9tEIDc3fsR+yDPMmUCQ42smljEsRXEPA1AMHBjTwDefdPr895MafXMcxFzu
50gLVJRiy/SqYNvRvknAxwDS3g9X2Us+Qo7J3jY+rZu4cMTF2jikZzYPGxKpUaAS
cRITpAU6lowpsND+19EZKyqq0JyS27vJ4kgPxeAcUs52vGZJZOEQDurVEHrEGMMy
0hgWmdR9RolwoXYyoSWwbuaIRLzsuCNar8qULASvFemgwm1qxon4N1lLMb5wz8sN
jJ3WcBzrpzntogMP+3rB2ncOc4+evFIP61KfFQAfdbaOrN1ynd7qRdjwmDrQoz04
Yw3waS5m9J13oBEL+wRRPsLS/xF6NylxLKXm/aaUpZGRHRNiznipB9QLPyEwT+kJ
5OZjau0hi65asoJfCfL57WICt7Pcss+nfrSdpEYSkqSMAQmvZYM=
=NFgd
-----END PGP SIGNATURE-----

--y0Ed1hDcWxc3B7cn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
