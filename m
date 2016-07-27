From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
 driver for Linux
Date: Wed, 27 Jul 2016 14:25:43 -0700
Message-ID: <20160727212543.GA7821@kroah.com>
References: <1469585137-31229-1-git-send-email-kys@exchange.microsoft.com>
 <20160727044047.GA20509@kroah.com>
 <DM2PR0301MB0783CDD854EAA40B5739468FA00F0@DM2PR0301MB0783.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM2PR0301MB0783CDD854EAA40B5739468FA00F0@DM2PR0301MB0783.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "yishaih@mellanox.com" <yishaih@mellanox.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "leann.ogasawara@canonical.com" <leann.ogasawara@canonical.com>, Long Li <longli@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 27, 2016 at 09:09:08PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Tuesday, July 26, 2016 9:41 PM
> > To: KY Srinivasan <kys@microsoft.com>
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; linux-
> > rdma@vger.kernel.org; yishaih@mellanox.com; sean.hefty@intel.com;
> > dledford@redhat.com; olaf@aepfle.de; apw@canonical.com;
> > vkuznets@redhat.com; jasowang@redhat.com;
> > leann.ogasawara@canonical.com; Long Li <longli@microsoft.com>
> > Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
> > driver for Linux
> > 
> > On Tue, Jul 26, 2016 at 07:05:37PM -0700, kys@exchange.microsoft.com
> > wrote:
> > > +/*
> > > + * Create a char device that can support read/write for passing
> > > + * the payload.
> > > + */
> > 
> > That sounds "interesting"...
> > 
> > > +
> > > +static struct completion ip_event;
> > > +static bool opened;
> > > +
> > > +char hvnd_ip_addr[4];
> > > +char hvnd_mac_addr[6];
> > > +bool hvnd_addr_set;
> > 
> > Global variables?
> 
> > 
> > > +
> > > +int hvnd_get_ip_addr(char **ip_addr, char **mac_addr)
> > > +{
> > > +	int t;
> > > +
> > > +	/*
> > > +	 * Now wait for the user level daemon to get us the
> > > +	 * IP addresses bound to the MAC address.
> > > +	 */
> > > +	if (!hvnd_addr_set) {
> > > +		t = wait_for_completion_timeout(&ip_event, 600*HZ);
> > > +		if (t == 0)
> > > +			return -ETIMEDOUT;
> > > +	}
> > > +
> > > +	if (hvnd_addr_set) {
> > > +		*ip_addr = hvnd_ip_addr;
> > > +		*mac_addr = hvnd_mac_addr;
> > > +		return 0;
> > > +	}
> > > +
> > > +	return -ENODATA;
> > > +}
> > > +
> > > +static ssize_t hvnd_write(struct file *file, const char __user *buf,
> > > +			size_t count, loff_t *ppos)
> > > +{
> > > +	char input[120];
> > > +	int scaned, i;
> > > +	unsigned int mac_addr[6], ip_addr[4];
> > > +
> > > +	if (hvnd_addr_set) {
> > > +		hvnd_error("IP/MAC address already set, ignoring input\n");
> > > +		return count;
> > > +	}
> > > +
> > > +	if (count > sizeof(input)-1)
> > > +		return -EINVAL;
> > > +
> > > +	if (copy_from_user(input, buf, count))
> > > +		return -EFAULT;
> > > +
> > > +	input[count] = 0;
> > > +
> > > +	/*
> > > +	 * Wakeup the context that may be waiting for this.
> > > +	 */
> > > +	hvnd_debug("get user mode input: %s\n", input);
> > > +
> > > +	scaned = sscanf(input,
> > > +		"rdmaMacAddress=\"%x:%x:%x:%x:%x:%x\"
> > rdmaIPv4Address=\"%u.%u.%u.%u\"",
> > > +		&mac_addr[0],
> > > +		&mac_addr[1],
> > > +		&mac_addr[2],
> > > +		&mac_addr[3],
> > > +		&mac_addr[4],
> > > +		&mac_addr[5],
> > > +		&ip_addr[0],
> > > +		&ip_addr[1],
> > > +		&ip_addr[2],
> > > +		&ip_addr[3]);
> > 
> > Oh, that's a mess, you are going to parse text in the kernel that is
> > passed on a char device?  Please tell me that not all IB drivers are
> > like this...
> 
> Greg,
> 
> This driver is plugging into the Windows NetworkDirect infrastructure on the host side.
> The fabric assigns the MAC/IP address for the interface. I have chosen this mechanism for
> passing the information to the kernel driver. I can certainly look at other mechanism.

Why create a new mechanism that is different from all other IB
controllers?  Shouldn't this just be a "normal" network device in that
manner?

> > > +
> > > +	if (scaned == 10) {
> > > +
> > > +		for (i = 0; i < 6; i++)
> > > +			hvnd_mac_addr[i] = (char) mac_addr[i];
> > > +		for (i = 0; i < 4; i++)
> > > +			hvnd_ip_addr[i] = (char) ip_addr[i];
> > > +
> > > +		hvnd_error("Scanned IP address: %pI4 Mac address: %pM\n",
> > > +			   hvnd_ip_addr, hvnd_mac_addr);
> > > +
> > > +		hvnd_addr_set = true;
> > > +		complete(&ip_event);
> > > +	}
> > > +
> > > +	return count;
> > > +}
> > > +
> > > +static int hvnd_open(struct inode *inode, struct file *f)
> > > +{
> > > +	/*
> > > +	 * The user level daemon that will open this device is
> > > +	 * really an extension of this driver. We can have only
> > > +	 * active open at a time.
> > 
> > Do you have a pointer to that code?  As it's a logical extension, you
> > know what the license for that code better be... :)
> 
> This is part of the automation to spin up RDMA capable VMs on Azure.
> Linux VMs on Azure include an agent that I used to provision the VMs
> (Distro vendors currently ship this agent). Here is the agent code:
> 
> https://github.com/Azure/WALinuxAgent/tree/archive/2.0
> 
> Currently all the provisioning work is done in the agent code and this includes
> provisioning the RDMA NIC - passing the MAC/IP address assigned by the host.

Again, that's fine, but don't create a new API when an existing one
should work just fine.  You aren't the first to need to set the IP
address of a device like this :)

> > > +	 */
> > > +	if (opened)
> > > +		return -EBUSY;
> > 
> > You just raced, and lost, oops :(
> 
> This is just to catch bugs in the agent code; the only open will be from the
> agent.

The kernel doesn't know that, and even if so, you aren't catching the
bug correctly.  Don't add known-buggy code to the kernel please, you
know better than this...

> > There are better ways to do this, the easiest being, why do you need
> > "exclusive" access at all?
> 
> This case should not happen since we have written the agent code and only that code
> should inject the provisioning information. 

Hah, but the kernel doesn't know this, you can't rely on userspace being
"correct".

Again, use the common interfaces that all other drivers like this use
today, don't create a char device for this, that's not ok.

thanks,

greg k-h
