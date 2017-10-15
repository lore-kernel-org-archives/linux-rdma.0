From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Sun, 15 Oct 2017 09:27:14 +0300
Message-ID: <20171015062713.GV2106@mtr-leonro.local>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fryGc0vzirnrYIcd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171015054745.GA2608@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fryGc0vzirnrYIcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 15, 2017 at 08:47:46AM +0300, Yuval Shaia wrote:
> On Thu, Sep 28, 2017 at 10:53:05AM -0600, Jason Gunthorpe wrote:
> > On Thu, Sep 28, 2017 at 07:47:35PM +0300, Leon Romanovsky wrote:
> > > On Thu, Sep 28, 2017 at 10:34:06AM -0600, Jason Gunthorpe wrote:
> > > > On Wed, Sep 27, 2017 at 12:32:48PM +0300, Yuval Shaia wrote:
> > > > > The sysfs "create_child" interface creates pkey based child interface but
> > > > > derives the name from parent device name and pkey value.
> > > > > This makes administration difficult where pkey values can change but
> > > > > policies encoded with device names do not.
> > > > >
> > > > > We add ability to create a child interface with a user specified name and a
> > > > > specified pkey with a new sysfs "create_named_child" interface (and also
> > > > > add a corresponding "delete_named_child" interface).
> > > > >
> > > > > We also add a new module api interface to query pkey from a netdevice so
> > > > > any kernel users of pkey based child interfaces can query it - since with
> > > > > device name decoupled from pkey, it can no longer be deduced from parsing
> > > > > the device name by other kernel users.
> > > >
> > > > This should all use netlink these days, not more sysfs files.
> > > >
> > > > Leon? What do you think about using rdmatool to provide a command line
> > > > for creating ipoib children?
> > >
> > > As far as I understand ipoib_netlink.c, ipoib_new_child_link() already
> > > implements it and it is supported in "ip".
> >
> > Oh right:
> >
> >   ip link add DEVICE name NAME type ipoib [ pkey PKEY ] [mode MODE ]
>
> So with this interface we can entirely remove the sysfs interface to create
> child, right?

We can't :(, it will break user's scripts.

Thanks

>
> >
> > So what is the point of this series?
> >
> > NAK from me.
> >
> > Jason

--fryGc0vzirnrYIcd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlni/8EACgkQ5GN7iDZy
WKeR9Q/+INegjE4m88qfMvVvEEewea9cp1rEdbxjvJG73sEkq1JmCfybdBiLAmrk
gzXJK1aK7FAqEXH3L5/T+LsT9jTHgHtgSlVvUnCGytE0VA1UKZtLd9a5ZQ4qPgxO
YX/CkyaQjWBTDpsR0NNROyA4ERo9hlh5qGTkp5c7KQ90yoTqv4I4Tm7Ukz/pg6RO
S54VwhuAPGrNlKNwq1Ncdrm/aVY1gEP75JmXGziZytOofdLDU77mfvB0TksZwhqS
XvnsXGukW8ZmSjZpbq8JgQec4zOF4JGNErV8LCS9YWMqj9RVBwdunV6NJXLGceO7
2YHTrSkMG0NMcBk1BH5fwt5Fx94yOMtjscAjVYFcCIP9i9mzrAdoKbzKmrtzTb37
sfYZPu9b1WSlm+mzKFDCSnDP50X+iD9otPQ8z8YWFJtJEUZZhn+KLjD7NA+DzLnI
9l/gXvw0p9KETT7I2HDPSqr81iwRqtTIqWu7crOr1kU4s4JqCRdUv3rXHA/P95yI
5XcoiLgL4KDlGmgISPk++a2rvWcb4odYGedcdoy4qulNAEt6d8x0+7ClMKqJz+C0
W5ipfPwvcS1bcwBOhoqJxvfmvGJhq6gfcn6YukkKmuJDCpRfJZR2DGD5uzdFZR4h
z/LCpzIp0S1KrIgK5eI8f1lj/iQokrj8P50K3Qnx313Qzd80nIQ=
=vGy9
-----END PGP SIGNATURE-----

--fryGc0vzirnrYIcd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
