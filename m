From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Mon, 27 Feb 2017 11:59:12 -0700
Message-ID: <20170227185912.GM5891@obsidianresearch.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2017 at 06:08:41PM +0200, Alex Rosenbaum wrote:
 
> Here I suggest to modify the implementation of ibv_get_device_list()
> so that consecutive calls will re-scan the sysfs in the same manner
> as done today in order to create a fresh ibv_device list each
> time. We will remove caching of devices that support plugout, while
> keeping the ibv_device cache for devices which do not support
> plugout.

I have no problem with this.

> In order to prevent resource leak for provider libraries that do not
> support plugout API, libibverbs will move the relevant ibv_device’s
> to a cached device

We no longer support configurations like this, add the new feature and
globally update all providers in rdma-core. No hacks to support
un-updated providers.

> Few examples: librdmacm logic is based on GUID values. Socket
> acceleration (libvma) maps an IB device to its corresponding net
> iface based on netlink and sysfs. DPDK applications lookup the IB
> device PCI address. And most MPI implementation want human specified
> IB device name in command line and will probably not handle any
> hotplug (out or in) events.

I have often thought we should have better entry points to get a
specific device/port in libibverbs.

> If a legacy user space application did not follow the
> ibv_get_device_list() man page definition, and it saved a private
> copy of an ibv_device pointer and used it after releasing the device
> list (call to ibv_free_device_list()), then

This is explicitly called out as broken in the man page, we do not
need to support applications using the API in such an obviously wrong
way.

NOTES

       Client code should open all the devices it intends to use with
       ibv_open_device() before calling ibv_free_device_list().  Once
       it frees the array with ibv_free_device_list(), it will be able
       to use only the open devices; pointers to unopened devices will no
       longer be valid.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
