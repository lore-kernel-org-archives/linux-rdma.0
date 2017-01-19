From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Thu, 19 Jan 2017 10:33:52 -0700
Message-ID: <20170119173352.GA8109@obsidianresearch.com>
References: <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
 <20170112201622.GA14584@obsidianresearch.com>
 <20170113150824.GQ20392@mtr-leonro.local>
 <20170113171234.GA30551@obsidianresearch.com>
 <20170113203127.GT20392@mtr-leonro.local>
 <20170113212721.GB1463@obsidianresearch.com>
 <20170115083543.GA20392@mtr-leonro.local>
 <20170116201218.GA7890@obsidianresearch.com>
 <20170119131258.GT32481@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170119131258.GT32481-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2017 at 03:12:58PM +0200, Leon Romanovsky wrote:

> Let's hope that we will find such brave man who will
> remove this line. The removal of this one line will
> require from him to do extensive testing and reviewing
> different code paths.

Why? We already fully support this configuration for RC

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
