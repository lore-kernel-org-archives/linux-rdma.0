From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Fri, 14 Jan 2011 07:46:01 -0500
Message-ID: <4D304589.9070909@cadence.com>
References: <ig5vl1$j0$1@dough.gmane.org> <adafwt06puj.fsf@cisco.com> <4D2D5FAD.6030508@cadence.com> <adahbde57r7.fsf_-_@cisco.com> <4D2F310B.2010906@cadence.com> <20110113184432.GA9681@obsidianresearch.com> <ada62ts316q.fsf@cisco.com> <20110113221454.GB9681@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110113221454.GB9681-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>  > Although, while looking into this I wonder J.L., how does your PCI
>>  > device even work? Look at, eg pci_read_bridge_mmio_ref, it seems to me
>>  > it will bail if a bridge is seen with a 64 bit setting but the system
>>  > isn't 64 bit? IMHO, this is a bug, it should be testing for
>>  > sizeof(resource_size_t)
>>
>> I don't see that function... where are you looking?
>
> Sorry, I typo'd it
>
> static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
>
> drivers/pci/probe.c

Yes, on my embedded system, Linux does "bail".  That is, during enumeration,
I get the message:

PCI: Unable to handle 64-bit BAR for device 0000:13:00.0

At 2.6.26, pci_read_bridge_mmio_pref was not present, but the same basic
code is (within pci_read_bases() of probe.c).

When first working on getting the petabyte BAR device to work, I did add
some logic to this code so it was not wholly dependent on BITS_PER_LONG
being 64.  I used CONFIG_RESOURCES_64BIT in an "else" clause (although
using your suggestion of sizeof(resource_size_t) should be equivalent).
Starting with 2.6.28, CONFIG_RESOURCES_64BIT has been replaced by
CONFIG_PHYS_ADDR_T_64BIT.

However, I had to comment out my change in this area (i.e. go back to
the original behavior) as there was no way to allocate a petabyte area
within the 440's mappable space.  I believe there is 2GB of PCI mappable
space in the normal 440 setup under Linux.

My scheme (only viable in the controlled environment of an embedded system)
is to allow Linux enumeration to fail for the petabyte BAR device and
use a quirk routine to manually assign both the BAR value for the device
and to adjust the parent PCIe bridges' prefetchable ranges.

2+ years later, that's where I got in trouble when now adding the
Infiniband card to my "controlled environment".  My quirk routine is not
sensitive to the possibility that Linux enumeration may have established
proper 32-bit prefetchable ranges in the bridges.  I'm going to look at
reworking enumeration for my system to assign prefetchable memory at the
end of the 440 mappable area.  That way, the quirk routine should be able
to simply extend the size of any existing prefetchable ranges to include
the large petabyte area.

But back to your point, yes, my petabyte device is not handled by the
2.6.26 Linux enumeration but that's unavoidable for the PowerPC 440.
It means that the Linux kernel does not have a resource object for the
petabyte area, etc.  But that's OK because the 440 CPU can not access
it.  Our device has a smaller "baby BAR" for 440 CPU access to part of
its resources.  The petabyte BAR is used for peer accesses from other
PCIe devices.

I agree with you:  the use of BITS_PER_LONG looks wrong in probe.c for
environments like the PowerPC 440.  You may want to pose your question
in the linux-pci discussion group.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
