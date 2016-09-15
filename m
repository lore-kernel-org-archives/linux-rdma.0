From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 26/28] Avoid gcc 5.4 warning -Wunused-result
Date: Thu, 15 Sep 2016 08:13:19 +0300
Message-ID: <20160915051319.GI26069@leon.nu>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-27-git-send-email-jgunthorpe@obsidianresearch.com>
 <3b8df987-b422-a59c-4dc0-8a99524ab45e@dev.mellanox.co.il>
 <20160914165830.GE16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="X+nYw8KZ/oNxZ8JS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914165830.GE16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--X+nYw8KZ/oNxZ8JS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 10:58:30AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 14, 2016 at 07:35:42PM +0300, Yishai Hadas wrote:
> > >+	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
> > >+	    write(sockfd, "done", sizeof "done") != sizeof "done") {
> > >+		perror("client read/write");
> > >+		fprintf(stderr, "Couldn't read/write remote address\n");
> >
> > It's just an example, however, better to have an accurate error message and
> > separate into 2 stubs.
>
> There is no value to the user in distinguishing the two cases. They
> both mean the socket closed unexpectedly.

Agree, it will give nothing to the user. We are all treating pingpong
applications very similar - works/doesn't work, while "doesn't work"
actually says that something very basic is broken.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--X+nYw8KZ/oNxZ8JS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2i3vAAoJEORje4g2clinxMgP/2TtK+MX6mIgYIeTq65ybFoM
aQYRIiO6jJ2kzfpNlOV+7JOXmrQVIBMlcpgjimcnE3z7N103jnQ/YXRtrBrl3RTi
ARvoccsNtDk6bQae+3p+YNmn/S6e1OW3OfKv34NaDfzkX/YnJvq8QlDWl/iUcZm0
vUyho88F+QzKJTn6fY2bMRaQrWRavH/8EYwF7qBUs4aiuJxG59hO3138i5iefioo
RBZMMb/B2aqmiCmdaRwD54GLVEuxFKSVs9fctE/I3PjwRumY+538678FqMcdR7qq
r3M/Fm1zJnXl7YtDs3eaAW6GiXIeZkYWieOrCUrJyQ/qG3swlpBF2GT1VIP1In66
oOLo4raMy99sHNiJIWjTgsaDTAcT2TnH2Sm0Qh+VFq7pejsjX3MxKFlbfm2EmdPT
6jIINAve6FWwvt/XtKKNtgkAkuH5fu7mHMqDWoiYTevsri5Q85CPxuwofOvg89Tr
16d7Nzn51+eHEETfnbN7pxJds1rBEnMAXinwBaSclXPznc0nVtAQ2Gh3J7Htccv0
yCamTz6GNU1zo4dCTzwgvdZjgPUjMtBJcmUVgW7/PUlSuYeENQjefB+sgGjz7jjQ
xF/AO/zjl6+pq1cBqQFe/xkx4gdqhQ1/SdqIzHpqPZCuHMO1O6pKKTFYzjnDEh+H
uPJnQAYmkC8aDZLYEcvy
=fztg
-----END PGP SIGNATURE-----

--X+nYw8KZ/oNxZ8JS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
