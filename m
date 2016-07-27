From: KY Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
 driver for Linux
Date: Wed, 27 Jul 2016 23:31:03 +0000
Message-ID: <DM2PR0301MB0783273A01F94AA980179CA1A00F0@DM2PR0301MB0783.namprd03.prod.outlook.com>
References: <1469585137-31229-1-git-send-email-kys@exchange.microsoft.com>
 <20160727044047.GA20509@kroah.com>
 <DM2PR0301MB0783CDD854EAA40B5739468FA00F0@DM2PR0301MB0783.namprd03.prod.outlook.com>
 <20160727212543.GA7821@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727212543.GA7821-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org" <olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org>, "apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Wednesday, July 27, 2016 2:26 PM
> To: KY Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org; apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org;
> vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org; Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
> driver for Linux
> 
> On Wed, Jul 27, 2016 at 09:09:08PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > > Sent: Tuesday, July 26, 2016 9:41 PM
> > > To: KY Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org; linux-
> > > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> > > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org; apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org;
> > > vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> > > leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org; Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
> > > driver for Linux
> > >
> > > On Tue, Jul 26, 2016 at 07:05:37PM -0700, kys-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org
> > > wrote:
> > > > +/*
> > > > + * Create a char device that can support read/write for passing
> > > > + * the payload.
> > > > + */
> > >
> > > That sounds "interesting"...
> > >
> > > > +
> > > > +static struct completion ip_event;
> > > > +static bool opened;
> > > > +
> > > > +char hvnd_ip_addr[4];
> > > > +char hvnd_mac_addr[6];
> > > > +bool hvnd_addr_set;
> > >
> > > Global variables?
> >
> > >
> > > > +
> > > > +int hvnd_get_ip_addr(char **ip_addr, char **mac_addr)
> > > > +{
> > > > +	int t;
> > > > +
> > > > +	/*
> > > > +	 * Now wait for the user level daemon to get us the
> > > > +	 * IP addresses bound to the MAC address.
> > > > +	 */
> > > > +	if (!hvnd_addr_set) {
> > > > +		t = wait_for_completion_timeout(&ip_event, 600*HZ);
> > > > +		if (t == 0)
> > > > +			return -ETIMEDOUT;
> > > > +	}
> > > > +
> > > > +	if (hvnd_addr_set) {
> > > > +		*ip_addr = hvnd_ip_addr;
> > > > +		*mac_addr = hvnd_mac_addr;
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	return -ENODATA;
> > > > +}
> > > > +
> > > > +static ssize_t hvnd_write(struct file *file, const char __user *buf,
> > > > +			size_t count, loff_t *ppos)
> > > > +{
> > > > +	char input[120];
> > > > +	int scaned, i;
> > > > +	unsigned int mac_addr[6], ip_addr[4];
> > > > +
> > > > +	if (hvnd_addr_set) {
> > > > +		hvnd_error("IP/MAC address already set, ignoring input\n");
> > > > +		return count;
> > > > +	}
> > > > +
> > > > +	if (count > sizeof(input)-1)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (copy_from_user(input, buf, count))
> > > > +		return -EFAULT;
> > > > +
> > > > +	input[count] = 0;
> > > > +
> > > > +	/*
> > > > +	 * Wakeup the context that may be waiting for this.
> > > > +	 */
> > > > +	hvnd_debug("get user mode input: %s\n", input);
> > > > +
> > > > +	scaned = sscanf(input,
> > > > +		"rdmaMacAddress=\"%x:%x:%x:%x:%x:%x\"
> > > rdmaIPv4Address=\"%u.%u.%u.%u\"",
> > > > +		&mac_addr[0],
> > > > +		&mac_addr[1],
> > > > +		&mac_addr[2],
> > > > +		&mac_addr[3],
> > > > +		&mac_addr[4],
> > > > +		&mac_addr[5],
> > > > +		&ip_addr[0],
> > > > +		&ip_addr[1],
> > > > +		&ip_addr[2],
> > > > +		&ip_addr[3]);
> > >
> > > Oh, that's a mess, you are going to parse text in the kernel that is
> > > passed on a char device?  Please tell me that not all IB drivers are
> > > like this...
> >
> > Greg,
> >
> > This driver is plugging into the Windows NetworkDirect infrastructure on the
> host side.
> > The fabric assigns the MAC/IP address for the interface. I have chosen this
> mechanism for
> > passing the information to the kernel driver. I can certainly look at other
> mechanism.
> 
> Why create a new mechanism that is different from all other IB
> controllers?  Shouldn't this just be a "normal" network device in that
> manner?

That is a good point. I will look at other options.

Regards,

K. Y
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
