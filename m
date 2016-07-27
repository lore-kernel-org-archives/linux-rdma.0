From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
 driver for Linux
Date: Tue, 26 Jul 2016 21:40:47 -0700
Message-ID: <20160727044047.GA20509@kroah.com>
References: <1469585137-31229-1-git-send-email-kys@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469585137-31229-1-git-send-email-kys-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org, apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 26, 2016 at 07:05:37PM -0700, kys-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org wrote:
> +/*
> + * Create a char device that can support read/write for passing
> + * the payload.
> + */

That sounds "interesting"...

> +
> +static struct completion ip_event;
> +static bool opened;
> +
> +char hvnd_ip_addr[4];
> +char hvnd_mac_addr[6];
> +bool hvnd_addr_set;

Global variables?

> +
> +int hvnd_get_ip_addr(char **ip_addr, char **mac_addr)
> +{
> +	int t;
> +
> +	/*
> +	 * Now wait for the user level daemon to get us the
> +	 * IP addresses bound to the MAC address.
> +	 */
> +	if (!hvnd_addr_set) {
> +		t = wait_for_completion_timeout(&ip_event, 600*HZ);
> +		if (t == 0)
> +			return -ETIMEDOUT;
> +	}
> +
> +	if (hvnd_addr_set) {
> +		*ip_addr = hvnd_ip_addr;
> +		*mac_addr = hvnd_mac_addr;
> +		return 0;
> +	}
> +
> +	return -ENODATA;
> +}
> +
> +static ssize_t hvnd_write(struct file *file, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	char input[120];
> +	int scaned, i;
> +	unsigned int mac_addr[6], ip_addr[4];
> +
> +	if (hvnd_addr_set) {
> +		hvnd_error("IP/MAC address already set, ignoring input\n");
> +		return count;
> +	}
> +
> +	if (count > sizeof(input)-1)
> +		return -EINVAL;
> +
> +	if (copy_from_user(input, buf, count))
> +		return -EFAULT;
> +
> +	input[count] = 0;
> +
> +	/*
> +	 * Wakeup the context that may be waiting for this.
> +	 */
> +	hvnd_debug("get user mode input: %s\n", input);
> +
> +	scaned = sscanf(input,
> +		"rdmaMacAddress=\"%x:%x:%x:%x:%x:%x\" rdmaIPv4Address=\"%u.%u.%u.%u\"",
> +		&mac_addr[0],
> +		&mac_addr[1],
> +		&mac_addr[2],
> +		&mac_addr[3],
> +		&mac_addr[4],
> +		&mac_addr[5],
> +		&ip_addr[0],
> +		&ip_addr[1],
> +		&ip_addr[2],
> +		&ip_addr[3]);

Oh, that's a mess, you are going to parse text in the kernel that is
passed on a char device?  Please tell me that not all IB drivers are
like this...

> +
> +	if (scaned == 10) {
> +
> +		for (i = 0; i < 6; i++)
> +			hvnd_mac_addr[i] = (char) mac_addr[i];
> +		for (i = 0; i < 4; i++)
> +			hvnd_ip_addr[i] = (char) ip_addr[i];
> +
> +		hvnd_error("Scanned IP address: %pI4 Mac address: %pM\n",
> +			   hvnd_ip_addr, hvnd_mac_addr);
> +
> +		hvnd_addr_set = true;
> +		complete(&ip_event);
> +	}
> +
> +	return count;
> +}
> +
> +static int hvnd_open(struct inode *inode, struct file *f)
> +{
> +	/*
> +	 * The user level daemon that will open this device is
> +	 * really an extension of this driver. We can have only
> +	 * active open at a time.

Do you have a pointer to that code?  As it's a logical extension, you
know what the license for that code better be... :)

> +	 */
> +	if (opened)
> +		return -EBUSY;

You just raced, and lost, oops :(

There are better ways to do this, the easiest being, why do you need
"exclusive" access at all?

> +
> +	/*
> +	 * The daemon is alive; setup the state.
> +	 */
> +	opened = true;
> +	return 0;
> +}
> +
> +static int hvnd_release(struct inode *inode, struct file *f)
> +{
> +	/*
> +	 * The daemon has exited; reset the state.
> +	 */
> +	opened = false;
> +	return 0;
> +}
> +
> +
> +static const struct file_operations hvnd_fops = {
> +	.write          = hvnd_write,
> +	.release	= hvnd_release,
> +	.open		= hvnd_open,
> +};
> +
> +static struct miscdevice hvnd_misc = {
> +	.minor          = MISC_DYNAMIC_MINOR,
> +	.name           = "hvnd_rdma",
> +	.fops           = &hvnd_fops,
> +};
> +
> +static int hvnd_dev_init(void)
> +{
> +	init_completion(&ip_event);
> +	return misc_register(&hvnd_misc);
> +}
> +
> +static void hvnd_dev_deinit(void)
> +{
> +
> +	/*
> +	 * The device is going away - perhaps because the
> +	 * host has rescinded the channel. Setup state so that
> +	 * user level daemon can gracefully exit if it is blocked
> +	 * on the read semaphore.
> +	 */
> +	opened = false;

But if it's blocked, it's not going to get unblocked here :(


> +	/*
> +	 * Signal the semaphore as the device is
> +	 * going away.
> +	 */
> +	misc_deregister(&hvnd_misc);
> +}

Your comment doesn't match the code you are calling.

I gave up here, sorry.

Exactly why do you want a char interface?  It looks like you are using
it to configure your "hardware", surely there is already other ways to
do this and not every driver needs to roll-their-own like this?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
