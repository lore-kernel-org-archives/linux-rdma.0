From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v5 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Tue, 23 Jan 2018 20:35:52 +0200
Message-ID: <20180123183552.GW1393@mtr-leonro.local>
References: <20180122125119.26419-1-leon@kernel.org>
 <20180122125119.26419-4-leon@kernel.org>
 <20180123175433.GI30670@ziepe.ca>
 <20180123175848.GK30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wiiWofWi8Et/oezL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180123175848.GK30670-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wiiWofWi8Et/oezL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2018 at 10:58:48AM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 23, 2018 at 10:54:33AM -0700, Jason Gunthorpe wrote:
> > On Mon, Jan 22, 2018 at 02:51:14PM +0200, Leon Romanovsky wrote:
> > > +	mutex_lock(&dev->res.mutex);
> > > +	hash_del_rcu(&res->node);
> > > +	mutex_unlock(&dev->res.mutex);
> > > +
> > > +	res->valid = false;
> > > +
> > > +	if (res->task)
> > > +		put_task_struct(res->task);
> > > +	synchronize_srcu(&dev->res.srcu);
> > > +}
> >
> > This locking is wrong..
>
> Actually, just don't use RCU.
>
> We can't afford to call synchronize_srcu in the destroy() path of
> every object and the netlink user is not critical enough to bother
> optimizing the read side.

In large systems with many objects, such rwlock will block easily destroy
of the objects.

>
> Replace the rcu and the mutex with a simple rwlock.

My initial proposal was SRCU per-res to protect data with rwlock per-type to protect lists.

>
> Jason

--wiiWofWi8Et/oezL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpngIgACgkQ5GN7iDZy
WKcK8Q/9ESj9YtS8bGnGAYVpOUr3GZRQNWkyEf9iKt6DcbVhqQVM/tgrKsP0mR0s
7nGklz9irXYAn4RlPf6u2WPlhbwBrYl83k4DKP4oT9k5X2w2gkY7Hay05Ul7mMOY
w6+VI75nG0rNcWKtIkeSVZPOJPM/snge4mBOIkae2/zjyieUGP7cli3dK/uteQJL
MnrALtuST51hmCIKlCZjE7asuZt81a2ydl1D8SkraZmdJLSwPo8BfcpRwuIad9xt
2Ld0tMo8O0VuJv7l0ZVmvpDtH9mTojntC2hHwzoD4FzbCCRMaPwR1GI2j7a8aE1n
sO5NjJS3btwyikivyfesKgjsL5dK7S5uK0vbvz96gr8rg2wi72PEveYwHlWwl875
MyjOYAsVbGDR5jsgfyxuTd08L3QhHfqKbK5amrkEmW0PNcJZKWS7HuekIJHgc43D
7De0kLhib+KQslnbh0kZr0gdAYoIKdOMmOUjoLmyE8uCr/pjnTpUZ/YbedbIakCw
ECvMk3Z4DMuM6QmSYO1RquIoSVrSRDPhX+HU/naLA3dw6J6K5n11Y6OJpBwywgtZ
mXuN+qkMQhDrciw8CQlIsVFT/bBjYAltM07JUXVVcq9Qj29ImhGJaw6StJSfvnMQ
8yEkSXevKuthyI86JVxOYDILNn8Jj0mDRY872OpzDD632dnX2iQ=
=45ed
-----END PGP SIGNATURE-----

--wiiWofWi8Et/oezL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
