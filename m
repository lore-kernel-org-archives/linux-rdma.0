From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: PCI/AER: AER in SRIOV environment
Date: Mon, 23 Jun 2014 13:09:15 -0600
Message-ID: <CAErSpo7xVvqYea8v624T8EyVf6skQccraAe_WYpzcf2tkWFLhg@mail.gmail.com>
References: <53A839C6.5050102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A839C6.5050102-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil-VXdhtT5mjnY@public.gmane.org>, Myron Stowe <myron.stowe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[+cc linux-pci, Don]

On Mon, Jun 23, 2014 at 8:29 AM, Yishai Hadas
<yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Hi Vijay,
> Trying to add AER support for Mellanox NIC in SRIOV environment, while
> evaluating/testing encountered a problem which led me to your
> patch accepted as part of kernel 3.8, commit ID
> "918b4053184c0ca22236e70e299c5343eea35304".
>
> Have some concerns/questions on:
> When working in SRIOV environment VFs may be un-attached, having no driver
> assigned to, or may be attached to Virtual machine to work in some
> pass-through mode.
> Once working in KVM setup there is pci-stub driver which is loaded in the
> HYP/PF for a given attached VF.
>
> I'm using the aer-inject kernel module and its corresponding aer-inject tool
> to simulate an error in the HYP.
> In both cases your commit will cause the AER recovery to fail as there is no
> driver assigned to PF's VFs that supports AER, comparing the code before
> your change.
>
> How such cases should work ?  my expectation was that the PF will get the
> error detected message then will recognize whether
> issue is its own or one of its VFs

I'm really not an AER expert, so help me understand this question of
recognizing whether an error is associated with a PF or a VF.

In terms of hardware, it looks like the device that detects an error
logs some information and sends an Error Message upstream.  The Root
Complex receives the message, captures the source ID from the Error
Message, and may generate an interrupt.  I expect this source ID can
be either a PF or a VF; there's no requirement that a VF error must be
reported as though it's from the PF, is there?

> and work accordingly, in current code
> looks like recovery failed as part of "voting" once there is no AER handler
> assigned to the VFs.

The commit you mentioned has to do with PCI_ERS_RESULT_NO_AER_DRIVER.
We use pci_walk_bus() to figure out whether all the devices in a
subtree have a driver.  What subtree is involved here?  I would expect
the VFs to be siblings of the PF, not children of it, so I'm not sure
where things went wrong.

Can you collect "lspci -vvv" output and maybe add some debug so we can
see exactly where the error is detected and what devices we're looking
at to conclude that one of them doesn't have a driver?

Bjorn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
