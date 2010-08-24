From: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Tue, 24 Aug 2010 16:27:24 +0300
Message-ID: <4C73C8BC.6010702@voltaire.com>
References: <4C6B9A42.9020505@voltaire.com> <20100824040354.GH5837@me>	<4C73B34A.4080508@voltaire.com> <AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/24/2010 04:10 PM, Hal Rosenstock wrote:
> On Tue, Aug 24, 2010 at 7:55 AM, Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>> On 08/24/2010 07:03 AM, Sasha Khapyorsky wrote:
>>> On 11:30 Wed 18 Aug     , Doron Shoham wrote:
>>>> add '-f' flag to show full information (ports' speed and witdh).
>>>> mainly to work with ibsim (using links real speed and width).
>>>
>>> Seems almost fine. However see the comments below.
>>>
>>>>
>>>> Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>  infiniband-diags/src/ibnetdiscover.c |   10 +++++++++-
>>>>  1 files changed, 9 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
>>>> index f20058c..0a020a2 100644
>>>> --- a/infiniband-diags/src/ibnetdiscover.c
>>>> +++ b/infiniband-diags/src/ibnetdiscover.c
>>>> @@ -77,6 +77,7 @@ static char *diff_cache_file = NULL;
>>>>  static unsigned diffcheck_flags = DIFF_FLAG_DEFAULT;
>>>>
>>>>  static int report_max_hops = 0;
>>>> +static int full_info = 0;
>>>>
>>>>  /**
>>>>   * Define our own conversion functions to maintain compatibility with the old
>>>> @@ -357,6 +358,8 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
>>>>              ext_port_str ? ext_port_str : "");
>>>>      if (port->remoteport->node->type != IB_NODE_SWITCH)
>>>>              fprintf(f, "(%" PRIx64 ") ", port->remoteport->guid);
>>>> +    if (full_info)
>>>> +                    fprintf(f, " s=%d w=%d", ispeed, iwidth);
>>>
>>> I think that in order to not potentially break any ibnetdiscover output
>>> parsers it would be better to put such "f" output after a comment line.
>>> Would it work with ibsim in a same way?
>>
>> ibsim should still work if the output is after the comment.
>> I still think that it can potentially break ibnetdiscover output parsers (that why I used '-f' flag).
>> Do you want it with '-f' flag and after the comment?
>> for example:
>> [1](2c903000020a9)      "S-0008f10500650272"[19]                #  s=2 w=2 lid 6 lmc 0 "Voltaire sLB-4018    Line 10  Chip 1 4700 #4700-B778" lid 3 4xDDR
>>
> 
> Personally, I'd prefer it at the end of the line after 4xDDR and use
> speed/width rather than s=/w=:
> 
> [1](2c903000020a9)      "S-0008f10500650272"[19]                #  lid
> 6 lmc 0 "Voltaire sLB-4018    Line 10  Chip 1 4700 #4700-B778" lid 3
> 4xDDR speed 2 width 2
> 
> I think that looks better and is more readable. Just my $0.02...
> 
> -- Hal

The problem is the ibsim is expecting s=/w= and not speed <number> or width <number>.

What about the flag? do we still need it if we pass the output after the comment?

Doron
> 
>>>
>>>>      fprintf(f, "\t\t# \"%s\" lid %d %s%s",
>>>>              rem_nodename,
>>>>              port->remoteport->node->type == IB_NODE_SWITCH ?
>>>> @@ -396,7 +399,8 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
>>>>      rem_nodename = remap_node_name(node_name_map,
>>>>                                     port->remoteport->node->guid,
>>>>                                     port->remoteport->node->nodedesc);
>>>> -
>>>> +    if (full_info)
>>>> +                    fprintf(f, " s=%d w=%d", ispeed, iwidth);
>>>
>>> Ditto.
>>>
>>> Sasha
>>>
>>>>      fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d %s%s\n",
>>>>              port->base_lid, port->lmc, rem_nodename,
>>>>              port->remoteport->node->type == IB_NODE_SWITCH ?
>>>> @@ -926,6 +930,9 @@ static int process_opt(void *context, int ch, char *optarg)
>>>>      case 's':
>>>>              cfg->show_progress = 1;
>>>>              break;
>>>> +    case 'f':
>>>> +            full_info = 1;
>>>> +            break;
>>>>      case 'l':
>>>>              list = LIST_CA_NODE | LIST_SWITCH_NODE | LIST_ROUTER_NODE;
>>>>              break;
>>>> @@ -964,6 +971,7 @@ int main(int argc, char **argv)
>>>>      ibnd_fabric_t *diff_fabric = NULL;
>>>>
>>>>      const struct ibdiag_opt opts[] = {
>>>> +            {"full", 'f', 0, NULL, "show full information (ports' speed and witdh)"},
>>>>              {"show", 's', 0, NULL, "show more information"},
>>>>              {"list", 'l', 0, NULL, "list of connected nodes"},
>>>>              {"grouping", 'g', 0, NULL, "show grouping"},
>>>> --
>>>> 1.5.4
>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
