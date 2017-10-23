From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Mon, 23 Oct 2017 20:03:28 +0300
Message-ID: <20171023170328.GL2106@mtr-leonro.local>
References: <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
 <20171017081837.GA19107@obsidianresearch.com>
 <20171017102121.GM2106@mtr-leonro.local>
 <20171019061100.GB6555@obsidianresearch.com>
 <20171019061405.GW2106@mtr-leonro.local>
 <c2f3b529-cc53-aef0-fdcf-e86e99360db0@mellanox.com>
 <20171021194215.GA4094@obsidianresearch.com>
 <20171023060436.GD2106@mtr-leonro.local>
 <20171023152340.GA11952@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Bd5h60K8hFlO6A9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023152340.GA11952-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/Bd5h60K8hFlO6A9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 09:23:40AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2017 at 09:04:36AM +0300, Leon Romanovsky wrote:
> > On Sat, Oct 21, 2017 at 01:42:15PM -0600, Jason Gunthorpe wrote:
> > > On Thu, Oct 19, 2017 at 09:28:31AM +0300, Alex Vesker wrote:
> > > > On 10/19/2017 9:14 AM, Leon Romanovsky wrote:
> > > > >On Thu, Oct 19, 2017 at 12:11:00AM -0600, Jason Gunthorpe wrote:
> > > > >>On Tue, Oct 17, 2017 at 01:21:21PM +0300, Leon Romanovsky wrote:
> > > > >>>>Yes, we should add a deprecation one shot printk to the kernel for the
> > > > >>>>sysfs interface to encourage people to use ip
> > > > >>>Please don't do that, it won't help for anyone, and especially for the people
> > > > >>>who didn't hear about "ip" in 2017.
> > > > >>This is the standard kernel way to encourage people to use the new
> > > > >>interfaces...
> > > > >>
> > > > >>>IPoIB netlink doesn't support enhanced IPoIB device because child
> > > > >>>device in netlink code was not allocated with rdma_alloc_netdev call
> > > > >>>as it was done for other flows.
> > > > >>I don't understand, isn't this just a (bad) bug to be fixed?
> > > > >Yes and we want to fix it BEFORE adding discouraging warnings.
> > >
> > > > We plan to block ipoib_netlink in the meanwhile until we fix it.
> > >
> > > That isn't a good idea, don't break APIs for performance reasons..
> >
> > It is not "performance", but simple attempt to prevent kernel panic,
> > while calling that function, because I'm unsure if we success to provide
> > proper fix till merge window.
>
> Er, why should a non-accelerated ipoib instance panic? That makes no
> sense :(
>
> In any event, someone needs to send patches to fix these oops's!

Agree, Alex is supposed to work on it.

>
> Jason

--/Bd5h60K8hFlO6A9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuIOAACgkQ5GN7iDZy
WKfIRRAAntKwbMF9XNJ67tuP8eHq53vesBYzDwg6tvWWFQRdiLkv9OUzvZxHs2Vp
MEnGEtGExkXiMsSt02viCMtLTIAISZH/csZ1rHQP0RNR9Uh/fYiy4YCFfmt3wM8F
wOepz4LSxYyzwKtthPz/ULShypaV017en9YtH9k63HGZGQIbsFHXDsNBWh13CI9Z
nrm1wHTB+dYHARrG/jOF1OslR/1c8ftxfjtf9MI91jWNEDRau6JL0rkKBnt2hG6c
4zaRghpV9iD2mHze7sLfMA8eaXPwKYZw2zcz9kJGqrg8Fkh3nZI22DDb0EmWOqcJ
X+r1QF93vdrVy8mBKaRjc5tEV+fzUAtPn7x4DQYPPYsg+kiffh5AhmUvdKcn2im9
aLb3UVrACBizIXlNs3BSV2Bufns3k1JyhQAqnYK9s/4tmOgnjU7DZR+1kMMAj9E4
CvAZSxyJCUBTgs8fEiBFJ1HdtcdoCGF0PV4GxedBxc0LlajY2Wqkr7vb8+4LVCY8
V/4G+QdgJCc4U70zpZ2OKMDWkiFrAMK2RnVEgRXD5pDNH0i88Ad7p7ca/w7iNoJc
H/ojkHHehazJQTXZ4iDn+AxZcWW5a0ibMkl1M/P+4P1Pc+0j2oKsTBCE6LiHYhVM
f8c1L7RaTo3rp2DhzYToAOj9ZALzgy/KiIT+VBG35kAyy7JEFxk=
=Ff1T
-----END PGP SIGNATURE-----

--/Bd5h60K8hFlO6A9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
