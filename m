From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Sun, 10 Apr 2016 07:52:04 -0700
Message-ID: <20160410145204.GA2409@infradead.org>
References: <20160404225831.GA6725@infradead.org>
 <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org>
 <570548AB.4090802@grimberg.me>
 <20160406231658.GB11588@infradead.org>
 <570608C9.1070805@grimberg.me>
 <570623B9.8040108@mellanox.com>
 <570679B6.10409@grimberg.me>
 <20160407221359.GA16686@infradead.org>
 <570A5563.5060104@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570A5563.5060104-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 10, 2016 at 04:30:11PM +0300, Max Gurtovoy wrote:
> Hi Christoph,
> did you add similar assignment in iser code or only used the scsi patches ?

Yes, to fix it I had to do the assignment in iser.  Not sure why
I didn't manage to send it out.  Let me prepare a proper patch series.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
