From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH] ibsim/sim_cmd.c: Only relink port if
	remote port is currently linked
Date: Tue, 29 Sep 2009 18:05:12 -0400
Message-ID: <f0e08f230909291505g42596320of278b7f994814f8@mail.gmail.com>
References: <20090924193444.GA15377@comcast.net> <20090929215338.GA17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090929215338.GA17846@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Tue, Sep 29, 2009 at 5:53 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Hal,
>
> On 15:34 Thu 24 Sep =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> When multiple switches are unlinked and then a switch is relinked,
>> it should behave like a cable pull or power down of switch so it
>> depends on the state of the remote peer port (as to linked or not).
>> This is not represented in the IB port/port physical state and is
>> additional state.
>
> I'm not sure that I understand what this patch tries to achieve - I
> cannot see any changes related to port physical state handling. I can
> only see that you try to prevent linking with previously unlinked por=
ts,
> and it is not clear for me why. Could you explain?

The failure scenario is to unlink 2 connected switches and then relink
the first one. It then relinks the second one even though it still
should be unlinked.

>
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>
>> diff --git a/ibsim/sim.h b/ibsim/sim.h
>> index bf85875..52eb73b 100644
>> --- a/ibsim/sim.h
>> +++ b/ibsim/sim.h
>> @@ -210,6 +211,7 @@ struct Port {
>> =C2=A0 =C2=A0 =C2=A0 int remoteport;
>> =C2=A0 =C2=A0 =C2=A0 Node *previous_remotenode;
>> =C2=A0 =C2=A0 =C2=A0 int previous_remoteport;
>> + =C2=A0 =C2=A0 int unlinked;
>
> Do you really need this flag? Existence of non NULL previous_remoteno=
de
> pointer should be good indication.

That's how I started (using previous_remotenode) but it didn't work
correctly for all cases. It worked with the simple case above (unlink
2 switches and relink the first). It didn't work with a 3 switch case.

-- Hal

>> =C2=A0 =C2=A0 =C2=A0 int errrate;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t errattr;
>> =C2=A0 =C2=A0 =C2=A0 Node *node;
>> diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
>> index cb6e639..d27ab0f 100644
>> --- a/ibsim/sim_cmd.c
>> +++ b/ibsim/sim_cmd.c
>> @@ -1,5 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This file is part of ibsim.
>> =C2=A0 *
>> @@ -146,12 +147,18 @@ static int do_link(FILE * f, char *line)
>>
>> =C2=A0 =C2=A0 =C2=A0 rport =3D node_get_port(rnode, rportnum);
>>
>> + =C2=A0 =C2=A0 if (rport->unlinked) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->unlinked =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
>> + =C2=A0 =C2=A0 }
>> +
>
> Why?
>
>> =C2=A0 =C2=A0 =C2=A0 if (link_ports(lport, rport) < 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -fprintf(f,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# can't link: local/remote port ar=
e already connected\n");
>>
>> =C2=A0 =C2=A0 =C2=A0 lport->previous_remotenode =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 rport->previous_remotenode =3D NULL;
>> + =C2=A0 =C2=A0 lport->unlinked =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>> @@ -194,7 +201,7 @@ static int do_relink(FILE * f, char *line)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 numports++; =C2=A0 =
=C2=A0 // To make the for-loop below run up to last port
>> =C2=A0 =C2=A0 =C2=A0 else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lportnum--;
>> -
>> +
>> =C2=A0 =C2=A0 =C2=A0 if (lportnum >=3D 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport =3D ports + l=
node->portsbase + lportnum;
>>
>> @@ -206,12 +213,18 @@ static int do_relink(FILE * f, char *line)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rport =3D node_get_=
port(lport->previous_remotenode,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->previou=
s_remoteport);
>>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rport->unlinked) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 lport->unlinked =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> +
>
> Why?
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (link_ports(lpor=
t, rport) < 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -fprintf(f,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# can'=
t link: local/remote port are already connected\n");
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->previous_rem=
otenode =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rport->previous_rem=
otenode =3D NULL;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->unlinked =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
>> =C2=A0 =C2=A0 =C2=A0 }
>> @@ -224,11 +237,17 @@ static int do_relink(FILE * f, char *line)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rport =3D node_get_=
port(lport->previous_remotenode,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->previou=
s_remoteport);
>>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rport->unlinked) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 lport->unlinked =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> +
>
> Ditto.
>
> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (link_ports(lpor=
t, rport) < 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->previous_rem=
otenode =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rport->previous_rem=
otenode =3D NULL;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->unlinked =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 relinked++;
>> =C2=A0 =C2=A0 =C2=A0 }
>> @@ -246,6 +265,7 @@ static void unlink_port(Node * lnode, Port * lpo=
rt, Node * rnode, int rportnum)
>> =C2=A0 =C2=A0 =C2=A0 lport->previous_remoteport =3D lport->remotepor=
t;
>> =C2=A0 =C2=A0 =C2=A0 rport->previous_remotenode =3D rport->remotenod=
e;
>> =C2=A0 =C2=A0 =C2=A0 rport->previous_remoteport =3D rport->remotepor=
t;
>> + =C2=A0 =C2=A0 lport->unlinked =3D 1;
>>
>> =C2=A0 =C2=A0 =C2=A0 lport->remotenode =3D rport->remotenode =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 lport->remoteport =3D rport->remoteport =3D 0;
>> @@ -406,6 +426,7 @@ static int do_unlink(FILE * f, char *line, int c=
lear)
>> =C2=A0 =C2=A0 =C2=A0 if (portnum >=3D 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port =3D ports + no=
de->portsbase + portnum;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!clear && !port=
->remotenode) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 port->unlinked =3D 1;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(f, "# port %d at nodeid \"%s\" is not linked\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 portnum, nodeid);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -1;
>> @@ -420,8 +441,10 @@ static int do_unlink(FILE * f, char *line, int =
clear)
>>
>> =C2=A0 =C2=A0 =C2=A0 for (port =3D ports + node->portsbase, e =3D po=
rt + numports; port < e;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port++) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!clear && !port->rem=
otenode)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!clear && !port->rem=
otenode) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 port->unlinked =3D 1;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (port->remotenod=
e)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 unlink_port(node, port, port->remotenode,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->remoteport);
>> diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
>> index 8a5d281..0092068 100644
>> --- a/ibsim/sim_net.c
>> +++ b/ibsim/sim_net.c
>> @@ -492,6 +492,7 @@ static void init_ports(Node * node, int type, in=
t maxports)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->linkwidth =3D=
 LINKWIDTH_4x;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->linkspeedena =
=3D netspeed;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->linkspeed =3D=
 LINKSPEED_SDR;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->unlinked =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size =3D (type =3D=3D=
 SWITCH_NODE && i) ? sw_pkey_size : ca_pkey_size;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (size) {
> _______________________________________________
> general mailing list
> general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
>
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openi=
b-general
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
