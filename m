From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/12] IB/srpt: convert to the generic RDMA READ/WRITE
	API
Date: Fri, 29 Apr 2016 08:34:43 +0200
Message-ID: <20160429063443.GA18893@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-11-git-send-email-hch@lst.de> <570E96B5.5030002@sandisk.com> <20160414133255.GA22523@lst.de> <57227A6D.4000802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57227A6D.4000802-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 05:02:37PM -0400, Doug Ledford wrote:
> I see you responded to Bart's comment above, but in the same email he
> had a second comment on this patch (that the logic was incorrect in part
> of it), and I've not seen a response to that.  Here's the comment I'm
> referring to:

That one has also been addressed in the latest repost.  Bart has reported
another issue with the current version, which I plan to look into by
the weekend or early next week.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
