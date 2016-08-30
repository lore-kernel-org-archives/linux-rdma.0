From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 10:35:21 +0300
Message-ID: <20160830073521.GM594@leon.nu>
References: <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Tc49Tft5g1TIuAea"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160830071716.GA3098-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Tc49Tft5g1TIuAea
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 30, 2016 at 12:17:16AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 30, 2016 at 09:08:42AM +0300, Leon Romanovsky wrote:
> > Doug is a busy person and there is a limit on how fast he can handle it.
> > He is already buried under his internal and external responsibilities.
> >
> > Placing him responsible for vendors code will add extra step,
> > extra complexity to the chain and will hurt kernel/libibverbs flows.
>
> Leon, calm down.  What Jason is proposing is to apply the exact same
> flow we have in the kernel to a much smaller project.  We prove it
> works on a giant project, and it will work on a smaller one.

Kernel project has more than "pile of code in one place".

>
> Maintainer overload always is a problem, and it's helped by adding
> more maintainers.  And yes, both the kernel RDMA stack and the user
> code should have a small maintainer team, but that's a different
> discussion.

Awesome, let's start from this discussion to clear the ground and move
to technical proposals after it.

>
> The current state of RDMA userspace is a complete trainwreck, and
> one of the major reasons I can only do testing in very limited
> environment - setting all this up on another systems is just too much
> work.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Tc49Tft5g1TIuAea
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxTc5AAoJEORje4g2clinocIQAK+kSRA/MA2wgSz5BELDQ09I
A3erL9WdBdKXQIv4ZvUTtUG8ztLET9vH6q2dVsvtlo9BIzApe3bkxcBZrtgZssg1
1x8MqhK3sHwPTG5KLVKJ2UPkmsa62x49IcJ+0kzZJskLk0f6mk2Jbflvw2kfx1fT
noPXYpmFI5iS4lIIb8jb61vcRy4BNkFbRa28PhkB5An4PQiRxLrVidTv59QAqsQt
Zk7D9sRBoNiDczfCJV5AWtBFcGT/K1LnQsyAyarFKsBxqcGmlO9mSYo2cy2dl54+
+r4s9uXEU8XUfIoKgYULp6WroZLdDNOw1ukLz6OiMFV5HGfdCOH6Oa4ex/zr6tPJ
/qetESQ8cm+9KBEkYARCTxiEq5yTjMa8e66KSPMCxhwhaiweEShN0jE6Uyqhs6zk
TIaOj7k81g9j5DInVWx3kGG0nFMdawyWKAdwYG3mEOOdzs1hbhIY5tDqEskN/ubl
71xixEaI0hmoBlP6dd0zthnJwaOoKBQ6NlUQkXUd2QIrpbr2l0+pJdKdyWGJpDdd
nYyAq3aC0xSppoeienrNdkbttDqWlio59M8Z9+OQXE3mV4E7ge5IiRHYcPOgzcpf
+61dMxxXKJwGjL1aVHS8gGlM4eKdE4Y7eJkiurlLEuxFrInuanCmpuEb3zBCZa7F
Qysj6mx4gS7JpXd/GMsq
=Ft8q
-----END PGP SIGNATURE-----

--Tc49Tft5g1TIuAea--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
