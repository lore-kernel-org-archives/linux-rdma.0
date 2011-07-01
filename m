From: James Smart <james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: Warning: mthca/qib  : removal of PCI_CAP_ID_EXP
Date: Fri, 1 Jul 2011 10:49:12 -0400
Message-ID: <6dbdff99-df75-4456-ac0e-b35ac475f079@exht1.ad.emulex.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us> <4E0CDF8B.3020505@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E0CDF8B.3020505-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James Smart <james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Jon Mason <jdmason-zqedIHPRSYI@public.gmane.org>, Richard Lary <rlary-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

All,

I wanted to communicate a potential warning to those drivers that had a patch 
submitted to replace config space searches of PCI_CAP_ID_EXP with shorthand 
options such as is_pcie and pci_is_pcie().

Testing with the lpfc driver and AER/EEH identified cases where the short-hand 
search options would fail on PPC platforms.  The only successful option in all 
cases was the explicit search via PCI_CAP_ID_EXP.   Therefore, I recommend 
that this change not be accepted until the platform level issue can be 
identified and corrected.

-- james s



On 6/30/2011 4:41 PM, James Smart wrote:
> Jon,
>
> I must NACK this patch to the lpfc driver and recommend that all other patches
> which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with
> "pci_is_pcie(pdev)" are NACK'd as well.
>
> The reason is due to an issue on PPC platforms whereby use of "pdev->is_pcie"
> and pci_is_pcie() will erroneously fail under some conditions, but explicit
> search for the capability struct via pci_find_capability() is always
> successful.   I expect this to be due a shadowing of pci config space in the
> hal/platform that isn't sufficiently built up.  We detected this issue while
> testing AER/EEH, and are functional only if the pci_find_capability() option
> is used.
>
> -- james s
>
>
>
> On 6/27/2011 1:39 PM, Jon Mason wrote:
>> The PCIE capability offset is saved during PCI bus walking.  It will
>> remove an unnecessary search in the PCI configuration space if this
>> value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
>> better way of determining if the device is PCIE or not (as it uses the
>> same saved PCIE capability offset).
>>
>> Signed-off-by: Jon Mason<jdmason-zqedIHPRSYI@public.gmane.org>
>> ---
>>    drivers/scsi/lpfc/lpfc_init.c |    2 +-
>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>> index 148b98d..9000ad0 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>    	pci_save_state(pdev);
>>
>>    	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
>> -	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
>> +	if (pci_is_pcie(pdev))
>>    		pdev->needs_freset = 1;
>>
>>    	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
