From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: protection domain question
Date: Sun, 10 Apr 2016 07:55:11 -0700
Message-ID: <20160410145511.GB2409@infradead.org>
References: <20160409190331.GA23186@infradead.org>
 <570A62B7.9020200@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570A62B7.9020200-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 10, 2016 at 05:27:03PM +0300, Sagi Grimberg wrote:
> >Is there any good reason to have each kernel driver create it's own PDs
> >instead of simply creating one per device and sticking it into the
> >ib_device structure?
> 
> There is a theoretical breach here. Say you're connected with a srp
> channel to a target, and you send out rkey X to your peer. In case
> there is a man-in-the-middle who sniffs it, he can theoretically
> read/write to your rkey by connecting to IPoIB in RC mode (which
> will connect to anyone).

Already, makes sense.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
