From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Tue, 24 Nov 2009 21:12:53 -0500
Message-ID: <DD0B6BCA-5892-4CA9-8F5D-87C6CC1189DC@cisco.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091125001136.GP6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Nov 24, 2009, at 7:11 PM, Jason Gunthorpe wrote:

> Is the same true for openmpi? If you try to run it as is on a RDMAOE
> interface will it work? If not I think that alone should kill this
> idea..
>


OMPI uses RDMACM (among others), so I'm not sure I follow what you're  
asking me...?

The checks that I was referring to was when OMPI is checking  
reachability (before it makes QPs).  If the peer proc is on the same  
server, if it's real IB, OMPI concludes "yes, this works".  If the  
peer proc is on the same server and it's IBoE, OMPI concludes "no,  
this won't work."

But I'm not actually sure that's a 100% standards compliant test.  We  
have a long-standing bug ticket open to change this test to actually  
try to open a QP to the same host and see if it works rather than  
relying on the transport_type.  However, all [real] IB devices that we  
run with seem to obey this semantic.  So there's at least historical  
precedent...?  (that might be a weak argument)

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
