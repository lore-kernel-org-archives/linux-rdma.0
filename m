From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH perftest] Fix assorted memory leaks on error paths
Date: Mon, 23 May 2016 19:01:46 -0400
Message-ID: <20160523230146.GI60083@redhat.com>
References: <1463593448-30864-1-git-send-email-jarod@redhat.com>
 <HE1PR05MB1161CBD222FA0968211017C7B54D0@HE1PR05MB1161.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB1161CBD222FA0968211017C7B54D0-eBadYZ65MZ9Q1L+Po+k9MtqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 22, 2016 at 07:25:58AM +0000, Gil Rockah wrote:
> Thanks Jarod.
> Same patch is also needed for src/send_bw.c ? 

Quite possible. I'm not quite sure how our internal automated system work,
but after fixing this one, it stopped complaining to me, so I assumed I'd
gotten all of them. There could well be more that we're simply not
encountering due to .. I have no idea what. :p

> -----Original Message-----
> From: Jarod Wilson [mailto:jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org] 
> Sent: Wednesday, May 18, 2016 8:44 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH perftest] Fix assorted memory leaks on error paths
> 
> Clang noticed that we might leak mcg_params.ib_devname in failure paths.
> There are additional leaks after fixing this initial one that it still reported, here's hoping I've got them all now...

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
