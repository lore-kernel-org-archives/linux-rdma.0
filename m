From: Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>
Subject: Re: Warning: mthca/qib : removal of PCI_CAP_ID_EXP
Date: Fri, 1 Jul 2011 10:07:35 -0500
Message-ID: <BANLkTimT5SaRupWoC+60sgdgsvW2a_T3_g@mail.gmail.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
	<4E0CDF8B.3020505@emulex.com>
	<6dbdff99-df75-4456-ac0e-b35ac475f079@exht1.ad.emulex.com>
	<35AAF1E4A771E142979F27B51793A4888838F2367E@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888838F2367E-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: James Smart <james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Lary <rlary-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

pci_is_pcie checks for a PCI-E capability offset that was determined
by calling pci_find_capability during the PCI bus walking.  Based on
the description below this should be functionally equivalent.  If
this is not safe, then the PCI bus walking code is most likely busted
on EEH enabled PPC systems (and that is a BIG problem).  I'll e-mail
the PPC mailing list to verify the issue.

Thanks,
Jon

On Fri, Jul 1, 2011 at 10:01 AM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> The patch was ok here, but we only support x86_64.
>
> Mike
>
>> -----Original Message-----
>> From: James Smart [mailto:james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org]
>> Sent: Friday, July 01, 2011 10:49 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: James Smart; Jon Mason; Richard Lary; Mike Marciniszyn;
>> eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org; jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org
>> Subject: Warning: mthca/qib : removal of PCI_CAP_ID_EXP
>>
>> All,
>>
>> I wanted to communicate a potential warning to those drivers that ha=
d a
>> patch
>> submitted to replace config space searches of PCI_CAP_ID_EXP with
>> shorthand
>> options such as is_pcie and pci_is_pcie().
>>
>> Testing with the lpfc driver and AER/EEH identified cases where the
>> short-hand
>> search options would fail on PPC platforms. =A0The only successful o=
ption
>> in all
>> cases was the explicit search via PCI_CAP_ID_EXP. =A0 Therefore, I
>> recommend
>> that this change not be accepted until the platform level issue can =
be
>> identified and corrected.
>>
>> -- james s
>>
>>
>>
>> On 6/30/2011 4:41 PM, James Smart wrote:
>> > Jon,
>> >
>> > I must NACK this patch to the lpfc driver and recommend that all
>> other patches
>> > which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with
>> > "pci_is_pcie(pdev)" are NACK'd as well.
>> >
>> > The reason is due to an issue on PPC platforms whereby use of "pde=
v-
>> >is_pcie"
>> > and pci_is_pcie() will erroneously fail under some conditions, but
>> explicit
>> > search for the capability struct via pci_find_capability() is alwa=
ys
>> > successful. =A0 I expect this to be due a shadowing of pci config =
space
>> in the
>> > hal/platform that isn't sufficiently built up. =A0We detected this
>> issue while
>> > testing AER/EEH, and are functional only if the pci_find_capabilit=
y()
>> option
>> > is used.
>> >
>> > -- james s
>> >
>> >
>> >
>> > On 6/27/2011 1:39 PM, Jon Mason wrote:
>> >> The PCIE capability offset is saved during PCI bus walking. =A0It=
 will
>> >> remove an unnecessary search in the PCI configuration space if th=
is
>> >> value is referenced instead of reacquiring it. =A0Also, pci_is_pc=
ie is
>> a
>> >> better way of determining if the device is PCIE or not (as it use=
s
>> the
>> >> same saved PCIE capability offset).
>> >>
>> >> Signed-off-by: Jon Mason<jdmason-zqedIHPRSYI@public.gmane.org>
>> >> ---
>> >> =A0 =A0drivers/scsi/lpfc/lpfc_init.c | =A0 =A02 +-
>> >> =A0 =A01 files changed, 1 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/drivers/scsi/lpfc/lpfc_init.c
>> b/drivers/scsi/lpfc/lpfc_init.c
>> >> index 148b98d..9000ad0 100644
>> >> --- a/drivers/scsi/lpfc/lpfc_init.c
>> >> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> >> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>> >> =A0 =A0 =A0 =A0 =A0 =A0pci_save_state(pdev);
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0/* PCIe EEH recovery on powerpc platforms =
needs fundamental
>> reset */
>> >> - =A0if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
>> >> + =A0if (pci_is_pcie(pdev))
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdev->needs_freset =3D 1;
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0return 0;
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-sc=
si"
>> in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>
>
> This message and any attached documents contain information from QLog=
ic Corporation or its wholly-owned subsidiaries that may be confidentia=
l. If you are not the intended recipient, you may not read, copy, distr=
ibute, or use this information. If you have received this transmission =
in error, please notify the sender immediately by reply e-mail and then=
 delete this message.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
