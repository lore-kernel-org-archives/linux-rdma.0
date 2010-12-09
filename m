From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma_cm resource over use
Date: Fri, 10 Dec 2010 00:06:54 +0200
Message-ID: <AANLkTimvcVnr3ECO8TaH-zy3bdEWQHWf_i5zg++Jk+cy@mail.gmail.com>
References: <20101209175338.GA26902@mtldesk30>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1F52B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1F52B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46or ConnectX, mlx4 will consume a UAR page for each open of libibverb=
s
device file. On a 4K page architectures we usually have 1024 UAR
pages. On a 64K page size the situation becomes worth. Suppose you
have a system with more than one device. One of the devices is used by
rdam_cm and the other is not. You can easily exhaust all the
resources. We actually have this situation at a customer.

On Thu, Dec 9, 2010 at 8:30 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> the rdma_cm library opens all availabe devices and keeps them open
>> even after binding to a specific device/port. This eats resources fr=
om
>> other devices that would otherwise be available to other application=
s.
>> Is there a way to avoid this? If not, maybe we should close all othe=
r
>> devices after binfing?
>
> The librdmacm documents that all RDMA devices remain open while the l=
ibrdmacm is loaded (see rdma_get_devices). =A0Also, a listen doesn't ne=
ed to be bound to any specific device, but the connection request will =
be. =A0Personally, I really don't see this as a major use of resources.
>
> - Sean
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
