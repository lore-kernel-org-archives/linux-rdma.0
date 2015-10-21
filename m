From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix rb-tree duplicate free and
 use-after-free
Date: Wed, 21 Oct 2015 15:58:18 -0400
Message-ID: <5627EE5A.7030303@redhat.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734333@ORSMSX109.amr.corp.intel.com>
 <561FC309.2030102@mellanox.com> <5626A39D.6030906@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G1vaDHoj962DXW5h7bLf3JbnulWRJHbxD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5626A39D.6030906-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G1vaDHoj962DXW5h7bLf3JbnulWRJHbxD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/20/2015 04:27 PM, Doug Ledford wrote:
> On 10/15/2015 11:15 AM, Matan Barak wrote:
>>
>>
>> On 10/12/2015 7:37 PM, Hefty, Sean wrote:
>>>> ib_send_cm_sidr_rep could sometimes erase the node from the sidr
>>>> (depending on errors in the process). Since ib_send_cm_sidr_rep is
>>>> called both from cm_sidr_req_handler and cm_destroy_id, cm_id_priv
>>>
>>> This should clarify that it is the app calling from the callback, and=

>>> not a direct call from the cm_sidr_req_handler.
>>>
>>
>> Consider the following error flows:
>>
>> Double free:
>> cm_sidr_req_handler:3156->cm_reject_sidr_req:663->ib_send_cm_sidr_rep:=
3233->erase_rb
>>
>> cm_sidr_req_handler:3173->ib_destroy_cm_id->cm_destroy_id:846->ib_send=
_cm_sidr_rep:3233->erase_rb
>>
>>
>> RB contains free node:
>> cm_sidr_req_handler:3156->cm_reject_sidr_req:663->ib_send_cm_sidr_rep-=
>returns
>> error(for example cm_alloc_msg,3219)
>>
>> cm_sidr_req_handler:3173->ib_destroy_cm_id->cm_destroy_id:846->cm_reje=
ct_sidr_req->cm_reject_sidr_req:663->returns
>>
>> error(for example cm_alloc_msg,3219)->RB wasn't erased but memory is
>> freed :910 kfree(cm_id_priv)
>>
>>
>>>> could be either erased from the rb_tree twice or not erased at all.
>>>
>>> In an error case, I can see why it would be left in the rbtree, but I=

>>> don't see how it can be removed twice.
>>>
>>>
>>>> Fixing that by making sure it's erased only once before freeing
>>>> cm_id_priv.
>>>>
>>>> Fixes: a977049dacde ('[PATCH] IB: Add the kernel CM implementation')=

>>>> Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>
>>>> Hi Doug,
>>>> This patch fixes a bug in the CM. In some flow, rb-tree could be
>>>> freed twice or used after it was freed. This bug was picked by
>>>> our regression tests and this fix was verified.
>>>>
>>>> Thanks,
>>>> Doron and Matan
>>>>
>>>>   drivers/infiniband/core/cm.c | 10 +++++++++-
>>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/=
cm.c
>>>> index f5cf1c4..56ff0f3 100644
>>>> --- a/drivers/infiniband/core/cm.c
>>>> +++ b/drivers/infiniband/core/cm.c
>>>> @@ -844,6 +844,11 @@ retest:
>>>>       case IB_CM_SIDR_REQ_RCVD:
>>>>           spin_unlock_irq(&cm_id_priv->lock);
>>>>           cm_reject_sidr_req(cm_id_priv, IB_SIDR_REJECT);
>>>> +        spin_lock_irq(&cm.lock);
>>>> +        if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node))
>>>> +            rb_erase(&cm_id_priv->sidr_id_node,
>>>> +                 &cm.remote_sidr_table);
>>>> +        spin_unlock_irq(&cm.lock);
>>
>> This change seeks to remove the about to be freed node from the rb tre=
e,
>> while verifying it has not been freed already
>>
>>>
>>> We should be able to use a return value from cm_reject_sidr_req() --
>>> passed through from ib_send_cm_sidr_rep() to determine if the id was
>>> removed from the tree.
>>>
>>
>> But this won't protect from double free in ib_send_cm_sidr_rep, unless=

>> we pass this parameter to the cm destroy function, but this alternativ=
e
>> is cumbersome.
>>
>>>>           break;
>>>>       case IB_CM_REQ_SENT:
>>>>       case IB_CM_MRA_REQ_RCVD:
>>>> @@ -3210,7 +3215,10 @@ int ib_send_cm_sidr_rep(struct ib_cm_id *cm_i=
d,
>>>>       spin_unlock_irqrestore(&cm_id_priv->lock, flags);
>>>>
>>>>       spin_lock_irqsave(&cm.lock, flags);
>>>> -    rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
>>>> +    if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
>>>> +        rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);=

>>>> +        RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
>>>> +    }
>>
>> This change protects against double free
>>
>>>>       spin_unlock_irqrestore(&cm.lock, flags);
>>>
>>> Something is very wrong in this function if the id is not in the tree=

>>> at this point.
>>>
>>
>> We agree, but there's an error flow that triggers this behavior.
>=20
> Sean, I need to close on this patch.  What is your position after
> Matan's explanation?
>=20

Absent an objection from Sean, I've pulled this in.  A use after free
bug is a pretty serious issue, and you've listed an error flow that
triggers it.  The only thing bugging me is that this code is 10+ years
old and this didn't show up until now, which makes me think that some
recent change is the cause of this.  I've made note of that fact in my
tag commit and I think this warrants further examination in the next
kernel cycle.  But since we are so close to out of time on 4.3, I deemed
it better to fix the use after free issue, even if it isn't necessarily
the perfect fix, than leave that hanging about.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--G1vaDHoj962DXW5h7bLf3JbnulWRJHbxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJ+5aAAoJELgmozMOVy/d6AsP/RKlWnJGSFmL9t/a7+YAZcSe
30G1c5NtWYmPr+YLLCXmHi4X+GucwN9m+qhsabkoiXKkU0YWGy8BTzd4A4MhuwT6
q+L436nBjiQ2cB0kN+nGOFpqo+YJIbbuS3MP3go9HDPsz2S09pJjHiHFHONKF0N3
obqHyhGA+Zo6rXKG5SEuAA8FK/JaisG+vK0wA74rIwastZvpqYjNoRQ8/w6GTlNW
BSBw0OkHeLB7BLJ6v2nf8xgPpZ9Oh9KayH/IwNlzhGRnKGJ2VXXNDRYcJHISsMnq
7bPWOEioH3sk4R4aNKJ6JgGrU367njdRkhV7XEXkS75+lyUVLhFMIqzXI0ExFgQP
WCM+h2DzeIvk2wOJ1kJZ9HSqFYG5dRs2yNPajgrAOHTYJuq0aYqS27jslYpUXgws
bnApoG7hTKqBziQjPszKvYw4KaGiYoHrbEiph/3t1vP7rgYmI2Om7+W4eE4wqIAc
lI9JSORQytsDv7RSJGmHl9w1PDyPWJgXcXK4mJqVJLaIH/qVYtG7Rtn8/fnQcthF
oAWwi3717xeBN0DcSfqZCamyWQ/ZsvhtT2qjCS2NFA4UUePQ12pzrozMFvr89Lsa
zuiaXOBSLWzqCKpvg5P5Dbf1d6Es6WpoEOxjqPlvKP/9E5so86OCx+6RHVo7x2eR
WXRm49HT5gC4H3s/DP8r
=TKT2
-----END PGP SIGNATURE-----

--G1vaDHoj962DXW5h7bLf3JbnulWRJHbxD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
