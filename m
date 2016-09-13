From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 26/28] Avoid gcc 5.4 warning -Wunused-result
Date: Tue, 13 Sep 2016 21:58:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0806AA@ORSMSX109.amr.corp.intel.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-27-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-27-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It used to be you could suppress this with (void), however the gcc
> developers have decided to get rid of that.
> 
> So, look closely at each occurrence and decide what to do:
> - *pingpong: Join the error handling with the if statement directly
>    above
> - niegh: read on a timer_fd should never fail, so just use assert.
>    The assert is compiled out for Release builds so this is no-change
> - acm: Failure of ucma_set_server_port is detected by a 0 return
>    so check fscanf and return appropriately. This is no change since
>    fscanf failure was assumed to have left server_port as 0 (though
>    I doubt the standard supports that usage)
> - rsocket: This looks super sketchy. At least lets make the intent
> clear
>    with a read_all/write_all wrapper that calls assert. Most likely
>    this code is wrong..
>    Mangle the code with failable_fscanf to make it clear, but as with
>    acm, I don't think the standard supports this usage.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

For my parts

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The rsocket code is sending a small message between a socketpair to notify a service thread that it needs to add a new rsocket to its processing.  It could probably check for a failure on the write calls and report that back to the caller.  If the read fails, I'm not sure what the service thread could do. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
