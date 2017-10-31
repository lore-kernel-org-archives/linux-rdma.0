From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix request completion holes
Date: Tue, 31 Oct 2017 13:10:10 +0200
Message-ID: <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
 <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8abcde91-9150-2982-3900-078619bcdac0-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks Sagi.
> We'll run these patches in our lab + our patches for the performance 
> improvments that we sent few days ago and update the results.

Thanks,

> I guess I'll need to run it with my cq moderation patches to get less 
> penalty in performance.

Fine, but just a heads up, any cq moderation that is not adaptive is not 
something
that we'd like to pursue. I have a generic adaptive moderation library 
in the
works, so any ideas should be integrated into that (or something 
equivalent).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
