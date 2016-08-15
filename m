From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH perftest] ib_read_bw: fix testing with XRC connections
Date: Mon, 15 Aug 2016 16:58:39 -0400
Message-ID: <20160815205839.GB64631@redhat.com>
References: <1471027212-41282-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471027212-41282-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Zhaojuan Guo <zguo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 12, 2016 at 02:40:12PM -0400, Jarod Wilson wrote:
> At some point, support for testing XRC connections was broken. Our QA
> folks report that it used to work, but does not in 3.0:
> 
> $ ib_read_bw ib0-qe-06 -a -c XRC -F
> Unknown connection type
>  Unable to create QP.
> Failed to create QP.
>  Couldn't create IB resources

Oops, drop this, already fixed in latest git head of perftest, I failed to
notice there were updates in git and new tarballs available for download.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
