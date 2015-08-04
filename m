From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V7 4/6] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Tue, 4 Aug 2015 15:48:47 -0600
Message-ID: <20150804214847.GD10934@obsidianresearch.com>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
 <1438697008-26209-5-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438697008-26209-5-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 05:03:26PM +0300, Yishai Hadas wrote:
> Enables the uverbs_remove_one to succeed despite the fact that there are
> running IB applications working with the given ib device.  This
> functionality enables a HW device to be unbind/reset despite the fact that
> there are running user space applications using it.
> 
> It exposes a new IB kernel API named 'disassociate_ucontext' which lets
> a driver detaching its HW resources from a given user context without
> crashing/terminating the application. In case a driver implemented the
> above API and registered with ib_uverb there will be no dependency between its
> device to its uverbs_device. Upon calling remove_one of ib_uverbs the call
> should return after disassociating the open HW resources without waiting to
> clients disconnecting. In case driver didn't implement this API there will be no
> change to current behaviour and uverbs_remove_one will return only when last
> client has disconnected and reference count on uverbs device became 0.
> 
> In case the lower driver device was removed any application will
> continue working over some zombie HCA, further calls will ended with an
> immediate error.

Looks OK now..

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

I think I provided reviews for 1-4 now, you forgot the copy them
forward from v6 to help Doug.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
