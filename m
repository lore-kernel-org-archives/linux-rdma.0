From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] nvmet-rdma: SRQ per completion vector
Date: Mon, 20 Nov 2017 13:34:52 +0200
Message-ID: <20171120113452.GH18825@mtr-leonro.local>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <263c6c9d-0dd2-da4f-12a9-efefd361e592@grimberg.me>
 <a8e2be0b-deb7-8cc1-92ce-fc5dea3e241a@mellanox.com>
 <20171118125229.GT18825@mtr-leonro.local>
 <935af437-d69e-e258-c00a-8bf9a04f9988@mellanox.com>
 <20171118144042.GU18825@mtr-leonro.local>
 <d6579bd6-053e-1214-ea95-ff72e6191cb0@mellanox.com>
 <14682e66-de0d-042b-434b-0eb40fb79f0c@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7HqTdBsuSOA5h1B/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14682e66-de0d-042b-434b-0eb40fb79f0c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7HqTdBsuSOA5h1B/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 20, 2017 at 01:00:28PM +0200, Sagi Grimberg wrote:
>
> > > > > > We can implement it for isert, but I think it's better
> > > > > > to see how the CQ
> > > > > > pool will be defined first.
> > > > > > It can bring a big benefit and improvement for ib_srpt
> > > > > > (similar to NVMEoF
> > > > > > target) but I'm not sure if I can commit for that one soon..
> > > > >
> > > > > Too bad, but I don't see inclusion of generic SRQ pool code in RDMA
> > > > > subsystem without actual conversion of existing ULP clients.
> > > > >
> > > > > Thanks
> > > > >
> > > >
> > > > This patchset adds this feature to NVMEoF target so actually
> > > > there are ULPs
> > > > that use it. Same issue we have with mr_pool that only RDMA rw.c
> > > > use it (Now
> > > > we're adding it to NVMEoF initiators too - in review).
> > >
> > > The difference between your code and mr_pool is that mr_pool is part of
> > > RDMA/core and in use by RDMA/core (rw.c), which in use by all ULPs.
> > >
> > > However if you insist, we can remove EXPORT_SYMBOL from mr_pool
> > > implementation, because of being part of RDMA/core and it blows
> > > symbols map without need. Should I?
> >
> > No, we'll use it in NVMEoF host as I mentioned earlier.
> > >
> > > In your case, you are proposing generic interface, which supposed to be
> > > good fit for all ULPs but without those ULPs.
> > >
> > > > I can add srq_pool to iSER target code but I don't want to
> > > > re-write it again
> > > > in few weeks, when the CQ pool will be added.
> > >
> > > So, please finalize interface in RFC stage and once you are ready,
> > > proceed to
> > > the actual patches.
> > >
> > > > Regarding other ULPs, we don't have a testing environment for them so I
> > > > prefer not to commit on their implementation in the near future.
> > >
> > > You are not expected to have all testing environment, it is their (ULPs
> > > maintainers) responsibility to test your conversion, because you are
> > > doing conversion to generic interface.
> > >
> > > >
> > > > I don't know why we can't add this feature "as is".
> > > > Other ULPs maintainers might use it once it will be pushed.
> > >
> > > Sorry, but it is not how kernel development process works.
> > > "You propose -> you do" and not "You propose -> they do".
> >
> > I'm not changing an interface here. So all the other ULPs that use SRQ
> > (ipoib and srpt) currently will cuntinue using it.
> > I don't know why this patchset brought up the idea to add SRQ pools to
> > isert/svcrdma/etc.., but knowing that there are patches (under
> > discussions) that will have a big enfluance on these drivers (at least
> > isert), it doesn't make sence to implement *new* feature (SRQ usage) and
> > chage it a week afterwards.
>
> I'm almost sorry I asked :)
>

There is nothing to sorry about it. It was just a matter of time when we
would see it.

The reason why I'm so direct in this case, is related to the fact that
resource pools are really beneficial when they are used for create/destroy
of resources in (massive) dynamic operations.

In the proposed code (nvme-rdma), it is not the case and resources (SRQ)
are statically allocated, hence it makes no sense to me to propose new interface
without seeing any benefits from it.

This is why I'm asking from Max or implement real users of this interface or
don't provide that interface at all.

> Max,
>
> Leon's request while adding more work for you is valid as I see it. Leon
> and Doug (like other kernel maintainers and others in our community) are
> interested in improving the RDMA core subsystem in the sense of offering
> useful interfaces and having the consumers implement as less as
> possible. Making useful features/interfaces (like in your case)
> available for (and adopted by) most of the common consumers is helping
> the community and the subsystem as a whole rather than helping the
> specific module we happen to be focused on at that specific time. The
> long term goal is to make the consumers do as much as possible with
> implementing as less as possible.
>
> Having said that, if it was up to me, I wouldn't say its a hard
> requirement but definitely encouraged (I try to do it for the core
> interfaces I happen to offer and I know others have too).
> I think that Doug and others should really decide on the direction here.
>
> What do others think?

Right, I'm not alone here.

I already said my position in this mailing list, but will repeat it:
core work is must to move forward and to make this community better.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7HqTdBsuSOA5h1B/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloSvdwACgkQ5GN7iDZy
WKcBHA//Vh1Rr6S9FEkBr4eT7z/nM7xMfH3acnvUz1j3JXGQzhpnMINv4SgNT4un
wkt3y84ySquhocD4wupQzxDDllGTx5PKli2cGJ1vdEMRbaXgcu/P6Ve0nyMNrBcy
9CuFGVESJd5466Mxn+IdPuXMICj0OPDL9IbUBTna5vtS2vGhrGtW1ewIg61aRGSx
yIjRyA7gA0HHrWK7Xc19rDAhfeKsWhC+76+lxI1oRnQMMl8LGS5RVgWxHe9BHvwJ
+ceQDbkuVTJE+r6vhSbTzU/QZhP0J0l2D7e1C8hei+miVnLKspBqDQl+dy255b7g
qBJBH57S/4hNkQX+iGnSoLloKIvwTgV0hgR/km6149RpmcpfpbUue0ymP3//AKNA
TIWox6PO3sVH/29RvqDiXLxEMDZB7fBah/BRan1YwGk/wyDmmWQZ8fxzNsv5QCq3
QeFW53JNz3uk8z1WQLZJuStAT8ruPylx+70zpSTR3Fkez4KoaLeVDlbVq8g5tiK7
lRcaMX+O0cM5AFlM05aF24eanVH8Y4FgdwwQ3GRo/Zmv7PyVGii3O9BftKvxqq2A
evkDOTHiSSi/eu1SFvGWW/okinKLDStNKjrwzHOuWD/yrK3Xz3Rm3H9PwyE79nb2
0tWkcPPXQ/GGqtLhStb95E53BOMcXpHSgdlY18WIoXU6oef5uSo=
=JEk7
-----END PGP SIGNATURE-----

--7HqTdBsuSOA5h1B/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
