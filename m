From: Reeted <reeted-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 05 Sep 2012 19:52:43 +0200
Message-ID: <5047916B.4070706@shiftmail.org>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
 <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/05/12 17:51, Christoph Lameter wrote:
> PCI-E on PCI 2.0 should give you up to about 2.3 Gbytes/sec with these
> nics. So there is like something that the network layer does to you that
> limits the bandwidth.

I think those are 8 lane PCI-e 2.0 so that would be 500MB/sec x 8 that's 
4 GBytes/sec. Or you really mean there is almost 50% overhead?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
