From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Thu, 26 May 2011 00:46:20 +0300
Message-ID: <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
	<BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
	<BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
	<BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> And 4K MTU should probably be the default, since almost all users
> want 4K MTU vs. caring about VLs.  (Probably 99% of IB users
> never set SL of anything)

I agree that we want that to be the default, I'm not sure the 99%
thing is accurate, with more and more (specifically the huge ones) IB
clusters that are built in some sort of 2D/3D torus, mesh or alike
topologies for which routing engines such as DOR and LASH use multiple
VLs to avoid credit loops. also I assume that some users (maybe < 5%)
would like to enjoy 8 HW traffic classes, so if pressed to the wall,
they would prefer 2k mtu with the current HW.

> I mean is there anyone who really uses >4 VLs? =A0Presumably the
> HW designers didn't think so, because they limited HW to 4 VLs with 4=
K MTU.

I'm not sure if 4 VLs are enough for all the topologies / algorithms I
mentioned above, so I do prefer to leave an option to run with eight
VLs. As for the HW designers comment, its always good to look forward
for improvements in newer HCA drops (the patch for the CX3 series
device IDs is already comitted by
31dd272e8cbb32ef31a411492cc642c363bb54b9, so one can expect for the
actual cards to be coming soon as well).

> At least can we make this a runtime thing? =A0If we're able to set a
> port as IB vs ethernet then # of VLs seems like it should be doable t=
oo.

Here I lost you again, the policy is dictated by the module param,
which whose default value should be turned on, the code that sets the
mtu and VL cap is executed each time the function change by the patch
is called, which in turn happens each time an IB link type is sensed
or dictated for the port.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
