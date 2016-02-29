From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Mon, 29 Feb 2016 01:11:18 -0800
Message-ID: <20160229091118.GA8927@infradead.org>
References: <56C0A6C3.3010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56C0A6C3.3010903-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

can you give my series at:

http://thread.gmane.org/gmane.linux.scsi.target.devel/11518

a a try?  This sorts out the session list handling so that whoever
removes a session from the list on the node ACLs gets to tear it down
fully.  Previously the old kref papered over the lack of clear
responsibility here.

I think this should sort out this race, but as I can't reproduce it on
my SRP test setup I'm not 100% sure.

I've also uploaded a git tree to make your life easier, as it sits on
top of Nic's for-next branch:

	git://git.infradead.org/users/hch/scsi.git target-session-cleanup

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
