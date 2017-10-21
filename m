From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 03/16] IB/core: Introduce counter set describe
 verb
Date: Sat, 21 Oct 2017 00:29:21 +0000
Message-ID: <AM6PR0502MB37838B19976EDF1D04C74751BD400@AM6PR0502MB3783.eurprd05.prod.outlook.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <1508424118-27205-4-git-send-email-yishaih@mellanox.com>
 <alpine.DEB.2.20.1710200541250.10736@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1710200541250.10736@nuc-kabylake>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On Thu, 19 Oct 2017, Yishai Hadas wrote:
>=20
> > +#define IB_COUNTER_NAME_LEN 64
> > +struct ib_counter_set_describe_attr {
> > +	/* Type that this set refers to, use enum ib_counter_set_type */
> > +	u8 counted_type;
>=20
> Gap here of 7 bytes. Maybe move the field to get a more compact structure=
?
>=20
> > +	/* Number of instances of this counter-set available in the hardware
> */
> > +	u64 num_of_cs;
>=20
> u16 or u32 should be enough right?

Future API might be added to create user-customizable  sets.
How many potential subsets are for a set of 32 counters? More than 2^64.
We might want to be able to support it.

>=20
> > +	/* Attributes of the set, use enum ib_counter_set_attributes */
> > +	u32 attributes;
> > +	/* Number of counters in this set */
> > +	u8 entries_count;
>=20
> A counter set is limited to 255? Could there be counter sets that have a
> thousand or so?

A counter set is merely a set. I can't see a reason why would a user want t=
o query a set=20
which contains more than 256 counters. All at the same time.
However, I agree that we could modify it to u16 or u32.

[Guy Shattah]=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
