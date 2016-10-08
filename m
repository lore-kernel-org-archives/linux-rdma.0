From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Sat, 8 Oct 2016 18:39:42 +0300
Message-ID: <20161008153942.GY9282@leon.nu>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
 <CY1PR0701MB1337AC7B933E917765C3EBC990C60@CY1PR0701MB1337.namprd07.prod.outlook.com>
 <20161007142454.GU9282@leon.nu>
 <a146f562-1970-e939-1bd5-074af868f7d6@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YPAu9GJT3m1iC0FS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a146f562-1970-e939-1bd5-074af868f7d6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YPAu9GJT3m1iC0FS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 08, 2016 at 09:35:06AM -0400, Doug Ledford wrote:
> On 10/7/2016 10:24 AM, Leon Romanovsky wrote:
> > On Fri, Oct 07, 2016 at 10:47:18AM +0000, Elior, Ariel wrote:
> >>>> @@ -66,6 +85,12 @@ struct rdma_cqe_common {
> >>>>     struct regpair qp_handle;
> >>>>     __le16 reserved1[7];
> >>>>     u8 flags;
> >>>> +#define RDMA_CQE_COMMON_TOGGLE_BIT_MASK  0x1
> >>>> +#define RDMA_CQE_COMMON_TOGGLE_BIT_SHIFT 0
> >>>> +#define RDMA_CQE_COMMON_TYPE_MASK        0x3
> >>>> +#define RDMA_CQE_COMMON_TYPE_SHIFT       1
> >>>> +#define RDMA_CQE_COMMON_RESERVED2_MASK   0x1F
> >>>> +#define RDMA_CQE_COMMON_RESERVED2_SHIFT  3
> >>>>     u8 status;
> >>>
> >>> It is VERY uncommon to mix defines and structs together.
> >>> Please don't do it, it confuses a lot and doesn't help to
> >>> readability/debug.
> >>
> >> Hi Leon,
> >> Firstly, thanks for investing your time in reviewing our driver.
> >> As for mixed defines and structures, far from being very uncommon, they are
> >> actually ubiquitous throughout the kernel and are used by the foremost
> >> developers (Dave Miller, Linus, Jeff Kirsher).
> >
> > Net subsystem is very different from other kernel community.
> > For example, this article from LWN [1] - "Coding-style exceptionalism"
> > talks about it.
>
> > [1] https://lwn.net/Articles/694755/
>
> That article only refers to multi-line comments, not to embedding
> #defines inside of structs that the #defines are used with.

That article supports my claim that net subsystem is different from the
rest of the kernel.

>
> My personal taste on things like this is that if you had something like
> a variable with a result code, then use a separate enum for the possible
> options.  However, in this case, you have a multi-mask item and the
> defines are the three masks and their shifts.  I'm OK with that being
> mixed in or being separate, but if it's separate, I would want it
> immediately before the struct with a comment specifying that this is the
> format of the status byte in the struct.  What I wouldn't want is the
> #defines moved far away from the struct with a bunch of other defines
> where the context of the struct is lost.

It looks like you are neutral on the topic, and I'm against mixing these
specific defines with structures. Every change in such define changes
struct as well which can be easily missed out.

Ram,
Please invest an extra effort and help the reviewers to accomplish their
task.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--YPAu9GJT3m1iC0FS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+RM+AAoJEORje4g2clinv5gQAI/gYrAhYhblUmfoHJKGaKXS
Dl0AlNG/k3Yh9jJkN017ux4UbzYhZgUMjUQslGT3kp8tU/kPNFn8cNL97j/BVxfv
zeV/dZycRxPSv1PU/ZlMEY36CX8+TS8iSxXhUO7rH2dEfDxIolpvgVCcIc50lsyO
9Y1Rn3EW1aPJVTROodNd0ZLwo+greALv16vi7XnYextKLd4mDTVQrMIa/enzIcYp
Nje7L3wChXQWS0559JFFjEzwve3400qus4375T3xfEa71H6UCs0suGud4u9qEwxA
xHtGyUNHF1DnqDw0tecy0OaPlA7xE10w6nODapXmLXb8b1AM505yl6Eazba7VH1m
v+WPfw2KMWypsR2zNx25AbxEeR1RyMomSe4r0kTc8sHHNXjZdG3kTKJNiVc3Pphz
1ZaXAxgd5P0WahhriOksx/j9jHbW+yYqJicaWu9nguhWDSVLJ3HKwNcMwan9uDqg
H42UFIP7nn4ldyZi4uFkpEJwDGV5la2aoS36pAdB2pvZassIZW/6s3m2l0/1bMec
GE1r4ah7POklEgYAPOMzb6mUA+wJRLxxcrL3+lxmbr3Gyns3biUqFocg8zFeUK3y
P9EKTFIt92sAy6g50qcH4FBFJJSPeSE2mMScmAQELbKbE5WOXxy8rE8GVrDax33b
ZWlyJrE/6Djzmc4ruTZF
=7ZgL
-----END PGP SIGNATURE-----

--YPAu9GJT3m1iC0FS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
