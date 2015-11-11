From: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
 description
Date: Wed, 11 Nov 2015 14:03:02 +0000
Message-ID: <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19F69@FMSMSX102.amr.corp.intel.com>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
 <1447227213-15122-12-git-send-email-jubin.john@intel.com>
 <20151111084439.GA18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111084439.GA18797@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dan Carpenter
> Sent: Wednesday, November 11, 2015 2:45 AM
> To: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
> description
> 
> On Wed, Nov 11, 2015 at 02:33:32AM -0500, Jubin John wrote:
> > +static int read_efi_var(const char *name, unsigned long *size,
> > +			void **return_data)
> > +{
> > +	int ret;
> > +
> > +	/* set failure return values */
> > +	*size = 0;
> > +	*return_data = NULL;
> > +
> > +	/*
> > +	 * Use EFI run-time support to obtain an EFI variable.  Support may
> > +	 * be compiled out, so declare all variables inside.
> > +	 */
> > +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> 
> 
> Flip this around:
> 
> 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> 		return -ENOSYS;

The style here is very deliberate.

The issue is how efi_enabled() is defined via CONFIG options.  The function can be turned into a 0 if certain CONFIG variables are not set.  The code is structured to make all of the dependent variables disappear if efi_enabled() becomes 0.  If the code is shifted as you suggest, we will get builds from the automatic builders that try all combinations with unused variables.  This was done to avoid that.  

The question: Which is preferred?


> > +		efi_status_t status;
> > +		efi_char16_t *uni_name;
> > +		efi_guid_t guid;
> > +		unsigned long temp_size;
> > +		void *temp_buffer;
> > +		void *data;
> > +		int i;
> > +
> > +		uni_name = kzalloc(sizeof(efi_char16_t) * (strlen(name) + 1),
> > +				   GFP_KERNEL);
> > +		temp_buffer = kzalloc(EFI_DATA_SIZE, GFP_KERNEL);
> > +		data = NULL;
> 
> No need.
> 
> > +
> > +		if (!uni_name || !temp_buffer) {
> > +			ret = -ENOMEM;
> > +			goto fail;
> > +		}
> > +
> > +		/* input: the size of the buffer */
> > +		temp_size = EFI_DATA_SIZE;
> > +
> > +		/* convert ASCII to unicode - it is a 1:1 mapping */
> > +		for (i = 0; name[i]; i++)
> > +			uni_name[i] = name[i];
> > +
> > +		/* need a variable for our GUID */
> > +		guid = HFI1_EFIVAR_GUID;
> > +
> > +		/* call into EFI runtime services */
> > +		status = efi.get_variable(
> > +				uni_name,
> > +				&guid,
> > +				NULL,
> > +				&temp_size,
> > +				temp_buffer);
> > +
> > +		/*
> > +		 * It would be nice to call efi_status_to_err() here, but that
> > +		 * is in the EFIVAR_FS code and may not be compiled in.
> > +		 * However, even that is insufficient since it does not cover
> > +		 * EFI_BUFFER_TOO_SMALL which could be an important
> return.
> > +		 * For now, just split out succces or not found.
> > +		 */
> > +		ret = status == EFI_SUCCESS   ? 0 :
> > +		      status == EFI_NOT_FOUND ? -ENOENT :
> > +						-EINVAL;
> > +
> > +		if (!ret) {
> > +			/*
> > +			 * We have successfully read the EFI variable into our
> > +			 * temporary buffer.  Now allocate a correctly sized
> > +			 * buffer.
> > +			 */
> > +			data = kmalloc(temp_size, GFP_KERNEL);
> > +			if (data) {
> > +				memcpy(data, temp_buffer, temp_size);
> > +				*size = temp_size;
> > +				*return_data = data;
> > +			} else {
> > +				ret = -ENOMEM;
> > +			}
> > +		}
> 
> People often change the last two conditions in the function from
> error handling to success handling.  I have ranted about it before many
> times so I should just paste a previous rant instead of commenting here.
> :P
> 
> http://www.spinics.net/lists/arm-kernel/msg457849.html
> 
> Success handling makes this look more complicated than it really is.
> This code is just a string of commands in a row with error handling.  No
> need for if statements or indenting.  Here is how it looks when it's
> pulled in one indent level and changed from success handling to error
> handling.
> 
> 	ret = status == EFI_SUCCESS   ? 0 :
> 	      status == EFI_NOT_FOUND ? -ENOENT : -EINVAL;
> 	if (ret)
> 		goto free;
> 
> 	data = kmemdup(data, temp_size, GFP_KERNEL);
> 	if (!data) {
> 		ret = -ENOMEM;
> 		goto free;
> 	}
> 
> 	*size = temp_size;
> 	*return_data = data;
> 
> free:
> 	kfree(uni_name);
> 	kfree(temp_buffer);
> 
> 	return ret;
> 
> > +
> > +fail:
> > +		kfree(uni_name);
> > +		kfree(temp_buffer);
> > +	} else {
> > +		ret = -ENOSYS;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Read an HFI1 EFI variable of the form:
> > + *	<PCIe address>-<kind>
> > + * Return an kalloc'ed array and size of the data.
> > + *
> > + * Returns 0 on success, -errno on failure.
> > + */
> > +int read_hfi1_efi_var(struct hfi1_devdata *dd, const char *kind,
> > +		      unsigned long *size, void **return_data)
> > +{
> > +	char name[64];
> > +
> > +	/* create a common prefix */
> > +	snprintf(name, sizeof(name), "%04x:%02x:%02x.%x-%s",
> > +		 pci_domain_nr(dd->pcidev->bus),
> > +		 dd->pcidev->bus->number,
> > +		 PCI_SLOT(dd->pcidev->devfn),
> > +		 PCI_FUNC(dd->pcidev->devfn),
> > +		 kind);
> > +	name[sizeof(name) - 1] = 0; /* make sure the string is terminated */
> 
> No need.  snprintf() always puts a NUL terminator (technically it
> doesn't if the sizeof(name) is zero, I suppose).
> 
> > +
> > +	return read_efi_var(name, size, return_data);
> > +}
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
