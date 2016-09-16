From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 16 Sep 2016 17:53:31 +0300
Message-ID: <20160916145331.GJ26069@leon.nu>
References: <20160915083945.GU26069@leon.nu>
 <20160915160427.GC18154@obsidianresearch.com>
 <01e901d20f6b$7ae067d0$70a13770$@opengridcomputing.com>
 <20160915163756.GB26069@leon.nu>
 <20160915164931.GC26111@obsidianresearch.com>
 <022e01d20f84$a3685870$ea390950$@opengridcomputing.com>
 <20160915192628.GB437@obsidianresearch.com>
 <02a501d20f88$8386bca0$8a9435e0$@opengridcomputing.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24EE4644@CRSMSX101.amr.corp.intel.com>
 <001501d21021$68ad9fe0$3a08dfa0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8Ll2WeG2L2s3+nMg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001501d21021$68ad9fe0$3a08dfa0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Weiny, Ira'" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "'Marciniszyn, Mike'" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Nikolova, Tatyana E'" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8Ll2WeG2L2s3+nMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 16, 2016 at 08:51:22AM -0500, Steve Wise wrote:
> > >
> > > > > > > Do we want to create rdma-tools after this task will be
> > > > > > > completed? For
> > > > > example
> > > > > > > with debug and performance tools in it.
> > > > > >
> > > > > > Prolification of repositories is exactly what this is intended to
> > > > > > prevent :(
> > > > >
> > > > > The goal would be to move all the tools/cmds/etc into one repo.  How
> > > > > is that prolification?
> > > >
> > > > I guess I should wait and see what could end up in there before
> > > > commenting...
> > > >
> > >
> > > I think we should shelf this discussion until we get our current project
> done...
> > >
> > > But... :)
> > >
> > > A quick gander at the OFED packages produces this list of possible
> > > candidates:
> > >
> > > dapl  (perhaps dapl should be in rdma-plumbing?) fabtests ibacm ibpd ibsim
> > > ibutils infiniband-diags infinipath-psm mstflint opensm perftest qlvnictools
> > > qperf rds-tools
> >
> > I strongly suggest against adding anything that is not a library and even then
> I like
> > what Jason has said previously.  "This is a library targeted for kernel APIs."
> So, for
> > example, libibmad was not included.  In fact architecturally I think ibmad
> should go
> > away somehow.  The main user is infiniband-diags but there are some other
> users
> > of it so I have not been able to deprecate it.
> >
> > I guess my opinion is I don't want to see this repo become "OFED" in a
> different
> > form.  There are valid reasons to have separate packages.  It is really the
> support
> > libraries which have been a pain.
>
> This discussion where I've listed possible inclusions is for a rdma-tools
> uber-repo, not the current plumbing repo (aka rdma-user).
>
> However, I'm beginning to think there really is no need for an rdma-tools repo.
> one benefit for having an rdma-user is to make it easy to do API changes and
> global changes to all provider libs.  For the rdma-tools and other packages that
> use RDMA, that will probably never be needed.
>
> Ok, this time I'm really done discussing an rdma-tools for now. :)

I talked about rdma-tools.git only and failed to understand why people started to add tools to rdma-user.git,
which is better to be called rdma-iibs.git.

Let's stop this discussion till better times.

>
> Steve.
>

--8Ll2WeG2L2s3+nMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX3AdrAAoJEORje4g2clinNs0P/jHgsb3oqJUbXogTgRPmGS2f
7px8jZyZO+NbaEXLsVu1ND0VzSSXxoiYf8eNo2hnc+EZqOe/RJQB8zBWmwo4Ozms
xu0pd6AvMcywY/lJspZUuAdesMaU9wbLE5wjxIt3V2qZy1TMj5S1dG8ydQ6Sj2Tl
koXOjANLL8uD5XiVUMOyPlGZuvTMx3L+bHPD3acb9Z/QgVcxxVAjiPLwmF+BUJGJ
fLP9SWpH2ln8qVroInCmWRq6WC3kBIR9ybpH5Rv4stmxWm6M+49FxaXFms0qlzWK
7uwPJB1pSdUL/dVZPur4MXD9ePh482WKZbGzjcDk7ULBebXtujxbi13FKxnSpZec
nbdlkY54SQ+VxTxUBUG2r78fj5Xf876Qee7rD2f61UhL8Fn0eutUaLy1DWGFxQSI
FQ6Y+iMZ2q6xIhjld+cVhEE255ieTpyaOdD7KP7SXSyhhwIopW5qIPGeaO75s10p
+c/7oG5iqSMiQGT8m6ZIQdS815WefLimXXO2/yykPe9M5/VhbQgnX40rL6AS5mXS
oy1u+on1r6Nd4HsaENuh/AfEw4MQU6HTrCh8hNlHTJGbYPkNO+yS4h6dGN3bkmBl
XOZDY3jrPlAGh/WLbR2EpLlnlmH8nUPd7FLcLjEWxgNtsmYuQL0rj18gfsb3QT4+
4iKpJDNyRaiHhws6TrVz
=U0c7
-----END PGP SIGNATURE-----

--8Ll2WeG2L2s3+nMg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
