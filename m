From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: PCI/IB: add support for pci driver attribute groups
Date: Tue, 1 Aug 2017 16:40:46 -0500
Message-ID: <20170801214046.GB26498@bhelgaas-glaptop.roam.corp.google.com>
References: <20170719130106.GE17776@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170719130106.GE17776@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 19, 2017 at 03:01:06PM +0200, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Some drivers (specifically the nes IB driver), want to create a lot of
> sysfs driver attributes.  Instead of open-coding the creation and
> removal of these files (and getting it wrong btw), it's a better idea to
> let the driver core handle all of this logic for us.
> 
> So add a new field to the pci driver structure, **groups, that allows
> pci drivers to specify an attribute group list it wishes to have created
> when it is registered with the driver core.
> 
> Big bonus is now the driver doesn't race with userspace when the sysfs
> files are created vs. when the kobject is announced, so any script/tool
> that actually wanted to use these files will not have to poll waiting
> for them to show up.
> 
> Cc: Faisal Latif <faisal.latif@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

If you want me to take this let me know; otherwise I'll assume Doug will
merge it.

> ---
>  drivers/infiniband/hw/nes/nes.c |   69 +++++++++++++---------------------------
>  drivers/pci/pci-driver.c        |    1 
>  include/linux/pci.h             |    1 
>  3 files changed, 26 insertions(+), 45 deletions(-)
> 
> --- a/drivers/infiniband/hw/nes/nes.c
> +++ b/drivers/infiniband/hw/nes/nes.c
> @@ -808,13 +808,6 @@ static void nes_remove(struct pci_dev *p
>  }
>  
>  
> -static struct pci_driver nes_pci_driver = {
> -	.name = DRV_NAME,
> -	.id_table = nes_pci_table,
> -	.probe = nes_probe,
> -	.remove = nes_remove,
> -};
> -
>  static ssize_t adapter_show(struct device_driver *ddp, char *buf)
>  {
>  	unsigned int  devfn = 0xffffffff;
> @@ -1156,35 +1149,29 @@ static DRIVER_ATTR_RW(idx_addr);
>  static DRIVER_ATTR_RW(idx_data);
>  static DRIVER_ATTR_RW(wqm_quanta);
>  
> -static int nes_create_driver_sysfs(struct pci_driver *drv)
> -{
> -	int error;
> -	error  = driver_create_file(&drv->driver, &driver_attr_adapter);
> -	error |= driver_create_file(&drv->driver, &driver_attr_eeprom_cmd);
> -	error |= driver_create_file(&drv->driver, &driver_attr_eeprom_data);
> -	error |= driver_create_file(&drv->driver, &driver_attr_flash_cmd);
> -	error |= driver_create_file(&drv->driver, &driver_attr_flash_data);
> -	error |= driver_create_file(&drv->driver, &driver_attr_nonidx_addr);
> -	error |= driver_create_file(&drv->driver, &driver_attr_nonidx_data);
> -	error |= driver_create_file(&drv->driver, &driver_attr_idx_addr);
> -	error |= driver_create_file(&drv->driver, &driver_attr_idx_data);
> -	error |= driver_create_file(&drv->driver, &driver_attr_wqm_quanta);
> -	return error;
> -}
> -
> -static void nes_remove_driver_sysfs(struct pci_driver *drv)
> -{
> -	driver_remove_file(&drv->driver, &driver_attr_adapter);
> -	driver_remove_file(&drv->driver, &driver_attr_eeprom_cmd);
> -	driver_remove_file(&drv->driver, &driver_attr_eeprom_data);
> -	driver_remove_file(&drv->driver, &driver_attr_flash_cmd);
> -	driver_remove_file(&drv->driver, &driver_attr_flash_data);
> -	driver_remove_file(&drv->driver, &driver_attr_nonidx_addr);
> -	driver_remove_file(&drv->driver, &driver_attr_nonidx_data);
> -	driver_remove_file(&drv->driver, &driver_attr_idx_addr);
> -	driver_remove_file(&drv->driver, &driver_attr_idx_data);
> -	driver_remove_file(&drv->driver, &driver_attr_wqm_quanta);
> -}
> +static struct attribute *nes_attrs[] = {
> +	&driver_attr_adapter,
> +	&driver_attr_eeprom_cmd,
> +	&driver_attr_eeprom_data,
> +	&driver_attr_flash_cmd,
> +	&driver_attr_flash_data,
> +	&driver_attr_nonidx_addr,
> +	&driver_attr_nonidx_data,
> +	&driver_attr_idx_addr,
> +	&driver_attr_idx_data,
> +	&driver_attr_wqm_quanta,
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(nes);
> +
> +static struct pci_driver nes_pci_driver = {
> +	.name = DRV_NAME,
> +	.id_table = nes_pci_table,
> +	.probe = nes_probe,
> +	.remove = nes_remove,
> +	.groups = nes_groups,
> +};
> +
>  
>  /**
>   * nes_init_module - module initialization entry point
> @@ -1192,20 +1179,13 @@ static void nes_remove_driver_sysfs(stru
>  static int __init nes_init_module(void)
>  {
>  	int retval;
> -	int retval1;
>  
>  	retval = nes_cm_start();
>  	if (retval) {
>  		printk(KERN_ERR PFX "Unable to start NetEffect iWARP CM.\n");
>  		return retval;
>  	}
> -	retval = pci_register_driver(&nes_pci_driver);
> -	if (retval >= 0) {
> -		retval1 = nes_create_driver_sysfs(&nes_pci_driver);
> -		if (retval1 < 0)
> -			printk(KERN_ERR PFX "Unable to create NetEffect sys files.\n");
> -	}
> -	return retval;
> +	return pci_register_driver(&nes_pci_driver);
>  }
>  
>  
> @@ -1215,7 +1195,6 @@ static int __init nes_init_module(void)
>  static void __exit nes_exit_module(void)
>  {
>  	nes_cm_stop();
> -	nes_remove_driver_sysfs(&nes_pci_driver);
>  
>  	pci_unregister_driver(&nes_pci_driver);
>  }
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -1307,6 +1307,7 @@ int __pci_register_driver(struct pci_dri
>  	drv->driver.bus = &pci_bus_type;
>  	drv->driver.owner = owner;
>  	drv->driver.mod_name = mod_name;
> +	drv->driver.groups = drv->groups;
>  
>  	spin_lock_init(&drv->dynids.lock);
>  	INIT_LIST_HEAD(&drv->dynids.list);
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -729,6 +729,7 @@ struct pci_driver {
>  	void (*shutdown) (struct pci_dev *dev);
>  	int (*sriov_configure) (struct pci_dev *dev, int num_vfs); /* PF pdev */
>  	const struct pci_error_handlers *err_handler;
> +	const struct attribute_group **groups;
>  	struct device_driver	driver;
>  	struct pci_dynids dynids;
>  };
