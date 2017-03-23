From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 10:58:00 -0600
Message-ID: <20170323165800.GC29811@obsidianresearch.com>
References: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
 <36a02b19-5b50-10f6-f3da-13d4a67f50c2@dev.mellanox.co.il>
 <22f0dfe4-bf35-02cf-df73-ef7b59295015@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <22f0dfe4-bf35-02cf-df73-ef7b59295015-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 23, 2017 at 12:50:14PM -0400, Jarod Wilson wrote:

> >Any option that you saw below message in the log ?
> >"Architecture NOT able to do coherent DMA (check libibverbs/arch.h) some
> >providers disabled!")"
> 
> Yep, it's there, lost it in all the verbosity. Okay, that explains that.

FWIW, that section after 'Missing Optional Items:' reflects everything
'wrong' with the build environment. An ideal build will list nothing,
eg on FC25.

Everything else means something is broken and cmake is working around
the breakage somehow. It is worth reviewing if the thing is really
broken or not...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
