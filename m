From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Mon, 30 May 2016 11:05:01 -0600
Message-ID: <20160530170501.GA17321@obsidianresearch.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com>
 <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <4958edf4-7296-26c9-4cbe-8fab45be11a3@mellanox.com>
 <4e8befc4-aec5-a17d-24ce-40ff97d345da@redhat.com>
 <8708a378-4c48-df98-86a4-d210bbe690b5@redhat.com>
 <ecdbec76-31cd-74e1-25b4-7d60c3fa2af0@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ecdbec76-31cd-74e1-25b4-7d60c3fa2af0-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 30, 2016 at 06:01:24PM +0300, Matan Barak (External) wrote:
> So, you suggest that "simple" attributes will take into account byte_offset,
> bit_offset, bits_size (or mask) and endianity. While the right endianity
> conversion function will be chosen by inspecting the bits_size?
> Of course, this is in addition to the attribute's nature (simple/possible
> simple/complex), which we need to condition on that too.
> This doesn't sound simple for me and I'm afraid it will affect performance
> more than just a real simple function call.

Right, that is exactly the point - if the inlined version requires a
branch to choose betwen simple/complex then it will be about the same
cost to just branch to the correct code in the driver.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
