From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Send with immediate data completion
Date: Wed, 11 Jan 2012 16:15:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325675686@ORSMSX101.amr.corp.intel.com>
References: <11EC89F0-2BFD-4727-BC45-AD30E0F10348@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A823732566A099@ORSMSX101.amr.corp.intel.com>
 <9A17BA94-61E0-4176-81CF-98BE023320AF@ornl.gov>
 <7B006904-1749-4562-B2FD-1A0E5212A449@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7B006904-1749-4562-B2FD-1A0E5212A449-1Heg1YXhbW8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Any thoughts?
> 
> Personally, I would like to have it in the send completion, but it might not
> be possible for all drivers to implement. If not, then the spec should be
> clarified.

>From my interpretation of the spec, it looks like a bug and the immediate data should be available in the send wc, since it's not explicitly excluded.  I'll verify that this is the intent with the IBTA.

I haven't traced through the library and driver code to see if mlx4 driver can report it.  I'll see if I can do this within the next couple of days.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
