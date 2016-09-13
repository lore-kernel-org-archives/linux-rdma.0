From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 9/13/2016 at 11:00PDT
Date: Tue, 13 Sep 2016 13:32:38 +0300
Message-ID: <20160913103238.GW8812@leon.nu>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org>
 <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ItroYk2LVxvwOvi/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160913070418.GA31616-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ItroYk2LVxvwOvi/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 13, 2016 at 12:04:18AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 13, 2016 at 12:31:22PM +0530, Parav Pandit wrote:
> > Sure. I just want to remind HFI folks to give their comments. There
> > has been no response from them to Matan's question.
> >
> > I am agreement with your point that most RDMA objects will have common
> > structure at the start and thats sufficient for cgroup to function
> > correctly. There hasn't been any disagreement yet on it.
> > So I am believing that we are good for now. Or I am missing something?
> > I will continue to have mailing list as one point for review and
> > discussion/feedback.
>
> I think we're fine now.  The non-verbs HFSI interfaces aren't really a
> fit for our inifiband/rdma (it should really be called ibverbs I guess)
> interface.

Out of curiosity, can you point me to the discussions where you
expressed your objections while hfi1 was added to drivers/inifiniband?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ItroYk2LVxvwOvi/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX19XGAAoJEORje4g2clinEr0P/RtKvfDSuMoN5mhEj38GqpOY
ZAsaGQkZ1ylZqFFokzQTJA5V9mwcMOH8rYRBKohCbT69nQrfX3kEU+IFuNQ3+sFy
tj4X7akcmFFij20Kp61uhn7e0iK3yGoMxS1CW5/QGzOImXsI2zDi4DuGhElfuo35
qr7J0gdGpdq2edY0wamlH0v9bhurufQXbzubULYgoSw5pxo/fbcXVoHgGwZ/qGn+
BjA6ZqwANx+PfsHq4V0I7RkI+ug5Gs3U3hnJyU4bgJlend0gCXwqQ+EQm7uQumC6
MZh5OaHf4iTibbMT3zPu6shGcj/+iEtDFus0hbfUJ3HLsAF7MOHHGa+2zwkCtPsw
cN9FIWo+R3V9p/cpk40iB5YQo5bV/mmA5Ilhtf/9lEcP9Y+CVuWp0WXqSvyXYZDt
W4itPrk5DsH0iOrrk48cmFOC9pDRbc+rmErQ9b3WHFRsk1K2NUyeYRNXXda36fv4
kTwwSLNpVVeEhsKLqosQ0WJLDivW3QgIBllhrBEKEZAQdVZU8W8xyx6rzUcIW1dk
1HjQRu1T36sssaBqyLFJVTGBdXi/mhhe4BlRYR+kaKSGiJWLJ4BJafk9iWBKnfnx
u8dcEtLYj+4nyKyTW+ejmtmJ4w7GUTeLU0Xvw03rQebhyf6R09uKpoG8hblRk4UX
BnUNv0Knkv3YIA8gYnXr
=oEQ+
-----END PGP SIGNATURE-----

--ItroYk2LVxvwOvi/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
