From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix rb-tree duplicate free and
 use-after-free
Date: Tue, 20 Oct 2015 16:27:09 -0400
Message-ID: <5626A39D.6030906@redhat.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734333@ORSMSX109.amr.corp.intel.com>
 <561FC309.2030102@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cGrRvDE1XXoucCuCP2sSC1dKsj1Oq8TWR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561FC309.2030102-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cGrRvDE1XXoucCuCP2sSC1dKsj1Oq8TWR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 11:15 AM, Matan Barak wrote:
>=20
>=20
> On 10/12/2015 7:37 PM, Hefty, Sean wrote:
>>> ib_send_cm_sidr_rep could sometimes erase the node from the sidr
>>> (depending on errors in the process). Since ib_send_cm_sidr_rep is
>>> called both from cm_sidr_req_handler and cm_destroy_id, cm_id_priv
>>
>> This should clarify that it is the app calling from the callback, and
>> not a direct call from the cm_sidr_req_handler.
>>
>=20
> Consider the following error flows:
>=20
> Double free:
> cm_sidr_req_handler:3156->cm_reject_sidr_req:663->ib_send_cm_sidr_rep:3=
233->erase_rb
>=20
> cm_sidr_req_handler:3173->ib_destroy_cm_id->cm_destroy_id:846->ib_send_=
cm_sidr_rep:3233->erase_rb
>=20
>=20
> RB contains free node:
> cm_sidr_req_handler:3156->cm_reject_sidr_req:663->ib_send_cm_sidr_rep->=
returns
> error(for example cm_alloc_msg,3219)
>=20
> cm_sidr_req_handler:3173->ib_destroy_cm_id->cm_destroy_id:846->cm_rejec=
t_sidr_req->cm_reject_sidr_req:663->returns
>=20
> error(for example cm_alloc_msg,3219)->RB wasn't erased but memory is
> freed :910 kfree(cm_id_priv)
>=20
>=20
>>> could be either erased from the rb_tree twice or not erased at all.
>>
>> In an error case, I can see why it would be left in the rbtree, but I
>> don't see how it can be removed twice.
>>
>>
>>> Fixing that by making sure it's erased only once before freeing
>>> cm_id_priv.
>>>
>>> Fixes: a977049dacde ('[PATCH] IB: Add the kernel CM implementation')
>>> Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>
>>> Hi Doug,
>>> This patch fixes a bug in the CM. In some flow, rb-tree could be
>>> freed twice or used after it was freed. This bug was picked by
>>> our regression tests and this fix was verified.
>>>
>>> Thanks,
>>> Doron and Matan
>>>
>>>   drivers/infiniband/core/cm.c | 10 +++++++++-
>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/c=
m.c
>>> index f5cf1c4..56ff0f3 100644
>>> --- a/drivers/infiniband/core/cm.c
>>> +++ b/drivers/infiniband/core/cm.c
>>> @@ -844,6 +844,11 @@ retest:
>>>       case IB_CM_SIDR_REQ_RCVD:
>>>           spin_unlock_irq(&cm_id_priv->lock);
>>>           cm_reject_sidr_req(cm_id_priv, IB_SIDR_REJECT);
>>> +        spin_lock_irq(&cm.lock);
>>> +        if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node))
>>> +            rb_erase(&cm_id_priv->sidr_id_node,
>>> +                 &cm.remote_sidr_table);
>>> +        spin_unlock_irq(&cm.lock);
>=20
> This change seeks to remove the about to be freed node from the rb tree=
,
> while verifying it has not been freed already
>=20
>>
>> We should be able to use a return value from cm_reject_sidr_req() --
>> passed through from ib_send_cm_sidr_rep() to determine if the id was
>> removed from the tree.
>>
>=20
> But this won't protect from double free in ib_send_cm_sidr_rep, unless
> we pass this parameter to the cm destroy function, but this alternative=

> is cumbersome.
>=20
>>>           break;
>>>       case IB_CM_REQ_SENT:
>>>       case IB_CM_MRA_REQ_RCVD:
>>> @@ -3210,7 +3215,10 @@ int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id=
,
>>>       spin_unlock_irqrestore(&cm_id_priv->lock, flags);
>>>
>>>       spin_lock_irqsave(&cm.lock, flags);
>>> -    rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
>>> +    if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
>>> +        rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
>>> +        RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
>>> +    }
>=20
> This change protects against double free
>=20
>>>       spin_unlock_irqrestore(&cm.lock, flags);
>>
>> Something is very wrong in this function if the id is not in the tree
>> at this point.
>>
>=20
> We agree, but there's an error flow that triggers this behavior.

Sean, I need to close on this patch.  What is your position after
Matan's explanation?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--cGrRvDE1XXoucCuCP2sSC1dKsj1Oq8TWR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJqOdAAoJELgmozMOVy/d7RkP/jc8lpe/0DolXs1s97YBSNMs
U6fLJ0a/kOlNnZ39ObfI1WT8luwW8LklA9b5ZrZBdsCDO5wfRtW40cP0c34F8/RN
u+cN2a5jXVVxWUXwnXI4db+jzwG+l2GRHkirImgYQBylbrsMh9ISHJrt6JUdrpqM
dKyv3x2kIJrPv7wKrc4vNnpP3w1T66EzUNhNJMxr7paWrKM6Mu3/TaCfDHA4igAP
5PBjY3LeaPG9Uj8gRkES6ytViX5jRUlhgDdk/fkt46M+qdA6O2jJe8lI9omidjgs
kEpYnrogee8fSzD+pisSD7wTqDsJgpHQcvjYtAsA0yRUQMMvGGXBTzZ5UKw605zw
NFDkOp1e3cSccPRoq5KWLq/JaXHhKnfPaopl8Uyu/bGERGKukAkydKd4c/9JSVUL
blTB0NcvpvEoe2E/QIS9DxUikcZsw6teciOdhcF2bShjIbTxYrxaS68tnRfltAX1
c0ufANnJYyxYbOtwjZiGZkpMs/1XQ1CtV6bYUYO2nbqTlbZxK0lsAlPwQSMV6CbY
TVPpiCWgRwDfozlul8i16xa8KyTBJ49ISc8nDNm2BjTLtOKZnp85DEXafXP9QGoX
Z7mi6vKd5TnlrmwR1t7eTWZw1DNjFF4gHdFwVxnfPzIaC/YRlHCpqMZ4GCfkMoNK
/5IIC4pBk1FNsBrQl1Rl
=ApuH
-----END PGP SIGNATURE-----

--cGrRvDE1XXoucCuCP2sSC1dKsj1Oq8TWR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
