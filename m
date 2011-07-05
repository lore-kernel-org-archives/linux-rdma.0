From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: install.pl "chown" issue (Was: Re: rhel6 ofed v1.5.3)
Date: Tue, 5 Jul 2011 15:36:18 -0700
Message-ID: <20110705153618.c7cba778.weiny2@llnl.gov>
References: <BANLkTi=fJr7BypNCs-7S4-THNTUGtmiicg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=fJr7BypNCs-7S4-THNTUGtmiicg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 1 Jul 2011 10:08:47 -0700
Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> According to my installation of Ofed 1.5.3 on RHEL6, the
> infiniband-diags package rpm is trying to chown /usr/local in order to
> deposit a library in lib64.

infiniband-diags does not do a chown.

> 
> In my environment /usr/local is off-limits to root and all package
> installs.  Is this a bug?  Is there a workaround to allow the
> install.pl to complete?

I just tried this on a vanilla Fedora 15 system and was able to build the source rpms just fine.

Try building and installing in this order.

libibumad-1.3.7-1.src.rpm
libibmad-1.3.7-1.src.rpm
opensm-3.3.9-1.src.rpm
infiniband-diags-1.5.8-1.src.rpm


Ira

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
