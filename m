From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: NFS over RDMA in SLinux
Date: Sat, 07 Mar 2015 04:19:54 +0200
Message-ID: <54FA604A.4050807@dev.mellanox.co.il>
References: <000501d0577e$35db88a0$a19299e0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000501d0577e$35db88a0$a19299e0$@gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/5/2015 9:54 PM, Francisco Manuel Cardoso wrote:
> Hello,
>
>
>
> Sorry newcomer to the group at the moment, brief question i hope someone can
> at least point me.
>
> Are there any considerations regarding NFS over RDMA on Linux SL6 ?
>
> Question I've been setting up/using an HPC cluster and NFS over IPoIB it's
> cool as soon as start dishing out things onto with the RDMA things go crazy.
>
> The tipical setup is each machine is able to handle max 40 processes, using
> all of those to mpi, I seem to be having some performance issues, if I scale
> down to 39 I get much better performance still it crashes.
>
> Anyone got any pointers ?

I'm not sure if you're asking about NFS over IPoIB or NFSoRDMA?

CC'ing Chuck which is probably the best help you can get...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
