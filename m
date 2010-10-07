From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Thu, 07 Oct 2010 13:21:36 +0200
Message-ID: <4CADAD40.8080202@voltaire.com>
References: <036401cb5c35$85829220$9087b660$@edu>	<adar5giahvd.fsf@cisco.com> <037101cb5c39$b98036f0$2c80a4d0$@edu>	<adamxr6ahd3.fsf@cisco.com> <4CAD9572.5060507@Voltaire.com> <20101007101316.GA9605@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007101316.GA9605@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> If you create a MR in kernel, it covers the entire address space and 
> the HCA does not pose any limit since you do not consume MTTs. And if 
> you use MTTs then the page size is a parameter in this calculation - 
> huge page, regular page etc.
I agree that the kernel case is not of large interest, even though what 
you wrote only applies for dma mr, when some FMR scheme is used, MTTs 
are consumed, ofcourse. But, typically, kernel code will not go to the 
order of giga-bytes, and in other words will not hit the HCA limit.

> Do leaving it as is seems to be the most accurate thing...
I would implement it for regular pages and drop a note in the libibverbs 
man page that if huge pages are used (well, the huge pages patch set 
isn't fully merged, maybe its about time to make this happen...) then 
the actual limit is bigger, e.g follows the proportion between the 
regular to the huge pages used.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
