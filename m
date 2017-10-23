From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Expose CQ moderation to user space
Date: Mon, 23 Oct 2017 19:54:17 +0300
Message-ID: <20171023165417.GI2106@mtr-leonro.local>
References: <20171019053524.11135-1-leon@kernel.org>
 <20171023094744.GH2106@mtr-leonro.local>
 <20171023130804.GA21584@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Uaw16JuuybUwHkzF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023130804.GA21584-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Uaw16JuuybUwHkzF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 08:08:04AM -0500, Shiraz Saleem wrote:
> On Mon, Oct 23, 2017 at 12:47:44PM +0300, Leon Romanovsky wrote:
> > On Thu, Oct 19, 2017 at 08:35:18AM +0300, Leon Romanovsky wrote:
> > > This patch set exposes CQ moderation. This will allow to moderate
> > > number of CQEs needed to create an event. Such change brings performance
> > > improvement by reducing pressure on application to receive event per-CQE.
> > >
> > > The proposed semantics follows the well-established kernel semantics.
> > >
> > >  * cq_max_count - defines the number of cookies needed to create an event.
> > >  * cq_period 	- defines the timeout between last event and a new one
> > > 		  that will occur even if cq_max_count was not reached
> > >
> > > The patches are available in the git repository at:
> > >   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-19-2
> > >
> > > 	Thanks
> > > ---------------------------------------
> > >
> >
> > Doug,
> >
> > Please drop this series.
> >
> > I'll resubmit it once user space part will be finished.
> >
> > Mellanox,
> > I would like to use this opportunity and to ask publicly, please submit kernel
> > and user spaces altogether.
> >
> > It causes for too much errors and it is actually wrong to submit it separately.
> >
>
> Hi Leon,
>
> I have a generic question. And I apologize if this is redundant and
> has been answered before. But what is the process for user-space submissions?

On top of Jason's answer. Sometimes, you can skip mailing list, usually it is
spelling fixes or very local and small fixes to your code.

>
> For libi40iw we make all submissions to this mailing list _only_ and
> this is all we are aware of. Are there alternate submission paths?
>
> Shiraz
>
>

--Uaw16JuuybUwHkzF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuHrkACgkQ5GN7iDZy
WKdPqRAAoYNQ4affNRQqTwpJMh/YYAXwdm/yc7OY4kvMzvP/QZIPCVDyy5gBoBqy
lt3TQch2O8tsfDmr3e2LHTEHpmbQGCpxJPIRNQ+bxBSsX8H6ysCkCipAMnR24W29
2qY7FlRCrkMDSBCKVdVPSSZV1qbmGki8fVNFeIfjgdM6guvriumkUd0ha+peQrtc
PdplzOgKOBGS+ySjUeJENi2QBmRQpViUl/6vSr+m6o5u84JwFmlrgH8Rpc1/iCCf
LAZBTGia25FrENs38WwNoQLpHRkt0wsxk55nju1/By0R3nCTapJL4CiiOnQ9sCmC
DgbOkAJblPPhDMugV2NLm7kxmdFJqzm29PT2sXOAjg0zY1C+58ZgaohP9c8Pt0XC
7cUDoWaV1lp5obkzgad1uONs0v5bgiMIfF1yC2+xwp+qyyR4ip5ub2YmTphZpVI+
VDozb1Zn/rzRiZ+kVz4XxxZwcbJhbJsxPqs1pevQyFU3RFk+sUN1LT9wZ011y/JY
evaiV0ggGtDUqCth8fCaQj77m1PzZk5tBJl125ep6Hzf1rhj4Xf/3ItbqvYMWgTW
9p+TyclFjWQNKENMsgf3LTmBrwgMe+jEVaOVMkjXoG39LQWrN+3e6xYUF14Wt3sm
zz+IMXxyljgij5kqK8L6gUCLCmmATbL6VyBkqcfreH+LUvccMpc=
=jGzQ
-----END PGP SIGNATURE-----

--Uaw16JuuybUwHkzF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
