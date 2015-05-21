From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Thu, 21 May 2015 15:44:36 -0600
Message-ID: <20150521214436.GA29836@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432226406.28905.22.camel@redhat.com>
 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
 <1432242708.28905.73.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432242708.28905.73.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 05:11:48PM -0400, Doug Ledford wrote:
> fffe in the middle 2 bytes, and then when we call get vf_info, we get a
> MAC back that removes those 2 bytes and generates an inconsistency
> between what we *think* our constructed guid should be and what the set
> guid actually is.

Bingo - When ndo_get_vf_config is called on the PF it must return the
same 20 byte LLADDR that will match the IFLA_ADDRESS returned on the
VF netdevice.

If do_get_vf_config returns the 20 byte LLADDR, then ndo_set_vf_mac
must also accept the same format.

This probably suggests option #2 from my last email is the way to go,
as the input and ouput from the set, and any followup IFLA_ADDRESS or
ndo_get_vf_config will all be the same LLADDR. Hidden changes to the
LLADDR are probably just going to confuse things.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
