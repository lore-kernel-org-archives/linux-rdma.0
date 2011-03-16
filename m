From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Wed, 16 Mar 2011 10:27:30 +0200
Message-ID: <4D807472.2060000@mellanox.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov> <1300148888.2772.15.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300148888.2772.15.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> I'm getting ready to re-roll this series to address Or's review
> comments. I'm going to leave BMME support until later, as I have a few
> concerns about the error cases.
> 
> I'd like to see this go into 2.6.39 -- do you guys have any other
> questions or comments I should address?

nothing special, just want to make sure that at this point we're talking 
only on patches 1-8 i.e excluding the "increase DMA max_segment_size on 
Mellanox hardware" patch, correct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
