From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH] opensm/qos.c: Revert port ranges for calls to
 sl2vl_update_table().
Date: Mon, 24 May 2010 15:42:01 -0600
Message-ID: <1274737321.4773.68.camel@sale659.sandia.gov>
References: <1851_1274473140_o4LKDZ3n001852_1274473115-3153-1-git-send-email-jaschut@sandia.gov>
 <1274473795.4773.43.camel@sale659.sandia.gov>
 <AANLkTimzCMA8sdpT7W7bpBnb0fqdEhA5I3j-6Vqc7S2L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimzCMA8sdpT7W7bpBnb0fqdEhA5I3j-6Vqc7S2L-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On Mon, 2010-05-24 at 12:03 -0600, Hal Rosenstock wrote:
> Hi Jim,
> 
> On Fri, May 21, 2010 at 4:29 PM, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org> wrote:
> >
> > Sorry, I somehow got this wrong.
> >
> > Corrected patch below.
> >
> > -- Jim
> >
> > On Fri, 2010-05-21 at 14:18 -0600, Jim Schutt wrote:
> >> Before commit 051a1dd5 (opensm/osm_qos.c: split switch external and end
> >> ports setup), osm_qos_setup() would end up calling sl2vl_update_table()
> >> for output ports 1-N, and inport ports 0-N.
> >>
> >> Commit 051a1dd5 changed this around to be output ports 0-N, and input
> >> ports 1-N, and an InfiniScale IV based fabric would log lots of errors
> >> like these:
> >>
> >>   log_rcv_cb_error: ERR 3111: Received MAD with error status = 0x1C
> >>   SubnGetResp(SLtoVLMappingTable), attr_mod 0x2300, TID 0xad069
> >>   Initial path: 0,1,1,4,13 Return path: 0,25,1,7,10
> >>
> >> The attr_mod in every such message has 0x00 in the least significant
> >> byte.
> 
> This is the output port.
> 
> >> With the port ranges restored to their old values, the above log messages
> >> stop.
> 
> Is this with base or enhanced port 0 ? I'm assuming base. See comment below.

See extra patch below.

> 
> Also, what firmware version is in use ?

flint reports the FW version as 7.2.0

> 
> >> Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
> >> ---
> >>  opensm/opensm/osm_qos.c |    8 ++++----
> >>  1 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> >> index 6bbbfa2..b8c3111 100644
> >> --- a/opensm/opensm/osm_qos.c
> >> +++ b/opensm/opensm/osm_qos.c
> >> @@ -230,12 +230,12 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
> >>                                         &qcfg->sl2vl);
> >>       }
> >>
> >> -     for (i = 1; i < num_ports; i++) {
> >> +     for (i = 0; i < num_ports; i++) {
> >>               p = osm_node_get_physp_ptr(node, i);
> >>               force_update = p->need_update || sm->p_subn->need_update;
> >> -             for (j = 0; j < num_ports; j++)
> >> -                     if (sl2vl_update_table(sm, p, i, i << 8 | j,
> >> -                                            force_update, &qcfg->sl2vl))
> >> +             for (j = 1; j < num_ports; j++)
> >> +                     if (sl2vl_update_table(sm, p, i, j, force_update,
> >> +                                            &qcfg->sl2vl))
> >>                               ret = -1;
> >>       }
> >>
> >
> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> > index 6bbbfa2..7d76c75 100644
> > @@ -230,10 +230,10 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
> >                                          &qcfg->sl2vl);
> >        }
> >
> > -       for (i = 1; i < num_ports; i++) {
> > +       for (i = 0; i < num_ports; i++) {
> >                p = osm_node_get_physp_ptr(node, i);
> >                force_update = p->need_update || sm->p_subn->need_update;
> > -               for (j = 0; j < num_ports; j++)
> > +               for (j = 1; j < num_ports; j++)
> >                        if (sl2vl_update_table(sm, p, i, i << 8 | j,
> >                                               force_update, &qcfg->sl2vl))
> >                                ret = -1;
> >
> 
> I think the start for j depends on whether it is base or enhanced port
> 0. Start should be 0 for enhanced and 1 for base.

Ah.  I see now in the IBA 1.2.1 spec, Table 146 PortInfo, p 837, that
only an enhanced SP0 supports OperationalVLs.  So if a base SP0 doesn't
support it, such port also doesn't support VLs, and it makes sense that 
you shouldn't attempt to program SL2VL maps.

Is that what you're thinking?

I added this patch on top of above, and things still work w/ no
error messages.  I guess that means our InfiniSwitch IV gear has
only base SP0.

--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -233,7 +233,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	for (i = 0; i < num_ports; i++) {
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
-		for (j = 1; j < num_ports; j++)
+		j = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
+		for (; j < num_ports; j++)
 			if (sl2vl_update_table(sm, p, i, i << 8 | j,
 					       force_update, &qcfg->sl2vl))
 				ret = -1;

Does that look OK to you?

Thanks -- Jim


> 
> -- Hal
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
