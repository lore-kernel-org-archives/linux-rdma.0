From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 29 Aug 2016 09:29:18 +0300
Message-ID: <20160829062918.GR594@leon.nu>
References: <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227@redhat.com>
 <20160828132804.GN594@leon.nu>
 <20160828183627.GC12783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lt3WynA+XK9Fj6D4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828183627.GC12783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lt3WynA+XK9Fj6D4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 28, 2016 at 12:36:27PM -0600, Jason Gunthorpe wrote:
> On Sun, Aug 28, 2016 at 04:28:04PM +0300, Leon Romanovsky wrote:
> > On Fri, Aug 26, 2016 at 11:17:52PM -0400, Doug Ledford wrote:
> > > On 8/25/2016 4:13 PM, Jason Gunthorpe wrote:
> > > > We've never been able to run the rdma stack from the build trees,
> > >
> > > It's possible...you just have to do every step in the right order ;-)  I
> > > had a spreadsheet that I tracked packages, versions, build states,
> > > install states, and dependencies.  Made things a lot easier.
> > >
> > > But I get your point.
> > >
> >
> > Sorry, but I missed your point. On my development machine, I'm
> > running all relevant RDMA stack directly from their git trees
> > without any excel file. It worked flawlessly without any
> > obstacles, did I do anything wrong?
>
> Maybe, because it is fairly hard to do correctly.
>
> How do you make sure that eg librdmacm or a provider is built against
> the git checkout of verbs, headers, shlib and all?
>
> How do you rebuild the right trees if a change is made to verbs?
>
> How do you have verbs load the provider driver from the git directory build?
>
> When I said 'from the build trees' I mean without a 'make install',
> just run 'build/bin/ibvdev_info' for instance and it guarenteed uses
> the build products exclusively, including all the libraries and
> providers.
>
> Or set LD_LIBRARY_PATH=`pwd`/build/lib and have everything
> use the new build.
>
> This is the goal, and the consolidated repo can do everything except
> the providers right now.

I'm doing that by running number of one liners [1], it builds me
development setup in shared folder, so my base image is continuing
to be clean.

It is not final version, I didn't upload it yet.

Libraries:
	@echo "Build libibverbs"
	@cd $(LIBIBVERBS_SRC)/; ./autogen.sh; ./configure --prefix=$(KVM_SHARED) CFLAGS=-I$(KVM_SHARED)/include LDFLAGS=-L$(KVM_SHARED)/lib CPPFLAGS=-I$(KVM_SHARED)/include; $(MAKE); $(MAKE) install
	@echo "Build libmlx5"
	@cd $(LIBMLX5_SRC)/; ./autogen.sh; ./configure --prefix=$(KVM_SHARED) CFLAGS=-I$(KVM_SHARED)/include LDFLAGS=-L$(KVM_SHARED)/lib CPPFLAGS=-I$(KVM_SHARED)/include; $(MAKE); $(MAKE) install

Kernel headers:
	@echo "Install kernel headers"
	@make -C $(KERNEL_SRC) headers_install INSTALL_HDR_PATH=$(KVM_SHARED)

>
> Doug is also adressing a larger issue with packaging and getting
> everything to build correctly as the distro - he talked about it here:
>
> https://www.spinics.net/lists/linux-rdma/msg37855.html

I read that thread and think that it is related to unoptimized build
process of one distro who for any reason decided do not use repo tool
[2] for managing complex build dependencies between different git trees,
but used excel file and manual download of source tarballs.

We used such tool for our 100+ git trees project and it worked like a charm.
There is worth to invest time and revise internal process of releasing
RDMA stack in that specific distro and no need to invent new beast
(rdma-plumbers).

[1] https://github.com/rleon/dev-scripts/blob/master/Makefile#L89
[2] https://source.android.com/source/developing.html

>
> Jason

--lt3WynA+XK9Fj6D4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXw9Y+AAoJEORje4g2clinWigQALDfNXnxDQSxtsYW7ccIfoqi
zyZZB+54aThPSwAzG1IdIuPYn0mBT1KmnbrajaDd7nq8MNCRSfsKE/5opmiGA1lE
AhJRybEU1qPoGlS4RG8tMB3cImvqOU1sQDlbBRthH5i38884xrAnGHlilhnaCmgf
9nw2tTonTxK/6sQJJN8uGaKcadpXhmHmDJYZYCrrwEsX9vI/rIqHQlSQqDQJGbzq
VmnbUUXbn27qL6ZcAZ61QW7//i4tK26TX3ycRE1I6vCWxrLWLrhDfU/KKncRABKF
DWiNLDruXOcgzBA6ReSaiyLlPhhOWwPHXEjJDCqBpw54uydLOZVJKZ3oHuMR5Nj7
J7yJwlxvbIlH0L//uBBYxM7JFMQ6B3lm7+GcJRpDn9gSo7rNSfDMsfgYeYNx3LZr
hg+DPVMjLNrMmiTNtV4lmMFViqLaTTO2t+DPAVKB0ckjg+Nq/FnBjMtZcoLvoBiG
KSbk0LohX/mGDL4KA+UWQe+VQsjzMkInN4Xc+QUCHKEqnueuYQtkua5WGK+NyHjV
YDsut2ug+8Vy/lCeEXbilKx8LSMkdA2sInalj4MvCo93Ug+A2qkMr1486n6cWLos
SNjzUoagPgL3lE32MzYdLdASnrjsUXAdpcneNduD1qwzWKjACzPZUZLDhr2cdqM0
ZLnKcFnXLGndAvDnWlOZ
=suEU
-----END PGP SIGNATURE-----

--lt3WynA+XK9Fj6D4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
