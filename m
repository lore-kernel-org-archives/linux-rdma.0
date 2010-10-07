From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Thu, 7 Oct 2010 13:49:04 +0200
Message-ID: <20101007114904.GB9605@mtldesk30>
References: <036401cb5c35$85829220$9087b660$@edu>
 <adar5giahvd.fsf@cisco.com>
 <037101cb5c39$b98036f0$2c80a4d0$@edu>
 <adamxr6ahd3.fsf@cisco.com>
 <4CAD9572.5060507@Voltaire.com>
 <20101007101316.GA9605@mtldesk30>
 <4CADAD40.8080202@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CADAD40.8080202-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 07, 2010 at 01:21:36PM +0200, Or Gerlitz wrote:
> I would implement it for regular pages and drop a note in the
> libibverbs man page that if huge pages are used (well, the huge
> pages patch set isn't fully merged, maybe its about time to make
> this happen...) then the actual limit is bigger, e.g follows the
> proportion between the regular to the huge pages used.
> 
What you're proposing is to change something that is not accurate in
another not accurate thing. Even when you don't use huge pages, a
calculation based on regular pages would be inaccurate too. That's
because the allocator allocates MTTs in 2^n quantities while the
registered memory need not be sized like that. Moreover, such
calculation is less accurate then what we have now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
