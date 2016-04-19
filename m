From: Marc Smith <marc.smith-FHhu8y7Kp0U@public.gmane.org>
Subject: Re: mlx5_core Issue
Date: Tue, 19 Apr 2016 15:17:11 -0400
Message-ID: <CAHkw+LfHFqeJe_JSEzx1anr6gac+02-_qjWde+mrTCJmZLjwcQ@mail.gmail.com>
References: <CAHkw+Lc3h5-0Km6J5j7xOHa0d-5gx1RO_dBRXYLfgGoyKzHkoA@mail.gmail.com>
	<20160206153613.GB8584@leon.nu>
	<20160207085221.GB17225@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160207085221.GB17225-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry for the long delay... we tested with 4.5-rc2 after you sent this
email, and the error message did not appear, but the driver/hardware
didn't appear to function; after loading the module we got this:

--snip--
Mar  3 15:05:43 localhost kernel: [  294.632663] mlx5_core
0000:41:00.0: firmware version: 12.12.1100
Mar  3 15:05:43 localhost kernel: [  295.229653] mlx5_core
0000:41:00.1: firmware version: 12.12.1100
Mar  3 15:05:44 localhost kernel: [  295.805140] mlx5_ib: Mellanox
Connect-IB Infiniband driver v2.2-1 (Feb 2014)
--snip--

No Ethernet/IB interfaces are visible, and no additional output in
kernel messages.


I looked at trying to apply the said patch to 4.1.11, but it appears
the driver has changed too much between the 4.1 and 4.5 branches, at
least in drivers/infiniband/core/sysfs.c (different function names,
parameters changed, etc.).

Should I focus on trying to use a newer kernel, or is it possible to
get the patch re-worked for 4.1.x? Or any other solutions so we can
stick to the upstream Mellanox kernel drivers for these 100 Gb/s VPI
adapters?



Thanks for your time.


--Marc

On Sun, Feb 7, 2016 at 3:52 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Sat, Feb 06, 2016 at 05:36:13PM +0200, Leon Romanovsky wrote:
>> > I'm using Linux 4.1.11 and trying to get Mellanox 100 Gb adapters
>> > working. When loading 'mlx5_core'.
>
> I assume that this accepted patch [1] will fix your issue.
>
> [1] https://patchwork.kernel.org/patch/7929551/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
