From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Thu, 28 May 2015 00:58:59 +0300
Message-ID: <CAJ3xEMjXXKy=DSeksTFEX-GAN=nYm_6nn5msvsYOwnp0roEHJQ@mail.gmail.com>
References: <1432242708.28905.73.camel@redhat.com>
	<CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	<20150525211433.GA9186@obsidianresearch.com>
	<CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
	<20150525223235.GA9858@obsidianresearch.com>
	<1432659226.28905.151.camel@redhat.com>
	<20150526181336.GD11800@obsidianresearch.com>
	<1432672378.28905.178.camel@redhat.com>
	<20150526211114.GB4502@obsidianresearch.com>
	<1432736046.28905.215.camel@redhat.com>
	<20150527171143.GB9909@obsidianresearch.com>
	<1432749191.28905.243.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432749191.28905.243.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 8:53 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, 2015-05-27 at 11:11 -0600, Jason Gunthorpe wrote:
> Well, let's just be clear: netlink/iproute2 screwed the pooch on their
> implementation of this stuff.  Any solution that doesn't include fixing
> this up in some way is not really a good solution.

>>  For instance iproute2 would need IB specific code to format
>> the 'ip link show' (review print_vfinfo in iproute2) and to length
>> check 'ip link set vf mac'

>> If we do use 8, then it would be ideal (and my strong preference) to
>> also fix the IFLA_VF_MAC message to have a working length. I think
>> that could be done compatibly with a bit of work. At least that way
>> iproute2 can be kept clean when it learns to do IB, and we could have
>> the option again of using 20 someday if we need.
>>

> Sounds like a reasonable plan.
> Or, this is your patch set, are you going to pick up these action items?

Let see

>> So to be clear, to go with the 8 byte option I suggest:

>>  - Engage netdev/iproute and confirm they are philosophically OK
>>    with IFLA_VF_MAC != IFLA_ADDRESS

the last thing netdev are is having philosophical views, they are very
practical (and non-perfect and happy and lively community), the one
thing before the last  netdev are is caring for the rdma subsystem. If
something has to change @ their direct part, we should come with
patches.

>>  - Make a kernel patch to properly size the IFLA_VF_MAC message

You mean the below structure which is expected by the kernel after
they see the IFLA_VF_MAC NL attribute

struct ifla_vf_mac {
         __u32 vf;
         __u8 mac[32]; /* MAX_ADDR_LEN */
 };

How you thought to patch things such that the size of the address
provided by user-space will propagate into the kernel w.o breaking the
NL ABI here?

Why not just take the eight lower bytes and set them NL --> ipoib -->  PF driver

>>  - Make a iproute patch to use the IFLA_VF_MAC size in print_vfinfo
>>    instead of hardcoded ETH_ALEN (using len == 32 mean len 6 for compat)

I was thinking to patch iproute to sense the link type: if eth print
six bytes, if ipoib print 8 bytes, simple.

>>  - Drop in the IB patch

sounds good.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
