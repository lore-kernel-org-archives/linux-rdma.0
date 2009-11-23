From: javed-If5XQcfNmg0@public.gmane.org
Subject: Re: patch for non-ib network
Date: Mon, 23 Nov 2009 18:57:30 +0530 (IST)
Message-ID: <Pine.LNX.4.62.0911231138530.24997@mailhub.cdac.in>
References: <Pine.LNX.4.62.0911201915430.25859@mailhub.cdac.in><adabpit6ffb.
	fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN;
	charset=US-ASCII;
	format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabpit6ffb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


paramnet-3 supports RDMA. there's separate uDAPL interface for fast path 
specifically for MPI apps. tested with MVAPICH2 and intel mpi.

we've started with ofed/IPoIB for TCP/IP support. network is capable of 
exploiting the stack further.

mismatch between ofed requirements and paramnet-3 specs, are covered in 
the patch.

On Sun, 22 Nov 2009, Roland Dreier wrote:

> I think rather than worrying about OFED, you're better off working on 
> getting your drivers integrated in the mainline kernel.
>
> However if you just have IPoIB working, and your fabric is not IB, then 
> I think you might be better off implementing IP-over-paramnet-3 and 
> avoiding the complexity of the RDMA stack.  Unless paramnet-3 is 
> RDMA-like?

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
