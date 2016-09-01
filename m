From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 16:07:05 +0300
Message-ID: <20160901130705.GC21847@leon.nu>
References: <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com>
 <20160831200336.GA4134@obsidianresearch.com>
 <20160901082643.GA19799@infradead.org>
 <20160901110352.GI3694@leon.nu>
 <alpine.DEB.2.20.1609010736370.31007@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1609010736370.31007-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal@
List-Id: linux-rdma@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 01, 2016 at 07:39:24AM -0500, Christoph Lameter wrote:
> On Thu, 1 Sep 2016, Leon Romanovsky wrote:
>
> > If it helps, I can step in and do this job.
>
> Start by improving on Jason's work? The better Jason's tree becomes the
> earlier we will be able to get onto the unified repo. As you contribute
> we can work out any issues that may come up in the vendor to upstream
> patch flow for these libraries. That may make you more confident in the
> speed with which you can get changes in there.

How nice, I'm pretty sure that Jason will forward code extremely fast.

user space:
Leon -> Jason -> Doug
kernel space (features):
Leon -> Doug
kernel space (fixes):
Leon -> Doug

Do you see bottleneck here?
Maybe it is time to solve root cause and don't hide it?

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyCf5AAoJEORje4g2clinSr8P/jeRoIRG5UbiVnlAdzotj1uL
FyZ3bPYYIPAIcWDfue2oPVCzITAjD588efScuDxsQcUzCniG6RV8E03jaFelztak
MYucGEL+RUhhTdPn0zGCfRnWOzWQUbZRquNsBUkTebQtK4MqkMkm8EQzq3W+lkLJ
hbOUwc4n+2m0GLerE2jJlaL7oAdXZ6APLBXqUf4teVpB27AUTjEwKejE8L/flKSM
+bH7STgJpH0QH0PBOUo9rOkuz/NuRvnqgZ8wMkXwQyvzc3Q/9Sd/ILvLjHps3PiK
VE+uw1Cq7rRMsd+L33itFmF1CzCUgwCf3OppTZqcRi9cjWQBOodeSLzjQlbCV/fk
8KRsbQZtZf/jVZilj8V+vDhmELNfp+NlJVR2kywg2vVF3HS0IdMmzNNawTH83/E2
jODZwWFvDO6FNcc8s8n8BfhaUyccZ5LM0YEItlSCTHJnLzTkZiYoZ4lleMsuGcD8
aObV8WLhWQ5CsB12FCTOxMmZrUGBcTCXm7ojbUDSIlAuX/dP76w9D5gwoPl4M27R
9UsTYC1oirYr3VcBC0jeYS6F4ACfNMhSpZA8F0crVdR3AnZi1peU2Uz3qGZ5YrJ8
OWjk2j8Us3j+0Hby4uEMY5i77TOJBs52dwB34BXCjt9fbWztm/fmzSKuOH0ZK3Cn
9BtpVacB7LoI37Zar11S
=RxW5
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
