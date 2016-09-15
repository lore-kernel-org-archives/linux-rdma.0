From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 15 Sep 2016 11:39:45 +0300
Message-ID: <20160915083945.GU26069@leon.nu>
References: <20160830163033.GC26778@obsidianresearch.com>
 <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
 <20160906070102.GA23248@infradead.org>
 <6d47ca96-25eb-8358-879d-fc646ddda9cb@grimberg.me>
 <20160906110729.GM21847@leon.nu>
 <20160915061753.GD4869@infradead.org>
 <20160915065242.GO26069@leon.nu>
 <20160915080600.GA31776@infradead.org>
 <20160915081149.GT26069@leon.nu>
 <20160915081327.GA7572@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kSOhxpxUsM1s2qz/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915081327.GA7572-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kSOhxpxUsM1s2qz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 15, 2016 at 01:13:27AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 15, 2016 at 11:11:49AM +0300, Leon Romanovsky wrote:
> > > > We created github.com/linux-rdma/ organization. So the "rdma" can be
> > > > removed from the name.
> > > >
> > > > What do you think about github.com/linux-rdma/userspace.git ?
> > >
> > > That's very annoying if you actually clone it, or download tarballs.
> >
> > Maybe we will cut it a little bit to be github.com/linux-rdma/user.git ?
> > Any suggestions are welcomed, we didn't do anything irreversible.
>
> The annoying thing is not the userspace part, that is perfectly fine
> with me.  The problem is the lack of rdma- prefix which actually makes
> the name maningful.

Thanks for the explanation,

It looks like we have two different options to address your concern.

Easy option is to include "rdma" word in the name and enjoy built-in
UI to release packages [1].

And the more advanced option will be to create scripts to automate
releases [2] and append "rdma" to the name.

[1] https://github.com/blog/1547-release-your-software
[2] https://developer.github.com/v3/repos/releases/#create-a-release

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--kSOhxpxUsM1s2qz/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2l5RAAoJEORje4g2clin5DwP/10e/VUnosSgairZ8jnswRWQ
zSmBr4XgzXDx6Ua7N67zPODRIc/ZXHcNdLaF4OCQgE/6DS9nZ/Nx65YklwiEEnTX
oKLyKrV7S0RXGJ/7AL3z2uoYLO/6KOVf11VIFXFe8LyE31J4GnjbHc764j2NCkWg
brfdpIx2ggov1zKK+ICOPNA0czQX6IqAaFwdJfO09aPywSBha8eGEzmGQf3+ShN4
GOIWB+Kk92FxeWTWHqx+69gWpS2VaLcPoEVkMJRd4fb+ypjlD/9keurXrKDbfzSm
UznXd8fGl4TgUqgwu4jJ6jHXVo92wvHp4SgZUrgXBiHR9+QTwbAO17bkOFRJPjrR
eCbkzzrM3mA2n8lIlI7CJMuwDlMNw2zzbdo5bA6VgEYID/LO+8tgXZJxr5lkpPbj
rgdT+j8UDjgYQaaGwWvbnmwp5FWR01dF1ehldTCGKC3Cey08x4/DlKEmfV8W7rnl
qH6s81fLhRvtLacHN/xkoyvxKrBNWCBdF0T7fsjNwgtVbQyK/U7GKYmeYYbGJvmQ
yJeRJL+UVNzIUvczj1pI4uMqXIuX4oQ+f6rc4j7d/C4Xn/Hj8uPKqf76uarKKgHp
SokvhQouuzYH0Y+h1G+NYoirz+cA35zDzh3shjn6dqyjD6R+Txzrv4GHfe6lbiIu
tkToNj20tDTejzODwxB+
=+GPg
-----END PGP SIGNATURE-----

--kSOhxpxUsM1s2qz/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
