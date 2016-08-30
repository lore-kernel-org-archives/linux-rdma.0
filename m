From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 08:43:52 +0300
Message-ID: <20160830054352.GI594@leon.nu>
References: <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227@redhat.com>
 <20160828132804.GN594@leon.nu>
 <20160828183627.GC12783@obsidianresearch.com>
 <20160829062918.GR594@leon.nu>
 <20160829160009.GA23557@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="csjV5iuXLa65tnQH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160829160009.GA23557-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--csjV5iuXLa65tnQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 29, 2016 at 10:00:09AM -0600, Jason Gunthorpe wrote:
> On Mon, Aug 29, 2016 at 09:29:18AM +0300, Leon Romanovsky wrote:
>
> > I'm doing that by running number of one liners [1], it builds me
> > development setup in shared folder, so my base image is continuing
> > to be clean.
>
> Yes, I've done this approach as well, I actually have a script some
> place that kinda automates it. This is not nearly as easy to do as a
> single tree inplace build, and requires some expertise to setup.
>
> You'd be less happy if you scaled it to all our trees..
>
> > > Doug is also adressing a larger issue with packaging and getting
> > > everything to build correctly as the distro - he talked about it here:
> > >
> > > https://www.spinics.net/lists/linux-rdma/msg37855.html
> >
> > I read that thread and think that it is related to unoptimized build
> > process of one distro who for any reason decided do not use repo tool
> > [2] for managing complex build dependencies between different git trees,
> > but used excel file and manual download of source tarballs.
>
> Do not underestimate how hard a job the distro people have.

Everyone works hard, especially they, and the question is do the distro
people want to revise their process. The change of upstream process to
suit their needs is a nice solution, but it needs to be beneficial to
everyone. Current proposal is not good to vendors, who are responsible
for upstreaming their work.

>
> > RDMA stack in that specific distro and no need to invent new beast
> > (rdma-plumbers).
>
> Progress, Leon!

I disagree that removing old, unsupported libraries from the graves is
called progress.

>
> Jason

--csjV5iuXLa65tnQH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxR0YAAoJEORje4g2clinaXMP/jtE7y65tvXXdZMSDbs4aIAG
ForEv9kmn/qHzuKFaJXl5uTYhlfHJIbjoa2BYDcRgUdk2yL98DPPcF/XcAlbIbmM
CGH4rKw1gTwY0iLBFU6FbmkzxnqLLZSFEkvWp4ASrdCtvJVeR3oWzaS30pbKq2CW
WpPSeixbuYlUZY1uoPEHZ/ZbgCj4qz9l2nZtZt8DXm6uriK27CzXesn/CzczOo+C
ug0RtTEcBpOfpRPmx4F2FKb4K0P37Tbl2jDclPfvwk1SXVwetA1VaVoF0HhYD/PO
wv7zSyrx5yqM9+ImzuH7P1NO2dlebu+ZI7sDfo73dBInMQ75po3SbkyH4sr/5zTK
6d7nJFikfGSR+pggnDS0tl6gUnQQsHQQipKPKC9qWz38PLIH3XqCVnqxkNzKl9lk
FdOljwWwO6rHBqvzbPBmmiuZKzENGAx7mIiruJGEZRpK6bEX9Yd31vfZ13b6BDLC
tNu3ZbnWtwwWP1zbVZijidXVZ+H2DWi8AP0rlLSXrlN6QpSUsvNAnZPOtj9t6Rwi
sRNnjwi0f9REoBz8F8bMOboLnemH7LGRjueRwxEzvcf3Zx46OLLHy/4vLsgQNLJ2
/VICGYN3Cyao0AVmPFCs8x8J5Wt3zVGyLKBF76S/f8BN7JF167KJUXYzA9qWQ11E
7SGSI7HVrG5Qbk0mZYMc
=bk4w
-----END PGP SIGNATURE-----

--csjV5iuXLa65tnQH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
