From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until vmxnet3
 link is up
Date: Tue, 17 Jan 2017 16:31:08 -0800
Message-ID: <35f6cce2-00c8-16b6-e3e0-481f234bd9c9@vmware.com>
References: <cover.1484075557.git.aditr@vmware.com>
 <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
 <20170116073858.GA25853@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170116073858.GA25853-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 16, 2017 at 09:38:58AM +0200, Leon Romanovsky wrote:
> On Tue, Jan 10, 2017 at 11:15:39AM -0800, Adit Ranadive wrote:
> > From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> >
> > Currently on bootup, ethernet drivers seem to load before RDMA ones
> > in Linux. So while the vmxnet3 module is loaded before vmw_pvrdma,
> > the vmxnet3 link state may not necessarily be enabled by the stack
> > before pvrdma is loaded. This is a problem because if the pvrdma
> > module is loaded on bootup (by installing it in /lib/modules/*),
> > the pvrdma device comes up in a port down state.
> >
> > Since this is the most common use case scenario, defer the activation
> > of the device till the paired vmxnet3 link actually comes up. One
> > downside of doing this is, if a user doesn't have the vmxnet3 link
> > up when the pvrdma driver is loaded, they may not see any output
> > for ibv_devinfo until the paired vmxnet3 link is enabled too. The
> > users somehow need to be aware of this.
> >
> 
> I wouldn't call it "fix", the more appropriate name is "hack".
> It doesn't look right that users should be aware of such non-intuitive
> driver behavior.

Well its a partial fix for 4.10 to let the RDMA device come up correctly
Since this is a RoCE device we want to mimic to eth port status for the
RDMA link. Currently, for us there isnt an easy way to do this if the
vmxnet3 device comes up after we have already registered the IB device.
This patch moves the IB device registration to after the ethernet link is
up.
I wanted to get this in so that in the common case of VM power on, the 
PVRDMA device is in the port active state along with the vmxnet3 link.

Doug, any thoughts?

- Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
