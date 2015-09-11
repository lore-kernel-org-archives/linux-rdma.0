From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 16:09:49 -0400
Message-ID: <55F3350D.6090002@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <20150911183931.GB546@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UxrVHbDSEHVKOBv3Hsas6AI1NOrgdjW7H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911183931.GB546-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UxrVHbDSEHVKOBv3Hsas6AI1NOrgdjW7H
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/11/2015 02:39 PM, Jason Gunthorpe wrote:
> On Thu, Sep 10, 2015 at 09:21:05PM -0400, Doug Ledford wrote:
>> During the recent rework of the mcast handling in ipoib, the join
>> task for regular and send-only joins were merged.  In the old code,
>> the comments indicated that the ipoib driver didn't send enough
>> information to auto-create IB multicast groups when the join was a
>> send-only join.  The reality is that the comments said we didn't, but
>> we actually did.  Since we merged the two join tasks, we now follow
>> the comments and don't auto-create IB multicast groups for an ipoib
>> send-only multicast join.  This has been reported to cause problems
>> in certain environments that rely on this behavior.  Specifically,
>> if you have an IB <-> Ethernet gateway then there is a fundamental
>> mismatch between the methodologies used on the two fabrics.  On
>> Ethernet, an app need not subscribe to a multicast group, merely
>> listen.
>=20
> This should probably be clarified. On all IP networks IGMP/MLD is used
> to advertise listeners.
>=20
> A IB/Eth gateway is a router, and IP routers are expected to process
> IGMP - so the gateway certainly can (and maybe must) be copying
> groups declared with IGMP from the eth side into listeners on IB MGIDs

Obviously, the gateway in question currently is not doing this.

> We may also be making a mistake in IPoIB - if the send side MGID join
> fails, the send should probably go to the broadcast, and the join
> retried from time to time. This would at least let the gateway
> optimize a bit more by only creating groups in active use.

That's not *too* far off from what we do.  This change could be made
without a huge amount of effort.  Right now we queue up the packet and
retry the join on a timer.  Only after all of the join attempts have
failed their timed retries do we dequeue and drop the packets.  We could
drop the queue backlog entirely and just send to broadcast when the
multicast group is unsubscribed.

> That would emulate the ethernet philosophy of degrade to broadcast.

Indeed.

> TBH, fixing broken gateway devices by sending to broadcast appeals to
> me more than making a module option..

Well, we've already established that the gateway device might be well be
broken.  That makes one wonder if this will work or if it might be
broken too.

>> on the IB side of the gateway.  There are instances of installations
>> with 100's (maybe 1000's) of multicast groups where static creation
>> of all the groups is not practical that rely upon the send-only
>=20
> With my last patch the SM now has enough information to auto-create
> the wonky send-only join attempts, if wanted to. It just needs to fill
> in tclass, so it certainly is possible to address this long term
> without a kernel patch.
>=20
>> joins creating the IB multicast group in order to function, so to
>> preserve these existing installations, add a module option to the
>> ipoib module to restore the previous behavior.
>=20
> .. but an option to restore behavior of an older kernel version makes
> sense - did we really have a kernel that completely converted a
> send-only join to full join&create?

I just re-checked to verify this and here's what I found:

kernels v3.10, v3,19, and v4.0 have this in ipoib_mcast_sendonly_join:

        if (test_and_set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags)) {
                ipoib_dbg_mcast(priv, "multicast entry busy, skipping\n")=
;
                return -EBUSY;
        }

        rec.mgid     =3D mcast->mcmember.mgid;
        rec.port_gid =3D priv->local_gid;
        rec.pkey     =3D cpu_to_be16(priv->pkey);

        comp_mask =3D
                IB_SA_MCMEMBER_REC_MGID         |
                IB_SA_MCMEMBER_REC_PORT_GID     |
                IB_SA_MCMEMBER_REC_PKEY         |
                IB_SA_MCMEMBER_REC_JOIN_STATE;

        mcast->mc =3D ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
                                         priv->port, &rec,
                                         comp_mask,
                                         GFP_ATOMIC,
                                         ipoib_mcast_sendonly_join_comple=
te,
                                         mcast);

kernel v4.1 and on no longer have sendonly_join as a separate function.
 So, to answer your question, no, upstream didn't do this.  This,
however, is carried in OFED:

        rec.mgid     =3D mcast->mcmember.mgid;
        rec.port_gid =3D priv->local_gid;
        rec.pkey     =3D cpu_to_be16(priv->pkey);

        comp_mask =3D
                IB_SA_MCMEMBER_REC_MGID         |
                IB_SA_MCMEMBER_REC_PORT_GID     |
                IB_SA_MCMEMBER_REC_PKEY         |
                IB_SA_MCMEMBER_REC_JOIN_STATE;

        if (priv->broadcast) {
                comp_mask |=3D
                        IB_SA_MCMEMBER_REC_QKEY                 |
                        IB_SA_MCMEMBER_REC_MTU_SELECTOR         |
                        IB_SA_MCMEMBER_REC_MTU                  |
                        IB_SA_MCMEMBER_REC_TRAFFIC_CLASS        |
                        IB_SA_MCMEMBER_REC_RATE_SELECTOR        |
                        IB_SA_MCMEMBER_REC_RATE                 |
                        IB_SA_MCMEMBER_REC_SL                   |
                        IB_SA_MCMEMBER_REC_FLOW_LABEL           |
                        IB_SA_MCMEMBER_REC_HOP_LIMIT;

                rec.qkey          =3D priv->broadcast->mcmember.qkey;
                rec.mtu_selector  =3D IB_SA_EQ;
                rec.mtu           =3D priv->broadcast->mcmember.mtu;
                rec.traffic_class =3D priv->broadcast->mcmember.traffic_c=
lass;
                rec.rate_selector =3D IB_SA_EQ;
                rec.rate          =3D priv->broadcast->mcmember.rate;
                rec.sl            =3D priv->broadcast->mcmember.sl;
                rec.flow_label    =3D priv->broadcast->mcmember.flow_labe=
l;
                rec.hop_limit     =3D priv->broadcast->mcmember.hop_limit=
;
        }

and so this has been happening since forever in OFED (the above is from
1.5.4.1).

Part of the confusion here is that I was on a concall with the people
this problem is effecting, and their claim was that this started with my
cleanup of the multicast stuff in the v4.1 kernel.  I double checked the
OFED sources at the time, but not the upstream kernel, and took them at
their word that my patches caused the problem to appear on upstream
kernels, which implies that the older upstream kernels, where the
sendonly_join that I deleted still existed, were like OFED.  If my patch
set *did* start the problem, then it's not because of the autocreate
issue.  So in that sense, this would be more like creating an OFED
compatibility hook.

>> +		 * An additional problem is that if we auto-create the IB
>> +		 * mcast group in response to a send-only action, then we
>> +		 * will be the creating entity, but we will not have any
>> +		 * mechanism by which we will track when we should leave
>> +		 * the group ourselves.  We will occasionally leave and
>> +		 * re-join the group when these events occur:
>=20
> I would drop the langauge of creating-entity, that isn't something
> from the IBA.
>=20
> The uncontrolled lifetime of the join is not related to creating or
> not.
>=20
>> +		 * 2) a regular mcast join/leave happens and we run
>> +		 *    ipoib_mcast_restart_task
>=20
> Really? All send only mgids are discarded at that point? Ugly.

Yep.  Any time an app joins/leaves a multicast group, it updates our
multicast list in the net core, and via our net update we schedule a
multicast_restart_task().  When that happens, all full joins are matched
against the new list of joined groups from the net core, any that no
longer match a subscribed group we put on the remove list, any that
match we leave on the list, any that are now in the net core and not in
our list we add.  Because the sendonly groups are not tracked at the net
core level, our only option is to move them all to the remove list and
when we get another sendonly packet, rejoin.  Unless we want them to
stay around forever.  But since they aren't real send-only joins, they
are full joins where we simply ignore the incoming data, leaving them
around seems a bad idea.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--UxrVHbDSEHVKOBv3Hsas6AI1NOrgdjW7H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8zUNAAoJELgmozMOVy/do3MP/Rd/On9mKvDoe0YdwDjKCZiP
T/AINHkfgWjibLI5OQGPAADetPGgKYXZMZ3Eq2U1BqRot946/K6UFBqk2eDYiWSk
CZ6d6OSF8m6HJx/99E03hxhtchfygYJ3+JvQCKEpJYDQ35yzUhrcx+repirOcReh
rZtps2j7TnCuxOJh8JK7DnVTbK+OT02h/cJFxbZQ418UCMj1RXviYZ8sKtFLdaXx
O+h6Pr6eCPwLsJqCrW+QbofYuyuILFwYFQJCQ5sKZ+XQaslf3fLFrtGDbNAYs4zr
NC3V8aOMxveyKIB9xHJ0UzOuTybThvPbc4YG3Ju3N/M9TuzvaDDux5Y79VBlA8aN
rl8faxHkFS6Ofw6CsDqLR/AHCbqVwd1DWRpQHlpyfFqkQZkC052hdQ/K6BtDVvMP
LQN48BUHa3IdgR3J+I6xZdnZI6IGK7RFySnnujeil2tPYRHzeDhT3BAQ2rsJvZeH
f+pjXBdXRi41aly/PHY2DvLB1v6Z1Vm7QHjySQUc+PQmSuNVAxACZYPbYdXKzJMZ
evZFpvhLAuXoepuPdN9ya3dn4FHPxtr0vO9PGhVQTJ8kwoBm5TMe6KcqigH4gaeI
/8O9uJT6dLPkxwFmTySA74Y6GGzkeIY4lmWcQTxPnB550ZPnpuMkh3cl2S3cg+qx
TBtKiL/sHnDE6hnhQ89j
=hGGX
-----END PGP SIGNATURE-----

--UxrVHbDSEHVKOBv3Hsas6AI1NOrgdjW7H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
