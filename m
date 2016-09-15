From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 15 Sep 2016 19:44:16 +0300
Message-ID: <20160915164416.GC26069@leon.nu>
References: <20160915061753.GD4869@infradead.org>
 <20160915065242.GO26069@leon.nu>
 <20160915080600.GA31776@infradead.org>
 <20160915081149.GT26069@leon.nu>
 <20160915081327.GA7572@infradead.org>
 <20160915083945.GU26069@leon.nu>
 <20160915160427.GC18154@obsidianresearch.com>
 <01e901d20f6b$7ae067d0$70a13770$@opengridcomputing.com>
 <20160915163756.GB26069@leon.nu>
 <01fe01d20f6f$ac5ba780$0512f680$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fo/b2PYVqg2cQvBK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01fe01d20f6f$ac5ba780$0512f680$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fo/b2PYVqg2cQvBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 15, 2016 at 11:39:05AM -0500, Steve Wise wrote:
> > On Thu, Sep 15, 2016 at 11:09:04AM -0500, Steve Wise wrote:
> > > > On Thu, Sep 15, 2016 at 11:39:45AM +0300, Leon Romanovsky wrote:
> > > >
> > > > > Easy option is to include "rdma" word in the name and enjoy built-in
> > > > > UI to release packages [1].
> > > >
> > > > I think we should do this, I agree with Christoph, if you go through
> > > > the github gui and pick the clone path in 'Clone or Download' then the
> > > > resulting clone should be called rdma-user/
> > > >
> > >
> > > Ditto.  And I like rdma-user over rdma-userspace...
> >
> > Looks nice.
> >
> > Do we want to create rdma-tools after this task will be completed? For example
> > with debug and performance tools in it.
>
> I think so.

And what is exactly srptools? From the name, it looks like good
candidate for rdma-tools.git, but it is in rdma-user.git noa.

What about rdma-libs.git instead of rdma-user.git?

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fo/b2PYVqg2cQvBK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2s/gAAoJEORje4g2clinmc4P/jb+Joq0lw+LRUuycxf0SB3x
i+N0oh8wI6tfzYeFDfN5PxBdV5UPztI8Uv/HPVqVDlsYEaH0oZULBTI8u8E96EtI
bDZ1Bt/puIuK5/UzxzrfycxtvxDMLEVmjJXjjeVu6/UpCwUmh1l/bp3mSQuipt76
zS5X/9uB/7SEk5L/iyK9F5Hf8XbnKC0doYOweRued3MZlQF7sIIcR4t3EoeW0Ugz
TT416dAwQxw6IaSJdYxCoGzZ/Ru+d9zyg/aNwWJaLBTqdDNQIMbkO5JfVL1Dm7rb
TLwR/7289B7LgzEmnel2ukfQw4qISNNsEcmZE46qCjXbCyh29DrPT81A6JAJG0qJ
vjrNx3w41R0O07iuwcpNVf3NreWl/NRr8UktDctjpkehWjQww9V93ZaGFmB2sxYS
bebWxI6LorXvIiKjs9dzgfXcXlMyMr2F+2R4PB2E2hI0d9NvHPDRLyr++cyeh6Sm
fucUhBFQNxDhxrlsLlVMafi3LSU1BnfOLB4Xu1i+DOK5sYe+W9EdRoc3Yi6O/nPZ
YqOCkFAnjSN/BVgFLZJVtaHy4iT6yeNvC74kOylWk9bEVmUbCG14kd+Qp6MgQpEZ
dJiuqOOVssFlLxzBw+aTKWchLmKlxC8+izUiPHOEb+2580CVhgwL7wG5/TUxbgeJ
oKRWAa5S6qqD7/upWksF
=kHmb
-----END PGP SIGNATURE-----

--fo/b2PYVqg2cQvBK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
