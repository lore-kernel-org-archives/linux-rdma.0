From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Tue, 7 Jun 2016 19:20:34 +0300
Message-ID: <20160607162034.GG3663@leon.nu>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-3-git-send-email-leon@kernel.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
 <42668994-5666-f5b3-8d38-4c452f0cc70f@redhat.com>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw@mail.gmail.com>
 <27852e30-765c-012a-b54b-f5ba096121d4@redhat.com>
 <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg@mail.gmail.com>
 <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d@redhat.com>
 <99eb8d42-95f2-6899-b427-b6258db5e44b@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OFj+1YLvsEfSXdCH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <99eb8d42-95f2-6899-b427-b6258db5e44b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--OFj+1YLvsEfSXdCH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 07, 2016 at 10:50:54AM -0400, Doug Ledford wrote:
> On 6/7/2016 10:43 AM, Doug Ledford wrote:
> > On 6/7/2016 10:32 AM, Erez Shitrit wrote:
> >> On Tue, Jun 7, 2016 at 4:48 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> >>> On 6/7/2016 2:01 AM, Erez Shitrit wrote:
> >>>> On Tue, Jun 7, 2016 at 2:59 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> >>>>> On 6/5/2016 5:10 PM, Or Gerlitz wrote:
> >>>>>
> >>>>>>> -                       neigh->alive =3D jiffies;
> >>>>>>> +
> >>>>>>> +                       if (likely(skb_queue_len(&neigh->queue) <=
 IPOIB_MAX_PATH_REC_QUEUE))
> >>>>>>> +                               neigh->alive =3D jiffies;
> >>>>>>
> >>>>>> why testing the queue len makes things right?
> >>>>>
> >>>>> I'm with Or on this one.  This test doesn't make sense unless you a=
ssume
> >>>>> that the neighbor is being hit with a steady stream of packets.  If
> >>>>> someone just runs ping -c 1 to a dead neighbor, this test will fail.
> >>>>> The idea of the patch is OK, but the test needs to be reworked for
> >>>>> situations other than a blasting stream of data.
> >>>>>
> >>>>
> >>>> I will try to explain the idea behind that test, and why it works (I
> >>>> hope I'll make it clear this time :))
> >>>>
> >>>> there are 2 objects that are taking place here, the garbage-collector
> >>>> that removes neigh if was not used for defined time, and the
> >>>> path-query for each neigh.
> >>>> if the path-query failed the packets for specific neigh are kept in
> >>>> the neigh queue, but only if there are no more than
> >>>> IPOIB_MAX_PATH_REC_QUEUE, and the neigh is still kept for ever (let's
> >>>> assume CM connected that was stopped without any notification with
> >>>> DREQ etc.)
> >>>> The only way to know that there is an unresolved neigh is by checking
> >>>> its queue, if it is full we can assume that this is an unresolved
> >>>> neigh otherwise it is resolved.
> >>>
> >>> That's not true.  Reread what I wrote above (I was specific when I
> >>> picked that command).  Ping -c 1 will only send one ping.  It will not
> >>> trip this test.  As I said, your test relies on a stream of packets, a
> >>> single packet to a gone neighbor will never cause it to get deleted.
> >>
> >> If you ping one time (ping -c 1) there is no problem at all, the neigh
> >> will be deleted by the GC anyway, because no (unresolved) packet
> >> updates the neigh validity and the GC will check the last time it was
> >> refreshed and since only one ping refreshed it long ago, it will be
> >> deleted. (the GC always running)
> >>
> >> the problem is when there are non stop traffic to that neigh. IMHO
> >> that test works for that.
> >=20
> > Ok, that makes sense.
>=20
> Sorry, in case it wasn't clear, I grabbed this patch now (although I
> reworded the commit message significantly).

Thank you,
I truly appreciate your help.

>=20
>=20




--OFj+1YLvsEfSXdCH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVvRSAAoJEORje4g2clin9QoP/RjppO8B/oke7UYXQbmeXjfR
JOMkyK4FVOFzWDao7mCtYuJ5IjewELS/+2TSWAYH59rZI6ZqExJTEtA7riNpGIFV
MCovFBRbVWv/puMYNtxje2t7ZekY4MzDGBK3L9MwWMTa/ogopCgTbZStgSXjRdZ2
HlhdF4Bb4lXipsjEZFgQylmNdXBUNGi4Z+1LsdanEGKN1Y7j1fJreP3DFSrjizGN
ul4P6arUeHRW3n+yTIkdl/f0HqGL36baxXoFes50QA1bysOjOSmMUGYTG7t7gg93
8PNHmuF8TpQ0Avdc7VzcKyHJpLBTfpk0eyLFczCfNjHqGhCFcY5VKv3LAnvjaklw
MsDJA0YWMPXHutanWixaeW5woOF7x8D1J7heZvSGNdUUVoN79YDUWt+wGKFo9tZl
BfXexbIHy+witC22+Ajq9oGeuTb6tTOyS80lDunhYfYdAsTY2PXiYMoI/zmicjgx
lFfY+xd/PT0lzG0/TKzArdSUHzqTTY6ZHdVoci8OTT46+lr2Wy0xRT+zxOpKMkZp
yoIG3XwATu9Lw+o1mQ8eDFg/loOd97y2/mX/frm0UVl2LrfipoHHgKvCXP0c9vJS
HmiVOquMPT/GM/43MvRN+sl9JwS+A+YJXz0guEKjBf7wQqKBwps5kL4DFpg5FgFC
acf6pU5pmgxl3Q22QFPo
=K+FE
-----END PGP SIGNATURE-----

--OFj+1YLvsEfSXdCH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
