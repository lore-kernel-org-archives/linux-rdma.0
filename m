From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 17:40:41 -0400
Message-ID: <55F34A59.50401@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <20150911183931.GB546@obsidianresearch.com> <55F3350D.6090002@redhat.com>
 <20150911203820.GA19161@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q7EKpAcxC0xMnfjvQNmdj7ED8rRvm1k5J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911203820.GA19161-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q7EKpAcxC0xMnfjvQNmdj7ED8rRvm1k5J
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/11/2015 04:38 PM, Jason Gunthorpe wrote:
> On Fri, Sep 11, 2015 at 04:09:49PM -0400, Doug Ledford wrote:
>> On 09/11/2015 02:39 PM, Jason Gunthorpe wrote:
>>> On Thu, Sep 10, 2015 at 09:21:05PM -0400, Doug Ledford wrote:
>>>> During the recent rework of the mcast handling in ipoib, the join
>>>> task for regular and send-only joins were merged.  In the old code,
>>>> the comments indicated that the ipoib driver didn't send enough
>>>> information to auto-create IB multicast groups when the join was a
>>>> send-only join.  The reality is that the comments said we didn't, bu=
t
>>>> we actually did.  Since we merged the two join tasks, we now follow
>>>> the comments and don't auto-create IB multicast groups for an ipoib
>>>> send-only multicast join.  This has been reported to cause problems
>>>> in certain environments that rely on this behavior.  Specifically,
>>>> if you have an IB <-> Ethernet gateway then there is a fundamental
>>>> mismatch between the methodologies used on the two fabrics.  On
>>>> Ethernet, an app need not subscribe to a multicast group, merely
>>>> listen.
>>>
>>> This should probably be clarified. On all IP networks IGMP/MLD is use=
d
>>> to advertise listeners.
>>>
>>> A IB/Eth gateway is a router, and IP routers are expected to process
>>> IGMP - so the gateway certainly can (and maybe must) be copying
>>> groups declared with IGMP from the eth side into listeners on IB MGID=
s
>>
>> Obviously, the gateway in question currently is not doing this.
>=20
> Sure, my remark was the clarify the commit comment so people don't thin=
k
> this is OK/expected behavior from a gateway.
>=20
>> We could drop the queue backlog entirely and just send to broadcast
>> when the multicast group is unsubscribed.
>=20
> I'm pretty sure that would upset the people who care about this
> stuff.. Steady state operation has to eventually move to the optimal
> MLID.

I didn't mean to imply that we wouldn't attempt to join the group still.
 Just that right now the process is this:

send_mcast
  detect no-mcast group
    initiate sendonly join, while queueing packet to be sent
      process join completion
        success - send queued packet (which has been delayed)
        fail - leave packet on queue, set backoff timer, try
          join again after timer expires, if we exceed the
          number of backoff/join attempts, drop packet

The people I was on the phone with indicated that they are seeing some
packet loss of mcast packets on these sendonly groups.  For one thing,
that backlog queue we have while waiting for the join to complete is
capped at 3 deep and drops anything beyond that.  So it is easy to
imagine that even a small burst of packets could cause a drop.  But this
process also introduces delay on the packets being sent.  My comment
above then was to suggest the following change:

send_mcast
  no-mcast group
    initiate sendonly join
    simultaneously send current packet to broadcast group
      process join completion
        success - mark mcast group live, no queue backlog to send
        fail - retry as above
  mcast group, but group still no live
    send current packet to broadcast group
  mcast group, group is live
    send current packet to mcast group

The major change here is that we would never queue the packets any more.
 If the group is not already successfully joined, then we simply send to
the broadcast group instead of queueing.  Once the group is live, we
start sending to the group.  This would eliminate packet delays assuming
that the gateway properly forwards multicast packets received on the
broadcast group versus on a specific IB multicast group.

Then a simple mcast_expire_task that runs every 10 minutes or so and
leaves any send-only groups that haven't had a packet timestamp update
in more than some arbitrary amount of time would be a very simple
addition to make.

>> Well, we've already established that the gateway device might be well =
be
>> broken.  That makes one wonder if this will work or if it might be
>> broken too.
>=20
> If it isn't subscribed to the broadcast MLID, it is violating MUST
> statements in the RFC...

Yeah, my comment was in reference to whether or not it would receive a
multicast on broadcast packet and forward it properly.

>> and so this has been happening since forever in OFED (the above is fro=
m
>> 1.5.4.1).
>=20
> But has this has been dropped from the new 3.x series that track
> upstream exactly?

I haven't check that (I don't have any of the later OFEDs downloaded,
and I didn't see a git repo for the 3.x series under Vlad's area on
OpenFabrics git server).

>> our list we add.  Because the sendonly groups are not tracked at the n=
et
>> core level, our only option is to move them all to the remove list and=

>> when we get another sendonly packet, rejoin.  Unless we want them to
>> stay around forever.  But since they aren't real send-only joins, they=

>> are full joins where we simply ignore the incoming data, leaving them
>> around seems a bad idea.
>=20
> It doesn't make any sense to work like that. As is, the send-only
> side looks pretty messed up to me.
>=20
> It really needs to act like ND, and yah, that is a big change.
>=20
> Just to be clear, I'm not entirely opposed to an OFED compatability
> module option, but lets understand how this is broken, what the fix is
> we want to see for mainline and why the OFED 'solution' is not
> acceptable for mainline.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Q7EKpAcxC0xMnfjvQNmdj7ED8rRvm1k5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV80pZAAoJELgmozMOVy/dpx0P/1JHkLzQkpxpmDL/dSFe/ycp
p+e4/wv230vqIhKWhs9I3r2O4cA0AfMOziFujY8XuHc+CUuDzq7MyY57S4JSZ/2S
JLza4OuFlpSRikZ8Dcs09jb4rj5jbSTD5JAjfQfL2W52uYWKPJUnfXrauyH51cDR
th4Mx5HqvaBiNgdDTruYss0xVmKVqtPyx+UR0WHYPiT0LGbbGNMQgJstET8c8bDb
cpXXK551lqdsp725xwKYFIlp1lbLCvFz66KuZWY3PKaILLncLVrf522pof4C9ybC
Q22BHQ9zXTV/dINaJlENcj2eDyS137dFiBzXq9M5F2KRoqkicHtxAN9BvT3pQqj7
/DyttEME7ja1kULL4KtpqrgtvLjghzgjURiqh++qG05ul4qVs44+cuAC1pBIcWmI
FaCYUiV4zLgnhVvbyDeS81f/7VjOxCR34DCB/aTtNOI2BGfUPT6Gz8ljKpNftlIs
FXRiBy0+qSO+scB7D0LDqb4ZSgDj7D3TNpU0zPACXtltmTGm46TJZdqMUqp3NdUL
amqow4QiIPROVsunY4jF3/4NIv3/WcF2yajQoU2IqUmZOPTS0FD+g29szKGxcb3I
xTXz4ajntjlkuEGsjig1rrj5qrmbNqSLd7EcArtssZRHltB/0YaCvAnoB6MSgWfy
qu2ukmREY2hlzEsMgSKp
=dvhn
-----END PGP SIGNATURE-----

--Q7EKpAcxC0xMnfjvQNmdj7ED8rRvm1k5J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
