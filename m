From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/13] Have cmake run man pages through text substitution
Date: Mon, 26 Sep 2016 10:01:53 +0300
Message-ID: <20160926070153.GI4088@leon.nu>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08E9D8@ORSMSX109.amr.corp.intel.com>
 <20160923213819.GC8490@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="g5OIygP5QP1fC/+Y"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--g5OIygP5QP1fC/+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 26, 2016 at 06:30:21AM +0000, Weiny, Ira wrote:
> >
> > On Fri, Sep 23, 2016 at 09:23:42PM +0000, Hefty, Sean wrote:
> > > > rsocket.7 had an errant text substitution that never worked, it is a
> > > > good idea to have the man pages use the correct paths, so let us
> > > > have cmake run them through.
> > > >
> > > > Any man page ending in '.in' will be substituted automatically.
> > > >
> > > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >
> > > Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > FWIW, I'm in favor of replacing the man pages with markdown and then
> > > generating the man pages from that.  I volunteer someone else to do
> > > that work.
> >
> > I concur, and someone else should do the work ..
> >
> > We could begin by requiring all new man pages to be in markdown format.
> > Do you do this in libfabric? What conversion tool do you like?
> >
> > I've used rst for this in the past with reasonable results..
>
> Infiniband-diags uses rst through rst2man.  But if I had to do it over I would probably do it different.  rst2man is not always installed and has caused build issues for some people.  Whatever tool we use I would recommend it be something common.  I'm not too familiar with markdown.  Is this really common now?

Among hipsters - yes :)

>
> Ira
>
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> > body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--g5OIygP5QP1fC/+Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX6MfhAAoJEORje4g2clinWl4P/2Ua7GccJ58qgtSqzJVR8Lcx
i1jm39JeahYCaxYok8O89oeVwBXtvb/x6PwvA4DiUFjvz+zxoxdM5/MDD5mmFg5A
GiP3QOBLkJnzfVK70iqBbE3O7rlx4aiPSa3c1Et0t0taFcxjHXl5DtPk4aHMy7Wb
WAXERofggC4kIvxYY+8Xp2MgXMDOVQbxN60UOTZIxiuMWDpPlLLBGi+BbBO70qyO
f5gAaJ0yUn3OATrxiM1vv4zX5rQZzLDp2w5wzJgZHOzgaBJ8uTJyyBywRvBW8Rj0
tuLfwtHKmj20zJtkU2Vy4FmsgItlEzLWTcQRkjsACQE+Cg2CdLFPfZ7jc4Ve7B3u
a03KZzgVjPeFtmpa1dmAJyDtc2L7SM9QDglZthXIA5HoB2KeRwHS035fFM85Y6tw
m4b9jf8aCIpe+u08wYRo/6put8zY8RX4xFKLQgziFy4r+/8nE+8mwWCiy7Ov4wEH
oGBLuGjd8jLxjV0/33OOwyIvwU2oJhOUD6vLjcz6XmuVgzZLk6f1GCIUWozbCB8i
Ajz3ZAE8uzUmEDDwQoK+sVc4/06WOVptDt+VdkzkB4+7IkZP3DMW2z5fVLAzRpkI
7M/xlln9/qJU8XLODikfWITK0nDV7OPU2Y1U5wQn2yO2SwdFrI/iIFBdMrXOLqs1
3D2ycIvJAfmpBtvb72nF
=tHb0
-----END PGP SIGNATURE-----

--g5OIygP5QP1fC/+Y--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
