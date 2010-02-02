From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 0/2] Add support for enhanced atomic operations
Date: Tue, 02 Feb 2010 12:44:29 +0200
Message-ID: <4B68020D.4080401@dev.mellanox.co.il>
References: <4B66FA54.6030408@dev.mellanox.co.il> <52BD554704A742B18E3F2F8F2B00B9FE@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52BD554704A742B18E3F2F8F2B00B9FE-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> This patchset adds support for the following enhanced atomic operati=
ons:
>> - Masked atomic compare and swap
>> - Masked atomic fetch and add
>=20
> Can you explain these in more detail?  How exactly is a mask used?  A=
re there
> any restrictions on the format of the mask?  How is the mask carried =
over the
> wire?  etc.
>=20
> --

Masked Compare and Swap (MskCmpSwap)
The MskCmpSwap atomic operation is an extension to the CmpSwap operatio=
n defined in the IB
spec. MskCmpSwap allows the user to select a portion of the 64 bit targ=
et data for the =93compare=94
check as well as to restrict the swap to a (possibly different) portion=
=2E The pseudo code below
describes the operation:

-----
atomic_response =3D *va
if (((cmp XOR *va) AND cmp_mask) is ZERO) then
	*va =3D (*va AND NOT(swap_mask)) OR (swap AND swap_mask)

return atomic_response
-----

The additional operands are carried in the Extended Transport Header. A=
tomic response generation
and packet format for MskCmpSwap is as for standard IB Atomic operation=
s.


Masked Fetch and Add (MFetchAdd)
The MFetchAdd Atomic operation extends the functionality of the standar=
d IB FetchAdd by
allowing the user to split the target into multiple fields of selectabl=
e length. The atomic add is done
independently on each one of this fields. A bit set in the field_bounda=
ry parameter specifies the
field boundaries. The pseudo code below describes the operation:

------------
bit_adder(ci, b1, b2, *co)
{
         value =3D ci + b1 + b2;

         if (value & 2)
                 *co =3D 1
         else
                 *co =3D 0

         return value & 1
}

mask =3D 1
carry =3D 0
atomic_response =3D *va
#define MASK_IS_SET(mask, attr)      (((mask)&(attr))!=3D0)

for i =3D 0 to 63
{
         if ( i !=3D 0 )
                 mask =3D  mask << 1;

         bit_add_res =3D bit_adder(carry, MASK_IS_SET(atomic_response, =
mask), MASK_IS_SET(add_value, mask), &new_carry)
         if (bit_add_res)
                 atomic_response |=3D mask

         carry =3D ((new_carry) && (!MASK_IS_SET(cmp_mask, mask)))
}

return atomic_response
------------

The additional operands are carried in the Extended Transport Header. A=
tomic response generation
and packet format for MFetchAdd is as for standard IB Atomic operations=
=2E

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
