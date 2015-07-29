From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH v1] xprtrdma: take vendor driver refcount at client
Date: Wed, 29 Jul 2015 13:55:15 +0530
Message-ID: <CANjDDBhOHZXLR=ih5s8r4kMi96XAUU0uUYuhk8FEZDVfFGaw3A@mail.gmail.com>
References: <1438173661-12497-1-git-send-email-devesh.sharma@avagotech.com>
	<20150729073330.GA13361@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150729073330.GA13361-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 29, 2015 at 1:03 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Hi Devesh,
>
> I don't understand your use of "vendor driver" here.  It seems your'e
> talking about the HCA driver.

Yes, I mean to say HCA driver. I will change this in next revision,
its confusing rigth now.

>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
