From: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: What is OFED? (vs in-kernel drivers)
Date: Thu, 06 Jan 2011 02:34:50 +0100
Message-ID: <4D251C3A.8040701@shiftmail.org>
References: <4D246301.40006@shiftmail.org>
 <20110105191847.GB1211@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20110105191847.GB1211-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/05/2011 08:18 PM, Jason Gunthorpe wrote:
>
> They are related but separate. OFED started as a way to deliver IB
>
> CUT
>
> old. I generally build from git for my Ubuntu machines. I've attached
> a script that does the job, quick and easy:
>
> $ apt-get install gcc flex bison automake libtool autoconf
> $ mkdir /opt/ofa
> $ cd /opt/ofa
> $ ofabuild clone
> $ ofabuild build -V ofa-1.5.1 -p /opt/ofa-1.5.1
>
> But the install goes into /opt, not /usr/lib so you have to use
> something like
>
> LD_LIBRARY_PATH=/opt/ofa-1.5.1/lib/
> CPPFLAGS=-I/opt/ofa-1.5.1/include LDFLAGS="-L/opt/ofa-1.5.1/lib/ -Wl,-rpath=/opt/ofa-1.5.1/lib/"
> PATH=$PATH:/opt/ofa-1.5.1/bin:/opt/ofa-1.5.1/sbin
>
>    

How wonderful!!
I would never have hoped in such a reply, you even gave me the scripts 
to compile OFED under Ubuntu automatically!!
THANKS A LOT !!!

Only one more question: did I understand correctly that you suggest me 
to use the in-kernel modules on Ubuntu or vanilla kernels, even if I 
compiled OFED for userspace?
Otherwise, how should load those from OFED? I think modprobe does not 
find them unless they are in /lib/modules/mykernel, and your script does 
not put them there, it seems to me.

Thanks again!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
