From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: need pointer to Understand how to use IBV_WR_RDMA_WRITE_WITH_IMM
Date: Tue, 07 Jun 2011 11:36:52 -0500
Message-ID: <4DEE53A4.3080409@opengridcomputing.com>
References: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA@mail.gmail.com> <4DEE3326.9050105@redhat.com> <20110607163111.GA24005@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110607163111.GA24005-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/07/2011 11:31 AM, Jason Gunthorpe wrote:
> On Tue, Jun 07, 2011 at 07:18:14AM -0700, Steven Dake wrote:
>> On 06/07/2011 05:23 AM, Benoit Hudzia wrote:
>>> I am uncertain if this is the correct place for such email, please
>>> point me to an appropriate mailing list place if not.
>>>
>>> I would like to use IBV_WR_RDMA_WRITE_WITH_IMM , however I am facing
>>> difficulty to find documentation or example on how to use such
>>> feature.  The idea would be to do an RDMA write and wake up the peer
>>> upon reception in order to process the received data.
>>>
>>> What I understand from IBV_WR_RDMA_WRITE_WITH_IMM:
>> I would recommend against using IMM modes.  I believe they are not
>> supported on non-infiniband hardware, which limits your application from
>> being used on Ethernet rdma systems.
> There is some talk of fixing that in iWarp, the IMM stuff is much more
> efficient than a RDMA + SEND combo.
>

iWARP 2.0: http://datatracker.ietf.org/doc/draft-ietf-storm-rdmap-ext/


> If you are going to use it, and care about iWarp then you should
> design a fall back into your protocol to use RDMA + SEND.. I have some
> stuff that works like this.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
