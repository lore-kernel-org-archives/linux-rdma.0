From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 14:15:01 -0700
Message-ID: <20180110211501.GS4776@mellanox.com>
References: <1515531652.26021.1.camel@redhat.com>
 <1515537614.26021.3.camel@redhat.com>
 <1515591723.26021.6.camel@redhat.com>
 <20180110182648.GI4518@ziepe.ca>
 <1515609623.2745.20.camel@wdc.com>
 <1515610750.10153.1.camel@redhat.com>
 <20180110191510.GK4518@ziepe.ca>
 <1515612639.10153.3.camel@redhat.com>
 <20180110205243.GP4776@mellanox.com>
 <1515618674.10153.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515618674.10153.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 04:11:14PM -0500, Laurence Oberman wrote:

> Almost looks like changes made may require new Firmware maybe for my
> CX4 card because its coming from here and I dont like to see pci_err**
> called.

git tells me the shutdown error feature is newish, and surely
interacts with CQ shutdown, so guessing it is broken is a pretty good
starting point.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
