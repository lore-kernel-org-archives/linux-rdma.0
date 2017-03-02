From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Thu, 2 Mar 2017 09:53:30 -0700
Message-ID: <20170302165330.GB16689@obsidianresearch.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com>
 <20170301004449.GA13114@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com>
 <CAFgAxU9vObaW4O+byEJ5pV1Ofou4cd05HHWWPC7iTJshyk+LdA@mail.gmail.com>
 <d92df6b7-207f-f3a3-8bf5-b12cffe20684@redhat.com>
 <CAFgAxU_-jbAoOR2XMYfSgbDMn7FnrthudZJLgeNNTzb9GEUXrg@mail.gmail.com>
 <467c0560-8de7-42e5-14b9-178c367874d2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <467c0560-8de7-42e5-14b9-178c367874d2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 02, 2017 at 07:48:55AM -0500, Doug Ledford wrote:

> oneshot script.  The udev rules for various rdma capable hardware all
> call out for the rdma.init service to be run.  This is fine at
> bootup.

Yep, but that could be fixed in a fairly straightfoward way:

SUBSYSTEM=="module", KERNEL=="cxgb*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma_load_kmod@%k.service"

eg run a one shot instance of a systemd template that loads the extra
modules needed by the core module.

> However, once we are up and running, I don't think a hotplug of any
> module driver that services only the ethernet portion of a two part
> driver (cxgb*/hns/bnxt) will trigger a load of the corresponding RDMA
> portion of the driver.

I continue to belive we need to fix this in the kernel, the two part
drivers should auto-load their RDMA sides..

Not sure what this has to do with verbs though...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
