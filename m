From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
 embedded in struct pci_dev
Date: Tue, 7 Mar 2017 05:50:51 +0100
Message-ID: <20170307045051.GB3913@kroah.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
 <20170307003549.3872-2-bart.vanassche@sandisk.com>
 <VI1PR0502MB3008D3B38ED2F3694E100E5ED12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1488854653.2997.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488854653.2997.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org" <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 07, 2017 at 02:44:28AM +0000, Bart Van Assche wrote:
> On Tue, 2017-03-07 at 02:41 +0000, Parav Pandit wrote:
> > Compilation would break when CONFIG_PCI is not defined for some embedded platforms.
> > More than that, including specific pci_dev structure pointer in generic structure such as device just doesn't sound right.
> > I tested equivalent patch that you sent, but I don't think this is right direction to fix this bug.
> 
> You are welcome to voice your opinion. But unless anyone proposes a better
> alternative I propose to proceed with this approach.

That's not how development happens.  You don't just do "here's a
something I came up with, if you don't like it, tough!"  If people
object, you need to resolve those objections, not ignore them.

Especially when you are breaking the build!!!

come on now, you know better than this.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
