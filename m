From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 07:01:00 -0500
Message-ID: <17662E79-265B-4F62-AB12-FD73CF9AFD17@cisco.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <DD0B6BCA-5892-4CA9-8F5D-87C6CC1189DC@cisco.com> <20091125045244.GJ1966@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091125045244.GJ1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Nov 24, 2009, at 11:52 PM, Jason Gunthorpe wrote:

> > OMPI uses RDMACM (among others), so I'm not sure I follow what  
> you're
> > asking me...?
>
> I think I'm asking you about the non RDMACM stuff in openmpi, ibcm,
> xoob, etc. I can't tell at glance if any of them will be safe to run
> on RDMAoE as-is..
>


Wait, I think I might have been mistaken.  I'm looking through the  
patches this morning and I don't see the "don't allow host-loopback if  
it's IBoE" logic.  The only places I see the check for real IB vs.  
IBoE is when deciding to use IBCM or OOB connection schemes (which, as  
Pasha said, are designed to be [real] IB only).

But, as you mentioned, there definitely are apps that don't use RDMACM  
and use an "out of band" (i.e., OOB) mechanism for making IB QP's.   
They therefore might have similar issues (need to check for real IB  
vs. IBoE).

Sorry for the confusion... I'm going to chalk it up to the fact that  
it was late at night when I sent that.  :-)

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
