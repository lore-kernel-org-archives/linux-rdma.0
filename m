From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: Fix IPoIB to conform to ethtool definitions
Date: Mon, 8 Nov 2010 10:02:22 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443D1BB387C7@MTLMAIL.mtl.com>
References: <Pine.LNX.4.64.1011080936200.14213@zuben.voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443D1BB38721@MTLMAIL.mtl.com>
	<4CD7ABF4.5090305@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD7ABF4.5090305-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Will send those too. The idea is to let kernel consumers enjoy the improvements to latency that blue flame gives. And yes, SDP is motivating us but I am going to push to IPoIB too.
I want to take the opportunity that you raised the issue to hear others opinion about changing the bitmap allocator maintain an "avail" variable that will count the number of available UARs. I want to use this to limit the number of UARs that a kernel consumer can allocate so that there will always be some available for userspace such that we will never fail ibv_devinfo due to lack of UARs. Thoughts?

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org] 
Sent: Monday, November 08, 2010 9:51 AM
To: Eli Cohen
Cc: Roland Dreier; linux-rdma
Subject: Re: Fix IPoIB to conform to ethtool definitions

Eli Cohen wrote:
> Sure, I was going to. I will send later today.

I saw that you've dropped and implementation of inline/blue-flame sending 
for kernel space, what was the motivation is it sdp, rds or alike or something else?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
