From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA: Remove kernel private defines and
 reference to header from UAPI
Date: Wed, 8 Feb 2017 03:53:49 -0800
Message-ID: <20170208115349.GA18879@infradead.org>
References: <20170207174600.27218-1-leon@kernel.org>
 <20170208082850.GA11087@infradead.org>
 <20170208100043.GC6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208100043.GC6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 08, 2017 at 12:00:43PM +0200, Leon Romanovsky wrote:
> These constants are part of much larger enum ib_qp_attr_mask. IMHO copy
> two values from that enum isn't good, but copy whole enum (mostly not
> needed for the users) is bad either. So I decided to open code it as a fix
> for -rc7.

At least add comments mentioning the proper symbolic values then.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
