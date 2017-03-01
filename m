From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 11:07:23 -0700
Message-ID: <20170301180723.GA9539@obsidianresearch.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com>
 <20170301004449.GA13114@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 06:00:09PM +0000, Hefty, Sean wrote:

> If you had device add/remove events, the get_event call could
> intercept that event and update the device list there.  But I don't
> know that you try to sync a shared list between the library and the
> app.

That is the same basic race I outlined, just without the thread.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
