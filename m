From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 0/5] HW Device hot-removal support
Date: Thu, 30 Jul 2015 11:09:34 -0600
Message-ID: <20150730170934.GA25181@obsidianresearch.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <55BA54FC.8060905@redhat.com>
 <20150730165014.GD16659@obsidianresearch.com>
 <55BA57F2.5040207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BA57F2.5040207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 12:59:30PM -0400, Doug Ledford wrote:
> On 07/30/2015 12:50 PM, Jason Gunthorpe wrote:
> > On Thu, Jul 30, 2015 at 12:46:52PM -0400, Doug Ledford wrote:
> > 
> >> I've pulled this series in for 4.3.  There were some additional items in
> >> some of Jason's comments that ought to be looked into, but I think this
> >> patch set has reached the point where it's no worse than existing in
> >> terms of locking, there were just some existing issues that should be
> >> addressed too.
> > 
> > Eh? V6 corrupts random kernel memory if you use the hot-removal.
> 
> I didn't see that in there.  Did I read through the discussion too fast?
>  I'll go recheck...

For a char device you absolutely cannot kfree the cdev in the file
release callback.

The file still holds a ref on cdev and it will guarenteed use
after-free on cdev during core code struct file cleanup.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
