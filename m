From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/2] IB/iser: set block queue_virt_boundary
Date: Mon, 12 Oct 2015 08:37:49 +0300
Message-ID: <CAJ3xEMh9eU8ZtuuYzye5OQDBny0rfTUhDQmoEG6YcqhH9ZOvaw@mail.gmail.com>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
	<1444577707-15778-2-git-send-email-sagig@mellanox.com>
	<CAJ3xEMhhFSRcMrDm--PD-ekr6hJZZXGk_3JE2iEmmHN0fi=b-Q@mail.gmail.com>
	<561B3849.6000000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561B3849.6000000-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2015 at 7:34 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

>> What happens now when an app wants to use 1K, 2K, 3K IOs? they can
>> only use 1/4, 1/2 or 3/4 of the available memory for these
>> transactions?

> What? I'm not sure what you are talking about. what available memory?

Based on your comments, I'll take a look on the block layer changes and see.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
