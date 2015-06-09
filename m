From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Tue, 9 Jun 2015 04:14:33 -0700
Message-ID: <20150609111433.GA11938@infradead.org>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <20150608132254.GA14773@infradead.org>
 <55759B0B.8050805@mellanox.com>
 <20150608135151.GA14021@infradead.org>
 <5575A9C7.7000409@dev.mellanox.co.il>
 <20150609062054.GA13011@infradead.org>
 <5576A760.4090004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5576A760.4090004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 09, 2015 at 11:44:16AM +0300, Sagi Grimberg wrote:
> For example:
> - frwr requires a queue-pair for the post (and it must be the ULP
>   queue-pair to ensure the registration is done before the data-transfer
>   begins). While fmrs does not need the queue-pair.

How do you transfer data without a queue pair?

> - the ULP would probably always initiate data transfer after the
>   registration (send a request or do the rdma r/w). It is useful to
>   link the frwr post with the next wr in a single post_send call.
>   I wander how would an API allow such a thing (while other registration
>   methods don't use work request interface).
> 
> - There is the fmr_pool API which tries to tackle the disadvantages of
>   fmrs (very slow unmap) by delaying the fmr unmap until some dirty
>   watermark of remapping is met. I'm not sure how this can be done.
> 
> - How would the API choose the method to register memory?

Seems like the general preference in existing users is FRWR -> FMR -> FR
with an exception to use physical for single segment I/O requests.

> - If there is an alignment issue, do we fail? do we bounce?

Leave it to the high level driver for now.  NFS can simply split
requests when the offset mismatches for blok drivers the enhanced
SG_GAPS can take care of it.  If indirect is supported the driver
does not need to set SG_GAPS.
registrations tha

> - There is the whole T10-DIF support...

Just tell the driver if the registration model supports it.  Do the
indirect registrations support it, btw?

As far as I can tell the NFS abstraction fits SRP fairly well.  iSER
is a bit of a mess with it's bounce buffering so I'm not too sure about
that one.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
