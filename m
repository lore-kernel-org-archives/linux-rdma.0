From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: PCI/AER: AER in SRIOV environment
Date: Mon, 23 Jun 2014 17:17:05 -0600
Message-ID: <1403565425.3707.427.camel@ul30vt.home>
References: <53A839C6.5050102@dev.mellanox.co.il>
	 <CAErSpo7xVvqYea8v624T8EyVf6skQccraAe_WYpzcf2tkWFLhg@mail.gmail.com>
	 <53A88A32.4010406@redhat.com> <53A8ADD5.7030207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <53A8ADD5.7030207@dev.mellanox.co.il>
Sender: linux-pci-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>, Myron Stowe <myron.stowe@redhat.com>, "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "yishaih@mellanox.com" <yishaih@mellanox.com>, liranl@mellanox.com, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2014-06-24 at 01:44 +0300, Yishai Hadas wrote:
> On 6/23/2014 11:12 PM, Don Dutile wrote:
> > On 06/23/2014 03:09 PM, Bjorn Helgaas wrote:
> >> [+cc linux-pci, Don]
> >>
> > Adding Alex Williamson in case he can add more to this conversation...
> >
> >> On Mon, Jun 23, 2014 at 8:29 AM, Yishai Hadas
> >> <yishaih@dev.mellanox.co.il> wrote:
> >>> Hi Vijay,
> >>> Trying to add AER support for Mellanox NIC in SRIOV environment, while
> >>> evaluating/testing encountered a problem which led me to your
> >>> patch accepted as part of kernel 3.8, commit ID
> >>> "918b4053184c0ca22236e70e299c5343eea35304".
> >>>
> >>> Have some concerns/questions on:
> >>> When working in SRIOV environment VFs may be un-attached, having no 
> >>> driver
> >>> assigned to, or may be attached to Virtual machine to work in some
> >>> pass-through mode.
> >>> Once working in KVM setup there is pci-stub driver which is loaded 
> >>> in the
> >>> HYP/PF for a given attached VF.
> > huh? 'loaded in the hyp/pf? .... um, loaded in the host, and a VF is
> > detached from its host driver -- a VF can be used in the host w/o any 
> > virtualization,
> > i.e., that's how guest VM is driving the VF: as if it was used by a 
> > guest (host) OS directly --
> > and attached to pci-stub driver, when assigned to a KVM guest in 
> > pre-VFIO days/ways.
> > If VFIO used, then VF is attached to vfio-pci driver.
> >
> >>>
> >>> I'm using the aer-inject kernel module and its corresponding 
> >>> aer-inject tool
> >>> to simulate an error in the HYP.
> >>> In both cases your commit will cause the AER recovery to fail as 
> >>> there is no
> >>> driver assigned to PF's VFs that supports AER, comparing the code 
> >>> before
> >>> your change.
> >>>
> > Without VFIO, I believe that's correct. There was no AER-to-VF support 
> > pre-VFIO days.
> > I believe with the recent VFIO support,
> > and modifications to KVM, an AER that is associated with an assigned 
> > VF will
> > force the crash/halt of the KVM guest -- can't depend on a guest VF 
> > driver clearing
> > the AER in the hyp/host -- guest isn't privileged enough to clear the 
> > error.
> > So, crashing the guest is the simple option at the moment, to contain 
> > the error.
> > Alex: do I have that (vfio aer default) correct, or is that still 
> > site-under-construction?
>      How about the case that the VF is not attached to a KVM guest and 
> has no driver loaded on host ? in such a case from code review and some 
> testing the recovery will
>      fail as there is no AER aware driver here. What is the expected 
> solution here ?
>      Any special qemu /stuff is needed to activate the VFIO support ? 
> would like to give it a try for a case that VF is attached.

Just use recent QEMU (>=1.6, the newer the better) and it should be
automatic.  Note that the VM won't exit on error, it's stopped with
state RUN_STATE_IO_ERROR to allow the possibility of collecting data.
Thanks,

Alex

> >
> >>> How such cases should work ?  my expectation was that the PF will 
> >>> get the
> >>> error detected message then will recognize whether
> >>> issue is its own or one of its VFs
> > The AER packet will have the tag of the VF in if it was the source of 
> > the error;
> > so the PF will never see it; although one could argue it should be 
> > 'promoted'
> > to the PF if PF/VF needs to clear some state it has wrt the VF (the 
> > SRIOV spec is
> > lacking of info in this space); _but_, VFIO resets the VF (sets FLR 
> > bit) when the
> > device is deassigned and before re-attachment to the host, so that 
> > should clear out
> > any state btwn PF & VF ('should' ... famous last words...).
>      In my test I have used the aer-inject tool simulating an error to 
> the BUS that both PF/VF are residing on, putting the function number to 
> be the PF one, looks like both should be called by the aer driver as part
>      of the pci_walk_bus(). As mentioned I got a call only on the PF and 
> recovery failed as of the VF doesn't include an AER aware driver, once 
> removed the VF recovery succeeded.
>      I believe that packet should include some info about the source of 
> the error isn't it ?
>      In addition, looking at IXGBE upstream source code at 
> ixgbe_error_detected()  looks like there is some code running on the PF 
> that checks whether the source was a VF.
> 
>      By the way: when tried to simulate a VF error using its FN got 
> below error:
>      "Error: Failed to write, Inappropriate ioctl for device", any idea 
> about that error ?
> >
> >>
> >> I'm really not an AER expert, so help me understand this question of
> >> recognizing whether an error is associated with a PF or a VF.
> >>
> >> In terms of hardware, it looks like the device that detects an error
> >> logs some information and sends an Error Message upstream.  The Root
> >> Complex receives the message, captures the source ID from the Error
> >> Message, and may generate an interrupt.  I expect this source ID can
> >> be either a PF or a VF; there's no requirement that a VF error must be
> >> reported as though it's from the PF, is there?
> >>
> >>> and work accordingly, in current code
> >>> looks like recovery failed as part of "voting" once there is no AER 
> >>> handler
> >>> assigned to the VFs.
> >>
> >> The commit you mentioned has to do with PCI_ERS_RESULT_NO_AER_DRIVER.
> >> We use pci_walk_bus() to figure out whether all the devices in a
> >> subtree have a driver.  What subtree is involved here?  I would expect
> >> the VFs to be siblings of the PF, not children of it, so I'm not sure
> >> where things went wrong.
> > Well, VFs could be on virtual busses (ARI turned on), so not 
> > necessarily a
> > sibling to PF ... and then we have the problem in PCI code of not 
> > being able
> > to traverse these virtual busses (in some cases; not sure if 
> > pci_walk_bus(),
> > which is going down the tree vs up the tree, has any problems here 
> > w/VFs on
> > virtual busses).
> >
> >>
> >> Can you collect "lspci -vvv" output and maybe add some debug so we can
> >> see exactly where the error is detected and what devices we're looking
> >> at to conclude that one of them doesn't have a driver?
>      lspci -vvv for both PF & VF is attached, we can see that VF 
> (21:00.1) has no driver loaded comparing the PF (Kernel driver in use: 
> mlx4_core).
> >>
> >> Bjorn
> >>
> >
> 
