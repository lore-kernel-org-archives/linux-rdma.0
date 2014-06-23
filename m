From: Don Dutile <ddutile@redhat.com>
Subject: Re: PCI/AER: AER in SRIOV environment
Date: Mon, 23 Jun 2014 16:12:34 -0400
Message-ID: <53A88A32.4010406@redhat.com>
References: <53A839C6.5050102@dev.mellanox.co.il> <CAErSpo7xVvqYea8v624T8EyVf6skQccraAe_WYpzcf2tkWFLhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo7xVvqYea8v624T8EyVf6skQccraAe_WYpzcf2tkWFLhg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>, Myron Stowe <myron.stowe@redhat.com>, "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "yishaih@mellanox.com" <yishaih@mellanox.com>, liranl@mellanox.com, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 06/23/2014 03:09 PM, Bjorn Helgaas wrote:
> [+cc linux-pci, Don]
>
Adding Alex Williamson in case he can add more to this conversation...

> On Mon, Jun 23, 2014 at 8:29 AM, Yishai Hadas
> <yishaih@dev.mellanox.co.il> wrote:
>> Hi Vijay,
>> Trying to add AER support for Mellanox NIC in SRIOV environment, while
>> evaluating/testing encountered a problem which led me to your
>> patch accepted as part of kernel 3.8, commit ID
>> "918b4053184c0ca22236e70e299c5343eea35304".
>>
>> Have some concerns/questions on:
>> When working in SRIOV environment VFs may be un-attached, having no driver
>> assigned to, or may be attached to Virtual machine to work in some
>> pass-through mode.
>> Once working in KVM setup there is pci-stub driver which is loaded in the
>> HYP/PF for a given attached VF.
huh? 'loaded in the hyp/pf? .... um, loaded in the host, and a VF is
detached from its host driver -- a VF can be used in the host w/o any virtualization,
i.e., that's how guest VM is driving the VF: as if it was used by a guest (host) OS directly --
and attached to pci-stub driver, when assigned to a KVM guest in pre-VFIO days/ways.
If VFIO used, then VF is attached to vfio-pci driver.

>>
>> I'm using the aer-inject kernel module and its corresponding aer-inject tool
>> to simulate an error in the HYP.
>> In both cases your commit will cause the AER recovery to fail as there is no
>> driver assigned to PF's VFs that supports AER, comparing the code before
>> your change.
>>
Without VFIO, I believe that's correct. There was no AER-to-VF support pre-VFIO days.
I believe with the recent VFIO support,
and modifications to KVM, an AER that is associated with an assigned VF will
force the crash/halt of the KVM guest -- can't depend on a guest VF driver clearing
the AER in the hyp/host -- guest isn't privileged enough to clear the error.
So, crashing the guest is the simple option at the moment, to contain the error.
Alex: do I have that (vfio aer default) correct, or is that still site-under-construction?

>> How such cases should work ?  my expectation was that the PF will get the
>> error detected message then will recognize whether
>> issue is its own or one of its VFs
The AER packet will have the tag of the VF in if it was the source of the error;
so the PF will never see it; although one could argue it should be 'promoted'
to the PF if PF/VF needs to clear some state it has wrt the VF (the SRIOV spec is
lacking of info in this space); _but_, VFIO resets the VF (sets FLR bit) when the
device is deassigned and before re-attachment to the host, so that should clear out
any state btwn PF & VF ('should' ... famous last words...).

>
> I'm really not an AER expert, so help me understand this question of
> recognizing whether an error is associated with a PF or a VF.
>
> In terms of hardware, it looks like the device that detects an error
> logs some information and sends an Error Message upstream.  The Root
> Complex receives the message, captures the source ID from the Error
> Message, and may generate an interrupt.  I expect this source ID can
> be either a PF or a VF; there's no requirement that a VF error must be
> reported as though it's from the PF, is there?
>
>> and work accordingly, in current code
>> looks like recovery failed as part of "voting" once there is no AER handler
>> assigned to the VFs.
>
> The commit you mentioned has to do with PCI_ERS_RESULT_NO_AER_DRIVER.
> We use pci_walk_bus() to figure out whether all the devices in a
> subtree have a driver.  What subtree is involved here?  I would expect
> the VFs to be siblings of the PF, not children of it, so I'm not sure
> where things went wrong.
Well, VFs could be on virtual busses (ARI turned on), so not necessarily a
sibling to PF ... and then we have the problem in PCI code of not being able
to traverse these virtual busses (in some cases; not sure if pci_walk_bus(),
which is going down the tree vs up the tree, has any problems here w/VFs on
virtual busses).

>
> Can you collect "lspci -vvv" output and maybe add some debug so we can
> see exactly where the error is detected and what devices we're looking
> at to conclude that one of them doesn't have a driver?
>
> Bjorn
>
