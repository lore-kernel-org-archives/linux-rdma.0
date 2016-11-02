From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Wed, 2 Nov 2016 16:15:40 +0100
Message-ID: <20161102151540.GB14825@lst.de>
References: <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me> <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com> <4cc25277-429a-4ab9-470c-b3af1428ce93@grimberg.me> <01d101d2345e$2f054390$8d0fcab0$@opengridcomputing.com> <dbe5f18d-7928-f065-920f-753b30fb99a2@grimberg.me> <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com> <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me> <024e01d23476$6668b890$333a29b0$@opengridcomputing.com> <3512b8bb-4d29-b90a-49e1-ebf1085c47d7@grimberg.me> <004601d2351a$d9db85b0$8d929110$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <004601d2351a$d9db85b0$8d929110$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 02, 2016 at 10:07:38AM -0500, Steve Wise wrote:
> I'm not sure I understand the "subsystem" concept.  I never noticed before that
> any target device had the same controller ID.  The target json config file is
> inserted below.  There are 10 ramdisks exported over 2 ports of a cxgb4 40GE
> device and 1 port of an mlx4 RoCE device.   For this test, the NVMF host
> connects to all 10 targets over 1 port of the cxgb4 device.  Like this:

Yes, you have multiple subsystems.  It's sort of the NVMe equivalent
of a target which can have multiple LUNs, aka Namespaces in NVMe.

Btw, I want to actually make the ctrlid global for the target instead of
per-subsystem to ease a few things, and debuggability is just one more
on the list.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
