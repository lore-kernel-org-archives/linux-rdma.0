From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 12:53:26 -0500
Message-ID: <f0e08f230912150953n426c85b7uf8ea1152049738e6@mail.gmail.com>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	 <f0e08f230912150716y392cf1f1t4cd640b6663f7fea@mail.gmail.com>
	 <20091215090942.b33ddc1e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215090942.b33ddc1e.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 15, 2009 at 12:09 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Tue, 15 Dec 2009 10:16:42 -0500
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Ira,
>>
>> On Mon, Dec 14, 2009 at 7:43 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>> > Sasha, Hal,
>> >
>> > I have found that the following patch caused our SRP connected sto=
rage to
>> > break.
>>
>> What is causing the SRP target to fail ? Is it a non zero hop limit
>> returned in the SA PathRecord ?
>
> I am not sure exactly because I don't know what the SRP Target is see=
ing.
> (pesky firmware...) =C2=A0:-(
>
>>
>> > patch: 3d20f82edd3246879063b77721d0bcef927bdc48
>> >
>> > =C2=A0 =C2=A0opensm/osm_sa_path_record.c: separate router guid res=
olution code
>> >
>> > =C2=A0 =C2=A0Move off subnet destination (router address) resoluti=
on code to separate
>> > =C2=A0 =C2=A0function to improve readability.
>> >
>> > =C2=A0 =C2=A0Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> >
>> > I further traced the problem to pr_rcv_build_pr and the patch belo=
w fixes the
>> > bug.
>>
>> On quick glance, I'm missing the connection between Sasha's patch an=
d
>> this routine setting something bad in the hop limit of the returned
>> path record.
>
> It sets p_dgid even when we are not using a router which results in
> is_nonzero_gid being true.

Yes, that's the cause of the issue.

>>
>> > 16:03:34 > git diff
>> > diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/os=
m_sa_path_record.c
>> > index be0cd71..32c889f 100644
>> > --- a/opensm/opensm/osm_sa_path_record.c
>> > +++ b/opensm/opensm/osm_sa_path_record.c
>> > @@ -800,7 +800,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, =
IN const osm_port_t * p_src_port,
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Only set HopLimit if going through a=
 router */
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_nonzero_gid)
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_pr->hop_flow_=
raw |=3D cl_hton32(IB_HOPLIMIT_MAX);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_pr->hop_flow_=
raw |=3D IB_HOPLIMIT_MAX;
>>
>> This may fix this issue but it doesn't look right to me and I think
>> would break router scenarios and corrupts other field(s). Path recor=
d
>> fields are in network (not host) order.
>
> But HopLimit is an 8bit field?

Yes but in terms of the ib_path_rec_t definition hop_flow_raw is a 32 b=
it field.

> I might be wrong on this but I was thinking
> this set RawTraffic and parts of Flow label to 1's. =C2=A0I should do=
uble check
> that. =C2=A0Also, I wonder if the FW on the other side is flipping th=
is wrong? =C2=A0:-/
> I have not been able to determine this and I still have to test with =
our other
> vendor's SRP target...
>
>>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pr->pkey =3D p_parms->pkey;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_path_rec_set_sl(p_pr, p_parms->sl);
>> >
>> >
>> > "hop_flow_raw" is not really a 32bit value but rather 4 fields:
>> > Component =C2=A0 =C2=A0 Length(bits) =C2=A0 Offset(bits)
>> > RawTraffic =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0352
>> > Reserved =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0353
>> > FlowLabel =C2=A0 =C2=A0 20 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 356
>> > HopLimit =C2=A0 =C2=A0 =C2=A08 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0384
>> >
>> >
>> > However, I don't understand the comment "Only set HopLimit if goin=
g through a
>> > router"?
>>
>> Well, in a sense the HopLimit is always set. It's already set to 0
>> right above that code snippet in the patch where:
>> p_pr->hop_flow_raw &=3D cl_hton32(1 << 31);
>
> True, however, I believe the behavior before was that the entire fiel=
d is 0
> so the above statement really does nothing.

=46or all practical purposes that is true as raw traffic is deprecated.

>> This code is only setting the HopLimit to 255 (as this is very
>> primitive so far) when going through a router. Maybe it could be
>> stated better.
>
> That is exactly what Sasha's patch changes. =C2=A0This is not only ex=
ecuted when
> going through a router but at all times DGID is specified in the Comp=
Mask. =C2=A0I
> am willing to accept the fact that perhaps p_dgid should not be set u=
nless we
> find a router, however, I __don't__ think that is correct. =C2=A0Sear=
ching the spec
> I attempted to find where HopLimit was supposed to be 0xFF only when =
going
> through a router and I could not find it; therefore my email, I'm con=
fused
> again... =C2=A0:-(

When going through a router, it needs to be set to something other
than 0 or 1. 255 (max) was used as there's nothing currently to scope
it down to something more realistic. See IBA 1.2.1 vol 1 p.229 8.3.6
for one on settings for this field.

>>
>> > Was the intent to only set p_dgid in pr_rcv_get_end_points if we a=
re heading
>> > through a router? I don't think it matters if we are going through=
 a router
>> > or not does it?
>>
>> It's used when DGID is selected in the SA PR query via the comp mask
>> and in that instance is used for both the router and non router DGID
>> cases.
>
> So we agree that Sasha's patch is correct?

Yes; it restores this back the way it used to be when it worked.

-- Hal

>>
>> > If not, I think the comment needs to be removed in the patch above=
=2E
>>
>> I'm not following why you say this.
>
> Well, if HopLimit must only be set to 0xff when going through a route=
r and
> Sasha's patch is correct, then I think we need another way to determi=
ne if
> this path is going through a router. =C2=A0In that case the comment i=
s correct but
> the logic is wrong.
>
> Ira
>
>>
>> -- Hal
>>
>> > Thanks,
>> > Ira
>> >
>> > --
>> > Ira Weiny
>> > Math Programmer/Computer Scientist
>> > Lawrence Livermore National Lab
>> > 925-423-8008
>> > weiny2-i2BcT+NCU+M@public.gmane.org
>> >
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
