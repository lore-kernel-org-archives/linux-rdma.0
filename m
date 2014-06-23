From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: PCI/AER: AER in SRIOV environment
Date: Tue, 24 Jun 2014 01:44:37 +0300
Message-ID: <53A8ADD5.7030207@dev.mellanox.co.il>
References: <53A839C6.5050102@dev.mellanox.co.il> <CAErSpo7xVvqYea8v624T8EyVf6skQccraAe_WYpzcf2tkWFLhg@mail.gmail.com> <53A88A32.4010406@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040500000106030804050402"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A88A32.4010406-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil-VXdhtT5mjnY@public.gmane.org>, Myron Stowe <myron.stowe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040500000106030804050402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/2014 11:12 PM, Don Dutile wrote:
> On 06/23/2014 03:09 PM, Bjorn Helgaas wrote:
>> [+cc linux-pci, Don]
>>
> Adding Alex Williamson in case he can add more to this conversation...
>
>> On Mon, Jun 23, 2014 at 8:29 AM, Yishai Hadas
>> <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>> Hi Vijay,
>>> Trying to add AER support for Mellanox NIC in SRIOV environment, while
>>> evaluating/testing encountered a problem which led me to your
>>> patch accepted as part of kernel 3.8, commit ID
>>> "918b4053184c0ca22236e70e299c5343eea35304".
>>>
>>> Have some concerns/questions on:
>>> When working in SRIOV environment VFs may be un-attached, having no 
>>> driver
>>> assigned to, or may be attached to Virtual machine to work in some
>>> pass-through mode.
>>> Once working in KVM setup there is pci-stub driver which is loaded 
>>> in the
>>> HYP/PF for a given attached VF.
> huh? 'loaded in the hyp/pf? .... um, loaded in the host, and a VF is
> detached from its host driver -- a VF can be used in the host w/o any 
> virtualization,
> i.e., that's how guest VM is driving the VF: as if it was used by a 
> guest (host) OS directly --
> and attached to pci-stub driver, when assigned to a KVM guest in 
> pre-VFIO days/ways.
> If VFIO used, then VF is attached to vfio-pci driver.
>
>>>
>>> I'm using the aer-inject kernel module and its corresponding 
>>> aer-inject tool
>>> to simulate an error in the HYP.
>>> In both cases your commit will cause the AER recovery to fail as 
>>> there is no
>>> driver assigned to PF's VFs that supports AER, comparing the code 
>>> before
>>> your change.
>>>
> Without VFIO, I believe that's correct. There was no AER-to-VF support 
> pre-VFIO days.
> I believe with the recent VFIO support,
> and modifications to KVM, an AER that is associated with an assigned 
> VF will
> force the crash/halt of the KVM guest -- can't depend on a guest VF 
> driver clearing
> the AER in the hyp/host -- guest isn't privileged enough to clear the 
> error.
> So, crashing the guest is the simple option at the moment, to contain 
> the error.
> Alex: do I have that (vfio aer default) correct, or is that still 
> site-under-construction?
     How about the case that the VF is not attached to a KVM guest and 
has no driver loaded on host ? in such a case from code review and some 
testing the recovery will
     fail as there is no AER aware driver here. What is the expected 
solution here ?
     Any special qemu /stuff is needed to activate the VFIO support ? 
would like to give it a try for a case that VF is attached.
>
>>> How such cases should work ?  my expectation was that the PF will 
>>> get the
>>> error detected message then will recognize whether
>>> issue is its own or one of its VFs
> The AER packet will have the tag of the VF in if it was the source of 
> the error;
> so the PF will never see it; although one could argue it should be 
> 'promoted'
> to the PF if PF/VF needs to clear some state it has wrt the VF (the 
> SRIOV spec is
> lacking of info in this space); _but_, VFIO resets the VF (sets FLR 
> bit) when the
> device is deassigned and before re-attachment to the host, so that 
> should clear out
> any state btwn PF & VF ('should' ... famous last words...).
     In my test I have used the aer-inject tool simulating an error to 
the BUS that both PF/VF are residing on, putting the function number to 
be the PF one, looks like both should be called by the aer driver as part
     of the pci_walk_bus(). As mentioned I got a call only on the PF and 
recovery failed as of the VF doesn't include an AER aware driver, once 
removed the VF recovery succeeded.
     I believe that packet should include some info about the source of 
the error isn't it ?
     In addition, looking at IXGBE upstream source code at 
ixgbe_error_detected()  looks like there is some code running on the PF 
that checks whether the source was a VF.

     By the way: when tried to simulate a VF error using its FN got 
below error:
     "Error: Failed to write, Inappropriate ioctl for device", any idea 
about that error ?
>
>>
>> I'm really not an AER expert, so help me understand this question of
>> recognizing whether an error is associated with a PF or a VF.
>>
>> In terms of hardware, it looks like the device that detects an error
>> logs some information and sends an Error Message upstream.  The Root
>> Complex receives the message, captures the source ID from the Error
>> Message, and may generate an interrupt.  I expect this source ID can
>> be either a PF or a VF; there's no requirement that a VF error must be
>> reported as though it's from the PF, is there?
>>
>>> and work accordingly, in current code
>>> looks like recovery failed as part of "voting" once there is no AER 
>>> handler
>>> assigned to the VFs.
>>
>> The commit you mentioned has to do with PCI_ERS_RESULT_NO_AER_DRIVER.
>> We use pci_walk_bus() to figure out whether all the devices in a
>> subtree have a driver.  What subtree is involved here?  I would expect
>> the VFs to be siblings of the PF, not children of it, so I'm not sure
>> where things went wrong.
> Well, VFs could be on virtual busses (ARI turned on), so not 
> necessarily a
> sibling to PF ... and then we have the problem in PCI code of not 
> being able
> to traverse these virtual busses (in some cases; not sure if 
> pci_walk_bus(),
> which is going down the tree vs up the tree, has any problems here 
> w/VFs on
> virtual busses).
>
>>
>> Can you collect "lspci -vvv" output and maybe add some debug so we can
>> see exactly where the error is detected and what devices we're looking
>> at to conclude that one of them doesn't have a driver?
     lspci -vvv for both PF & VF is attached, we can see that VF 
(21:00.1) has no driver loaded comparing the PF (Kernel driver in use: 
mlx4_core).
>>
>> Bjorn
>>
>


--------------040500000106030804050402
Content-Type: text/plain; charset=windows-1252;
 name="lspci.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lspci.txt"

MjE6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXI6IE1lbGxhbm94IFRlY2hub2xvZ2llcyBNVDI3
NTAwIEZhbWlseSBbQ29ubmVjdFgtM10NCiAgICAgICAgU3Vic3lzdGVtOiBIZXdsZXR0LVBh
Y2thcmQgQ29tcGFueSBEZXZpY2UgMThjZg0KICAgICAgICBQaHlzaWNhbCBTbG90OiAyDQog
ICAgICAgIENvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lO
Vi0gVkdBU25vb3AtIFBhckVycisgU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgr
DQogICAgICAgIFN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERF
VlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5U
eC0NCiAgICAgICAgTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcw0KICAg
ICAgICBJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgNjQNCiAgICAgICAgUmVnaW9u
IDA6IE1lbW9yeSBhdCBmYmYwMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6
ZT0xTV0NCiAgICAgICAgUmVnaW9uIDI6IE1lbW9yeSBhdCBmODAwMDAwMCAoNjQtYml0LCBw
cmVmZXRjaGFibGUpIFtzaXplPTMyTV0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNDBdIFBv
d2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzDQogICAgICAgICAgICAgICAgRmxhZ3M6IFBNRUNs
ay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdC0s
RDNjb2xkLSkNCiAgICAgICAgICAgICAgICBTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVu
YWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNDhd
IFZpdGFsIFByb2R1Y3QgRGF0YQ0KICAgICAgICAgICAgICAgIFByb2R1Y3QgTmFtZTogSFAg
Q29ubmVjdFgtMyBNZXp6DQogICAgICAgICAgICAgICAgUmVhZC1vbmx5IGZpZWxkczoNCiAg
ICAgICAgICAgICAgICAgICAgICAgIFtQTl0gUGFydCBudW1iZXI6IDY0NDE2MS1CMjENCiAg
ICAgICAgICAgICAgICAgICAgICAgIFtFQ10gRW5naW5lZXJpbmcgY2hhbmdlczogQzQNCiAg
ICAgICAgICAgICAgICAgICAgICAgIFtTTl0gU2VyaWFsIG51bWJlcjogSUwyMjQyMDJWVw0K
ICAgICAgICAgICAgICAgICAgICAgICAgW1YwXSBWZW5kb3Igc3BlY2lmaWM6IEhQIElCIEZE
Ui9FTiAxMC80MEdiIDJQIDU0NE0gQWRwdHINCiAgICAgICAgICAgICAgICAgICAgICAgIFtS
Vl0gUmVzZXJ2ZWQ6IGNoZWNrc3VtIGdvb2QsIDAgYnl0ZShzKSByZXNlcnZlZA0KICAgICAg
ICAgICAgICAgIFJlYWQvd3JpdGUgZmllbGRzOg0KICAgICAgICAgICAgICAgICAgICAgICAg
W1YxXSBWZW5kb3Igc3BlY2lmaWM6IE4vQQ0KICAgICAgICAgICAgICAgICAgICAgICAgW1lB
XSBBc3NldCB0YWc6IE4vQQ0KICAgICAgICAgICAgICAgICAgICAgICAgW1JXXSBSZWFkLXdy
aXRlIGFyZWE6IDEwMiBieXRlKHMpIGZyZWUNCiAgICAgICAgICAgICAgICAgICAgICAgIFtS
V10gUmVhZC13cml0ZSBhcmVhOiAyNTMgYnl0ZShzKSBmcmVlDQogICAgICAgICAgICAgICAg
ICAgICAgICBbUlddIFJlYWQtd3JpdGUgYXJlYTogMjUzIGJ5dGUocykgZnJlZQ0KICAgICAg
ICAgICAgICAgICAgICAgICAgW1JXXSBSZWFkLXdyaXRlIGFyZWE6IDI1MyBieXRlKHMpIGZy
ZWUNCiAgICAgICAgICAgICAgICAgICAgICAgIFtSV10gUmVhZC13cml0ZSBhcmVhOiAyNTMg
Ynl0ZShzKSBmcmVlDQogICAgICAgICAgICAgICAgICAgICAgICBbUlddIFJlYWQtd3JpdGUg
YXJlYTogMjUzIGJ5dGUocykgZnJlZQ0KICAgICAgICAgICAgICAgICAgICAgICAgW1JXXSBS
ZWFkLXdyaXRlIGFyZWE6IDI1MyBieXRlKHMpIGZyZWUNCiAgICAgICAgICAgICAgICAgICAg
ICAgIFtSV10gUmVhZC13cml0ZSBhcmVhOiAyNTMgYnl0ZShzKSBmcmVlDQogICAgICAgICAg
ICAgICAgICAgICAgICBbUlddIFJlYWQtd3JpdGUgYXJlYTogMjUzIGJ5dGUocykgZnJlZQ0K
ICAgICAgICAgICAgICAgICAgICAgICAgW1JXXSBSZWFkLXdyaXRlIGFyZWE6IDI1MyBieXRl
KHMpIGZyZWUNCiAgICAgICAgICAgICAgICAgICAgICAgIFtSV10gUmVhZC13cml0ZSBhcmVh
OiAyNTMgYnl0ZShzKSBmcmVlDQogICAgICAgICAgICAgICAgICAgICAgICBbUlddIFJlYWQt
d3JpdGUgYXJlYTogMjUzIGJ5dGUocykgZnJlZQ0KICAgICAgICAgICAgICAgICAgICAgICAg
W1JXXSBSZWFkLXdyaXRlIGFyZWE6IDI1MyBieXRlKHMpIGZyZWUNCiAgICAgICAgICAgICAg
ICAgICAgICAgIFtSV10gUmVhZC13cml0ZSBhcmVhOiAyNTMgYnl0ZShzKSBmcmVlDQogICAg
ICAgICAgICAgICAgICAgICAgICBbUlddIFJlYWQtd3JpdGUgYXJlYTogMjUzIGJ5dGUocykg
ZnJlZQ0KICAgICAgICAgICAgICAgICAgICAgICAgW1JXXSBSZWFkLXdyaXRlIGFyZWE6IDI1
MiBieXRlKHMpIGZyZWUNCiAgICAgICAgICAgICAgICBFbmQNCiAgICAgICAgQ2FwYWJpbGl0
aWVzOiBbOWNdIE1TSS1YOiBFbmFibGUrIENvdW50PTEyOCBNYXNrZWQtDQogICAgICAgICAg
ICAgICAgVmVjdG9yIHRhYmxlOiBCQVI9MCBvZmZzZXQ9MDAwN2MwMDANCiAgICAgICAgICAg
ICAgICBQQkE6IEJBUj0wIG9mZnNldD0wMDA3ZDAwMA0KICAgICAgICBDYXBhYmlsaXRpZXM6
IFs2MF0gRXhwcmVzcyAodjIpIEVuZHBvaW50LCBNU0kgMDANCiAgICAgICAgICAgICAgICBE
ZXZDYXA6IE1heFBheWxvYWQgMjU2IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMg
PDY0bnMsIEwxIHVubGltaXRlZA0KICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBB
dHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldCsNCiAgICAgICAgICAgICAg
ICBEZXZDdGw6IFJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwrIEZhdGFs
KyBVbnN1cHBvcnRlZC0NCiAgICAgICAgICAgICAgICAgICAgICAgIFJseGRPcmQtIEV4dFRh
Zy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtIEZMUmVzZXQtDQogICAgICAgICAgICAg
ICAgICAgICAgICBNYXhQYXlsb2FkIDI1NiBieXRlcywgTWF4UmVhZFJlcSA0MDk2IGJ5dGVz
DQogICAgICAgICAgICAgICAgRGV2U3RhOiBDb3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJy
LSBVbnN1cHBSZXErIEF1eFB3ci0gVHJhbnNQZW5kLQ0KICAgICAgICAgICAgICAgIExua0Nh
cDogUG9ydCAjOCwgU3BlZWQgOEdUL3MsIFdpZHRoIHg4LCBBU1BNIEwwcywgTGF0ZW5jeSBM
MCB1bmxpbWl0ZWQsIEwxIHVubGltaXRlZA0KICAgICAgICAgICAgICAgICAgICAgICAgQ2xv
Y2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0NCiAgICAgICAgICAgICAgICBMbmtD
dGw6IEFTUE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29t
bUNsay0NCiAgICAgICAgICAgICAgICAgICAgICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBBdXRX
aWREaXMtIEJXSW50LSBBdXRCV0ludC0NCiAgICAgICAgICAgICAgICBMbmtTdGE6IFNwZWVk
IDhHVC9zLCBXaWR0aCB4OCwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldN
Z210LSBBQldNZ210LQ0KICAgICAgICAgICAgICAgIERldkNhcDI6IENvbXBsZXRpb24gVGlt
ZW91dDogUmFuZ2UgQUJDRCwgVGltZW91dERpcyssIExUUi0sIE9CRkYgTm90IFN1cHBvcnRl
ZA0KICAgICAgICAgICAgICAgIERldkN0bDI6IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0
byA1MG1zLCBUaW1lb3V0RGlzLSwgTFRSLSwgT0JGRiBEaXNhYmxlZA0KICAgICAgICAgICAg
ICAgIExua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiA4R1QvcywgRW50ZXJDb21wbGlhbmNl
LSBTcGVlZERpcy0NCiAgICAgICAgICAgICAgICAgICAgICAgICBUcmFuc21pdCBNYXJnaW46
IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBDb21w
bGlhbmNlU09TLQ0KICAgICAgICAgICAgICAgICAgICAgICAgIENvbXBsaWFuY2UgRGUtZW1w
aGFzaXM6IC02ZEINCiAgICAgICAgICAgICAgICBMbmtTdGEyOiBDdXJyZW50IERlLWVtcGhh
c2lzIExldmVsOiAtNmRCLCBFcXVhbGl6YXRpb25Db21wbGV0ZSssIEVxdWFsaXphdGlvblBo
YXNlMSsNCiAgICAgICAgICAgICAgICAgICAgICAgICBFcXVhbGl6YXRpb25QaGFzZTIrLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0NCiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBBbHRlcm5hdGl2ZSBSb3V0aW5nLUlEIEludGVycHJl
dGF0aW9uIChBUkkpDQogICAgICAgICAgICAgICAgQVJJQ2FwOiBNRlZDLSBBQ1MtLCBOZXh0
IEZ1bmN0aW9uOiAwDQogICAgICAgICAgICAgICAgQVJJQ3RsOiBNRlZDLSBBQ1MtLCBGdW5j
dGlvbiBHcm91cDogMA0KICAgICAgICBDYXBhYmlsaXRpZXM6IFsxNDggdjFdIERldmljZSBT
ZXJpYWwgTnVtYmVyIDI0LWJlLTA1LWZmLWZmLThiLTZiLWQwDQogICAgICAgIENhcGFiaWxp
dGllczogWzEwOCB2MV0gU2luZ2xlIFJvb3QgSS9PIFZpcnR1YWxpemF0aW9uIChTUi1JT1Yp
DQogICAgICAgICAgICAgICAgSU9WQ2FwOiBNaWdyYXRpb24tLCBJbnRlcnJ1cHQgTWVzc2Fn
ZSBOdW1iZXI6IDAwMA0KICAgICAgICAgICAgICAgIElPVkN0bDogRW5hYmxlKyBNaWdyYXRp
b24tIEludGVycnVwdC0gTVNFKyBBUklIaWVyYXJjaHkrDQogICAgICAgICAgICAgICAgSU9W
U3RhOiBNaWdyYXRpb24tDQogICAgICAgICAgICAgICAgSW5pdGlhbCBWRnM6IDE2LCBUb3Rh
bCBWRnM6IDE2LCBOdW1iZXIgb2YgVkZzOiAxLCBGdW5jdGlvbiBEZXBlbmRlbmN5IExpbms6
IDAwDQogICAgICAgICAgICAgICAgVkYgb2Zmc2V0OiAxLCBzdHJpZGU6IDEsIERldmljZSBJ
RDogMTAwNA0KICAgICAgICAgICAgICAgIFN1cHBvcnRlZCBQYWdlIFNpemU6IDAwMDAwN2Zm
LCBTeXN0ZW0gUGFnZSBTaXplOiAwMDAwMDAwMQ0KICAgICAgICAgICAgICAgIFJlZ2lvbiAy
OiBNZW1vcnkgYXQgMDAwMDAwMDBkODAwMDAwMCAoNjQtYml0LCBwcmVmZXRjaGFibGUpDQog
ICAgICAgICAgICAgICAgVkYgTWlncmF0aW9uOiBvZmZzZXQ6IDAwMDAwMDAwLCBCSVI6IDAN
CiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbMTU0IHYyXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRp
bmcNCiAgICAgICAgICAgICAgICBVRVN0YTogIERMUC0gU0RFUy0gVExQLSBGQ1AtIENtcGx0
VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1hbGZUTFAtIEVDUkMtIFVuc3VwUmVx
KyBBQ1NWaW9sLQ0KICAgICAgICAgICAgICAgIFVFTXNrOiAgRExQLSBTREVTLSBUTFAtIEZD
UC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0g
VW5zdXBSZXErIEFDU1Zpb2wtDQogICAgICAgICAgICAgICAgVUVTdnJ0OiBETFAtIFNERVMt
IFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQ
LSBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0NCiAgICAgICAgICAgICAgICBDRVN0YTogIFJ4
RXJyLSBCYWRUTFAtIEJhZERMTFAtIFJvbGxvdmVyLSBUaW1lb3V0LSBOb25GYXRhbEVycisN
CiAgICAgICAgICAgICAgICBDRU1zazogIFJ4RXJyLSBCYWRUTFAtIEJhZERMTFAtIFJvbGxv
dmVyLSBUaW1lb3V0LSBOb25GYXRhbEVyci0NCiAgICAgICAgICAgICAgICBBRVJDYXA6IEZp
cnN0IEVycm9yIFBvaW50ZXI6IDAwLCBHZW5DYXArIENHZW5Fbi0gQ2hrQ2FwKyBDaGtFbi0N
CiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbMThjIHYxXSAjMTkNCiAgICAgICAgS2VybmVsIGRy
aXZlciBpbiB1c2U6IG1seDRfY29yZQ0KICAgICAgICBLZXJuZWwgbW9kdWxlczogbWx4NF9j
b3JlDQoJCQ0KMjE6MDAuMSBOZXR3b3JrIGNvbnRyb2xsZXI6IE1lbGxhbm94IFRlY2hub2xv
Z2llcyBNVDI3NTAwIEZhbWlseSBbQ29ubmVjdFgtMyBWaXJ0dWFsIEZ1bmN0aW9uXQ0KICAg
ICAgICBTdWJzeXN0ZW06IEhld2xldHQtUGFja2FyZCBDb21wYW55IERldmljZSA2MWIwDQog
ICAgICAgIFBoeXNpY2FsIFNsb3Q6IDINCiAgICAgICAgQ29udHJvbDogSS9PLSBNZW0tIEJ1
c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGlu
Zy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0NCiAgICAgICAgU3RhdHVzOiBDYXArIDY2TUh6
LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQ0KICAgICAgICBSZWdpb24gMjogW3ZpcnR1
YWxdIE1lbW9yeSBhdCBkODAwMDAwMCAoNjQtYml0LCBwcmVmZXRjaGFibGUpIFtzaXplPTMy
TV0NCiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbNjBdIEV4cHJlc3MgKHYyKSBFbmRwb2ludCwg
TVNJIDAwDQogICAgICAgICAgICAgICAgRGV2Q2FwOiBNYXhQYXlsb2FkIDI1NiBieXRlcywg
UGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzDQogICAgICAgICAgICAg
ICAgICAgICAgICBFeHRUYWctIEF0dG5CdG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFLSBGTFJl
c2V0Kw0KICAgICAgICAgICAgICAgIERldkN0bDogUmVwb3J0IGVycm9yczogQ29ycmVjdGFi
bGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0gRkxS
ZXNldC0NCiAgICAgICAgICAgICAgICAgICAgICAgIE1heFBheWxvYWQgMTI4IGJ5dGVzLCBN
YXhSZWFkUmVxIDEyOCBieXRlcw0KICAgICAgICAgICAgICAgIERldlN0YTogQ29yckVyci0g
VW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3ItIFRyYW5zUGVuZC0NCiAg
ICAgICAgICAgICAgICBMbmtDYXA6IFBvcnQgIzAsIFNwZWVkIDhHVC9zLCBXaWR0aCB4OCwg
QVNQTSB1bmtub3duLCBMYXRlbmN5IEwwIDw2NG5zLCBMMSA8MXVzDQogICAgICAgICAgICAg
ICAgICAgICAgICBDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90LQ0KICAgICAg
ICAgICAgICAgIExua0N0bDogQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVk
LSBSZXRyYWluLSBDb21tQ2xrLQ0KICAgICAgICAgICAgICAgICAgICAgICAgRXh0U3luY2gt
IENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQ0KICAgICAgICAgICAgICAg
IExua1N0YTogU3BlZWQgdW5rbm93biwgV2lkdGggeDAsIFRyRXJyLSBUcmFpbi0gU2xvdENs
ay0gRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0NCiAgICAgICAgICAgICAgICBEZXZDYXAy
OiBDb21wbGV0aW9uIFRpbWVvdXQ6IFJhbmdlIEFCQ0QsIFRpbWVvdXREaXMrLCBMVFItLCBP
QkZGIE5vdCBTdXBwb3J0ZWQNCiAgICAgICAgICAgICAgICBEZXZDdGwyOiBDb21wbGV0aW9u
IFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0sIExUUi0sIE9CRkYgRGlzYWJs
ZWQNCiAgICAgICAgICAgICAgICBMbmtTdGEyOiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVs
OiAtNmRCLCBFcXVhbGl6YXRpb25Db21wbGV0ZS0sIEVxdWFsaXphdGlvblBoYXNlMS0NCiAg
ICAgICAgICAgICAgICAgICAgICAgICBFcXVhbGl6YXRpb25QaGFzZTItLCBFcXVhbGl6YXRp
b25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0NCiAgICAgICAgQ2FwYWJpbGl0
aWVzOiBbOWNdIE1TSS1YOiBFbmFibGUtIENvdW50PTI1NiBNYXNrZWQtDQogICAgICAgICAg
ICAgICAgVmVjdG9yIHRhYmxlOiBCQVI9MiBvZmZzZXQ9MDAwMDIwMDANCiAgICAgICAgICAg
ICAgICBQQkE6IEJBUj0yIG9mZnNldD0wMDAwMzAwMA0KICAgICAgICBDYXBhYmlsaXRpZXM6
IFs0MF0gIzAwIFswMDAwXQ0KICAgICAgICBLZXJuZWwgbW9kdWxlczogbWx4NF9jb3JlDQoJ
CQ0KCQk=
--------------040500000106030804050402--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
