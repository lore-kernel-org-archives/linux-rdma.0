From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 16:51:13 +0000
Message-ID: <VI1PR0502MB30081B8E7D917C3F86D9DD80D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170612064918.12510-1-leon@kernel.org>
         <1497281280.2770.1.camel@wdc.com>
         <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1497284956.2770.8.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497284956.2770.8.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]
> Sent: Monday, June 12, 2017 11:29 AM
> To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; Parav Pandit
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Mon, 2017-06-12 at 16:19 +0000, Parav Pandit wrote:
> > Hi Bart,
> >
> > > -----Original Message-----
> > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> > > Sent: Monday, June 12, 2017 10:28 AM
> > > To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Subject: Re: [PATCH rdma-next 0/3] Support out of order data
> > > placement
> > >
> > > On Mon, 2017-06-12 at 09:49 +0300, Leon Romanovsky wrote:
> > > > Out of order data placement capability indicates that if HCA
> > > > receives out of order RDMA packets, their data placement can be
> > > > done at the desired memory destination given in the packet(s).
> > > > This is applicable to RDMA read and write operations.
> > >
> > > Hello Leon and Parav,
> > >
> > > Since PCIe writes can be executed out of order, shouldn't that be
> > > mentioned in Documentation/infiniband/out_of_order.txt? See also the
> > > documentation of the=A0Device Control Register and the Enable Relaxed
> > > Ordering bit in the PCIe spec.
> >
> > There is no change in the way PCIe writes are done with respect to
> > this per QP bit. Meaning, if this bit is cleared, PCIe subsystem can
> > still do out of order writes depending on relaxed ordering flag.
>=20
> Hello Parav,
>=20
> That's why I asked to mention PCIe write reordering in out_of_order.txt.
> Someone who is reading that document could be mislead to assume that if
> the HCA does not reorder writes that no reordering will occur.
Make sense. I will update the documentation to describe that PCIe out-of-or=
der writes can still happen.

>=20
> > > Additionally, since not handling out-of-order RDMA writes correctly
> > > is an ULP bug and since there are more ULPs that handle out-of-order
> > > writes correctly than ULPs that don't handle out-of-order writes
> > > correctly, if a new flag is introduced, shouldn't that be a flag to d=
isable
> out-of-order writes?
> >
> > Not sure I understood correctly. This bit is not a bug fix for ULPs
> > who don't handle out-of-order writes. As I described in Documentation,
> > "Out of order data placement capability indicates that if HCA receives
> > out of order RDMA packets, their data placement can be done at the
> > desired memory destination given in the packet(s). This is applicable
> > to RDMA read and write operations." This flag indicates that - in above
> condition, HCA can do data placement out-of-order.
> > Without enabling this flag, when HCA receives out of order packets, it
> > would drop them due to PSN sequence error.
> >
> > So, - to your question - shouldn't that be a flag to disable out-of-ord=
er
> writes?
> > By default, its disabled at RDMA level.
>=20
> I don't think that your last two paragraphs mention anything that had not
> yet been mentioned in the four e-mails constituting your patch series.
I elaborated two points in email in last two paragraphs to answer your ques=
tion.
(a) Without enabling this out-of-order flag, when HCA receives out of order=
 packets, it would drop them due to PSN sequence error.
(b) by default out-of-order is disabled at RDMA level.

> Additionally, I think my question was clear and unambiguous. So please
> reread my question.

I reread your question. Let me try to answer again.
> shouldn't that be a flag to disable out-of-order writes?
No. There is no need for such flag in context of this patchset because by d=
efault out-of-order writes are disabled at RDMA level.

>=20
> Thanks,
>=20
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
