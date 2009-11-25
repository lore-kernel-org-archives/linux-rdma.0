From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 06:52:24 -0500
Message-ID: <10904370-1D66-4013-BB3F-0F4B5EE581EE@cisco.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <4B0CDBEC.1030203@voltaire.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0CDBEC.1030203-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Nov 25, 2009, at 2:25 AM, Or Gerlitz wrote:

> > I was reviewing Mellanox's Open MPI patches for RDMAoE support
>
> Can you send us point to the patch series (mail thread or some
> repository where they sit)?
>

Here's one thread:

http://www.open-mpi.org/community/lists/devel/2009/11/7063.php

the latest patch in that thread is here:

http://www.open-mpi.org/community/lists/devel/2009/11/7119.php

Here's another thread with a slightly different thread, but with  
elements of IBoE support in it:

http://www.open-mpi.org/community/lists/devel/2009/11/7120.php

> > 1. It looks like there is a new field on the ibv_port_attr struct:
> > transport. Is it expected that all device drivers will start filling
> > in this value, or is it done in the OF core code somewhere?
> Please note that this field isn't present in the distro provided IB
> stack and hence it is highly recommended to avoid referring it in your
> code,
>

FWIW: we have configure tests checking for this field (just like we  
have configure tests checking for transport_type, because that wasn't  
always there, either).  However, it is a little disturbing that based  
on this conversation, that field name may change, and therefore we'll  
have to add *more* configure logic to figure out what exact field to  
check.  The same is true for all the IBoE code -- since none of that  
code has been approved yet, it's risky to base any code off it.  :-\

> as least some of us (...) are for decoupling ompi from ofed, so
> lets not put sticks in the wheels of that process.
>

Hear hear (let's remove MPI from OFED! :-) ).  But I think that this  
is a separate issue.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
