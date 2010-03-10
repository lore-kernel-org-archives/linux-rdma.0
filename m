From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V3 1/2] IB/core: Add support for enhanced atomic operations
Date: Wed, 10 Mar 2010 17:58:13 +0200
Message-ID: <20100310155813.GA25993@vlad-laptop>
Reply-To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

- Add a new IB_WR_MASKED_ATOMIC_CMP_AND_SWP and IB_WR_MASKED_ATOMIC_FET=
CH_AND_ADD send
opcodes that can be used to mark a "masked atomic compare and swap" and
"masked atomic fetch and add" work request correspondingly.
- Add IB_DEVICE_MASKED_ATOMIC capability bit.
- Add mask fields to atomic struct of ib_send_wr
- Add new opcodes to ib_wc_opcode

Masked Compare and Swap (MskCmpSwap)
The MskCmpSwap atomic operation is an extension to the CmpSwap operatio=
n
defined in the IB spec. MskCmpSwap allows the user to select a portion =
of the
64 bit target data for the =E2=80=9Ccompare=E2=80=9D check as well as t=
o restrict the swap to a
(possibly different) portion. The pseudo code below describes the opera=
tion:

| atomic_response =3D *va
| if (!((compare_add ^ *va) & compare_add_mask)) then
|     *va =3D (*va & ~(swap_mask)) | (swap & swap_mask)
|
| return atomic_response

The additional operands are carried in the Extended Transport Header. A=
tomic
response generation and packet format for MskCmpSwap is as for standard=
 IB
Atomic operations.

Masked Fetch and Add (MFetchAdd)
The MFetchAdd Atomic operation extends the functionality of the standar=
d IB
=46etchAdd by allowing the user to split the target into multiple field=
s of
selectable length. The atomic add is done independently on each one of =
this
fields. A bit set in the field_boundary parameter specifies the field
boundaries. The pseudo code below describes the operation:

| bit_adder(ci, b1, b2, *co)
| {
|	value =3D ci + b1 + b2
|	*co =3D !!(value & 2)
|
|	return value & 1
| }
|
| #define MASK_IS_SET(mask, attr)      (!!((mask)&(attr)))
| bit_position =3D 1
| carry =3D 0
| atomic_response =3D 0
|
| for i =3D 0 to 63
| {
|         if ( i !=3D 0 )
|                 bit_position =3D  bit_position << 1
|
|         bit_add_res =3D bit_adder(carry, MASK_IS_SET(*va, bit_positio=
n), MASK_IS_SET(compare_add, bit_position), &new_carry)
|         if (bit_add_res)
|                 atomic_response |=3D bit_position
|
|         carry =3D ((new_carry) && (!MASK_IS_SET(compare_add_mask, bit=
_position)))
| }
|
| return atomic_response

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/rdma/ib_verbs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..53b16a6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -105,6 +105,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_UD_TSO		=3D (1<<19),
 	IB_DEVICE_MEM_MGT_EXTENSIONS	=3D (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK =3D (1<<22),
+	IB_DEVICE_MASKED_ATOMIC		=3D (1<<23),
 };
=20
 enum ib_atomic_cap {
@@ -467,6 +468,8 @@ enum ib_wc_opcode {
 	IB_WC_LSO,
 	IB_WC_LOCAL_INV,
 	IB_WC_FAST_REG_MR,
+	IB_WC_MASKED_COMP_SWAP,
+	IB_WC_MASKED_FETCH_ADD,
 /*
  * Set value of IB_WC_RECV so consumers can test if a completion is a
  * receive by testing (opcode & IB_WC_RECV).
@@ -689,6 +692,8 @@ enum ib_wr_opcode {
 	IB_WR_RDMA_READ_WITH_INV,
 	IB_WR_LOCAL_INV,
 	IB_WR_FAST_REG_MR,
+	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
+	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 };
=20
 enum ib_send_flags {
@@ -731,6 +736,8 @@ struct ib_send_wr {
 			u64	remote_addr;
 			u64	compare_add;
 			u64	swap;
+			u64	compare_add_mask;
+			u64	swap_mask;
 			u32	rkey;
 		} atomic;
 		struct {
--=20
1.6.6.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
