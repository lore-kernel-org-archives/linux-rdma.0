From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 10 Mar 2016 09:00:00 -0800
Message-ID: <56E1A810.1080001@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com>
 <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de>
 <56E071B6.8060809@sandisk.com> <20160310075722.GA551@lst.de>
 <56E1931C.1040206@sandisk.com> <20160310162150.GA9544@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160310162150.GA9544-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/10/2016 08:21 AM, Christoph Hellwig wrote:
> I see the use case for enabling MRs for debugging, but I still don't
> think the ULP is the right place.  I also don't see where you
> cna do this currently: for srpt, the only driver converted in this
> series there is no support for registrations at all currently,
> and with the the series you can force it to register with a one
> line code change in rdma_rw_use_mr.  For iSERt, which I plan to
> convert for 4.7 (and which has some WIP code in git) MR support
> exists, but is only enabled if the device supports the vendor
> specific signature handover extension (aka if running on mlx5 hardware).
> With the future conversion you'll still have a simply compile time
> switch to always enabled it, and I'd be fine with adding a module
> parameter to force it as well.

Hello Christoph,

Had you already noticed the ib_srp register_always kernel module parameter?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
