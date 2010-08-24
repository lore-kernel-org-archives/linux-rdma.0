From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Tue, 24 Aug 2010 09:45:05 -0400
Message-ID: <AANLkTime9OX4EPS_c+pKwnchuVfyLqeLcuX0rXDjOCgR@mail.gmail.com>
References: <4C6B9A42.9020505@voltaire.com>
	<20100824040354.GH5837@me>
	<4C73B34A.4080508@voltaire.com>
	<AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN@mail.gmail.com>
	<4C73C8BC.6010702@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C73C8BC.6010702-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 24, 2010 at 9:27 AM, Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org> wro=
te:
> On 08/24/2010 04:10 PM, Hal Rosenstock wrote:
>> On Tue, Aug 24, 2010 at 7:55 AM, Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
>>> On 08/24/2010 07:03 AM, Sasha Khapyorsky wrote:
>>>> On 11:30 Wed 18 Aug =C2=A0 =C2=A0 , Doron Shoham wrote:
>>>>> add '-f' flag to show full information (ports' speed and witdh).
>>>>> mainly to work with ibsim (using links real speed and width).
>>>>
>>>> Seems almost fine. However see the comments below.
>>>>
>>>>>
>>>>> Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>>> ---
>>>>> =C2=A0infiniband-diags/src/ibnetdiscover.c | =C2=A0 10 +++++++++-
>>>>> =C2=A01 files changed, 9 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-di=
ags/src/ibnetdiscover.c
>>>>> index f20058c..0a020a2 100644
>>>>> --- a/infiniband-diags/src/ibnetdiscover.c
>>>>> +++ b/infiniband-diags/src/ibnetdiscover.c
>>>>> @@ -77,6 +77,7 @@ static char *diff_cache_file =3D NULL;
>>>>> =C2=A0static unsigned diffcheck_flags =3D DIFF_FLAG_DEFAULT;
>>>>>
>>>>> =C2=A0static int report_max_hops =3D 0;
>>>>> +static int full_info =3D 0;
>>>>>
>>>>> =C2=A0/**
>>>>> =C2=A0 * Define our own conversion functions to maintain compatib=
ility with the old
>>>>> @@ -357,6 +358,8 @@ void out_switch_port(ibnd_port_t * port, int =
group, char *out_prefix)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_port_str ? ex=
t_port_str : "");
>>>>> =C2=A0 =C2=A0 =C2=A0if (port->remoteport->node->type !=3D IB_NODE=
_SWITCH)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(f, "(%" P=
RIx64 ") ", port->remoteport->guid);
>>>>> + =C2=A0 =C2=A0if (full_info)
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0fprintf(f, " s=3D%d w=3D%d", ispeed, iwidth);
>>>>
>>>> I think that in order to not potentially break any ibnetdiscover o=
utput
>>>> parsers it would be better to put such "f" output after a comment =
line.
>>>> Would it work with ibsim in a same way?
>>>
>>> ibsim should still work if the output is after the comment.
>>> I still think that it can potentially break ibnetdiscover output pa=
rsers (that why I used '-f' flag).
>>> Do you want it with '-f' flag and after the comment?
>>> for example:
>>> [1](2c903000020a9) =C2=A0 =C2=A0 =C2=A0"S-0008f10500650272"[19] =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# =C2=A0s=3D2 w=3D2=
 lid 6 lmc 0 "Voltaire sLB-4018 =C2=A0 =C2=A0Line 10 =C2=A0Chip 1 4700 =
#4700-B778" lid 3 4xDDR
>>>
>>
>> Personally, I'd prefer it at the end of the line after 4xDDR and use
>> speed/width rather than s=3D/w=3D:
>>
>> [1](2c903000020a9) =C2=A0 =C2=A0 =C2=A0"S-0008f10500650272"[19] =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# =C2=A0lid
>> 6 lmc 0 "Voltaire sLB-4018 =C2=A0 =C2=A0Line 10 =C2=A0Chip 1 4700 #4=
700-B778" lid 3
>> 4xDDR speed 2 width 2
>>
>> I think that looks better and is more readable. Just my $0.02...
>>
>> -- Hal
>
> The problem is the ibsim is expecting s=3D/w=3D and not speed <number=
> or width <number>.

Oh, I forgot about that; ugh...

> What about the flag? do we still need it if we pass the output after =
the comment?

I wouldn't think so. I also think we've made commentary changes to the
ibnetdiscover output format like this before. If we wanted to be
absolutely sure it wouldn't break anything, we'd keep the flag though.
It's up to Sasha.

-- Hal

>
> Doron
>>
>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0fprintf(f, "\t\t# \"%s\" lid %d %s%s",
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rem_nodename,
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remoteport-=
>node->type =3D=3D IB_NODE_SWITCH ?
>>>>> @@ -396,7 +399,8 @@ void out_ca_port(ibnd_port_t * port, int grou=
p, char *out_prefix)
>>>>> =C2=A0 =C2=A0 =C2=A0rem_nodename =3D remap_node_name(node_name_ma=
p,
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->remot=
eport->node->guid,
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->remot=
eport->node->nodedesc);
>>>>> -
>>>>> + =C2=A0 =C2=A0if (full_info)
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0fprintf(f, " s=3D%d w=3D%d", ispeed, iwidth);
>>>>
>>>> Ditto.
>>>>
>>>> Sasha
>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d=
 %s%s\n",
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->base_lid, p=
ort->lmc, rem_nodename,
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remoteport-=
>node->type =3D=3D IB_NODE_SWITCH ?
>>>>> @@ -926,6 +930,9 @@ static int process_opt(void *context, int ch,=
 char *optarg)
>>>>> =C2=A0 =C2=A0 =C2=A0case 's':
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg->show_progres=
s =3D 1;
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
>>>>> + =C2=A0 =C2=A0case 'f':
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0full_info =3D 1;
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
>>>>> =C2=A0 =C2=A0 =C2=A0case 'l':
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list =3D LIST_CA_=
NODE | LIST_SWITCH_NODE | LIST_ROUTER_NODE;
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
>>>>> @@ -964,6 +971,7 @@ int main(int argc, char **argv)
>>>>> =C2=A0 =C2=A0 =C2=A0ibnd_fabric_t *diff_fabric =3D NULL;
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0const struct ibdiag_opt opts[] =3D {
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"full", 'f', 0, NULL,=
 "show full information (ports' speed and witdh)"},
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"show", 's', 0, =
NULL, "show more information"},
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"list", 'l', 0, =
NULL, "list of connected nodes"},
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"grouping", 'g',=
 0, NULL, "show grouping"},
>>>>> --
>>>>> 1.5.4
>>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
