From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Fri, 22 Sep 2017 23:43:20 +0300
Message-ID: <20170922204320.GW5788@mtr-leonro.local>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
 <20170920163237.GD536@obsidianresearch.com>
 <1506101272.5172.11.camel@redhat.com>
 <20170922194834.GA26479@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TegBI+r9roYdcP94"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170922194834.GA26479-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--TegBI+r9roYdcP94
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 22, 2017 at 01:48:34PM -0600, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2017 at 01:27:52PM -0400, Doug Ledford wrote:
> > On Wed, 2017-09-20 at 10:32 -0600, Jason Gunthorpe wrote:
> > > On Wed, Sep 20, 2017 at 11:53:39AM +0200, Johannes Thumshirn wrote:
> > > > I wanted to try out Christoph's NVMe multipathing patchset on my
> > > > NVMe OmniPath
> > > > setup and merged it into 4.14-rc1. On bootup I stumbled upon that
> > > > splat and no
> > > > RDMA operation was possible:
> > >
> > > I think this was already found and fixed a month ago?? The oops is
> > > the same:
> > >
> > > https://patchwork.kernel.org/patch/9932505/
> > >
> > > Doug, one of the topics during the LPC was 'what to QA' - it
> > > obviously causes QA problems if known bugs are left to sit on the
> > > mailing list for a month :(
> >
> > A few things:
> >
> > 1)  It wasn't a month
> > 2)  I was out on well known, pre-announced PTO
> > 3)  I've got it now
> >
> > I can't do much else about it.
>
> Just so we are talking about the same expectation..
>
> The patch v1 was on Aug 30, you accepted it on Sep 20, as I write this
> I don't see it on your k.o. I see it in your github tree, so I know it
> is on the way.

Maybe my expectations are too high, but I don't see any difference
between 3 weeks and 4 weeks in this particular case.

>
> If you push it to k.o at EOD today it will be ~27 days before it gets
> into the hands of anyone doing QA based on your k.o tree.
>
> If you send a PR on Monday it will be > 28 days before it gets into
> the hands of anyone doing QA from Linus's tree.

Most of the time, QA doesn't run on k.o -rc branch but run it directly
on Linus's tree. It is the best and the right way to test the whole kernel
and to find bugs in the coming release. The focus is to clean release
and not to test k.o. -rc branches, while the expectation is that -rc
patches are small, localized and fix specific issue.

The -next branch is a completely different story.

>
> I know this patch unavoidably overlaps with your PTO, but this is
> still essentially an example of the topic we discussed at LPC..
>
> As a concrete recommendation, pushing this kind of patch to your k.o
> right away on the 20th and skipping the github 0day process might be
> helpful..
>
> Jason

--TegBI+r9roYdcP94
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnFdegACgkQ5GN7iDZy
WKeR/A/+Ovx0rJ/VrvHPjQJ8UzCATAb1yhTX4MuNVfx4sNJBoRo9FzgIYdeM8JB9
Oot7rXR8gcDL0k9dD9wGpsxpxLUBgcysvoIfSnxrgqBMuNYF4RfU3YGFfHjfLPGm
Wqcuk9hJa73+gKqfx79QBFnM5XpGnzPCJuOZRUEyiNUOOQskQ+ftj7jrp76qZNpB
wKQ2Urs1loD5pky23LMnVyEV44icPGc/juYAAK8ZsJfNTRwq62IoDHVFLDBJhiiZ
Imen7JliHllSblPhILtACqDyrjuGq9555RR6l8rcYtNxvofE6qvmA9loeI7o2GhD
kPKtsjMiCnEG5Fk6UW6kTbtRdgL7Gh9nHRx1GjAtZc1JJJuLiET8HFbkeqGTPYBz
84Ls3m5RklZjJ4Q9d2ZSt2BcxgFSTsHnFhT1krs3IZWvolovBeAWnmz/WDFtk3/o
NI8zFXlOZ09T49P8N0zUg20/ocRlE7m0fzsZuFPym1lOPtLF1YpjsKJ2STRJzoSt
a0dppmzKYOfCdhHn6EvNbajCpsMht8ucbIv1SUhzcdmVwyrgQMSXvzE05swrOtQ9
ug4YCvpOIbRJ3XZd0GP3fKVa8Z4zKb0Sjv7mzS718Y8V+RofU79NNh11ui4QJ9HN
rRMlFKQqISFXJkyDGmCYvrFf4hl1MmcIjZ2RZ1bpMEqNfGjzoyU=
=6PO1
-----END PGP SIGNATURE-----

--TegBI+r9roYdcP94--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
