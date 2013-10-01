From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] An improved infrastructure for uverbs commands (My take
 at designing extensible scheme)
Date: Tue, 1 Oct 2013 17:32:17 +0300
Message-ID: <524ADCF1.80508@mellanox.com>
References: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com> <524AAAE6.3040508@mellanox.com> <524AB54F.9050205@mellanox.com> <a8f6521f905732e511576cbc3768f254@meuh.org> <524ACF03.3010302@mellanox.com> <7a32cf4322932c154e9bc145d8cf9ba0@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7a32cf4322932c154e9bc145d8cf9ba0-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/10/2013 4:53 PM, Yann Droneaud wrote:
> Hi,
>
> Le 01.10.2013 15:32, Matan Barak a =C3=A9crit :
>> On 1/10/2013 4:13 PM, Yann Droneaud wrote:
>>> Hi,
>>>
>>> Le 01.10.2013 13:43, Matan Barak a =C3=A9crit :
>>>> On 1/10/2013 1:58 PM, Or Gerlitz wrote:
>>>>> On 24/09/2013 19:16, Yann Droneaud wrote:
>>>
>>>>> The patch should be titled as follows
>>>>>
>>>>> IB/core:  An improved infrastructure for extending uverbs command=
s
>>>>>
>>>>> Or.
>>>>>
>>>>
>>>> Really nice work. I also think it's better to move the comp_mask t=
o
>>>> the extended header in order to force future proof.
>>>
>>> Yes, that's why in a later patch, not send yet, I've added a 'respo=
nse
>>> header',
>>> so that the "comp_mask" could be returned as part of the infrastruc=
ture.
>>>
>>>> In addition, commands that have extensible sub-structures (for
>>>> example, extended address handle in QP attributes in IP based
>>>> addressing patch) should be given as a different UDATA in the cmd
>>>> structure. Therefore, we need a comp_mask in the cmd structure hea=
der
>>>> to describe which UDATA structure are included.
>>>
>>> You mean a command could be given a variable list or array of UDATA=
 ?
>>> The comp_mask will tell if slots are presents ?
>>>
>>> It's quite different from the scheme I proposed where a split is do=
ne
>>> so that the provider userspace library (say libmlx4) could add data
>>> to a command independently of data added to the verbs userspace lib=
rary
>>> (libibverbs).
>>
>> I don't think it's different. The solution you provided deals with
>> extending the command in a way that is unique to the hardware
>> provider. I was talking about standard command parts that could be
>> extended in the future.
>>
>>>
>>> Having more than 2 parts in a command making the whole thing lookin=
g
>>> more like Netlink messages, where a command would be split on multi=
ple
>>> "chunks",
>>> each chunks having a unique tag/version.
>>>
>>> Processing a command would consist of gathering each known chunk to
>>> create a command
>>> for version X, Y, or Z. The command would be be processed
>>> by core/ uverbs and remaining chunks would be given to the hw/ prov=
ider.
>>> [what to do with unprocessed chunks ? ignore or error ?]
>>> Once the command is complete, execution can take place.
>>>
>>> This scheme seems more complicated. Is it necessary ?
>>
>> Although it might looks like we're splitting the command into severa=
l
>> parts, this technique should only be used when a command uses a
>> standalone struct that might be extended some day.
>> Alternatively, we could pass a UDATA member in the command structure
>> itself, but I think that if we already introduces a UDATA for the
>> command and provider, why not add all those necessary stand-alone
>> parts in the same place ?
>>
>
> So we should not speak of UDATA, since UDATA data structure is used t=
i
> describe
> an input buffer *and* an output buffer.
> In the scheme you start to draw, they're no more correlated.

correct

>
> If I understand, a command can be represented like this:
>
> [command header]
>    [command data]
>    [command data ext1]
>    [command data ext2]
>    [provider data]
>    [provider data ext1]
>    [provider data ext2]
>    [provider data ext3]
>
> command header has a link to a response buffer that can be represente=
d
> like this,
> before the command execution.

If I understand this correctly, some of those [command data ext] fields=
=20
could be write-only fields, that are only placed here as "write buffer"=
s=20
for the command structure. I don't think the response is any different=20
than any other "write-only" buffers.


>
> [response header]
>    [command response space]
>    [provider response space]
>
>
> Once the command is executed, the response buffer would be:
>
> [response header]
>    [command response data]
>    [command response data ext1]
>    [command response data ext2]
>    [command response data ext3]
>    [provider response data]
>    [provider response data ext1]
>
>
>
> If this is an acceptable scheme, then the command should be built as =
a
> linked list of item by libibverbs,
> and this list being parse by core/uverbs to be given to command handl=
er ?

I thought about an array of user-buffers, but a list could work just as=
=20
well. We just have to make sure that the suggested infrastructure will=20
deal with joining/splitting the parts of the list/array.

Alternatively, we could drop this whole list/array thing and just put=20
pointers in the command itself. It's simpler, but if we expect a lot of=
=20
standard structures to extend, it'll be a lot more difficult to manage=20
in the long run.

>
> Regards.
>
Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
