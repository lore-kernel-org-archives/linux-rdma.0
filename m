From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v3 0/2] iw_cxgb4 pr_debug() changes for 4.14-rc
Date: Wed, 27 Sep 2017 10:17:03 -0400
Message-ID: <1506521823.82712.24.camel@redhat.com>
References: <1506497750-19972-1-git-send-email-bharat@chelsio.com>
         <1506519604.82712.19.camel@redhat.com>
         <006301d3379a$cc4dac10$64e90430$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <006301d3379a$cc4dac10$64e90430$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-27 at 09:13 -0500, Steve Wise wrote:
> Hey Doug,  I agree.  
> 
> We will clean up the BUG()s and remove them if they really aren't
> needed, or perhaps make them WARN_ONCE(), and fail the operations w/o
> crashing.
> 
> Steve.

Thanks Steve.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
