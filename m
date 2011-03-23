From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [opensm] routing segfault + LMC > 0 routing bug?
Date: Wed, 23 Mar 2011 09:25:17 -0400
Message-ID: <AANLkTik_3NMXbzn3DYomgveaq6PX8AJCFosOq2MKQY=0@mail.gmail.com>
References: <1300843412.3128.135.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300843412.3128.135.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 22, 2011 at 9:23 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> Hey Jim, Alex,
>
> Just hit a segfault on the main tree. =C2=A0It appears patch
>
> commit 9ddcf3419eade13bdc0a54f93930c49fe67efd63
> Author: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
> Date: =C2=A0 Fri Sep 3 10:43:12 2010 -0600
>
> opensm: Avoid havoc in minhop caused by torus-2QoS persistent use of
> osm_port_t:priv.
>
> segfaults opensm on one of our systems w/ updn routing and lmc > 0
> (would likely segfault dor, minhop, and maybe others too). =C2=A0Our =
system
> has older switches that do not support enhanced port zero, thus do no=
t
> support LMC > 0. =C2=A0(I imagine setting lmc_esp0 to FALSE, results =
in the
> same behavior.) =C2=A0Subsequently even if you set LMC > 0 in your op=
ensm
> config file, there can be ports with LMC =3D 0 and LMC !=3D 0 (e.g. f=
rom
> HCAs). Subsequently in alloc_ports_priv(), some ports will have priv =
set
> to NULL and some will not. =C2=A0Because of assumptions in osm_switch=
=2Ec about
> priv !=3D NULL when lmc > 0, we hit a segfault. =C2=A0The issue didn'=
t exist
> before b/c we allocated p_port->priv non-NULL no matter what.
>
> The attached patch fixes the problem w/ updn. =C2=A0I haven't looked =
through
> all of the 2Qos code thoroughly to figure out the consequences of thi=
s
> change, so I'm just considering this a starting point for discussion.
>
> In addition, with the possibility that SP0 ports will be LMC =3D 0, t=
his
> code in osm_ucast_mgr.c ucast_mgr_process_tbl() does not look good.
>
> lids_per_port =3D 1 << p_mgr->p_subn->opt.lmc;
> for (i =3D 0; i < lids_per_port; i++) {
> =C2=A0 =C2=A0 cl_qlist_t *list =3D &p_mgr->port_order_list;
> =C2=A0 =C2=A0 cl_list_item_t *item;
> =C2=A0 =C2=A0 for (item =3D cl_qlist_head(list); item !=3D cl_qlist_e=
nd(list);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0item =3D cl_qlist_next(item)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_port_t *port =3D cl_item_obj(it=
em, port, list_item);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ucast_mgr_process_port(p_mgr, p_sw,=
 port, i);
> =C2=A0 =C2=A0 }
> }
>
> It iterates over all ports with the configured LMC, not the LMC of th=
e
> port?

Yes, base SP0 is always LMC 0 and either LMC of port or perhaps 0 when
base SP0 and configured LMC otherwise (assuming it's an endport) could
be used for such loops. There used to be cases that used the latter
approach. I'm not sure which is more appropriate now.

-- Hal

> I haven't thought about this too deeply or investigated deeply,
> so consider this another starting point for discussion.
>
> Al
>
> --
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
