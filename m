From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 15 Sep 2016 22:17:25 +0300
Message-ID: <20160915191725.GI26069@leon.nu>
References: <20160915080600.GA31776@infradead.org>
 <20160915081149.GT26069@leon.nu>
 <20160915081327.GA7572@infradead.org>
 <20160915083945.GU26069@leon.nu>
 <20160915160427.GC18154@obsidianresearch.com>
 <01e901d20f6b$7ae067d0$70a13770$@opengridcomputing.com>
 <20160915163756.GB26069@leon.nu>
 <01fe01d20f6f$ac5ba780$0512f680$@opengridcomputing.com>
 <20160915164416.GC26069@leon.nu>
 <98fb59c6-2a6d-b36a-d582-e3b24a8d7024@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rPKw41Fi6dB0MaHy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <98fb59c6-2a6d-b36a-d582-e3b24a8d7024-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rPKw41Fi6dB0MaHy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 15, 2016 at 09:04:36PM +0200, Bart Van Assche wrote:
> On 09/15/2016 06:44 PM, Leon Romanovsky wrote:
> >And what is exactly srptools? From the name, it looks like good
> >candidate for rdma-tools.git, but it is in rdma-user.git noa.
>
> Does this mean that you don't know how SRP login works?

Yes, I had no idea about it.

> An SRP initiator
> logs in to an SRP target if a login string is written into the add_target
> sysfs attribute. Although it is possible to look up the proper login string
> on the target system and to issue the login manually, most SRP users run
> srp_daemon on the initiator system. srp_daemon is a daemon that runs on SRP
> initiator systems, that discovers SRP target systems and that logs in to
> these target systems if allowed by /etc/srp_daemon.conf. I expect that all
> SRP users will install the rdma-user package and that not all of them will
> need the rdma-tools package. So for SRP users it will be convenient to
> include srptools in the rdma-user package.

OK,
It makes sense to leave it in rdma-user.

Thanks for the explanation.

>
> Bart.

--rPKw41Fi6dB0MaHy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2vPFAAoJEORje4g2clinMZoQAKdgozLqvYCn1N5UyYcqlPEH
hCoSLX/YJprbfPlIcybN7ww8IEXoEUMnb+CU9v8IzQ39qKrT/+PqncoubF0fKCrO
aoZXkC+3PnO+OD52izqBnB28EBpDmTGcbjcyAB1YdquIpmNXqYGSUnlbQQbF354Q
rKiKbPRK/B/wATa208R/EKaDPry3OEXss2D2rZNM1Ak8b7EFNT1azmo35+nYdQL0
/5kMhF5q2W82uN9lM1mgnTdPVb6kecAUjO8tqW3zn/URdEIUYMLVoBIdXSrQsIH5
dClLQZct554gnlYxMfH6/BdLzD+t9fquK69cWyNRwTHsTOf0PQKp7t+3CwC62p+J
4zKjdmuSRpXeyLZvRTmDKlRaCg/igbGu5jMnEW5OLVI0ZSvo0C3fwyeAK03ra0PU
RpFyAln60GmmfrSoXOVFPwxxjnCqTpxrTJYRdaszgeBLAUqaMK/T6oy7byYTDknw
8WV9SjhjyNd/hh43K/xf0ANf2ngakQ87sW1pGg3wIG81B0CAy5uqO+61pftk+ORw
CsM1ZGffSnRByIFD3mPdXDHwhYfcyBieyuUDNv6o7mhJSilsBNpgpXuYxQa3w0Ty
DvIukU4SoTSqjlpGeS0c2EfS4OnYbpT84AW60HJ+nssZhEqA+EmhoPiKGjCbQyLl
9SnI1aBI7KIPVifqaqMX
=MLC+
-----END PGP SIGNATURE-----

--rPKw41Fi6dB0MaHy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
