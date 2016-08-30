From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 09:08:42 +0300
Message-ID: <20160830060842.GJ594@leon.nu>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="to+bXLvrczl8f0V1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160829161902.GB23557-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--to+bXLvrczl8f0V1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 29, 2016 at 10:19:02AM -0600, Jason Gunthorpe wrote:
> On Mon, Aug 29, 2016 at 09:39:01AM -0500, Steve Wise wrote:
>
> > > Again, it doesn't matter. The distros will take from upstream whenever
> > > they are ready and upstream is 'continuously releasable'. This way the
> > > distros can get everything and not have to hunt down 15 different git
> > > trees randomly sprinkled across the internet
> >
> > Please walk us through this scenario:  Vendor X has very important changes to
> > their provider lib that enables new a hw device.  There is no dependency on any
> > other rdma-plumbing library.  How will that new important enhancement get made
> > available to downstream distros in a timely manner?
>
> Post the patch. Tag it with a Fixes: line. Doug/etc pick it
> up. Distros notice the new commit on git, marked for backporting and
> consider backporting it into their distro.

Doug is a busy person and there is a limit on how fast he can handle it.
He is already buried under his internal and external responsibilities.

Placing him responsible for vendors code will add extra step,
extra complexity to the chain and will hurt kernel/libibverbs flows.

In addition, Steve's change is not a fix, but new functionality.

>
> The vendor will still probably have to lobby the distros to include
> the specific change quickly, that is no different of course. At least
> now there is a better chance the non-lobbied distros will keep pace..
>
> Same basic process as the kernel.
>
> End-users observing the single tree can get the change very quickly by
> grabbing the single git and building it to their distro's packages.
>
> The state today is pretty sad. For example, libmlx4 is up to 1.2.1,
> while the best I can get from Debian is 1.0.6.

The point is taken.

>
> In your specific case, you've kind of missed the large problem.
> libcxgb4 isn't even packaged in Debian (or derived). A big swath of
> Linux users don't even have your code available from their distro *at
> all* - and that is a direct consequence of this mess we have made
> upstream.
>
> The distros are obviously not acceptably keeping pace with our
> upstream mess. It looks like only Doug and RH are able to keep
> up. IIRC John at SuSE just uses OFED (bleck) rather than sort this all
> out by hand.
>
> Further, we have another pending 2-3 upstream kernel drivers coming
> and I have no idea where to find their userspace components..

And I have no idea, where you can buy these custom based SoCs.

>
> We need to grow up and provide something sensible for our downstreams,
> so our users can get the software easily..

No one is arguing with you about it, the talks are about the process and
responsibilities which need to be cleared BEFORE.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--to+bXLvrczl8f0V1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxSLqAAoJEORje4g2clinD9YQAK0FTlCSdwy/q4B2mhitLZhh
RALAXPDzHAf/SjHWnzXrFGpdl3rq8DvDp6P9nGFohc25RIwIPkbhH1mJ9FEGGj5i
zd/n2UbwfPsqmMXp5OLjnI+q51gDPM4gzwCoFMOiqtiQuR/oItO/AD72RASCYI70
tQijZ0ILhHlOcJRafIfMGuAb5bgDxoIthXR4dJUSSC+RctL37UqKDP2YS5sJePZK
kHCCImhkx37qpzQMUbyGG1dY96AznwLTc/segXTysZhy9kav/EzoGXHiFvkcrTDn
JR/dQAjLXCZslzxSohBS09b4SsJyMcpVor1pTgE52gVRULXv2hjKiA5spLa0XH3V
BGPJHkm9Y7ulRQvRn/UEXGOfgGF7ywwKnrljwjNtZE6bzj1VpKOiaMCNzl/kVhny
zApWRuSWBTe9HsSgHv5AR4Y7UJ0EJw4GMgZ3UCTR13tlckTIKvyEKyV6YFy5iw+U
NIoLtAWr9LTUUxuOnyKKJdBcdx+IgoZ79IHodnZG4LQij6TyLoqOYCWmG1p6PGi7
zeWohFxBE8Df+ZJNGe1MBn8u7uXfm0zUEtudG1hmKl9hBHqHonQ1zaj8QNWns2/x
V8C+V/P+QXCf1FhwXFPLaQVgGada6UkB/uZSC+nuOBGXw1jYHNdnVzvEND7p0Rle
d+84SpYtlj7zfW3e7Zwu
=UBdk
-----END PGP SIGNATURE-----

--to+bXLvrczl8f0V1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
