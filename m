From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 22:36:49 +0000
Message-ID: <1499985409.2740.24.camel@wdc.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
         <1499968101.2740.10.camel@wdc.com>
         <20170713182018.GE11069@obsidianresearch.com>
         <1499970786.2740.17.camel@wdc.com>
         <20170713221520.GA10088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713221520.GA10088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <E6B575D9EF3C1E40B2CCD1F03D40BB34-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 16:15 -0600, Jason Gunthorpe wrote:
> The one nit that I don't have an easy solution for is starting modules
> depending on the device technology, eg not starting srp or ipoib on
> !IB devices. The issue is that I can't think of an easy way to detect
> the device technology from the udev rule, at least not without a
> helper script or additional kernel sysfs..

Are users expected to modify the kernel-boot/modules/*.conf files? I
expect that only a minority of the RDMA users will want to load the ib_srpt
and ib_isert kernel modules.=20

> I havne't been able to test this yet, help would be appreciated.

I will try to free up some time to test the SRP-related changes.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
