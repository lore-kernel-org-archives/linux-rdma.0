From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libibverbs and versions
Date: Wed, 2 Jun 2010 11:59:08 -0600
Message-ID: <20100602175908.GH15969@obsidianresearch.com>
References: <4C067DE0.8020508@opengridcomputing.com> <20100602173245.GG15969@obsidianresearch.com> <4C069774.4050402@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C069774.4050402-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 02, 2010 at 12:40:04PM -0500, Steve Wise wrote:
>>> I have this library I'm writing that uses libibverbs.  Somehow it 
>>> seems  to be using the 1.0 version instead of the newer version (I'm 
>>> guessing).  When I call ibv_create_cq()  I get a seg fault and the 
>>> stack looks like this:

>> Make sure you link your library to libibverbs and do not rely on
>> linking the app to libibverbs to resolve the symbols. Check with ldd 
>> foo.so

> This was the issue.  My library wasn't explicitly linking via -libverbs.  
> When I added that, it worked.
>
> But how did it manage to link to the old version I wonder?

If the linker doesn't have the library to look through an external
symbol is simply set as 'ibv_create_cq' in the symbol table. That is
the same name an app using libibverbs 1.0 would use to refer to the
old symbol. When linker has the library it sees that the proper name
for the symbol is now ibv_create_cq@1.1 and puts that in the symbol
table instead.

It is critical that all library are explicitly linked to all their
dependent libraries, otherwise a variety of bad things can happen.

Hmm.. Also, this reveals that it was a mistake to change the the
argument objects and use versioned symbols to cover that up -
versioned symbols cannot be used that way, it makes a really big mess
in real use cases. Curious that nobody has noticed this before..

Basically what Steve did is linked his library to verbs 1.0 and linked
the app to 1.1, and then passed an ibv_context across his library's
function call boundary.. Kablooie.

Makes me wonder if the versioned symbol bother is even worth the
trouble.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
