From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: What is OFED? (vs in-kernel drivers)
Date: Wed, 5 Jan 2011 20:49:03 +0100
Message-ID: <AANLkTikLMknEtbxUmZ7UTOmawbBxt3taJahBK3CL-izu@mail.gmail.com>
References: <4D246301.40006@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D246301.40006-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 5, 2011 at 1:24 PM, Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org> wrote:
>
> Excuse the newbie question...
> What is the relationship between OFED and in-kernel infiniband drivers?
> Is ofed the source of merges? If yes, why is there need for an external development this time, why are drivers not developed within the kernel like it is for all other drivers?
> Is there more stuff in ofed than there is in the kernel? I see mellanox docs reporting that in order to flash the firmware of their cards you need ofed installed...
> Do I need to delete in-kernel drivers if I install ofed?
> I am on ubuntu + vanilla kernel. What is the suggested approach to install ofed in ubuntu? I see there are rpms but not debs: should I go with git?

In addition to what Jason wrote: personally I use the distro-provided
IB kernel drivers and user space with Linux distributions that track
the mainline kernel closely and either the distro-provided IB software
or OFED on enterprise Linux distributions. While using OFED has the
advantage of having the latest IB features available, a disadvantage
is that the entire OFED software stack has to be recompiled after each
kernel update. And most Linux distributors frequently release updated
kernels, e.g. because of security fixes.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
