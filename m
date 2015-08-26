From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Wed, 26 Aug 2015 09:37:50 -0400
Message-ID: <55DDC12E.6030705@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com> <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com> <20150825194945.GA22335@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3BcojVpQfo5Vdeh2GxdeqaTaffeeao3WI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150825194945.GA22335-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3BcojVpQfo5Vdeh2GxdeqaTaffeeao3WI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/25/2015 03:49 PM, Jason Gunthorpe wrote:
> On Tue, Aug 25, 2015 at 02:35:27PM -0400, Doug Ledford wrote:
>> On 08/25/2015 02:22 PM, Jason Gunthorpe wrote:
>>> On Tue, Aug 25, 2015 at 01:50:05PM -0400, Doug Ledford wrote:
>>>> On 08/21/2015 07:34 PM, Jason Gunthorpe wrote:
>>>>> Even though we don't expect the group to be created by the SM we
>>>>> sill need to provide all the parameters to force the SM to validate=

>>>>> they are correct.
>>>>
>>>> Why does this patch embed locking changes that, as far I can tell, a=
re
>>>> not needed by the rest of the patch?
>>>
>>> test_bit was lowered into ipoib_mcast_join, which requires pushing th=
e
>>> lock unlock down as well. The set_bit side holds that lock.
>>
>> I see the confusion.  The test bit of SENDONLY isn't protected by the
>> lock, just the setting and clearing of BUSY.
>=20
> Well, I don't like to see locking elided unless necessary.

The corollary to that is that you shouldn't put locking around something
that doesn't need it just to make yourself feel better.

> The flags
> is clearly lock protected data,

Parts of flags are, not all of it.  Locking is needed to provide
exclusion between things that can race.  If two things can not race,
then the locking is not needed.

> the lock should be held when accessing
> it - even if one can reason some of the locking away today. That just
> increases maintainability and clarity.
>=20
> In this instance pushing the locking is trivial. Do you really want it
> gone?

I've been considering leaving it, but for other reasons.  However, the
change is not without problems.  I'll get to that later in this email...

> .. and looking at this, I feel justified in this position, because
> I noticed a bug in how flags is manipulated.
>=20
> This:
>=20
> static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
> 				   struct ib_sa_mcmember_rec *mcmember)
> {
> [..]
> 		if (test_and_set_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
> [..]
> 			clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags);
> 			return ret;
> 		}
>=20
> Has two unlocked sets for flags. The above is called directly from
> the sa callback.

Correct.

> While, the clear_bit/etc in ipoib_mcast_restart_task has a lock held
> and no obvious exclusion with the above (the mcast is on the
> multicast_list by now)..
>=20
> Sure looks like these two race:
>=20
> 		if (test_and_set_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags))..
> 		clear_bit(IPOIB_MCAST_FLAG_FOUND, &mcast->flags);
>=20
> Resulting in corruption of the flags.

Incorrect.  On all arches, the set_bit and friends functions are defined
to be atomic.  For arches without a specific asm implementation, that
means a spin lock internal to the bitops header is taken to prevent
corruption of the flags by multiple, racing attempts to access the bits.
 For x86 arch, the asm specific version uses locked memory instructions
to protect the accessing of the bits.  So simply accessing two different
flags at the same time is not a race condition.  You must be attempting
to access the same flag and then do something based up on that access.
The non-atomic nature of test/response is the only thing that needs locki=
ng.

In this particular instance, as you noted, ipoib_mcast_join_finish is
called via the sa callback, which will only ever be called if the BUSY
flag is set.  In restart task, we may set/clear the FOUND flag, but
that's only used to remove our mcast entry from the rbtree and move it
to the remove list.  We complete our sort and release our spinlock and
then we wait for all mcast entries with the BUSY flag set to call
complete(mcast->done) before we proceed any further.  Since we will
never call that complete until well after the tests/sets that you list,
and we will never call ipoib_mcast_leave() and therefore not test or
attempt to unattach based on the ATTACHED flag until after all completes
have come through, we are well outside of any race windows.

Which brings me to what I was alluding to earlier.  In your patch, you
move the complete(mcast->done); to inside the spinlock.  I don't
actually like that.  While the flags are atomic and therefore visible
the moment they are done, any other writes to the mcast struct might be
reordered.  By releasing the spinlock before you call complete(), you
force a write memory barrier and make all changes visible.  That way
anything that was waiting on that complete has a guaranteed clean
picture when they get woke up.  Calling complete() within the spinlock
takes that guarantee away.

As to the reason I was considering leaving it?  In the original code,
the normal path has to release/reacquire the spinlock once on success,
and twice on immediate error.  As per some of the talks at LinuxCon last
week, the cost to simply acquire/release a spinlock is in excess of 30
cycles now (mainly due to the locked memory access, which means all
those atomic bit ops are expensive too and yet we pepper them around in
the code like they were candy sprinkles).  Your code does a single
release/reacquire even in the case of immediate error.  However, it has
the issue of calling complete without releasing the spinlock, which I
don't like.  I suppose a wmb(); before the complete() would work though.

> This ugly untested thing sort it..

This patch is unneeded.  I'm guessing you just forgot that the *_bit
primitives in the kernel are defined as atomic operations.

> From ccfc99859d221ea4dada20e388d50e2cc6be580c Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Tue, 25 Aug 2015 13:27:02 -0600
> Subject: [PATCH] IB/ipoib: Do not write to mcast->flags without holding=
 a lock
>=20
> At a minimum the ipoib_mcast_restart_task could be called at any
> time and it will also write the flags resulting in corruption
> of the flags value.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> index 2d43ec542b63..077586a867bf 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -219,9 +219,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mca=
st *mcast,
>  	/* Set the multicast MTU and cached Q_Key before we attach if it's
>  	 * the broadcast group.
>  	 */
> +	spin_lock_irq(&priv->lock);
>  	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
>  		    sizeof (union ib_gid))) {
> -		spin_lock_irq(&priv->lock);
>  		if (!priv->broadcast) {
>  			spin_unlock_irq(&priv->lock);
>  			return -EAGAIN;
> @@ -244,7 +244,6 @@ static int ipoib_mcast_join_finish(struct ipoib_mca=
st *mcast,
>  			IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
> =20
>  		priv->qkey =3D be32_to_cpu(priv->broadcast->mcmember.qkey);
> -		spin_unlock_irq(&priv->lock);
>  		priv->tx_wr.wr.ud.remote_qkey =3D priv->qkey;
>  		set_qkey =3D 1;
>  	}
> @@ -254,19 +253,24 @@ static int ipoib_mcast_join_finish(struct ipoib_m=
cast *mcast,
>  			ipoib_warn(priv, "multicast group %pI6 already attached\n",
>  				   mcast->mcmember.mgid.raw);
> =20
> +			spin_unlock_irq(&priv->lock);
>  			return 0;
>  		}
> =20
> +		spin_unlock_irq(&priv->lock);
>  		ret =3D ipoib_mcast_attach(dev, be16_to_cpu(mcast->mcmember.mlid),
>  					 &mcast->mcmember.mgid, set_qkey);
>  		if (ret < 0) {
>  			ipoib_warn(priv, "couldn't attach QP to multicast group %pI6\n",
>  				   mcast->mcmember.mgid.raw);
> =20
> +			spin_lock_irq(&priv->lock);
>  			clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags);
> +			spin_unlock_irq(&priv->lock);
>  			return ret;
>  		}
> -	}
> +	} else
> +		spin_unlock_irq(&priv->lock);
> =20
>  	{
>  		struct ib_ah_attr av =3D {
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3BcojVpQfo5Vdeh2GxdeqaTaffeeao3WI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV3cEuAAoJELgmozMOVy/dQ0gQAKYZaLoQV9eWFm+zhCn09IsU
NQClk9dd2RJCLdjEUF9jKxxbUlUnUTSoWQNsdgddZkgX44fk2Dy/wF/K3G1y6qnM
CKhUHhsUA7rMNwo/73hjVX/GFlFMI5QYtkIU52reG0pqPqPB/ciAhXi6uXKNdefU
Auby5wkUgAILlEhguevDXC8fAl1/XDTDQ8d8nzZSaIogtVi/VuBzvHH2qpBkV6M2
E1pTsqHF8UpmTiaLvg8O8LjWQITSZ4w3y8yEVhNk1qKNFVFVg85ZtEYb3L3/wDeP
nnRit04njGrAQP7yMqzkRa12aJZE/A6Q1dkPB51bihbv93WI1h495zxkS4QIJhKN
6IzizV59w5z9fEeFFZJebDmGzMlDRh5/4HS0C0ma0XpWyRwo0syE+LWNFt2LyGzJ
nZZbrB/8SpP1QPZmIyiJtkO3AqdLfNQCBN8fnpY8MGxXF53hImlfg1EWDowYIaoj
IAqaH+KOUScKSTWvgq3YY4iH9KNVs4ka5WpyPrRbVhMH5OwkJFR9d1izaxbGJBE8
BB6xKjD3IuMRBhTRuxp5Etmf80hRMISVCYMkOJk3spj4LteK07AnQDk+cb8hWvRd
Q8wSfhhOBiMOZq6zdp11VX6RUKIrEaFZ+KZB4d1oOIfBn+MPsFw4+K5zRtuD7nzm
iG/yUW1tpd5+vTJ0ttY7
=2GOz
-----END PGP SIGNATURE-----

--3BcojVpQfo5Vdeh2GxdeqaTaffeeao3WI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
