From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Suppress a sparse warning
Date: Wed, 12 Mar 2014 19:54:51 +0200
Message-ID: <53209F6B.7050400@mellanox.com>
References: <531DAEA1.7060703@acm.org> <1394458406.3257.53.camel@localhost.localdomain> <531DCB7D.9020104@acm.org> <1394463733.3257.62.camel@localhost.localdomain> <20140310160803.GC21124@linux.vnet.ibm.com> <532033C5.7030803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <532033C5.7030803-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/12/2014 12:15 PM, Bart Van Assche wrote:
> On 03/10/14 17:08, Paul E. McKenney wrote:
>> On Mon, Mar 10, 2014 at 04:02:13PM +0100, Yann Droneaud wrote:
>>> Hi,
>>>
>>> Le lundi 10 mars 2014 =E0 15:26 +0100, Bart Van Assche a =E9crit :
>>>> On 03/10/14 14:33, Yann Droneaud wrote:
>>>>> Le lundi 10 mars 2014 =E0 13:22 +0100, Bart Van Assche a =E9crit =
:
>>>>>> Suppress the following sparse warning:
>>>>>> include/rdma/ib_addr.h:187:24: warning: cast removes address spa=
ce of expression
>>>>> You should explain why there's a warning here, and why is it safe=
 to
>>>>> cast. (I believe it's related to RCU domain ?)
>>>> Hello Yann,
>>>>
>>>> Now that I've had a closer look at the code in include/rdma/ib_add=
r.h,
>>>> that code probably isn't safe. How about the (untested) patch belo=
w ?
>>>>
>>> Thanks for investigating.
>>>
>>> I'm not an expert in RCU, but I believe it then miss the RCU annota=
tions
>>> around the RCU reader section (ensure correct ordering if I recall
>>> correctly).
>>>
>>> Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> If the rcu_read_lock() isn't supplied by all callers to this functio=
n,
>> then yes, it needs to be supplied as Yann shows below.
>>
>> The CONFIG_PROVE_RCU=3Dy Kconfig option can help determine that they=
 are
>> needed, but of course cannot prove that they are not needed, at leas=
t
>> not unless you have a workload that exercises all possible calls to
>> this function.
> Hello Moni,
>
> I think this warning got introduced via commit "IB/cma: IBoE (RoCE)
> IP-based GID addressing" (7b85627b9f02f9b0fb2ef5f021807f4251135857;
> December 12, 2013). Can you follow this up further ?
>
> Thanks,
>
> Bart.
Sure. I'll look into it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
