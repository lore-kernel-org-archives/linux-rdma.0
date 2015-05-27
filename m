From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Wed, 27 May 2015 16:01:33 +0300
Message-ID: <5565C02D.80007@mellanox.com>
References: <1432226406.28905.22.camel@redhat.com>
 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
 <1432242708.28905.73.camel@redhat.com>
 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
 <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <1432659226.28905.151.camel@redhat.com>
 <20150526181336.GD11800@obsidianresearch.com>
 <1432672378.28905.178.camel@redhat.com>
 <20150526211114.GB4502@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150526211114.GB4502-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/27/2015 12:11 AM, Jason Gunthorpe wrote:
> On Tue, May 26, 2015 at 04:32:58PM -0400, Doug Ledford wrote:
>
>>>   - ifcfg/udev/networkmanager: So what happens when I do
>>>      ip link add link ib0 name ib0.1 type ipoib
>>>     And get two IPoIB interfaces with the same GUID? I doubt any sane
>>>     user would want to apply the same config to those two interfaces.
>> No, they probably don't want to apply the same rules to both interfaces.
>> I'm not entirely sure I agree with the argument though.  I fully
>> expected this to fail without a pkey argument on the ip command
>> line.
> Does that matter to the above tools? Are they using PKey,GUID as their
> key?
>
>> The net stack doesn't allow users to do the same thing with Ethernet
>> devices, so I'm not sure we shouldn't be disallowing this as opposed to
>> creating duplicate devices that are identical in all ways except name.
> The netstack doesn't allow it for ethernet because it would create a
> 2nd identical LLADDR, and LLADDRs must be unique.
>
> Because the QPN is part of the LLADDR IB can create two interfaces on
> the same physical port that are completely separated by hardware. Read
> Haggi's email, he explains how they plan to use this to create
> interfaces that can be delegated to namespaces. It is not a bad idea
> really..
>
> So prepare for a world where each namespace has a child IPoIB
> interface with a unique QPN, but the same Pkey and GUID as the
> host. The breakage from assuming GUID == unique will become a problem.
>
>>> Unbreaking it is a UAPI change, not impossible, but do we really care
>>> enough about 8 or 20 to push for that?
>> In truth, at least right now, it's all moot.  Since we can't set the
>> subnet prefix, the qpn, or the flags, anything above 8 bytes is
>> immutable regardless of how many bytes we pass in.  So even if we say we
>> aren't going to change the UAPI and for everything to 20, the real world
>> result is that 8 works exactly the same and has no functional
>> difference.
> Not quite, in the 20 byte format the 8 bytes of the GUID are in the
> last 8/20 bytes, so the app would have to place 12 zeros and then the
> GUID to follow the 20 byte format (or 4 zeros, the prefix, then the GUID)
>
> This is why the question of 'what is ILFA_VF_MAC' is so important,
> every option presented (MAC,GUID,LLADDR) are incompatible with each
> other.

I agree with Doug that to be practical here, libvirt and Co. would 
really want to use rtnetlink based provisioning of IB VFs, at least in a 
similar manner done for Eth VFs.

So with this assumption at hand, my vote goes to having user-space to 
provide the eight bytes of vGUID through the ndo_set_vf_mac call into 
IPoIB.

I don't see the real value of user space providing the four zero bytes 
(19-16) and the 8 bytes of the subnet prefix provided by the SM.

My personal thinking is that the important thing to address is 
consistency between what the virtualization system provisions on the 
host (ndo_set_vf_mac) to the DHCP server scheme they build.

Do we have a go here?

Also few comments on DHCP:

If we're talking on different vlans/Eth or pkey/IB - it's totally OK for 
two entities (== IPoIB instances under IB) on the physical subnet to use 
the same identifier (IB/GUID, Eth/MAC) if they are on two different L2 
broadcast domains. The DHCP server is expected to have a different 
mapping scheme per such virtual L2 subnet.

For SRIOV, we don't expect two VFs on the network to use the same vGUID, 
so DHCP wise we should be OK. Today the Client-ID works fine for SRIOV 
schemes which are based on 8byte vGUIDs.

Re two IPoIB child devices using the same GUID and the same pkey, we can 
enhance the system and take advantage of IB Alias GUIDs which today are 
only used for SRIOV for Para-Virtual and other environments too, thanks 
for the heads up on the necessity of doing so.

>
>>> What does get return? If we accept 8 or 20, then get must return 20.
>> The get has to return 20 regardless.  It's the only accepted means of
>> getting all 20 bytes of the LLADDR.
> You are conflating IFLA_ADDRESS and IFLA_VF_MAC.
>
> IFLA_VF_MAC could be 8 byte and IFLA_ADDRESS could be 20, I think that
> makes no sense, but it wouldn't break existing stuff.
>

Just to make sure we're on the same page, this thread deals with using 
rtnetlink's IFLA_VF_MAC(== struct ifla_vf_mac) for provisioning vGUID 
for IB VFs, through the PF IPoIB interface, not attempting to use 
IFLA_ADDRESS.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
