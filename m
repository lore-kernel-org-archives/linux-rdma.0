From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Add support for enhanced atomic operations
Date: Tue, 2 Feb 2010 10:54:46 -0500
Message-ID: <f0e08f231002020754h482ba0f7xe35a78a72cc165e8@mail.gmail.com>
References: <4B66FA54.6030408@dev.mellanox.co.il>
	 <52BD554704A742B18E3F2F8F2B00B9FE@amr.corp.intel.com>
	 <4B68020D.4080401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B68020D.4080401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 2, 2010 at 5:44 AM, Vladimir Sokolovsky
<vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Sean Hefty wrote:
>>>
>>> This patchset adds support for the following enhanced atomic operat=
ions:
>>> - Masked atomic compare and swap
>>> - Masked atomic fetch and add
>>
>> Can you explain these in more detail? =C2=A0How exactly is a mask us=
ed? =C2=A0Are
>> there
>> any restrictions on the format of the mask? =C2=A0How is the mask ca=
rried over
>> the
>> wire? =C2=A0etc.
>>
>> --
>
> Masked Compare and Swap (MskCmpSwap)
> The MskCmpSwap atomic operation is an extension to the CmpSwap operat=
ion
> defined in the IB
> spec. MskCmpSwap allows the user to select a portion of the 64 bit ta=
rget
> data for the =E2=80=9Ccompare=E2=80=9D
> check as well as to restrict the swap to a (possibly different) porti=
on. The
> pseudo code below
> describes the operation:
>
> -----
> atomic_response =3D *va
> if (((cmp XOR *va) AND cmp_mask) is ZERO) then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0*va =3D (*va AND NOT(swap_mask)) OR (swap =
AND swap_mask)
>
> return atomic_response
> -----
>
> The additional operands are carried in the Extended Transport Header.=
 Atomic
> response generation
> and packet format for MskCmpSwap is as for standard IB Atomic operati=
ons.
>
>
> Masked Fetch and Add (MFetchAdd)
> The MFetchAdd Atomic operation extends the functionality of the stand=
ard IB
> FetchAdd by
> allowing the user to split the target into multiple fields of selecta=
ble
> length. The atomic add is done
> independently on each one of this fields. A bit set in the field_boun=
dary
> parameter specifies the
> field boundaries. The pseudo code below describes the operation:
>
> ------------
> bit_adder(ci, b1, b2, *co)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0value =3D ci + b1 + b2;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (value & 2)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*co =3D 1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*co =3D 0
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return value & 1
> }
>
> mask =3D 1
> carry =3D 0
> atomic_response =3D *va
> #define MASK_IS_SET(mask, attr) =C2=A0 =C2=A0 =C2=A0(((mask)&(attr))!=
=3D0)
>
> for i =3D 0 to 63
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ( i !=3D 0 )
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mask =3D =C2=A0=
mask << 1;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0bit_add_res =3D bit_adder(carry, MASK_IS_S=
ET(atomic_response, mask),
> MASK_IS_SET(add_value, mask), &new_carry)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bit_add_res)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_respons=
e |=3D mask
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0carry =3D ((new_carry) && (!MASK_IS_SET(cm=
p_mask, mask)))
> }
>
> return atomic_response
> ------------
>
> The additional operands are carried in the Extended Transport Header.=
 Atomic
> response generation
> and packet format for MFetchAdd is as for standard IB Atomic operatio=
ns.

Will Mellanox be adding this option to the IB spec rather than keep it
as vendor proprietary ?

-- Hal

>
> Regards,
> Vladimir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
