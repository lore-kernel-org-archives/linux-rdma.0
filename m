From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Thu, 6 Sep 2018 15:56:12 +0300
Message-ID: <20180906125612.GI3142@mtr-leonro.mtl.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-4-ar@cs.msu.ru>
 <20180905164727.3108bce6@shemminger-XPS-13-9360>
 <20180906072656.GB13034@cello>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906072656.GB13034@cello>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: Stephen Hemminger <stephen@networkplumber.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 06, 2018 at 10:26:56AM +0300, Arseny Maslennikov wrote:
> On Wed, Sep 05, 2018 at 04:47:27PM +0100, Stephen Hemminger wrote:
> > On Mon,  3 Sep 2018 19:13:16 +0300
> > Arseny Maslennikov <ar@cs.msu.ru> wrote:
> >
> > > +	if (ndev->dev_id == ndev->dev_port) {
> > > +		netdev_info_once(ndev,
> > > +			"\"%s\" wants to know my dev_id. "
> > > +			"Should it look at dev_port instead?\n",
> > > +			current->comm);
> > > +		netdev_info_once(ndev,
> > > +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
> > > +	}
> >
> > Single line message is sufficient.
> > Also don't break strings in messages.
> >
>
> OK, will fix in v4.
>
>
> (Sorry if the following is too off-topic here)
> Multi-line messages in separate printk calls can be racy, I get that.
> But I'd like to hear some reasoning behind the style decision to not
> break a long string into many string literals. (I'll most certainly not
> be alone in this, Documentation/process/ does not mention reasons, only
> the requirements themselves)
>
> The only drawback I currently see is that breaking a long message into
> multiple string literals makes it impossible to git grep the kernel tree
> for the whole message text.
> However, splitting a long line this way allows us to nicely wrap the
> code at 80 columns, which is a readability boon.
>
> Are there any other reasons to avoid that? Except maybe matters of taste. :)

AFAIK "grep" is the reason.

>
> > > +	}
> > > +
> > > +	ret = sprintf(buf, "%#x\n", ndev->dev_id);
> > > +
> > > +	return ret;
> >
> > Why not?
> > 	return sprintf...



--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbkSPsAAoJEORje4g2clin1/QQAKvHZDN6ogUZOlFfymvWtq4t
SnCDxZCKFXUeuC7KurD5My3CSRkQtapBTg/2QHVLrIIWMy/RWnz1NdXwngT78For
mAkCpQ8ieCrl7UhW19ugiPy7mSLZqO9U3JG2bjoRDAJG9L2zbWlo1CSPiXQrY8va
Olk2beFQmIEwvoC/TzXWgVyv0Oz+od6v+0xqXIUY9BG9yLDz352uWqDbvOdPahF5
hRcZFvHOgAxFD9RjOt1m83WRIsb5ccPa+akUG3EpqNwBZOPJtRV0/nb7+EHCb6Mn
nG4mIWJ6N3YtgjrZ7VdLbV0vOA2RgI3sfkDb0J7oMn1zMjA8GQnw2SXOj3tx0r+x
PqOSzDrwZv9UQa6YOJk0BhPKCzRlcWe4M6Y1lbZpIk8M1dW8D+8oUhfPObWpBDqc
2iTvbkMDKWI3Jptyp9nJvIFjlrRe/jh4xUNwphWprNnK3Olmfy0kvI5TDqoZZAlV
Fn7JI9dYDowXTdHVbJpX+uMjFjP1+rqnjHY5O4zgRjBvxXcJ25zKZ7oyKqAXcbwf
IbPMorcLP94Djkb4oafDs0esVEorlezR+QNkGMVeFoNzYuHGIlQ18ip0/R3CbWH+
V/PeQQE4bAWUyEtZxoar+0br4bczcxLXric+ldXVw43FLlMnMsZr99fI09sh04f3
ZHqzvfaUOWE00BDX1Dqp
=vHQA
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
