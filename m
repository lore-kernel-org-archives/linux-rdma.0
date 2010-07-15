From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Thu, 15 Jul 2010 14:14:16 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443ABB321050@MTLMAIL.mtl.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
	<20100711043449.GA31404@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
	<adatyo4xuqx.fsf@roland-alpha.cisco.com>
	<20100713193828.GB12614@obsidianresearch.com>
	<ada8w5fxenn.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada8w5fxenn.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > A quibble about multicast - AFAIK this is unsolved. I=20
> think some spec  > needs to be agreed that documents what=20
> sort of multicast snooping  > operations switches need to do,=20
> ie if IGMP joins imply that IBoE  > traffic for the same DMAC=20
> is included in the join, or if IBoE requires  > a seperate=20
> IGMP type process on its own ether-type. That would make it =20
> > much clearer what to do with MGIDs.
>

It would be quite na=EFve to require *new* snooping functionality in Et=
h switches. Some switches will gracefully apply to non-ip traffic the f=
iltering information acquired through IGMP snooping. And some will just=
 flood non-ip MC frames within the corresponding VLAN which is benign (=
e.g. that is the way FIP works). A cleaner solution would be based on M=
MRP but that, AFAIK, is not very widely deployed so it is less practica=
l at this stage.=20
=20
> I agree -- the current spec is rather broken for multicast. =20
> Choosing a different ethertype and then saying that all=20
> switches will just flood multicast traffic is half-baked at best.
>

It is a realistic approach. Do you claim that there are switches that w=
ill not forward the packets?
=20
>  > It would be nice to at least have a plan on how to=20
> integrate a  > non-link local address, if that is ever=20
> necessary in future. An  > extended AH with an additional 48=20
> DMAC field seems reasonable to me?
>=20
> You mean have a next-hop destination + a final destination? =20
> Could be done I guess.  But I'm not sure how having a routing=20
> table where you have to look up 48-bit Ethernet addresses is=20
> all that different from just having a standard Ethernet=20
> forwarding table.

I guess Jason suggests regarding the GID as a true L3 address and using=
 a new added L2 field for the next hop L2 address.

>=20
> I suppose something based on MAC-in-MAC (a la 802.1ah) could=20
> be done but to be honest the IBoE spec that the IBTA came up=20
> with looks rather broken for routing.

Routing is out of the scope of the current RoCE spec.
And I do not see how .1ah would be relevant for this purpose.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
