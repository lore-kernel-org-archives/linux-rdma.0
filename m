From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Multicast group pre-creation for TopSpin old stack
Date: Mon, 6 Sep 2010 19:55:15 -0400
Message-ID: <AANLkTinG2XEhJkYYf-kZGYx7h8wJnBcywMa4AS-KaVh4@mail.gmail.com>
References: <4C835DDF.6000809@dev.mellanox.co.il>
	<20100906164327.GD11502@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100906164327.GD11502@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 6, 2010 at 12:43 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Yevgeny,
>
> On 12:07 Sun 05 Sep =C2=A0 =C2=A0 , Yevgeny Kliteynik wrote:
>>
>> There's a hack in the SM to deal with TopSpin's non-compliant
>> join compmask for IPoIB v4 multicast group ff12:401b:<pkey>::1
>> The group is pre-defined and maintained as a well-known multicast
>> group.
>>
>> opensm/osm_prtn.c:
>>
>> =C2=A0 =C2=A0232 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* workaround for=
 TS */
>> =C2=A0 =C2=A0233 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* FIXME: remove =
this upon TS fixes */
>> =C2=A0 =C2=A0234 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mc_rec.mgid =3D o=
sm_ts_ipoib_mgid;
>> =C2=A0 =C2=A0235 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(&mc_rec.mg=
id.raw[4], &pkey, sizeof(pkey));
>> =C2=A0 =C2=A0236 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Scope in MCMem=
berRecord (if present) needs to be consistent with MGID */
>> =C2=A0 =C2=A0237 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mc_rec.scope_stat=
e =3D ib_member_set_scope_state(scope, IB_MC_REC_STATE_FULL_MEMBER);
>> =C2=A0 =C2=A0238 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_mgid_set_scope=
(&mc_rec.mgid, scope);
>> =C2=A0 =C2=A0239
>> =C2=A0 =C2=A0240 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D osm_mc=
mr_rcv_find_or_create_new_mgrp(p_sa, comp_mask, &mc_rec,
>> =C2=A0 =C2=A0241 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&=
p_mgrp);
>> =C2=A0 =C2=A0242 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p_mgrp) {
>> =C2=A0 =C2=A0243 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0p_mgrp->well_known =3D TRUE;
>> =C2=A0 =C2=A0244 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (!p->mgrp)
>> =C2=A0 =C2=A0245 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p->mgrp =3D p_mgrp;
>> =C2=A0 =C2=A0246 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> As far as I can tell, this was added before git history.
>> Any idea if it's still needed?
>
> I don't know, just remember that we have asked about this during
> partition manager development (somewhere in 2006), and have got an
> answer like "it is probably needed".
>
> Personally I've never seen this used. Maybe Hal may remember more.

It's been carried forward just in case anyone was still running the
old TS stack. It's always hard to determine the negative (when no one
is using it any longer) (with the latest OpenSM) but it may be high
time to deprecate this. Is anyone still using the old TS stack ? If
so, is it used with OpenSM ?

Maybe Roland has insight into whether the old TS stack might be being
used with (the latest) OpenSM.

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
