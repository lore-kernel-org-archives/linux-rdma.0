From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: PCI/AER: AER in SRIOV environment
Date: Tue, 24 Jun 2014 11:38:13 -0600
Message-ID: <1403631493.31091.2.camel@ul30vt.home>
References: <53A839C6.5050102@dev.mellanox.co.il>
	 <CAErSpo7xVvqYea8v624T8EyVf6skQccraAe_WYpzcf2tkWFLhg@mail.gmail.com>
	 <53A88A32.4010406@redhat.com> <53A8ADD5.7030207@dev.mellanox.co.il>
	 <53A9918D.9020607@redhat.com> <53A9A5B9.20003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <53A9A5B9.20003@dev.mellanox.co.il>
Sender: linux-pci-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>, Myron Stowe <myron.stowe@redhat.com>, "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "yishaih@mellanox.com" <yishaih@mellanox.com>, liranl@mellanox.com, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2014-06-24 at 19:22 +0300, Yishai Hadas wrote:
> On 6/24/2014 5:56 PM, Don Dutile wrote:
> > On 06/23/2014 06:44 PM, Yishai Hadas wrote:
> >> On 6/23/2014 11:12 PM, Don Dutile wrote:
> >>> On 06/23/2014 03:09 PM, Bjorn Helgaas wrote:
> >>>> [+cc linux-pci, Don]
> >>>>
> >>> Adding Alex Williamson in case he can add more to this conversation...
> >>>
> >>>> On Mon, Jun 23, 2014 at 8:29 AM, Yishai Hadas
> >>>> <yishaih@dev.mellanox.co.il> wrote:
> >>>>> Hi Vijay,
> >>>>> Trying to add AER support for Mellanox NIC in SRIOV environment, 
> >>>>> while
> >>>>> evaluating/testing encountered a problem which led me to your
> >>>>> patch accepted as part of kernel 3.8, commit ID
> >>>>> "918b4053184c0ca22236e70e299c5343eea35304".
> >>>>>
> >>>>> Have some concerns/questions on:
> >>>>> When working in SRIOV environment VFs may be un-attached, having 
> >>>>> no driver
> >>>>> assigned to, or may be attached to Virtual machine to work in some
> >>>>> pass-through mode.
> >>>>> Once working in KVM setup there is pci-stub driver which is loaded 
> >>>>> in the
> >>>>> HYP/PF for a given attached VF.
> >>> huh? 'loaded in the hyp/pf? .... um, loaded in the host, and a VF is
> >>> detached from its host driver -- a VF can be used in the host w/o 
> >>> any virtualization,
> >>> i.e., that's how guest VM is driving the VF: as if it was used by a 
> >>> guest (host) OS directly --
> >>> and attached to pci-stub driver, when assigned to a KVM guest in 
> >>> pre-VFIO days/ways.
> >>> If VFIO used, then VF is attached to vfio-pci driver.
> >>>
> >>>>>
> >>>>> I'm using the aer-inject kernel module and its corresponding 
> >>>>> aer-inject tool
> >>>>> to simulate an error in the HYP.
> >>>>> In both cases your commit will cause the AER recovery to fail as 
> >>>>> there is no
> >>>>> driver assigned to PF's VFs that supports AER, comparing the code 
> >>>>> before
> >>>>> your change.
> >>>>>
> >>> Without VFIO, I believe that's correct. There was no AER-to-VF 
> >>> support pre-VFIO days.
> >>> I believe with the recent VFIO support,
> >>> and modifications to KVM, an AER that is associated with an assigned 
> >>> VF will
> >>> force the crash/halt of the KVM guest -- can't depend on a guest VF 
> >>> driver clearing
> >>> the AER in the hyp/host -- guest isn't privileged enough to clear 
> >>> the error.
> >>> So, crashing the guest is the simple option at the moment, to 
> >>> contain the error.
> >>> Alex: do I have that (vfio aer default) correct, or is that still 
> >>> site-under-construction?
> >>      How about the case that the VF is not attached to a KVM guest 
> >> and has no driver loaded on host ? in such a case from code review 
> >> and some testing the recovery will
> >>      fail as there is no AER aware driver here. What is the expected 
> >> solution here ?
> > Well, how can a VF be attributed to an AER if it's not assigned to a 
> > guest, and it doesn't have a driver loaded for it in the host? i.e., 
> > if it's not configured, it's sitting idle, so how can it generate an AER?
>      The expectation is really that it will not participate and won't 
> vote, however in current code looks like it gets a default vote of 
> PCI_ERS_RESULT_NO_AER_DRIVER and recovery failed, that's exactly my concern.
>      In case pci_walk_bus() go over both PF & VF which have same BUS 
> number this may happen, agree ?
> > if you are injecting an AER attributed to a device that isn't 
> > configured, then you are contriving a non-valid system 
> > condition/state, and I'm not surprised that the AER handler fails.  
> > Maybe it needs an update/patch for the aer-inject case.
> >
>      The failure happens once I inject the error to its PF which is 
> configured.
> >>      Any special qemu /stuff is needed to activate the VFIO support ? 
> >> would like to give it a try for a case that VF is attached.
> > I see Alex answered this question.  VFIO rocks! ... Alex did a great 
> > job with it.
> > Definitely cleaned up and more cleanly architected a solution that 
> > will lend itself to incremental for
> > complete reconstruction/duplication for other arches, busses, iommus, 
> > etc. to follow.
>      Alex - have on my setup QEMU which comes as part of RH 6.5, it uses 
> the pci-stub driver, looking for a clear way to replace with a newer one 
> which supports VFIO.
>      Should I just download from GIT and run configure, make & make 
> install or there are other required steps to fully replace ? any pointer 
> to the required steps may help.

Sure, you can compile from git and make install, just don't expect
libvirt on a RHEL6 system to know about vfio.  That doesn't prevent you
from binding devices manually and running QEMU from the commandline.
Alternatively, RHEL7 and recent Fedora (and I assume other recent
distros) should have native vfio support.  Thanks,

Alex

> >>>>> How such cases should work ?  my expectation was that the PF will 
> >>>>> get the
> >>>>> error detected message then will recognize whether
> >>>>> issue is its own or one of its VFs
> >>> The AER packet will have the tag of the VF in if it was the source 
> >>> of the error;
> >>> so the PF will never see it; although one could argue it should be 
> >>> 'promoted'
> >>> to the PF if PF/VF needs to clear some state it has wrt the VF (the 
> >>> SRIOV spec is
> >>> lacking of info in this space); _but_, VFIO resets the VF (sets FLR 
> >>> bit) when the
> >>> device is deassigned and before re-attachment to the host, so that 
> >>> should clear out
> >>> any state btwn PF & VF ('should' ... famous last words...).
> >>      In my test I have used the aer-inject tool simulating an error 
> >> to the BUS that both PF/VF are residing on, putting the function 
> >> number to be the PF one, looks like both should be called by the aer 
> >> driver as part
> >>      of the pci_walk_bus(). As mentioned I got a call only on the PF 
> >> and recovery failed as of the VF doesn't include an AER aware driver, 
> >> once removed the VF recovery succeeded.
> >>      I believe that packet should include some info about the source 
> >> of the error isn't it ?
> > yup.
> >>      In addition, looking at IXGBE upstream source code at 
> >> ixgbe_error_detected()  looks like there is some code running on the 
> >> PF that checks whether the source was a VF.
> > Ping the INTEL gang listed in MAINTAINDERS for ixgbe to see what was 
> > tested, intention of this code wrt AER.
> > Alex Duyck & Greg Rose are the two I've worked with the most on design 
> > issues in the driver, but others @INTEL may be more active in it now.
>      Thanks, may be helpful.
> >
> >>
> >>      By the way: when tried to simulate a VF error using its FN got 
> >> below error:
> >>      "Error: Failed to write, Inappropriate ioctl for device", any 
> >> idea about that error ?
> > details? how did you simulate the error? -- send cmdline used, or code 
> > snippet to inject error, etc.
> > that (quickly) looks like a sysfs error reply when an operation is not 
> > supported to a file/device under it.
>      Working with the downloaded aer-inject-0.1 tool,  command line was 
> ./aer-inject test/aer1
>      content of aer1 file is as below:
>      AER
>      BUS 33 DEV 0 FN 0                  (33 is the decimal value of 21 
> hex value of PF & VF bus number)
>      UNCOR_STATUS POISON_TLP
>      HEADER_LOG 0 1 2 3
> >
> >>>
> >>>>
> >>>> I'm really not an AER expert, so help me understand this question of
> >>>> recognizing whether an error is associated with a PF or a VF.
> >>>>
> >>>> In terms of hardware, it looks like the device that detects an error
> >>>> logs some information and sends an Error Message upstream. The Root
> >>>> Complex receives the message, captures the source ID from the Error
> >>>> Message, and may generate an interrupt.  I expect this source ID can
> >>>> be either a PF or a VF; there's no requirement that a VF error must be
> >>>> reported as though it's from the PF, is there?
> >>>>
> >>>>> and work accordingly, in current code
> >>>>> looks like recovery failed as part of "voting" once there is no 
> >>>>> AER handler
> >>>>> assigned to the VFs.
> >>>>
> >>>> The commit you mentioned has to do with PCI_ERS_RESULT_NO_AER_DRIVER.
> >>>> We use pci_walk_bus() to figure out whether all the devices in a
> >>>> subtree have a driver.  What subtree is involved here?  I would expect
> >>>> the VFs to be siblings of the PF, not children of it, so I'm not sure
> >>>> where things went wrong.
> >>> Well, VFs could be on virtual busses (ARI turned on), so not 
> >>> necessarily a
> >>> sibling to PF ... and then we have the problem in PCI code of not 
> >>> being able
> >>> to traverse these virtual busses (in some cases; not sure if 
> >>> pci_walk_bus(),
> >>> which is going down the tree vs up the tree, has any problems here 
> >>> w/VFs on
> >>> virtual busses).
> >>>
> >>>>
> >>>> Can you collect "lspci -vvv" output and maybe add some debug so we can
> >>>> see exactly where the error is detected and what devices we're looking
> >>>> at to conclude that one of them doesn't have a driver?
> >>      lspci -vvv for both PF & VF is attached, we can see that VF 
> >> (21:00.1) has no driver loaded comparing the PF (Kernel driver in 
> >> use: mlx4_core).
> > um, well, the VF doesn't contain an AER cap strucuture, so expecting 
> > AER support for a pci device (VF or PF) w/o an AER cap is 
> > 'wishful'.... so, the VF can't generate an AER b/c it doesn't have the 
> > appropriate cap regs for the AER handler to use to report the error & 
> > recover from it.
>      In case VF doesn't have AER caps we may expect that once there is 
> an error let its PF that has the AER caps to know about and let it 
> handle it on behalf of the VF, doesn't it make sense ?
>      Do you think that without AER caps for the VF it can work properly 
> under VFIO driver ?
> >
> >>>>
> >>>> Bjorn
> >>>>
> >>>
> >>
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
