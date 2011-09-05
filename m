From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IBoE user space support
Date: Mon, 5 Sep 2011 21:36:53 +0300
Message-ID: <CAJZOPZJRRZX+B=eXKUNTLh684up3_bYievh3PVD_u8QZe3Qb5w@mail.gmail.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
	<CAJZOPZJ0JF_biZ32Kf=p6xw4rkm=TzdoMY5AdqMpfWfDRbg69Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJ0JF_biZ32Kf=p6xw4rkm=TzdoMY5AdqMpfWfDRbg69Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2011 at 10:43 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> the enclosed patch series enhances the user space IB stack to support IBoE.
>> [PATCH 1/7] libibverbs: Add link layer field port attribute
>> [PATCH 2/7] libibverbs: change kernel API to accept link layer
>> [PATCH 3/7] libibverbs: add GID change event
>> [PATCH 4/7] libibverbs: update examples for IBoE
>> [PATCH 5/7] libmlx4: add IBoE support
>> [PATCH 6/7] libmlx4: add IBoE UD/VLANs support
>> [PATCH 7/7] libmlx4: align the list of ConnectX devices supported with the kernel

> Hi Roland, Following a review by Jason and Sean I've posted V1
> for patches 1/7 and 3/7 as replies on the relevant posting of the V0 (this) thread.
> Please let me know if you have any further comments/questions on the series

Hi Roland, just wanted to check if you going to take that series soon,
specifically, soon enough so we have headroom to review/merge code
towards the 3.2 kernel window.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
