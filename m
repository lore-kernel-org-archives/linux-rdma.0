From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Fri, 11 Oct 2013 00:26:54 +0300
Message-ID: <CAJZOPZK2YyssNHELbBLCK9tgL8K9rzAit33T-WJ24cDGtyk1vA@mail.gmail.com>
References: <CAJZOPZJ_F06xORoQyt-6_SK5P5Y7LXekQuNKHHYSt+oJ8sV1GA@mail.gmail.com>
	<52480568.8000801@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52480568.8000801-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 29, 2013 at 1:48 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 17/09/2013 23:49, Or Gerlitz wrote:
>> On Tue, Sep 17, 2013 at 8:50 PM, Roland Dreier wrote:
>>> On Thu, Sep 12, 2013 at 10:22 AM, Jason Gunthorpe wrote:
>>>> On Thu, Sep 12, 2013 at 03:24:46PM +0300, Or Gerlitz wrote:

>>>>> Let me clarify this. The idea is that current RoCE applications will
>>>>> run as is after they update "their" librdmacm, since its this
>>>>> library that works with the new uverbs entries.

>>>> Or, we are not supposed to break userspace. You can't insist that a
>>>> user space library be updated in-sync with the kernel.

>>> Agree.  This "IP based addressing" for RoCE looks like a big problem
>>> at the moment.  Let me reiterate my understanding, and you guys can
>>> correct me if I get something wrong:

>>>   - current addressing scheme is broken for virtualization use cases,
>>> because VMs may not know about what VLANs are in use.  (also there are
>>> issues around bonding modes that use different Ethernet addresses)
>>
>> The current addressing is actually broken for vlan use cases, both
>> native and virtualized, for the virt as of the argument you mentioned,
>> for native as of one node connected to Ethernet edge switch acting in
>> access mode (that is the switch does vlan insertion/stripping) and the
>> other node handling vlans by itself. Each one will form different GID
>> for the other party.
>>
>>>   - proposed change requires:
>>>     * all systems must update kernel at the same time, because old and
>>> new kernels cannot talk to each other
>>>     * all systems must update librdmacm when they update the kernel,
>>> because old librdmacm does not work with new kernel
>>> I understand that we want to fix the issue around VLAN tagged traffic
>>> from VMs, but I don't see how we can break the whole stack to
>>> accomplish that.  Isn't there some incremental way forward?
>>
>> To begin with, we don't break the whole stack -- using the current
>> patch set, for ports whose link is IB, all biz as usual, and this is
>> the in the port resolution, that is if for a given device one port is
>> IB and one port Eth, existing librdmacm keep working on the IB por.
>>
>> Another fact to put in the fire is that SRIOV VMs don't have RoCE now
>> (not supported by upstream). Actually we're holding off with the SRIOV
>> RoCE patches submission b/c of the breakage with the current scheme
>> --> no need for backward compatibility here either. The vast majority
>> if not all the Cloud use cases we are aware to which would use RoCE
>> need VST and need it to work right.
>>
>> With vlans being broken already, I would say we need 1st and most fix
>> that and only/maybe later worry on backward compatibility for the few
>> native mode use cases that somehow manage to workaround the buggish
>> gid format when they use vlans.
>>
>> As for those who don't use vlans, which is also rare, as RoCE is
>> working best over some lossless channel which is typically achieved
>> using PFC over a vlan... we can use the fact that the IP bases
>> addressing patches configure both interface IPv4 and IPv6 addresses
>> into the gid table.
>>
>> Now,  the IPv6 link address is actually also plugged into the gid
>> table by nodes running the old code since this is how the non-vlan MAC
>> based GID is constructed. Using this fact, we can allow
>>
>> 1. the patched kernel to work with non updated user space, as long as
>> they use the GID which relates to an IPv6 link local address
>>
>> 2. node running the "old" code to talk with "new" node over what the
>> old node sees as a non-vlan MAC based GID and the new node sees as
>> IPv6 link local gid.
>>
>> Sounds better?
>>
>>
>
> Hi Roland, ping, I have wrote a detailed reply to your concerns and no word
> from you except on the "begin with" part, can you? Or.

Roland, its been almost a month since I replied to your concerns and
so far not a word from you on my core arguments, 3.12 is almost on rc5
and another kernel cycle can be easliy lost here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
