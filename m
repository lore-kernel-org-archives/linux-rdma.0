From: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Mon, 15 Aug 2011 07:45:03 -0700
Message-ID: <20110815144503.GA12014@suse.de>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.761358826@systemfabricworks.com>
 <CAO+b5-pRQXn08aVOPxeQBzrYXAV+3zD+HZdCCmPTTwBCCzY=ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO+b5-pRQXn08aVOPxeQBzrYXAV+3zD+HZdCCmPTTwBCCzY=ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 15, 2011 at 04:33:14PM +0200, Bart Van Assche wrote:
> On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > +	for (i = 0; i < ARRAY_SIZE(rxe_dev_attributes); ++i) {
> > +		err = device_create_file(&dev->dev, rxe_dev_attributes[i]);
> > +		if (err) {
> > +			pr_warn("device_create_file failed, "
> > +				"i = %d, err = %d\n", i, err);
> > +			goto err2;
> > +		}
> > +	}
> 
> (added Greg in CC)
> 
> It's not your fault but loops similar to the above for creating device
> attributes occur in many drivers in the Linux kernel. How about adding
> functions called device_create_files() and device_remote_files()
> functions in drivers/base/core.c ? If you want you can start from the
> implementations of sysfs_create_files() and sysfs_remove_files() in
> fs/sysfs/file.c.

How about using the api functions that are already present in the kernel
to do the exact thing you are asking for here?

And no one should EVER be doing a loop like the above mentioned one, so
yes, it is their fault :)

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
