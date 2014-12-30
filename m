From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4: having trouble getting mlx4_NOP to succeed in the VF driver
Date: Wed, 31 Dec 2014 02:26:07 +0530
Message-ID: <CANwwZzXTFQefhJcDJ1_eK+becUqhq=D3KgVbPfW9+Xqj7yqk0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the mlx4 source code and had a few questions
regarding the generation of interrupts upon execution of the NOP
command from the VF driver.

If i am running as a dedicated driver, then NOP seems to work fine(I
get an interrupt)

But if I enable SRIOV and then from the VF driver, i run the NOP
command, I don't receive any interrupt(on the VF side)

err = mlx4_NOP(dev); //this command when executed from VF driver
doesn't raise any interrupt.

I get the following from VF logs:

[  117.879100] mlx4_core 0000:01:00.0: communication channel command
0x5 timed out
[  117.879120] mlx4_core 0000:01:00.0: failed execution of VHCR_POST
commandopcode 0x31
[  117.879127] mlx4_core 0000:01:00.0: NOP command failed to generate
MSI-X interrupt IRQ 24).


I have checked the logs and it seems from the VHCR, NOP is received
properly on the PF side and the HCR command is successful.

Also GEN_EQE HCR command when executed in response to NOP is also
successful.( i can see the return status of the command execution)



But on the VF side, the mlx4_eq_int function doesn't get called.

I have checked the return value of request_irq and it seems to be 0(no error)

mlx4_enable_msi_x is also successful.


Can anyone please help me if I am missing something?
Is there anything to be done so as to get interrupts in the mlx4 VF driver?

Can i check at any logs? dmesg output is the only place i was checking.



Also, can the ConnectX hardware generate interrupt to the VF driver?
Or is it that it only generates to the PF driver and PF driver uses
GEN_EQE? I understand that GEN_EQE is used to generate an event
towards a VF..But how are the interrupts routed to the VF driver?


I would be really very much grateful if I can get any kind of help.


Thanks so much !!


Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
