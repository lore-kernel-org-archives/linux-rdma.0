From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4: having trouble getting mlx4_NOP to succeed in the VF
 driver
Date: Wed, 31 Dec 2014 11:25:40 +0200
Message-ID: <20141231112540.6b573c4f@jpm-OptiPlex-GX620>
References: <CANwwZzXTFQefhJcDJ1_eK+becUqhq=D3KgVbPfW9+Xqj7yqk0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANwwZzXTFQefhJcDJ1_eK+becUqhq=D3KgVbPfW9+Xqj7yqk0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 31 Dec 2014 02:26:07 +0530
Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> I was going through the mlx4 source code and had a few questions
> regarding the generation of interrupts upon execution of the NOP
> command from the VF driver.
> 
> If i am running as a dedicated driver, then NOP seems to work fine(I
> get an interrupt)
> 
> But if I enable SRIOV and then from the VF driver, i run the NOP
> command, I don't receive any interrupt(on the VF side)
> 
> err = mlx4_NOP(dev); //this command when executed from VF driver
> doesn't raise any interrupt.
> 
> I get the following from VF logs:
> 
> [  117.879100] mlx4_core 0000:01:00.0: communication channel command
> 0x5 timed out
> [  117.879120] mlx4_core 0000:01:00.0: failed execution of VHCR_POST
> commandopcode 0x31
> [  117.879127] mlx4_core 0000:01:00.0: NOP command failed to generate
> MSI-X interrupt IRQ 24).
> 

This simply indicates that the VF did not receive a command-completion
interrupt.

> 
> I have checked the logs and it seems from the VHCR, NOP is received
> properly on the PF side and the HCR command is successful.
> 
> Also GEN_EQE HCR command when executed in response to NOP is also
> successful.( i can see the return status of the command execution)
> 
> 
What is your setup topology?  Is the VF running on the Hypervisor?  Is
it running on a VM?

What is your O/S (Ubuntu X.Y, Fedora, SLES, etc).  What kernel are you
running?

I assume that you are running "inbox" under kernel 3.18.1.  Is this
correct?

> 
> But on the VF side, the mlx4_eq_int function doesn't get called.
>
This is because GEN_EQE did not succeed in triggering the EQ which the
VF uses for Async/command-completion events.
 
> I have checked the return value of request_irq and it seems to be
> 0(no error)
> 
> mlx4_enable_msi_x is also successful.
> 
> 
> Can anyone please help me if I am missing something?
> Is there anything to be done so as to get interrupts in the mlx4 VF
> driver?
> 
> Can i check at any logs? dmesg output is the only place i was
> checking.
> 
> 
> 
> Also, can the ConnectX hardware generate interrupt to the VF driver?
ConnectX does generate *send/receive* completion events directly to the
VF. This is because each CQ is associated individually with an EQ, and
the VF associates CQs it creates with its own EQs.

Each VF also creates an Async/command-completion EQ.  However, this EQ
is triggered by the PF via GEN_EQ (see explanation immediately below).

The issue here is that only the PF posts commands to the FW -- and
receives the command-completion event when a command completes.
The VF submits to the PF a command it wishes to post.  The PF posts
the command to the firmware (i.e., the HCA), and fields the
command-completion event.  It then invokes GEN_EQ to trigger the command
completion event on the VF's async EQ.

You need to verify that the IOMMU options are activated in
make menuconfig on the Hypervisor:

--- IOMMU Hardware Support
[*]   AMD IOMMU support
[*]     Export AMD IOMMU statistics to debugfs
<>     AMD IOMMU Version 2 driver
[*]   Support for Intel IOMMU using DMA Remapping Devices
[*]     Enable Intel DMA Remapping Devices by default
[*]   Support for Interrupt Remapping

I suspect that this may not have been done.
also, add intel_iommu=on to the kernel line in /boot/grub/menu.lst

-Jack

> Or is it that it only generates to the PF driver and PF driver uses
> GEN_EQE? I understand that GEN_EQE is used to generate an event
> towards a VF..But how are the interrupts routed to the VF driver?
> 
> 
> I would be really very much grateful if I can get any kind of help.
> 
> 
> Thanks so much !!
> 
> 
> Best Regards,
> Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
