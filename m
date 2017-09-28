From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Thu, 28 Sep 2017 20:08:21 +0300
Message-ID: <20170928170821.GD2297@mtr-leonro.local>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tGYciKv+SE5JumYf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928165305.GE17880-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tGYciKv+SE5JumYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 10:53:05AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 28, 2017 at 07:47:35PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 28, 2017 at 10:34:06AM -0600, Jason Gunthorpe wrote:
> > > On Wed, Sep 27, 2017 at 12:32:48PM +0300, Yuval Shaia wrote:
> > > > The sysfs "create_child" interface creates pkey based child interface but
> > > > derives the name from parent device name and pkey value.
> > > > This makes administration difficult where pkey values can change but
> > > > policies encoded with device names do not.
> > > >
> > > > We add ability to create a child interface with a user specified name and a
> > > > specified pkey with a new sysfs "create_named_child" interface (and also
> > > > add a corresponding "delete_named_child" interface).
> > > >
> > > > We also add a new module api interface to query pkey from a netdevice so
> > > > any kernel users of pkey based child interfaces can query it - since with
> > > > device name decoupled from pkey, it can no longer be deduced from parsing
> > > > the device name by other kernel users.
> > >
> > > This should all use netlink these days, not more sysfs files.
> > >
> > > Leon? What do you think about using rdmatool to provide a command line
> > > for creating ipoib children?
> >
> > As far as I understand ipoib_netlink.c, ipoib_new_child_link() already
> > implements it and it is supported in "ip".
>
> Oh right:
>
>   ip link add DEVICE name NAME type ipoib [ pkey PKEY ] [mode MODE ]
>
> So what is the point of this series?
>
> NAK from me.

I tried to be more polite than you :)

>
> Jason

--tGYciKv+SE5JumYf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNLIUACgkQ5GN7iDZy
WKdWTBAAjZ0CdotHkiYJX3EvNbYAvjJ/il/MTDJhs3xNKbhr1+msi5RwSNutLRPd
BtYtN2gvv3B28S28XX//lQm2+HzbUc/oQo0FW3d/YeFWaOEwTYHZknbg5s7SpPz9
8exceabNx6VmDOIbhCG4bgBwbXEZhpprQ+7nvd4vWU6YNJNWL/ZMAcmSQI9ibO9c
4dohlq0QkpUqj505390KD1tRuOj+zz6947YmqkMpaKMMaa6dAWS3LyfXVsE7TVaX
f3o5u0ov5+mdFFBaAF0Nk1VsGmG1rf8CuTJYE6rE2qdp+7Tw1Sd2NpRX+PqUrvK4
bsDhiP5XOvJ9AYl3lJE0Pmj2uOSVQwyNl9DkTtj2VWCvrUf8l6PewuvhqCmAU5MR
7x5L1k8rVPn9Ve6ys3vaPOlGHHoPVRBr8HF452IKbaB0leYmxZID1F5K3mZfX4j5
feEAcZ+abrjgbHww/G34Ur2PuasaZys0zD/Tadx92ajzYBstPx+xRyptlTb2ZdG4
/VQQoqdGVZvUR6RlslN19JyFQHfZ2riCYJitdzCvMnZRGB4mHvMSs0yalv5fwJFJ
Sk3dfxMszyTJGENj+lwbO1a9U8k85IaUhBoUkidmiCy7zVEcqqsGoGoOwSkDPba/
2BRGDboyBV+mySr9WWLVl+usjP353p4ML2XA6i7uyBaiX8Qpl4Q=
=gGY9
-----END PGP SIGNATURE-----

--tGYciKv+SE5JumYf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
