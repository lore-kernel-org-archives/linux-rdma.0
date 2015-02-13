From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/22] IB/ipoib: fix IPOIB_MCAST_RUN flag usage
Date: Fri, 13 Feb 2015 08:30:11 -0500
Message-ID: <1423834211.3387.8.camel@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
	 <73f38862d167a9849482464519c04b7c1f0a8b7c.1423703861.git.dledford@redhat.com>
	 <54DDBAB8.10002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-+OQXyGthaLG0P5JV/2is"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DDBAB8.10002-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-+OQXyGthaLG0P5JV/2is
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-02-13 at 10:50 +0200, Erez Shitrit wrote:
> On 2/12/2015 3:43 AM, Doug Ledford wrote:
> > The usage of IPOIB_MCAST_RUN as a flag is inconsistent.  In some places
> > it is used to mean "our device is administratively allowed to send
> > multicast joins/leaves/packets" and in other places it means "our
> > multicast join task thread is currently running and will process your
> > request if you put it on the queue".  However, this latter meaning is i=
n
> > fact flawed as there is a race condition between the join task testing
> > the mcast list and finding it empty of remaining work, dropping the
> > mcast mutex and also the priv->lock spinlock, and clearing the
> > IPOIB_MCAST_RUN flag.  Further, there are numerous locations that use
> > the flag in the former fashion, and when all tasks complete and the tas=
k
> > thread clears the RUN flag, all of those other locations will fail to
> > ever again queue any work.  This results in the interface coming up fin=
e
> > initially, but having problems adding new multicast groups after the
> > first round of groups have all been added and the RUN flag is cleared b=
y
> > the join task thread when it thinks it is done.  To resolve this issue,
> > convert all locations in the code to treat the RUN flag as an indicator
> > that the multicast portion of this interface is in fact administrativel=
y
> > up and joins/leaves/sends can be performed.  There is no harm (other
> > than a slight performance penalty) to never clearing this flag and usin=
g
> > it in this fashion as it simply means that a few places that used to
> > micro-optimize how often this task was queued on a work queue will now
> > queue the task a few extra times.  We can address that suboptimal
> > behavior in future patches.
> >
> > Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 11 +++++------
> >   1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> > index bc50dd0d0e4..91b8fe118ec 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> > @@ -630,8 +630,6 @@ void ipoib_mcast_join_task(struct work_struct *work=
)
> >   	}
> >  =20
> >   	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
> > -
> > -	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
> >   }
> >  =20
> >   int ipoib_mcast_start_thread(struct net_device *dev)
> > @@ -641,8 +639,8 @@ int ipoib_mcast_start_thread(struct net_device *dev=
)
> >   	ipoib_dbg_mcast(priv, "starting multicast thread\n");
> >  =20
> >   	mutex_lock(&mcast_mutex);
> > -	if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> > -		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
> > +	set_bit(IPOIB_MCAST_RUN, &priv->flags);
>=20
> Hi Doug,
> Can you use IPOIB_FLAG_OPER_UP instead of IPOIB_MCAST_RUN, in all these=
=20
> places and get rid of that RUN bit?

Yes, I think that should be easily doable.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-+OQXyGthaLG0P5JV/2is
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU3fxjAAoJELgmozMOVy/dZQMP/3BXiN830mf0AvzUCcK1apt8
wsCQK7JdBJuedw88wvAyzv/r72UMEufEjlKWqMUJZ7aojCQyQ+UoXKz1mahjXjfQ
s1m05syMJGm33j87W2EX2dOxQ5DvgdFjeYy+YNTLiJ62otfwey4nF2XpVMymU8z/
axq0f1ByiYy+2vK9v0e8NqL0R+HvUkvLhetaadPrudhpJvCFsQxlfRBfIyddnU9w
plcicgu7qu4JasaN+JJgiw0q4dSaN3uClGuxNCsIHHi9pgV9ncTp3yXOUNd2UwjS
teHXmKHE1GLmOiaR+2W9wVyBMfOAjN7DcryUg8jEC6Cj30wRwZy8oideAZrms/g7
UnHGYkvKwQDNpl6v8RDXeehbh8tQX1LyVmFp7RLtqrgMx+Fzx9PM+ZfBOGN0nKhr
xVqewAcBsfWSE0YjVqSnye0je4GvInAZMat1Ng+Z0SBV5osF2d7YFoqsnJj7gyon
IL9zB4XeKSANO/I036NBuCny0R7+XoCV9a8eCBoar3FebeG5dGkZCPR8mjl3faYZ
8/ygN1EK7qgmlLoOstotAWm3U2cf2mv7dXFyr5vIncjXs1g1zjm09LMfz1nAzf9h
6iKGbj7c6DBdLkT9/nuzTKcOvXl2qreTPcF84lx24HRZVRuORc1eMSc1k/R/azit
FbnQghwNuMVGYv8BQ6sI
=RJ+x
-----END PGP SIGNATURE-----

--=-+OQXyGthaLG0P5JV/2is--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
