From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Mon, 10 May 2010 13:01:42 +0300
Message-ID: <201005101301.43113.jackm@dev.mellanox.co.il>
References: <201002281102.21207.jackm@dev.mellanox.co.il> <201005050945.05729.jackm@dev.mellanox.co.il> <adaaasearf5.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaaasearf5.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 06 May 2010 01:56, Roland Dreier wrote:
> =A0> In my original implementation, the low-level driver was responsi=
ble for generating
> =A0> the events for all the processes. =A0To move this mechanism to t=
he core would require
> =A0> a fairly extensive re-write. =A0I would need to introduce ib_cor=
e methods for create,
> =A0> reg, unreg, and destroy, since the uverbs layer operates per use=
r process and does
> =A0> not track across multiple processes. =A0I was concerned that mod=
ifications of this
> =A0> magnitude would introduce instability in XRC, and would require =
a significant QA cycle
>=20
> It seems to me that it should, if anything, be easier to track all th=
ese
> lists at the uverbs layer. =A0We already have a global xrcd structure=
 for
> each xrcd that we could easily stick a list of rcv QPs in (and keep t=
he
> list of rcv QP registrations per rcv QP).=20
>=20
Roland,
While examining your proposed solution, I ran into the following diffic=
ulty.
In order to avoid the reg/unreg verbs in the low-level driver, I need t=
o move
event handling for XRC RCV qp's to the core layer.

Currently, the low-level driver maintains, for each XRC RCV qp a list o=
f user contexts
which are registered to that QP -- and generates an event for each of t=
hose contexts.
(this is so that each of the contexts may unregister, thus allowing the=
 QP to be
destroyed).

To move this to the core requires that I maintain a global list of all =
xrc_rcv QPs,
and per QP, a list of contexts registered to it -- regardless of which =
xrc domain the
xrc rcv QP is attached to (I do not have xrc domain information in the =
XRC RCV qp event).

Thus, I do not see how we can reasonably use the global xrcd structure =
for this purpose.
(I don't see searching all xrc domains for the QP as a reasonable solut=
ion).

I am therefore back at my proposal above to introduce ib_core methods: =
ib_reg_xrc_rcv_qp
and ib_unreg_xrc_rcv_qp (using the reg for create as well, and the unre=
g for destroy as well,
as you suggested in a subsequent mail).  That way, I can track xrc rcv =
QPs, and keep a list
per QP of process files to signal an event to.

I have an initial implementation of this which I will clean up and send=
 you for review (actually, an
implementation which has the ib_create_xrc_rcv_qp/ib_destroy_xrc_rcv_qp=
, and which does
not need the low-level driver implementations of reg/unreg.  I started =
off with this
implementation, and discontinued it when I noticed how different it was=
 from the original
XRC RCV implementation... but saved it just in case).

Comments?
-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
