From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by unicast routing
 tables (LFTs)
Date: Tue, 13 Oct 2009 17:44:27 +0200
Message-ID: <20091013154427.GP13830@me>
References: <20091004160541.GA28310@comcast.net>
 <20091012154629.GD31778@me>
 <f0e08f230910130559y2eb965cfm7a2e26b05ad63c12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910130559y2eb965cfm7a2e26b05ad63c12-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:59 Tue 13 Oct     , Hal Rosenstock wrote:
> >> @@ -405,7 +406,7 @@ uint8_t osm_switch_get_port_least_hops(IN cons=
t osm_switch_t * p_sw,
> >> =A0static inline uint8_t osm_switch_get_port_by_lid(IN const osm_s=
witch_t * p_sw,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0IN uint16_t lid_ho)
> >> =A0{
> >> - =A0 =A0 if (lid_ho =3D=3D 0 || lid_ho > IB_LID_UCAST_END_HO)
> >> + =A0 =A0 if (lid_ho =3D=3D 0 || lid_ho >=3D p_sw->lft_size)
> >
> > Similar story? Shouldn't this be checked against p_sw->max_lid_ho?
>=20
> Yes and this change could be considered independent as I think is a
> minor optimization even with the LFT heap changes.

It is not just optimization, but rather a bug fix - it should prevent
potential junk returned by this function. And yes, it exists even
without LFT reallocation stuff.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
