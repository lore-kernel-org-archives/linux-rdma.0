From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/core: create struct ib_port_cache
Date: Sun, 15 Jan 2017 10:50:14 +0200
Message-ID: <20170115085014.GB20392@mtr-leonro.local>
References: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
 <b1fdf011-dc25-ad63-b223-0700f6e90bc6@profitbricks.com>
 <20170113150103.GP20392@mtr-leonro.local>
 <2617abae-686e-c8c6-799a-8742156fcd08@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pDtNmxPr5KTxcQ6Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2617abae-686e-c8c6-799a-8742156fcd08-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pDtNmxPr5KTxcQ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 13, 2017 at 04:35:54PM +0100, Jack Wang wrote:
>
>
> On 13.01.2017 16:01, Leon Romanovsky wrote:
> > On Fri, Jan 13, 2017 at 02:12:19PM +0100, Jack Wang wrote:
> >> Hi Doug, hi Jason and others,
> >>
> >> As Doug already merged the first 4 patches to his tree, so I rebased this patch also
> >> on his latest for-4.11 branch (commit 102c5ce082), minor tweak on commit message.
> >> I also configured my thunderbirds to keep the patch format as expected :), so here we go!
> >
> > Hi Jack,
> > I don't know what did you configure, but git send-email is a preferred
> > way to send linux kernel patches.
> >
> > Your attached patches are appearing wrongly (wrong subject and mbox garbage) in
> > the patchworks https://patchwork.kernel.org/patch/9515651/
> >
> > Thanks
> >
> Hi Leon,
>
> Thanks, I understand I changed subject in the patch because I notice Doug is using such naming.

You changed the name of the patch which is fine, but you used the old thread
and it was registered under that name in the system.

Take a look on the subject of your patch:
"[PATCH] RDMA/core: create struct ib_port_cache"
and the name of in the system:
"[PATCHv2,1/1] IB/core: create struct ib_port_cache"

https://patchwork.kernel.org/patch/9515651/

> But I don't follow "mbox garbage", what do you mean here?

Your patches contain all the wording at the beginning.
Please download yours https://patchwork.kernel.org/patch/9515651/mbox/
and compare with the one in proper format https://patchwork.kernel.org/patch/9514391/mbox/

>
> About git send-email, I used to successfully sent patch with the tool, but somehow it's now always get reject
> by gmail.

According to the email headers, gmail and git send-email works fine for the most participants here.
>
> I'm not familiar with patchwork, will reply to same thread with proper subject fix the problem or I have to do it in a new thread?

No, please fix the setup before and submit it properly.
Thanks.

>
> Thanks,
> Jack

--pDtNmxPr5KTxcQ6Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh7N8YACgkQ5GN7iDZy
WKeXkhAAtbUxdl6IZHn/tZxgo99jmfh0tQcGlfcKG3U6Wp7nZoyhD+cgMASi/mSl
3izFzCG83i3Y09GcKVy1+vPgliDgWWhPDIuV9wgKFLJGoY9sAJxF640EOQPQZKNk
TCWOaEjCntgw0L/SeEnB1O8sIPeydgieWOSoCxiEccEkfylARAy++QQF1YPSh3hw
w5VnGgqYf4pgPEtp0JKxVr9B+pzLjVF23DgYjA1S5DhohSWVbe69DD5lEvCmrN8X
+ZxoC0hmB5K61Hdw6MNmMlBnBW8fbftzC7iiLZWziv/nylZG9k0JWFNmCAG/8qcx
jFQLIzeAB0wx4qaC76FSeRdoTUs3xcNDo695TTALQnkruBxAS+xUJSJwvkW541OO
P/2rchAvB7jb4Towjg+hAyhx4uZtv8r4NREdssWd0z8QhFtWydeEjYLLpVCeBcwY
z53SvIlQO3jDPGxHpF3loHsQrFCWNa0+KQOA54+X0fmEmlLv99G/BiwKUfss8iaR
7rF089v44v8nQVe8gMIydjHfIMhEZfuGMf1RGFX+GGxjLKjtt8CHqO0ZHUGyLS1Y
aqnY8uXY1R4HwrDHug+d53pfhtZbKKVtYJBKUC0VuBl8Rk+9PyvrTo14jgixhUuj
7VEWR6NeB2r6WTxYiOHCoXIO13IVyi+c/SZdADgdVo3NZP2eu28=
=a1ke
-----END PGP SIGNATURE-----

--pDtNmxPr5KTxcQ6Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
