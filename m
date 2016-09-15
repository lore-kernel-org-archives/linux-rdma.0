From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 15 Sep 2016 11:11:49 +0300
Message-ID: <20160915081149.GT26069@leon.nu>
References: <20160830071716.GA3098@infradead.org>
 <20160830073521.GM594@leon.nu>
 <20160830163033.GC26778@obsidianresearch.com>
 <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
 <20160906070102.GA23248@infradead.org>
 <6d47ca96-25eb-8358-879d-fc646ddda9cb@grimberg.me>
 <20160906110729.GM21847@leon.nu>
 <20160915061753.GD4869@infradead.org>
 <20160915065242.GO26069@leon.nu>
 <20160915080600.GA31776@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VjP/dwTbBl6I9PQk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915080600.GA31776-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VjP/dwTbBl6I9PQk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 15, 2016 at 01:06:00AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 15, 2016 at 09:52:42AM +0300, Leon Romanovsky wrote:
> > On Wed, Sep 14, 2016 at 11:17:53PM -0700, Christoph Hellwig wrote:
> > > On Tue, Sep 06, 2016 at 02:07:29PM +0300, Leon Romanovsky wrote:
> > > > On Tue, Sep 06, 2016 at 11:50:54AM +0300, Sagi Grimberg wrote:
> > > > >
> > > > > librdma maybe?
> > > >
> > > > It is not exactly library.
> > > > Maybe rdma-bundle?
> > >
> > > Or simple rdma-user?
> > >
> > > Either way, plumbing is just a horrible out of place and confusing name
> > > for software and we'll need to get rid of it.
> >
> > We created github.com/linux-rdma/ organization. So the "rdma" can be
> > removed from the name.
> >
> > What do you think about github.com/linux-rdma/userspace.git ?
>
> That's very annoying if you actually clone it, or download tarballs.

Maybe we will cut it a little bit to be github.com/linux-rdma/user.git ?
Any suggestions are welcomed, we didn't do anything irreversible.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--VjP/dwTbBl6I9PQk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2lfFAAoJEORje4g2clin78YQAIWpaMJuWF4nZGtoypxPvWq9
iLJfuxHitWXlozF9NCb7F6Z08rE7bnJIywQbYGlRS69uWppKMLDuzWfN0euMWdR2
unt8zEpIc4ygYzpg41LbdhzuUyr4H7ywEP9tMbt1G5CCWE+ElH4WG4wf0CLABOkX
txD512WwfS3FGmJ9WDt9BscMqT/KjDIPoduBXktaWjdzyHxrNC4+wopIuDd3rbFd
ZoGUUaVHhwpfZAnfq+pRn3O1bL+BFmocvV2edu5f3Mdh4M2B9iIWUZ3bj7mVR629
qpPjQB0veLt8bM7wH9HkZc6lkr/57UQR7D6myPlQC8P6zBw0DHmHqu7mawkJvqVg
BNZdwizqjeqeyyDCmY/GAeZp4K/x8p69QbIaWK8/1woB/LGAS7lRonEc8K80mMsd
yxscGg76Zk3HYgNrm76njTTItOy0Wq8/yqa2M+o4rWqKiIH7I2lDqIRG7SeR2Zq0
TvbUMSjPBQT4G8yBXutfUTNRBH9hnGbaNk1IYyq8NYV+HQpnlJ8Q/fpqAgb9Ot2c
2LjGhWVSmEV/zySmKaMwz0jqWb/QmlwVNBvc4+fAfZPzkPxZjowJiy/rnKO8fdpq
/qUcS5dJU4XVQnP5c/FTW+PGSrKWE2FRcsxf+YVk5JcpDA8T5RHLp2TpWYrovws3
ylhCppAnkG0nyY/JAN+7
=GRlN
-----END PGP SIGNATURE-----

--VjP/dwTbBl6I9PQk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
