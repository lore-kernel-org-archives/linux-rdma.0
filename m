From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Tue, 26 May 2015 06:33:15 +0300
Message-ID: <CAJ3xEMjSU0xVWyqd8v_-OO5JvsHycGTU6gg=BHpZD8PSqRfzQg@mail.gmail.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	<1432226406.28905.22.camel@redhat.com>
	<CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
	<1432242708.28905.73.camel@redhat.com>
	<CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	<20150525211433.GA9186@obsidianresearch.com>
	<CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
	<20150525223235.GA9858@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150525223235.GA9858-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 1:32 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, May 26, 2015 at 12:50:52AM +0300, Or Gerlitz wrote:
>> On Tue, May 26, 2015 at 12:14 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Mon, May 25, 2015 at 11:04:41PM +0300, Or Gerlitz wrote:
>> >
>> >> OK, so rewinding a bit, the IB VF [1] identity is their 8 bytes port
>> >> GUID, and as Jason noted the user/kernel API allows to deliver up to
>> >> 32 bytes between user and kernel under the set_vf_mac flow
>> >> (do_setvfinfo() in net/core/rtnetlink.c). Trying it out through
>> >> **non-modified** ip tool and net/core/rtnetlink.c things just work -
>> >> I can set eight bytes value to be the virtual port GUID :
>> >
>> > Was I not perfectly clear? You have to use the 20 byte LLADDR format here:
>> >
>> >> # ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff:11:22
>>
>> Jason,
>>
>> I am aiming to provision the VF IB end-node address == port GUID (vGUID)
>> in the same manner that VF Eth end-node address is their MAC, not
>> more, not less.
>
> I perfectly understand what you are trying to do.

Good, we should be doing things for a reason, and not just for the sake of doing
them 111% right by someone possibly subjective judgement

> I care about the design and consistency of netlink - and that means
> there is one LLADDR definition for a net device, and every single netlink
> message that touches a LLADDR uses that definition - for IPoIB that is 20
> bytes.

> To violate that design invariant needs an incredibly strong argument,
> and you haven't made it.


> This allows generic code to work with the LLADDR - for instance 'ip
> link set vf mac' should have checked the size of the IFLA_ADDRESS and
> demanded that the address argument is the same number of bytes. It is
> very broken the command happily accepts an 8 byte and 6 byte argument
> for the same device.

OK, so per your view, the existing kernel code for this flow is broken
and you resist my attempt to use it as is, and

> Yes, it is ugly that the PF side's ndo_get_vf_config cannot return the
> same 20 byte address of the VF's ipoib interface, but I think that is
> less ugly than forcing a different address format just for the vf calls.

you claim that what I propose is uglier from the fact that the PF can't
by no means return the 20 VF's IPoIB address and it's OK if I only let
the PF configure 20 bytes with part (say four) of them being arbitrary
and only have consistent 20B get/set by the PF.

Would you be happier if the ipoib ndo_set_vf_mac ndo be

1. getting 20B from user-space and treating 16 of them as the VF
subnet-prefix (8B) + vGUID (8B)

2. checking that the subnet-prefix  is correct

3. provision the vGUID through PF driver / the verb I proposed for the VF

???

on the way back, for the get_vf_config

1. read the VF vGUID from the PF IB driver through the verbs

2. add the port subnet prefix

3. return 20B to user-space

???

> If you have doubts then *ask netdev*. Ask them if ndo_set_vf_mac must
> follow the same address size and format as IFLA_ADDRESS, or if we can
> use something else.

> Such a netlink architecture choice is beyond the authority of linux-rdma.

I am not @ the point to change start changing this specific netlink flow.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
