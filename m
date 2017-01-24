From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 00/37] IB: Optimize DMA mapping
Date: Tue, 24 Jan 2017 09:49:27 -0800
Message-ID: <20170124174927.GA22799@infradead.org>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <1485279487.43764.38.camel@redhat.com>
 <1485279791.2715.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485279791.2715.3.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 24, 2017 at 05:43:26PM +0000, Bart Van Assche wrote:
> Waiting with a big patch series until the end of the merge window is the
> traditional approach. A quote from https://lwn.net/Articles/585782/:
> "Shortly after the -rc1 release is a good time for this, though it is best
> to agree on this timing ahead of time." This makes me wonder whether we
> should contact Linus before the next merge window opens?

Yes.  Keep it in a separate branch that still goes into linux-next,
send him a headsup with the first pull request.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
