From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup
Date: Tue, 22 Dec 2015 15:37:48 -0500
Message-ID: <5679B49C.8030705@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <CAJ3xEMgQNMtxgTKC0zaKgy-WGugf6KwT7Ys5h3_RbN_7qd2=tg@mail.gmail.com>
 <56706414.8010807@redhat.com> <5670FC5E.8070405@mellanox.com>
 <CAJ3xEMiGOF79o1OSgxgk2tN+kY91uiNY5Aq+xu2U0Sur-htxpQ@mail.gmail.com>
 <5679A254.2040809@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RXS74HCXUjRLPIBbcCNeR2XGgeCRikNsE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5679A254.2040809-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RXS74HCXUjRLPIBbcCNeR2XGgeCRikNsE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/22/2015 02:19 PM, Doug Ledford wrote:
> On 12/22/2015 02:56 AM, Or Gerlitz wrote:
>> On Wed, Dec 16, 2015 at 7:53 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
>>> On 12/15/2015 9:03 PM, Doug Ledford wrote:
>>
>>>> Or, you specifically asked me to wait until this week.  I made my
>>>> initial impressions clear (I don't necessarily like the removal of t=
he
>>>> attr struct, but I like the removal of all of the query calls, and I=
'm
>>>> inclined to take the patch in spite of not liking the removal of the=

>>>> struct).  Do you have anything to add or have we beat this horse to =
death?
>>
>>> Hi Doug,
>>> Lets stop beating, both horses and people.
>>> I do understand that
>>> 1. you don't link the removal of the attr
>>> 2. you do like the removal of all the query calls
>>>
>>> I am proposing to take the path of a patch that
>>> does exactly #2 while avoiding #1.
>>
>> Doug,
>>
>> Did you look on my v1 post and the related discussion there w.r.t udat=
a?
>=20
> Yes, I did.
>=20
>> You didn't make any comment on my response here nor on the proposed pa=
tches.
>=20
> I'm trying to find all of the emails, they aren't in a single thread in=

> my mailbox (I had to do some reconstruction of my mailbox due to a
> problem in a mail filter late last week...missing that the rule was set=

> to "match any" when I intended "match all" and the action of the rule
> was "delete" when I expected delete to be the same as "move to trash"
> and it wasn't, it was delete immediately, has caused me some problems).=


OK, here's part of the problem.  The udata discussion was in your
original patch series, not the V1 series.  I don't have that in my
mailbox at all (it was a casualty of the aforementioned mailbox event,
and I probably could have recovered it at the time, but I didn't think I
needed the original thread, just the V1 thread, so I didn't).  However,
I looked things up on marc.info.  It would have been preferable to
either remove query_device from the hardware drivers or to rename it to
something that clearly denotes it is now a kernel internal call-in point
(say device->init_ib_dev_attr).  Christoph's patch doesn't really get
rid of each device's query_device, it just moves the code into each
device's init routine and drops the call point.  As far as I'm
concerned, leaving the code in a function and calling that function
either from each driver's init routine or from the core registration
function is neither here nor there to me, either would suffice.

>> Since we are really short in time w.r.t EOY holidays and we have the
>> udata matter
>> open (see [1]), could we move finalizing this discussion to the 4.6 ti=
me-frame?
>>
>> If you do have the time, I think it would be fair to see a response
>> from you on the
>> discussion before you pick any of the two patch sets - so??
>=20
> I'm not inclined to take either patch set as they stand.  Your's is
> closer to what I'm leaning towards though.  I think I can add a single
> patch to yours to make it into what I want.  I'm going to go work on
> that right now...

After looking it over in detail, I'm not going to do what I had in mind.
 I still think the udata issue should be resolved, but I'm willing to
take that as a follow-on patch later on.  So, for now, I've taken in
your v1 patchset.  I'm now going to start seeing how many of the
patchsets I had also intended to take for 4.5 will need possible respins
in order to apply cleanly :-/

>> Or.
>>
>> [1] Christoph's patch doesn't remove the query_device callback from
>> mlx4 since we
>> report there values to libmlx4 through the udata mechanism. The
>> query_device callback
>> will need to be present in future/current drivers if they decide to
>> use udata as well



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--RXS74HCXUjRLPIBbcCNeR2XGgeCRikNsE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWebScAAoJELgmozMOVy/d+CEQAMU/BTEcKahHwhye02NBm3ny
nFBPCeFpHDAqkp/9/VWq0Dc2x+7etXhB/xlJbh5/qn0Y9LA3KyuWUbo9cfyLlC+g
hQPcSgbFBU/RmLPkvh58hyrVm9OgWcArnc37vgExmXfJXzzBfUkG3VJNVz9dMmIQ
XfO2P9AWanQviaiv2LddsuedUxlBWQxo0mv6KJ0W1QkQY6/JW7pqPv5VlsuXO+pe
Zf6+bf6CzqZEGPMIxpDlj9QKIJJpU37uKSpDfYhDKV2MuLP051jlPgVg4cRO/4Fj
Iv5TyqAhj1tlpd+oK1laD0Qfdl2q2i63qwrFUXgYO6rRgbehIkq+tkPM0gWVb8WT
kmKGGQXAN93IpSDI0Oj2dSwW2R/at1NSy1b+gWGHG3eye5ywJivViR5bxRx+3ueu
8OJxPyM3j96c/64caldkVyoGbdRg8L1bhkEx9YIFJVRa4luSTRmLJpvk+fCRrMq8
GC6mDXRq4ytaror8O50dWq0EgMrRWa6zS5PT58XjH/O+h6LrKibNug8P674B3KF9
Y/7iNPWG67nIJrxfW3eYPvrTNu4iF634xHMMl8qwoTl3hM/sATtfY/fu/U01wcpq
mH2aRKhylVi1kemOk2pz6ML/eD1LucVNCu6CcRUKrWTeO4eNrSGa6u/epcQZai/D
+vC+b/JVzLwh9LduU+Rq
=VBtb
-----END PGP SIGNATURE-----

--RXS74HCXUjRLPIBbcCNeR2XGgeCRikNsE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
