From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Wed, 19 Oct 2011 13:39:08 +0200
Message-ID: <4E9EB6DC.4010308@mellanox.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home> <CAJZOPZJVNiwU-YA6KteOoFYX5M=BzPEZJsvRoFOz170O11qgeA@mail.gmail.com> <alpine.DEB.2.00.1110181013090.687@router.home> <CAJZOPZJvF1F1J_DYJf-v6JZx5pGv_sxTb8GgsF09HFj81jQ+sw@mail.gmail.com> <CAJZOPZJCzMemMboH0V83w87uHqggQ5zqtMR3eKocvWKdaypmZg@mail.gmail.com> <CAL1RGDWhg6mjn2qa6Dgm2Hc2NugMM=RuG_6HrpxEvrooAZOX3w@mail.gmail.com> <CAJZOPZ+M9xX94YfESmPTihCBtV+dnrdVq3a9vHZSkwmQ9C72Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+M9xX94YfESmPTihCBtV+dnrdVq3a9vHZSkwmQ9C72Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/19/2011 1:05 AM, Or Gerlitz wrote:
> in few hours I will be next to the code...

The theory failed, looking on commit 
577818b50990853bf112ba2a2c336020dd278622 "Update examples for IBoE"
it doesn't change the default message size for the ud pingpong, so we 
have to dig deeper, Christoph,
can you patch out that commit on your system and say if you still see 
the problem? thanks,

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
