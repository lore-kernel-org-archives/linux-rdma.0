From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] An improved infrastructure for uverbs commands (My take
 at designing extensible scheme)
Date: Tue, 1 Oct 2013 16:32:51 +0300
Message-ID: <524ACF03.3010302@mellanox.com>
References: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com> <524AAAE6.3040508@mellanox.com> <524AB54F.9050205@mellanox.com> <a8f6521f905732e511576cbc3768f254@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a8f6521f905732e511576cbc3768f254-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/10/2013 4:13 PM, Yann Droneaud wrote:
> Hi,
>
> Le 01.10.2013 13:43, Matan Barak a =C3=A9crit :
>> On 1/10/2013 1:58 PM, Or Gerlitz wrote:
>>> On 24/09/2013 19:16, Yann Droneaud wrote:
>
>>> The patch should be titled as follows
>>>
>>> IB/core:  An improved infrastructure for extending uverbs commands
>>>
>>> Or.
>>>
>>
>> Really nice work. I also think it's better to move the comp_mask to
>> the extended header in order to force future proof.
>
> Yes, that's why in a later patch, not send yet, I've added a 'respons=
e
> header',
> so that the "comp_mask" could be returned as part of the infrastructu=
re.
>
>> In addition, commands that have extensible sub-structures (for
>> example, extended address handle in QP attributes in IP based
>> addressing patch) should be given as a different UDATA in the cmd
>> structure. Therefore, we need a comp_mask in the cmd structure heade=
r
>> to describe which UDATA structure are included.
>
> You mean a command could be given a variable list or array of UDATA ?
> The comp_mask will tell if slots are presents ?
>
> It's quite different from the scheme I proposed where a split is done
> so that the provider userspace library (say libmlx4) could add data
> to a command independently of data added to the verbs userspace libra=
ry
> (libibverbs).

I don't think it's different. The solution you provided deals with=20
extending the command in a way that is unique to the hardware provider.=
=20
I was talking about standard command parts that could be extended in th=
e=20
future.

>
> Having more than 2 parts in a command making the whole thing looking
> more like Netlink messages, where a command would be split on multipl=
e
> "chunks",
> each chunks having a unique tag/version.
>
> Processing a command would consist of gathering each known chunk to
> create a command
> for version X, Y, or Z. The command would be be processed
> by core/ uverbs and remaining chunks would be given to the hw/ provid=
er.
> [what to do with unprocessed chunks ? ignore or error ?]
> Once the command is complete, execution can take place.
>
> This scheme seems more complicated. Is it necessary ?

Although it might looks like we're splitting the command into several=20
parts, this technique should only be used when a command uses a=20
standalone struct that might be extended some day.
Alternatively, we could pass a UDATA member in the command structure=20
itself, but I think that if we already introduces a UDATA for the=20
command and provider, why not add all those necessary stand-alone parts=
=20
in the same place ?

>
>
> Regards.
>
Regards.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
