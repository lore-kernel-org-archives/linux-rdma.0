From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: MLX4 Cq Question
Date: Sun, 19 May 2013 09:09:21 +0300
Message-ID: <51986C91.7050308@mellanox.com>
References: <51968438.7070907@opengridcomputing.com> <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18/05/2013 00:37, Roland Dreier wrote:
> you see that when freeing a CQ, we first do the HW2SW_CQ firmware
> command; once this command completes, no more events will be generated
> for that CQ.  Then we do synchronize_irq for the CQ's interrupt
> vector.  Once that completes, no more completion handlers will be
> running for the CQ, so we can safely delete the CQ from the radix tree
> (relying on the radix tree's safety of deleting one entry while
> possibly looking up other entries, so no lock is needed).  We also use
> the lock to synchronize against the CQ event function, which as you
> noted does take the lock too.
>
> Basic idea is that we're tricky and careful so we can make the fast
> path (completion interrupt handling) lock-free, but then use locks and
> whatever else needed in the slow path (CQ async event handling, CQ
> destroy).

Jack, so do we finally agree to this analysis?  last time when this was 
on the list, I was under the impression that there was no consensus and 
I also see that on the stack we provide to customers there's a patch of 
yours in that area, or it may fix another bug?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
