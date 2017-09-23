From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Sat, 23 Sep 2017 10:38:43 +0300
Message-ID: <20170923073843.GX5788@mtr-leonro.local>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
 <20170920163237.GD536@obsidianresearch.com>
 <1506101272.5172.11.camel@redhat.com>
 <20170922194834.GA26479@obsidianresearch.com>
 <1506114386.120853.2.camel@redhat.com>
 <20170922211727.GA2348@obsidianresearch.com>
 <1506120161.120853.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/CHBEyLWSSL2QXIQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506120161.120853.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/CHBEyLWSSL2QXIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 22, 2017 at 06:42:41PM -0400, Doug Ledford wrote:
> On Fri, 2017-09-22 at 15:17 -0600, Jason Gunthorpe wrote:
> > On Fri, Sep 22, 2017 at 05:06:26PM -0400, Doug Ledford wrote:
> >
> > > Sure, I get that, but I was already out on PTO on the 30th.  What
> > > sucks
> > > is that it landed right after I was out.  But I plan to have the
> > > pull
> > > request in before EOB today, so the difference between the 20th and
> > > today is neglible.  Especially since lots of people doing QA
> > > testing
> > > prefer to take -rc tags, in that case, the difference is non-
> > > existent.
> >
> > My thinking was that people should test -rc,
>
> Great, with you here...
>
> >  but if they have problems
> > they could grab your for-rc branch and check if their issue is
> > already
> > fixed..
>
> They can do this too...
>
> But if that still doesn't resolve their problem, a quick check of the
> mailing list contents isn't out of the question either.  In that case,
> they would have found the solution to their problem.  But, when you get
> right down to it, only one person reported it in addition to the
> original poster, so either other people saw the original post and
> compensated in their own testing, or (the more likely I think), most
> people don't start testing -rcs until after -rc2.

I don't know about other people, but our testing of -rc starts on -rc1
and we are not waiting for -rc2. From my observe of netdev, they also
start to test -rc immediately.

Otherwise, what is the point of the week between -rc1 and -rc2?

> Which is why I try to set -rc2 as a milestone for several purposes.
> For getting in the bulk of the known fixes, but also as a branching
> point for for-next.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--/CHBEyLWSSL2QXIQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnGD4IACgkQ5GN7iDZy
WKcxdg//ZqSZo1DK48YeFtbjWaQsWYAVnXslmSN2QEo/S6VygQRg/SDLqR2z//cf
nja853FmKxawqZ2ryYZ5gOdYcMBhMXX1lAcDEmkSFb6cbeZEXWcr0a9wxdo1mPE6
qKZGvb7+BB9ESEn3GApO06luenbQMlcCFk2dboBunoOcjDowz84j+KrslKpgf/yJ
XjIbDRLOO3GNFZnUA23unH8xD10fDtgORglmJt0IuD5tSD1FkRPsTNw9aTsemZei
ww2AkKphVuFc49f6IZbTrvkr/vijwCYcAfhBC9n5dMHjfbR8a9P9us9n9viIqSSp
oIvvKKDmySSquhORybe+RBHWhkJyFaXXUxFb1PBrjv/2GJNItHxvV1jorewODP/F
VWNHAA8mvPeOdEUaxihkZ5rLRuuagon3ZbCKt7wMAZ77lalGpI1JCX7E9LIOtz8b
4jjJEPLp7p/Ce6ebjf4046R5fmgenGLOFFAz1FAPPYnGArQXz5cwkKdmlliCjDVB
EOmlnoBvvUSU3ssmHT73IAngD1t0LQgX8ejQHuD1BzkWBHDKBK7OWFQuKmAiKZFG
ax4l4gDK3ntD6s8fg1QyyRb2v7dno3vYlCplunxoT5eJwHyPh/cbu5xv3IM1/qqk
QTbTa0sSsyNheSAhhxg5ZmkfCMqjzMnrXLd/t99CgVLc/zp3Ae4=
=63IG
-----END PGP SIGNATURE-----

--/CHBEyLWSSL2QXIQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
