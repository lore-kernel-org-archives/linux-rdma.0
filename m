From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Better handling of PCI BAR assignments
Date: Mon, 8 May 2017 16:24:40 -0400
Message-ID: <06ed547c-b81f-ccb4-5869-4011bb67f7fe@intel.com>
References: <20170508194548.GA9962@oc1783850105.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170508194548.GA9962-i3Uw2LK+iw9rGVE3K263K1aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/08/2017 03:45 PM, Steven Roberts wrote:
> The Ominpath adapter driver fails to load the ppc64le platform due to invalid PCI setup.
> I am recommending this patch to pcie.c which better aligns configuration with linux PCI subsystem functions.  It also fixes the issue.
> Hopefully, this motivates a change.  I am new to the group, so if I am short content, I may need more direction than your experienced members.

Thanks for the patch. We'll work with you offline to get it into the 
right format for Doug to accept.

> --- a/opa-hfi1/pcie.c	2017-05-05 16:59:29.875421435 -0500
> +++ b/opa-hfi1/pcie.c	2017-05-05 17:00:16.745169904 -0500
> @@ -208,8 +208,10 @@
>  	/*
>  	 * Save BARs and command to rewrite after device reset.
>  	 */
> -	dd->pcibar0 = addr;
> -	dd->pcibar1 = addr >> 32;
> +         pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
> +         pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
> +/*      dd->pcibar0 = addr;
> + *      dd->pcibar1 = addr >> 32;*/
>  	pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
>  	pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
>  	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &dd->pcie_devctl);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
