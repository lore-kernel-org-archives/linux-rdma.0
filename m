From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Wed, 16 Aug 2017 20:51:45 +0300
Message-ID: <20170816175144.GX24282@mtr-leonro.local>
References: <1501590709.2725.10.camel@redhat.com>
 <20170802054512.GW13672@mtr-leonro.local>
 <1501761459.117042.5.camel@redhat.com>
 <20170816080523.GG24282@mtr-leonro.local>
 <1502902372.33760.17.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eqq5Le9VNi5o1NaU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502902372.33760.17.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eqq5Le9VNi5o1NaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 12:52:52PM -0400, Doug Ledford wrote:
> On Wed, 2017-08-16 at 11:05 +0300, Leon Romanovsky wrote:
> > On Thu, Aug 03, 2017 at 07:57:39AM -0400, Doug Ledford wrote:
> > > On Wed, 2017-08-02 at 08:45 +0300, Leon Romanovsky wrote:
> > > > On Tue, Aug 01, 2017 at 08:31:49AM -0400, Doug Ledford wrote:
> > > > > Here's the information from the tag:
> > > > >
> > > > > tag v15-rc1
> > > > > Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > Date:   Tue Aug 1 08:18:05 2017 -0400
> > > > >
> > > > > rdma-core-15-rc1
> > > >
> > > > Isn't the release supposed to be without "-rc1?
> > >
> > > It is.  This is an rc, the release should follow soon.
> >
> > Doug,
> >
> > Did the RDMA cluster return to operation?
>
> Mostly.  All of the easy fixes have been done.  Now we are down to
> debugging/fixing the things that aren't so easy.  For instance, if you
> have an older ConnectX-2 card in IB/Eth mode, and you are using PFC on
> two different no-drop priorities, and have two separate vlans with one
> egress priority map on one vlan and another egress priority map on the
> other vlan, then the second vlan will refuse to work.  This is true for
> one of our card models we have in the test lab:
>
> Model:	MHQH29B-XTR
> PSID:	MT_0D80120009
>
> Latest firmware available at Mellanox.com (without a support login):
> 	2_9_1000
>
> That firmware is broken for this test case.  It didn't show up prior to
> the cluster move as the card was plugged into a different switch
> (different brand, entirely different switch OS) and the prior switch
> allowed this card to get away with whatever it isn't doing right.  I
> was able to isolate the problem down to specifically being that when
> you add the egress mapping to the second vlan, that second vlan doesn't
> work, but if you remove the egress mapping on that second vlan but
> otherwise leave the vlan intact, then it starts working (albeit minus
> your egress mapping so you won't actually get PFC on that vlan like you
> should).  Some time ago, I used my Mellanox provided support login to
> get the latest unofficial/unreleased OEM firmware kit, so I built a new
> firmware for the card out of that unreleased stuff and that solved the
> problem.
>
> So, it's progressing, and we are slowly marking machines back as fully
> operational, but you know the saying, the first 90% takes 10% of the
> time and the last 10% takes 90% of the time, and that's how things are
> playing out here.  I was working on it as my main focus Monday and
> Tuesday, I'm going to refocus on patch processing today while a few
> hardware changes are being made, and go from there.  My first priority
> today is the -rc pull request and getting it ready.  After that I want
> to get some more -next stuff pulled in.
>
> And I know this particular thread is in reference to the rdma-core
> package, I haven't forgotten it, I just haven't had a chance to test it
> yet :-/.
>

Thanks for the update, I asked it in context of rdma-core, because
Yishai stopped submissions of all our user space patches till the
official release and it included my one-liner fix to ibv_xsrq_pinpong :)

> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--eqq5Le9VNi5o1NaU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUhjAACgkQ5GN7iDZy
WKcswQ//XEokjdLxkXG3lcP/0bFa8Uca4YHZPmEvzRYfUZhEGHUaZJYvYwLWJJZp
4ENFJcFIqZ+C4aekpT7Kj53Ec+lo1HdDzQPaXvfHPDxYbtPYBPKz1HtuVT859dx2
9zkxTBJlYCXxNGZPxifiM5nRS4pxTcrIMQslKM9mmaE3xKed27Kko/vFQtVnn9Pu
0gWoZYQqrZB0AkLYjg5xqI90d00W3eBt7T3et5ghvXvUcaR6r0JusELlm92OzHn3
yRkC2WNQfousp7KmAumWnIrXyT382cTEsXhLXy1uO2RzFczzpMz6Qmygjdv19GXM
/zdZbChBbd1Y21gxXp/r9wGGjRCE73qM63uyHRuBdgjE9lOGCxthvM+4S8zqEiL6
Sof3KxPdkfsJKewcPfFIIAZlwixqXBVlHPOi+5qSH08AeJr27obiZ+6EIrfRlPe/
zH4KrkQgoGbzSQD0qIZe3w8oLeCGoVS271SaAy4aeFqdxNb9NOOuUON977RGKgI1
vVQNHmbB++knoIbJmpnPV2/UYJbjfXpDakRFLRqwHljKzWlmeSUpbu++uGZz82Jg
s9GU7HkV/VNHf1eOC2nyeqNvtC/pvO2hA+8iUuJrhKwpoFi0yJ4F6n5A8mMkHHp5
Dp1bWlNnl85vtvBWHhWsQhA3g48IEpnyK8xTMM+i/SI7HasZwq8=
=Rp6V
-----END PGP SIGNATURE-----

--eqq5Le9VNi5o1NaU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
