From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 7 Apr 2016 16:54:22 -0700
Message-ID: <20160407235422.GB8951@infradead.org>
References: <57055BC6.7070402@sandisk.com>
 <5706E548.3080002@sandisk.com>
 <1460072224.18732.67.camel@haakon3.risingtidesystems.com>
 <5706F0E8.5020705@sandisk.com>
 <1460073123.18732.80.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460073123.18732.80.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 07, 2016 at 04:52:03PM -0700, Nicholas A. Bellinger wrote:
> Because I'm actively working on a bug-fix for the regression, and it's
> -rc2 in a target driver that hardly anyone cares about.
> 
> If the regression is not addressed before v4.6-rc6, then by all means
> revert the original patch.

Stop it.  People do care.  At least I do for sure, and it's blocking a
mayor feature I want to land in 4.7.  Bart has a proper fix, and it's
perfectly valid that you ask him to resend with various tweaks towards
how your prefer various details to be done, but there is no reason to
be agressive and personal.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
