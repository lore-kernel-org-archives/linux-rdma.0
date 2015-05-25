From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Mon, 25 May 2015 23:04:41 +0300
Message-ID: <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	<1432226406.28905.22.camel@redhat.com>
	<CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
	<1432242708.28905.73.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432242708.28905.73.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 22, 2015 at 12:11 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> On Thu, 2015-05-21 at 22:55 +0300, Or Gerlitz wrote:
>> On Thu, May 21, 2015 at 7:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>>
>> > The MAC/GUID mapping isn't the only thing that has to be faked her=
e
>>
>> Exactly nothing is faked here, Virtualization systems such as
>> open-stack provision unique 48 bit mac values to VMs, and it's
>> perfectly legitimate and viable to derive 64 bit guid value from tha=
t
>> mac.
>
> OK, faked wasn't the best use of words.  How's converted behind the
> software's back?  And if the management software set the MAC, then tr=
ied
> to check it via ARP after the guest is up and running, it would never
> find the guest.  I don't know if Open-Stack or any other controller
> would both A) attempt to set the MAC of the device in libvirt and sta=
rt
> the guest and B) enter the MAC into a dhcp.conf file for static IP
> assignment, but they could, and this sort of manipulation would direc=
tly
> break that.

OK, so rewinding a bit, the IB VF [1] identity is their 8 bytes port
GUID, and as Jason noted the
user/kernel API allows to deliver up to 32 bytes between user and
kernel under the set_vf_mac flow
(do_setvfinfo() in net/core/rtnetlink.c). Trying it out through
**non-modified** ip tool and net/core/rtnetlink.c
things just work -  I can set eight bytes value to be the virtual port =
GUID :

# ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff:11:22

# ibstat -d mlx4_2
CA 'mlx4_2'
        CA type: MT4100
        Number of ports: 1
        Firmware version: 2.34.1260
        Hardware version: 0
        Node GUID: 0x001405003bca04bb
        System image GUID: 0xf452140300117423
        Port 1:
                State: Active
                Physical state: LinkUp
                Rate: 56
                Base lid: 7
                LMC: 0
                SM lid: 1
                Capability mask: 0x02514868
                Port GUID: 0x2211ffeeddccbbaa
                Link layer: InfiniBand


Re DHCP: RFC 2131 adds a =E2=80=9Cclient identifier=E2=80=9D option tha=
t replaces the
client hardware address as the unique identifier of the client in its
subnet. DHCP over IB RFC 4390 [1] requires that IPoIB DHCP clients use
the client identifier (as they cannot fit their 20 byte MAC in the
client hardware address field). DHCP packages (e.g ISC) that support
IPoIB use client identifier which is based on the unique eight byte
port GUID, so with the modified patches that use 8 bytes, we're OK
DHCP wise.

[1] https://tools.ietf.org/html/rfc4390#section-2.1

[...]
> It's a workaround.  It comes with limitations, and if we get around t=
o
> adding an ndo later for really setting the guid, then it would be
> possible to call the set_guid ndo with a complete guid that didn't us=
e
> fffe in the middle 2 bytes, and then when we call get vf_info, we get=
 a
> MAC back that removes those 2 bytes and generates an inconsistency
> between what we *think* our constructed guid should be and what the s=
et
> guid actually is.

OK, as written above, I have managed to get away from this possible mes=
s
which you described here by providing eight bytes from user to kernel t=
hrough
the existing netlink API (which is used by the ip tool and libvirt).

>> Couple of months ago, we both attended a call with the libvirt
>> developers / maintainers from red-hat and they really liked this
>> staged approach.

> My recollection of that call was they said "Oh, you guys don't have a=
n
> API for us to set the GUIDs yet.  Ok, we'll close all the bugs and wa=
it
> until you do."  And they promptly closed the bugs and moved on.  But
> that didn't specify the API to use.  That's what we are doing here.  =
But
> I'm not finding this an entirely convincing solution.

So that was what said, we were wrong and with this small ipoib/verbs pa=
tch,
we fully have the API to provision the vGUID of the VF.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
