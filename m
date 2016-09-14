From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 9/13/2016 at 11:00PDT
Date: Wed, 14 Sep 2016 16:09:38 +0300
Message-ID: <20160914130938.GC26069@leon.nu>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org>
 <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org>
 <20160913103238.GW8812@leon.nu>
 <20160914123059.GA868@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914123059.GA868-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 14, 2016 at 05:30:59AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 13, 2016 at 01:32:38PM +0300, Leon Romanovsky wrote:
> > > I think we're fine now.  The non-verbs HFSI interfaces aren't really a
> > > fit for our inifiband/rdma (it should really be called ibverbs I gues=
s)
> > > interface.
> >
> > Out of curiosity, can you point me to the discussions where you
> > expressed your objections while hfi1 was added to drivers/inifiniband?
>
> No idea what you mean.  I'm fine with HFI living in drivers/infiniband,
> although other places for it might not be wrong either.
>
> I'm not fine with HFI exposing the non-verbs interfaces through
> drivers/infiniband/core interface, which as far as I can tell it
> currently does not even do, although some discussions here suggest
> that a future interface should cater to those interface.

I see your point. Latest discussionis or more correct lack of interest
=66rom Intel folks for proposed ABI suggest that it is best to limit this
ABI to verbs objects only. In such way, memcg will fit natively into
the stack.

>
> The real mistake was adding usnic, which has not business in
> drivers/infiniband/ at all.



--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2UwSAAoJEORje4g2clinIw4QALUsw+S2HkVENAh6yDsK9eJK
nSFPaTO4LdiJ9mDJt5d/k4bogefFxE97sbYZtOXXQezD4kYdYGA7qVHIPgSNvNLS
m+KrLt7gpLWumNO0C+IqNJRyZDzFAbXEcWDH4HGxTiSRJzO7wPwWT0V0krig8kMt
roDAJKDP85WuklC5Atm5UrXdQPmGXSihXZZdNBP3584zmP3gUNxrgRiJ6LsDo1R0
pJlj1UzJBH2oHk+RKEF6YtQnGnVC1+o2LgorgspXOIFrUxjLsSN7l/urvIhVHqdZ
tH7+ybnNmHigQv3R2I6msv2amXn5UWirkCFIL7ef1xkK3tEdSPu+hYeupL1LzOdx
QoV210gr7IjgDtAbK0ZqqeLac7DIAVlt92Xdk8++FJ4moK5vCrY+WQME4MKuAtrq
FNuDdgAknFVrLPeJIoEu6gvHsm7IJ8x19O7tR8WDVHeJ5NjENdKBzs+x4393/bx5
VrzwmVJWrMyVFRkCl9VtockdYNB+gMcbqRVZOyckjKGt6jVKKyEbDHCdpxW48a+P
5vA3RfmAprpfr0Z+It0v+T3UmgbINWYwu2S5RY93Ug6ffM0shxBDfZjjYSACP8bi
aRmwEuqqGcVxn6uKKu/ItP3jb3em/HPtRLB9qFaR+Aboz3U7w9x3jIioPHPjb+G+
U7zZeQbWWune77207UWM
=f4ko
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
