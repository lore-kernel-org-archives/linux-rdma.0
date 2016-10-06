From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Thu, 6 Oct 2016 07:58:40 +0300
Message-ID: <20161006045840.GL9282@leon.nu>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161005115132.GE9282@leon.nu>
 <0de7bc15-5e2e-8240-ba84-a5a95dcb2834@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+278g007AL/ykmV8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0de7bc15-5e2e-8240-ba84-a5a95dcb2834-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+278g007AL/ykmV8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 05, 2016 at 09:39:42AM -0700, Bart Van Assche wrote:
> On 10/05/2016 04:51 AM, Leon Romanovsky wrote:
> >On Wed, Sep 28, 2016 at 05:28:57PM -0600, Jason Gunthorpe wrote:
> >>Necessary to use the Travis CI service.
> >>
> >>Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >>---
> >> .travis.yml | 28 ++++++++++++++++++++++++++++
> >> 1 file changed, 28 insertions(+)
> >> create mode 100644 .travis.yml
> >>
> >>Now that travis is enabled on repo, we need a yml file to make it run.
> >>
> >>Here is a basic one.
> >>
> >>I don't test with distros as old as precise and I don't expect that glibc to
> >>be new enough to build this (eg missing timerfd, O_CLOEXEC, etc), and the
> >>cmake certainly isn't. So we use the trusty 'beta' environment and install
> >>gcc 6.2.
> >
> >I'm using 16.04 and it has gcc 5.4.0 as a default. Don't you think that
> >6.2 is too "new" for us and other distributions?
>
> Hi Leon,
>
> The rolling release distro that is running on my laptop includes gcc 6.2.1.

I'm not sure if there are many users of this bundle who are running
rolling distros.

Anyway, let's start from the simple (one, latest gcc) and increase
complexity later on.

>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+278g007AL/ykmV8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9doAAAoJEORje4g2clinVo0P/1a2orUBh+/crTYxfZufgncC
DctoXOu9rJWAYMxURzxEzAXF1FfHiEc6yZGV7CwiRN0Aj/0RY//OP4f4RAon8Vl6
ynWTNJjI81oZ3nYkaq8Rxf4smCdaqj2W7EPhfv92BHMggzIK1PZjl7WvNviUD3mp
eIeFnK6mNIgVas3WtaR4zCHGi5HVSL70BOAFHeAxShinBS/+8+40Fm9Oz9rCeOOh
qYJurXKHpp/v2Dolfhe+L2Vmlx3fecWvQlE6HYKAebdVw3HWxIUydbwsi3dtB0yQ
i+rMh2m1cosiCubKxj+TWh4bdZiBG317SLzEvDWjv7JKpcc4AH977/OqVr+5MzA9
DGXn5XLug6Nawt8H4lzHoxSai741SwkOGaJVKBLt/SxoaE8W/pCwr8dONt5TxlQi
30XGEIQoQGC393sNfjbwf99aYuG443EapW1Zrpa62Xdzp/rbNgQNPgb30brwZuxm
RbOV2d4MrKrdmUguHZe5YwFnJYDNLnNsfB6azbzFwHwuM71RLPCMfdHW8434UYwN
hta1pVuZ9kIq2C69W5zowOXIz5ORnf/5z46xH38yBWvPCZ5bJT4xynWJ8AB5BwbF
7T0BEuuC2FcaEj4JlotvOyO224rOopyjMzUvEZ0q2G9DLnYYhLd4HWmvHGVzX+XI
ulXoi9MxUBVFlSWLUPGm
=N+Tl
-----END PGP SIGNATURE-----

--+278g007AL/ykmV8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
